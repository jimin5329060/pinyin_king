/// 拼音声调标注工具：
/// 把「基础字母 + 声调」转成带声调符号的显示文本，如 (a, 4) → à、(zhi, 1) → zhī。
library;

/// 声调符号表：key 为声调 1-4，value 为各元音对应的带调字符
const Map<int, Map<String, String>> _toneMarks = {
  1: {'a': 'ā', 'o': 'ō', 'e': 'ē', 'i': 'ī', 'u': 'ū', 'ü': 'ǖ'},
  2: {'a': 'á', 'o': 'ó', 'e': 'é', 'i': 'í', 'u': 'ú', 'ü': 'ǘ'},
  3: {'a': 'ǎ', 'o': 'ǒ', 'e': 'ě', 'i': 'ǐ', 'u': 'ǔ', 'ü': 'ǚ'},
  4: {'a': 'à', 'o': 'ò', 'e': 'è', 'i': 'ì', 'u': 'ù', 'ü': 'ǜ'},
};

/// 返回用于界面显示的拼音文本
///
/// [letter] 为 manifest 中的基础字母（v 代表 ü）；
/// [tone] 为声调 1-4，null 表示无声调（声母 / 字母表）。
String pinyinDisplay(String letter, int? tone) {
  // 转写规则：v → ü；素材中 ue / ve 都代表韵母 üe，统一显示为 üe
  var s = letter.replaceAll('v', 'ü');
  if (s == 'ue') s = 'üe';

  // 无声调直接返回基础写法
  if (tone == null) return s;

  // 标调位置规则（小学语文标准）：
  // 优先级 a > o > e；i / u 并列时标在靠后的那个（如 iu 标 u、ui 标 i）
  int idx = s.indexOf('a');
  if (idx < 0) idx = s.indexOf('o');
  if (idx < 0) idx = s.indexOf('e');
  if (idx < 0) {
    // i / u / ü 并列时，标在靠后的那个（如 iu 标 u、ui 标 i、ün 标 ü）
    final i = s.lastIndexOf('i');
    final u = s.lastIndexOf('u');
    final vChar = s.lastIndexOf('ü');
    idx = [i, u, vChar].reduce((a, b) => a > b ? a : b);
  }

  // 找不到可标调的元音（异常数据），原样返回，保证不崩溃
  if (idx < 0) return s;

  final marked = _toneMarks[tone]?[s[idx]];
  // 无对应符号（异常数据），原样返回
  if (marked == null) return s;

  return s.replaceRange(idx, idx + 1, marked);
}
