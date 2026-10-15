/// 音频播放服务：全局单例，统一管理标准音播放
library;

import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  // 单例：全 App 共用一个播放器，避免多处播放互相打断失控
  AudioPlayerService._internal();
  static final AudioPlayerService instance = AudioPlayerService._internal();

  final AudioPlayer _player = AudioPlayer();

  /// 当前正在播放的资源路径（用于标记正在播放的卡片，可扩展高亮）
  String? currentAsset;

  /// 播放 assets 下的音频
  ///
  /// [asset] 为完整资源路径，如 assets/audio/声母表/01_b.mp3。
  /// 注意：audioplayers 的 AssetSource 会自动在路径前拼 `assets/` 前缀，
  /// 因此这里要先去掉 manifest 里带的前缀，避免变成 `assets/assets/...` 而加载失败。
  /// 播放前先停止上一次播放，保证快速连点安全（先停后播）。
  Future<void> playAsset(String asset) async {
    try {
      // 去掉开头的 assets/ 前缀，交给 audioplayers 自行拼接
      final relative = asset.startsWith('assets/')
          ? asset.substring('assets/'.length)
          : asset;
      currentAsset = asset;
      await _player.stop();
      await _player.play(AssetSource(relative));
    } catch (_) {
      // 音频缺失或解码失败：静默失败即可，不崩溃
      // （PRD FR-02-W：提示与禁用由 UI 层处理）
      currentAsset = null;
    }
  }

  /// 停止播放
  Future<void> stop() async {
    currentAsset = null;
    await _player.stop();
  }

  /// 释放资源（App 退出时调用，常规使用可忽略）
  Future<void> dispose() async {
    await _player.dispose();
  }
}
