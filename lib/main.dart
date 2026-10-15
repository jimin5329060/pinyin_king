/// 拼音王 —— 权威拼音教材工具
/// 主入口：配置全局主题并挂载主页
library;

import 'package:flutter/material.dart';

import 'package:pinyin_king/pages/pinyin_home_page.dart';
import 'package:pinyin_king/theme/app_colors.dart';

void main() {
  runApp(const PinyinKingApp());
}

class PinyinKingApp extends StatelessWidget {
  const PinyinKingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '拼音王',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // 全局使用 Material 3，主色取头部紫色
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.header),
        scaffoldBackgroundColor: AppColors.pageBackground,
      ),
      home: const PinyinHomePage(),
    );
  }
}
