import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DraggableAIFab extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onPressed;

  const DraggableAIFab({
    super.key,
    required this.isDarkMode,
    required this.onPressed,
  });

  @override
  State<DraggableAIFab> createState() => _DraggableAIFabState();
}

class _DraggableAIFabState extends State<DraggableAIFab>
    with SingleTickerProviderStateMixin {
  Offset _position = const Offset(20, 0);
  bool _isInitialized = false;

  late AnimationController _snapController;
  Animation<Offset>? _snapAnimation;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _snapController.addListener(() {
      setState(() {
        if (_snapAnimation != null) {
          _position = _snapAnimation!.value;
        }
      });
    });
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const double buttonSize = 60.0;
    const double safeBottom = 120.0;
    const double sideMargin = 20.0;

    if (!_isInitialized) {
      _position = Offset(screenSize.width - buttonSize - sideMargin,
          screenSize.height - safeBottom - buttonSize);
      _isInitialized = true;
    }

    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onTap: widget.onPressed,
        onPanUpdate: (details) {
          setState(() {
            _position = Offset(
              (_position.dx + details.delta.dx)
                  .clamp(0.0, screenSize.width - buttonSize),
              (_position.dy + details.delta.dy)
                  .clamp(0.0, screenSize.height - buttonSize),
            );
          });
        },
        onPanEnd: (details) {
          double targetX;
          if (_position.dx + (buttonSize / 2) < screenSize.width / 2) {
            targetX = sideMargin;
          } else {
            targetX = screenSize.width - buttonSize - sideMargin;
          }
          double targetY = _position.dy.clamp(
            MediaQuery.of(context).padding.top + 20,
            screenSize.height - safeBottom - buttonSize,
          );
          _snapAnimation = Tween<Offset>(
            begin: _position,
            end: Offset(targetX, targetY),
          ).animate(CurvedAnimation(
              parent: _snapController, curve: Curves.easeOutCubic));
          _snapController.forward(from: 0.0);
        },
        child: _buildFormalButton(),
      ),
    );
  }

  Widget _buildFormalButton() {
    final bool isDark = widget.isDarkMode;
    final Color primaryColor =
        isDark ? AppColors.pureWhite : AppColors.deepNavy;
    final Color iconColor = AppColors.goldenBronze;

    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: primaryColor,
        border: Border.all(color: AppColors.goldenBronze, width: 1.5),
        boxShadow: [
          BoxShadow(
              color: (isDark ? Colors.black : AppColors.deepNavy)
                  .withOpacity(isDark ? 0.3 : 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Center(
          child: Icon(Icons.auto_awesome_rounded, color: iconColor, size: 24)),
    );
  }
}
