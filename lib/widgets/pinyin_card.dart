/// 拼音卡片：白色圆角卡片 + 大字母 + 右下角喇叭图标，点击播放标准音
library;

import 'package:flutter/material.dart';

import 'package:pinyin_king/models/pinyin_item.dart';
import 'package:pinyin_king/services/audio_player_service.dart';
import 'package:pinyin_king/theme/app_colors.dart';

class PinyinCard extends StatelessWidget {
  const PinyinCard({super.key, required this.item});

  final PinyinItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => AudioPlayerService.instance.playAsset(item.asset),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            // 极浅阴影，贴近参考 UI 的悬浮感
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // 居中大字母
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      item.displayText,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              // 右下角喇叭图标（提示可点击发音）
              const Positioned(
                right: 6,
                bottom: 6,
                child: Icon(
                  Icons.volume_up,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
