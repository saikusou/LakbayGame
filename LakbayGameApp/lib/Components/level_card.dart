import 'package:flutter/material.dart';
import 'package:lakbay_game/Components/partial_star.dart';

class LevelCard extends StatefulWidget {
  final String imagePath;
  final double width;
  final double imageHeight;
  final double starSize;
  final VoidCallback onTap;
  final bool enabled;
  final double progress;

  const LevelCard({
    super.key,
    required this.imagePath,
    required this.width,
    required this.imageHeight,
    required this.starSize,
    required this.onTap,
    required this.enabled,
    required this.progress,
  });

  @override
  State<LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<LevelCard> {
  bool isHighlighted = false;
  bool isOpening = false;

  double clampValue(double value, double minimum, double maximum) {
    return value.clamp(minimum, maximum).toDouble();
  }

  void setHighlight(bool value) {
    if (!widget.enabled) return;
    if (!mounted) return;
    if (isHighlighted == value) return;

    setState(() {
      isHighlighted = value;
    });
  }

  void showLockedMessage() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Kailangan mo muna kumpletuhin ang nakaraang aralin upang ma-access ang susunod na aralin. '
          'Tapusin muna ang nakaraang aralin',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  int get earnedStars {
    if (widget.progress >= 100) return 3;
    if (widget.progress >= 67) return 2;
    if (widget.progress >= 34) return 1;
    return 0;
  }

  Future<void> handleTap() async {
    if (!widget.enabled) {
      showLockedMessage();
      return;
    }

    if (isOpening) return;

    setState(() {
      isOpening = true;
      isHighlighted = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 120));

    if (!mounted) return;

    setState(() {
      isHighlighted = false;
    });

    widget.onTap();

    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    setState(() {
      isOpening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double lockSize = clampValue(widget.width * 0.22, 48, 70);

    final double lockIconSize = clampValue(widget.width * 0.11, 25, 38);

    return MouseRegion(
      cursor: widget.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      onEnter: (_) {
        setHighlight(true);
      },
      onExit: (_) {
        setHighlight(false);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: handleTap,
        onTapDown: (_) {
          setHighlight(true);
        },
        onTapUp: (_) {
          setHighlight(false);
        },
        onTapCancel: () {
          setHighlight(false);
        },
        child: AnimatedScale(
          scale: isHighlighted && widget.enabled ? 1.07 : 1.0,
          duration: const Duration(milliseconds: 180),
          child: AnimatedOpacity(
            opacity: widget.enabled ? 1.0 : 0.48,
            duration: const Duration(milliseconds: 250),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: widget.width,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: isHighlighted && widget.enabled
                    ? Colors.yellow.withValues(alpha: 0.18)
                    : Colors.transparent,
                border: Border.all(
                  color: isHighlighted && widget.enabled
                      ? Colors.yellow
                      : Colors.transparent,
                  width: 4,
                ),
                boxShadow: isHighlighted && widget.enabled
                    ? [
                        BoxShadow(
                          color: Colors.yellow.withValues(alpha: 0.90),
                          blurRadius: 26,
                          spreadRadius: 4,
                        ),
                      ]
                    : const [],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ColorFiltered(
                    colorFilter: widget.enabled
                        ? const ColorFilter.mode(
                            Colors.transparent,
                            BlendMode.dst,
                          )
                        : const ColorFilter.mode(
                            Colors.grey,
                            BlendMode.saturation,
                          ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          widget.imagePath,
                          width: widget.width,
                          height: widget.imageHeight,
                          fit: BoxFit.contain,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            // Convert percentage to 3-star scale
                            double stars = widget.progress / 100 * 3;

                            double fill = (stars - index).clamp(0.0, 1.0);

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: widget.starSize * 0.08,
                              ),
                              child: PartialStar(
                                fill: fill,
                                size: widget.starSize,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),

                  if (!widget.enabled)
                    Container(
                      width: lockSize,
                      height: lockSize,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.60),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: lockIconSize,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
