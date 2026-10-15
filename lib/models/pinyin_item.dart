/// 数据模型：对应 assets/audio/manifest.json 中的一条拼音音频条目
library;

import 'package:pinyin_king/utils/tone_marker.dart';

class PinyinItem {
  /// 所属分组：字母表 / 声母表 / 单韵母 / 复韵母 / 前鼻韵母 / 后鼻韵母 / 整体认读
  final String group;

  /// 基础字母（v 代表 ü），如 a、zh、zhi、an
  final String letter;

  /// 声调 1-4；null 表示无声调（声母 / 字母表）
  final int? tone;

  /// 组内排序序号（同一字母的四个声调共用一个 seq）
  final int seq;

  /// 音频资源路径，如 assets/audio/单韵母/01_a_1.mp3
  final String asset;

  const PinyinItem({
    required this.group,
    required this.letter,
    required this.tone,
    required this.seq,
    required this.asset,
  });

  /// 从 manifest.json 的条目 JSON 构造
  factory PinyinItem.fromJson(Map<String, dynamic> json) {
    return PinyinItem(
      group: json['group'] as String,
      letter: json['letter'] as String,
      tone: json['tone'] as int?,
      seq: json['seq'] as int,
      asset: json['asset'] as String,
    );
  }

  /// 界面显示文本（自动带声调符号），如 à、zhī、üe
  String get displayText => pinyinDisplay(letter, tone);
}
