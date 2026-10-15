// 基础冒烟测试：验证应用能启动并渲染出拼音卡片网格
//
// 说明：测试环境无法访问 AssetSource 音频播放（audioplayers 插件未注册），
// 因此只验证 UI 结构，不实际点击播放。

import 'package:flutter_test/flutter_test.dart';

import 'package:pinyin_king/main.dart';

void main() {
  testWidgets('应用启动后显示头部标题与拼音卡片', (WidgetTester tester) async {
    // 挂载应用并触发首帧
    await tester.pumpWidget(const PinyinKingApp());
    // 等待 FutureBuilder（manifest 加载）完成
    await tester.pumpAndSettle();

    // 默认选中「拼音表」主 Tab，头部显示对应标题
    expect(find.text('汉语拼音拼音表'), findsOneWidget);
    // 主 Tab 四项齐全
    expect(find.text('拼音表'), findsOneWidget);
    expect(find.text('声母表'), findsOneWidget);
    expect(find.text('韵母表'), findsOneWidget);
    expect(find.text('整体认读'), findsOneWidget);
  });
}
