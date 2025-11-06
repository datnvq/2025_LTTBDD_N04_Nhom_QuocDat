import 'package:flutter/material.dart';

/// Widget hiển thị skeleton loading khi đang tải dữ liệu thời tiết
class WeatherSkeleton extends StatefulWidget {
  const WeatherSkeleton({super.key});

  @override
  State<WeatherSkeleton> createState() => _WeatherSkeletonState();
}

class _WeatherSkeletonState extends State<WeatherSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SkeletonBox(
                            width: 200,
                            height: 24,
                            opacity: _animation.value,
                          ),
                          const SizedBox(height: 8),
                          _SkeletonBox(
                            width: 120,
                            height: 14,
                            opacity: _animation.value,
                          ),
                        ],
                      ),
                    ),
                    _SkeletonBox(
                      width: 80,
                      height: 80,
                      borderRadius: 16,
                      opacity: _animation.value,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Temperature
                _SkeletonBox(width: 150, height: 72, opacity: _animation.value),

                const SizedBox(height: 24),

                Divider(color: theme.colorScheme.outline.withOpacity(0.2)),

                const SizedBox(height: 16),

                // Details
                Row(
                  children: [
                    Expanded(
                      child: _SkeletonBox(
                        height: 80,
                        borderRadius: 12,
                        opacity: _animation.value,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _SkeletonBox(
                        height: 80,
                        borderRadius: 12,
                        opacity: _animation.value,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _SkeletonBox(
                        height: 80,
                        borderRadius: 12,
                        opacity: _animation.value,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _SkeletonBox(
                        height: 80,
                        borderRadius: 12,
                        opacity: _animation.value,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    this.width,
    required this.height,
    this.borderRadius = 8,
    required this.opacity,
  });

  final double? width;
  final double height;
  final double borderRadius;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(opacity),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
