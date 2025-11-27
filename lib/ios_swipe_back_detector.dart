import 'dart:io';

import 'package:flutter/material.dart';

/// iOS 侧滑返回检测器
/// 用于解决 PopScope canPop: false 时 iOS 侧滑手势不触发回调的问题
class IOSSwipeBackDetector extends StatefulWidget {
  const IOSSwipeBackDetector({
    super.key,
    required this.child,
    required this.onSwipeBack,
    this.edgeWidth = 20.0,
    this.swipeThreshold = 100.0,
  });

  final Widget child;
  final VoidCallback onSwipeBack;

  /// 边缘触发区域宽度
  final double edgeWidth;

  /// 触发返回的滑动距离阈值
  final double swipeThreshold;

  @override
  State<IOSSwipeBackDetector> createState() => _IOSSwipeBackDetectorState();
}

class _IOSSwipeBackDetectorState extends State<IOSSwipeBackDetector> {
  double _startX = 0;
  bool _isEdgeSwipe = false;

  bool enabled = false;
  @override
  void initState() {
    super.initState();
    enabled = Platform.isIOS;
  }

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return widget.child;
    }

    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart: (details) {
        final screenWidth = MediaQuery.of(context).size.width;
        final startPosition = details.globalPosition.dx;

        // 根据布局方向判断边缘位置
        // LTR: 从左边缘开始滑动
        // RTL: 从右边缘开始滑动
        if (isRTL) {
          _isEdgeSwipe = startPosition > screenWidth - widget.edgeWidth;
        } else {
          _isEdgeSwipe = startPosition < widget.edgeWidth;
        }
        _startX = startPosition;
      },
      onHorizontalDragUpdate: (details) {
        // 可以在这里添加滑动过程中的视觉反馈
      },
      onHorizontalDragEnd: (details) {
        if (!_isEdgeSwipe) return;

        final currentX = details.localPosition.dx;
        final deltaX = isRTL ? (_startX - currentX) : (currentX - _startX);

        // 滑动距离超过阈值，触发返回
        if (deltaX > widget.swipeThreshold) {
          widget.onSwipeBack();
        }

        _isEdgeSwipe = false;
        _startX = 0;
      },
      onHorizontalDragCancel: () {
        _isEdgeSwipe = false;
        _startX = 0;
      },
      child: widget.child,
    );
  }
}
