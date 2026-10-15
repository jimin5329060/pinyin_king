/// 全局颜色常量（对照参考 UI 配色统一管理，避免散落各处的魔法值）
library;

import 'package:flutter/material.dart';

class AppColors {
  /// 头部导航紫色
  static const Color header = Color(0xFF9B7BD8);

  /// 页面浅灰背景
  static const Color pageBackground = Color(0xFFF2F2F4);

  /// 卡片白色
  static const Color card = Colors.white;

  /// 主文字（卡片字母）
  static const Color textPrimary = Color(0xFF333333);

  /// 次要文字（喇叭图标等）
  static const Color textSecondary = Color(0xFF9E9E9E);

  /// 选中 Tab 下划线
  static const Color tabUnderline = Colors.white;

  /// 子 Tab 选中时的浅紫底
  static const Color subTabActiveBg = Color(0xFFEDE6F9);

  /// 子 Tab 选中文字紫
  static const Color subTabActiveText = Color(0xFF7B57C4);
}
