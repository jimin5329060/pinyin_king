/// 拼音数据仓库：负责加载 manifest.json 并按分组提供数据
library;

import 'dart:convert' show jsonDecode;

import 'package:flutter/services.dart' show rootBundle;

import 'package:pinyin_king/models/pinyin_item.dart';

class PinyinRepository {
  /// 韵母表下的四个子分组（顺序即子 Tab 顺序）
  static const List<String> yunmuSubGroups = [
    '单韵母',
    '复韵母',
    '前鼻韵母',
    '后鼻韵母',
  ];

  final List<PinyinItem> _items = [];
  bool _loaded = false;

  /// 加载 manifest.json（幂等，重复调用只加载一次）
  Future<void> load() async {
    if (_loaded) return;
    final raw = await rootBundle.loadString('assets/audio/manifest.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final list = decoded['items'] as List;
    _items
      ..clear()
      ..addAll(
        list.map((e) => PinyinItem.fromJson(e as Map<String, dynamic>)),
      );
    _loaded = true;
  }

  /// 取指定分组的全部条目，按 seq、tone 排序（同一字母的声调顺序排列）
  List<PinyinItem> itemsOfGroup(String group) {
    final result =
        _items.where((e) => e.group == group).toList()
          ..sort((a, b) {
            final bySeq = a.seq.compareTo(b.seq);
            return bySeq != 0 ? bySeq : (a.tone ?? 0).compareTo(b.tone ?? 0);
          });
    return result;
  }
}
