/// 主页面：紫色头部 + 主 Tab（拼音表/声母表/韵母表/整体认读）+ 韵母子 Tab + 卡片网格
library;

import 'package:flutter/material.dart';

import 'package:pinyin_king/models/pinyin_item.dart';
import 'package:pinyin_king/services/pinyin_repository.dart';
import 'package:pinyin_king/theme/app_colors.dart';
import 'package:pinyin_king/widgets/pinyin_card.dart';

/// 主 Tab 定义：标题 + 对应数据分组（韵母表特殊，含子分组）
class _MainTab {
  const _MainTab(this.title, this.headerTitle, {this.group, this.isYunmu = false});

  /// Tab 文案
  final String title;

  /// 头部大标题（选中该 Tab 时显示）
  final String headerTitle;

  /// 对应的音频分组（非韵母表使用）
  final String? group;

  /// 是否为韵母表（需要显示子 Tab）
  final bool isYunmu;
}

class PinyinHomePage extends StatefulWidget {
  const PinyinHomePage({super.key});

  @override
  State<PinyinHomePage> createState() => _PinyinHomePageState();
}

class _PinyinHomePageState extends State<PinyinHomePage> {
  /// 数据仓库
  final PinyinRepository _repository = PinyinRepository();

  /// 当前选中的主 Tab 下标
  int _mainTabIndex = 0;

  /// 当前选中的韵母子 Tab 下标
  int _yunmuSubIndex = 0;

  /// 主 Tab 配置（顺序与参考 UI 一致）
  static const List<_MainTab> _tabs = [
    _MainTab('拼音表', '汉语拼音拼音表', group: '字母表'),
    _MainTab('声母表', '汉语拼音声母表', group: '声母表'),
    _MainTab('韵母表', '汉语拼音韵母表', isYunmu: true),
    _MainTab('整体认读', '汉语拼音整体认读', group: '整体认读'),
  ];

  @override
  void initState() {
    super.initState();
    // 提前触发数据加载
    _repository.load();
  }

  /// 当前应展示的数据分组名
  String get _currentGroup {
    final tab = _tabs[_mainTabIndex];
    if (tab.isYunmu) {
      return PinyinRepository.yunmuSubGroups[_yunmuSubIndex];
    }
    return tab.group!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Column(
        children: [
          _buildHeader(),
          // 数据网格
          Expanded(child: _buildGrid()),
        ],
      ),
    );
  }

  /// 紫色圆角头部：大标题 + 主 Tab（韵母表时含子 Tab）
  Widget _buildHeader() {
    final tab = _tabs[_mainTabIndex];
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.header,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 第一行：大标题 + 品牌
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      tab.headerTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text(
                    '拼音王',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // 第二行：主 Tab
              Row(
                children: [
                  for (var i = 0; i < _tabs.length; i++)
                    _buildMainTab(i, _tabs[i].title),
                ],
              ),
              // 第三行：韵母表的子 Tab
              if (tab.isYunmu) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    for (var i = 0; i < PinyinRepository.yunmuSubGroups.length; i++)
                      _buildSubTab(i, PinyinRepository.yunmuSubGroups[i]),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 主 Tab 按钮：白色文字，选中时带白色下划线
  Widget _buildMainTab(int index, String title) {
    final selected = index == _mainTabIndex;
    return GestureDetector(
      onTap: () => setState(() => _mainTabIndex = index),
      child: Padding(
        padding: const EdgeInsets.only(right: 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withValues(alpha: selected ? 1 : 0.85),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // 选中下划线
            Container(
              height: 3,
              width: 34,
              decoration: BoxDecoration(
                color: selected ? AppColors.tabUnderline : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 韵母子 Tab 按钮：选中时浅紫圆角底 + 深紫文字
  Widget _buildSubTab(int index, String title) {
    final selected = index == _yunmuSubIndex;
    return GestureDetector(
      onTap: () => setState(() => _yunmuSubIndex = index),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppColors.subTabActiveBg : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected ? AppColors.subTabActiveText : Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// 数据网格：根据分组加载条目并渲染卡片
  Widget _buildGrid() {
    return FutureBuilder<void>(
      future: _repository.load(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('数据加载失败，请重启应用'));
        }

        final items = _repository.itemsOfGroup(_currentGroup);
        if (items.isEmpty) {
          return const Center(child: Text('暂无数据'));
        }
        return _PinyinGridView(items: items);
      },
    );
  }
}

/// 卡片网格：按宽度自适应列数（手机 4 列，平板/桌面更多列）
class _PinyinGridView extends StatelessWidget {
  const _PinyinGridView({required this.items});

  final List<PinyinItem> items;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    // 响应式列数：窄屏 4 列，随宽度增加
    final crossAxisCount = width < 420 ? 3 : (width < 760 ? 4 : (width < 1200 ? 6 : 8));

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        // 卡片接近正方形
        childAspectRatio: 0.95,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => PinyinCard(item: items[index]),
    );
  }
}
