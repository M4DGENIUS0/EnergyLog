import 'package:app/file/app_preferences/app_preferences.dart';
import 'package:flutter/material.dart';

class DotNavigationBar extends StatelessWidget {
  const DotNavigationBar({
    super.key,
    required this.items,
    this.currentIndex = 0,
    this.onTap,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.margin = const EdgeInsets.all(8),
    this.itemPadding = const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOutQuint,
    this.dotIndicatorColor,
    this.barMargin = const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
    this.barPadding ,
    this.borderRadius = 30,
    this.splashBorderRadius,
    required this.backgroundColor,
    this.boxShadow = const [
      BoxShadow(
        color: Colors.transparent,
        spreadRadius: 0,
        blurRadius: 0,
        offset: Offset.zero,
      ),
    ],
    this.enableFloatingNavBar = true,
    this.enablePaddingAnimation = true,
    this.splashColor,
    this.dotMargin = 8.0,
    this.elevation = 0.0,
    this.iconSize = 24.0,
    this.dotSize = 7.0,
  });

  final List<DotNavigationBarItem> items;
  final int currentIndex;
  final Function(int)? onTap;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final EdgeInsets margin;
  final EdgeInsets itemPadding;
  final Duration duration;
  final Curve curve;
  final Color? dotIndicatorColor;
  final EdgeInsetsGeometry barMargin;
  final EdgeInsetsGeometry? barPadding;
  final double borderRadius;
  final double? splashBorderRadius;
  final Color backgroundColor;
  final List<BoxShadow> boxShadow;
  final bool enableFloatingNavBar;
  final bool enablePaddingAnimation;
  final Color? splashColor;
  final double dotMargin;
  final double elevation;
  final double iconSize;
  final double dotSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return enableFloatingNavBar
        ? _buildFloatingBar(context, theme)
        : _buildStandardBar(context, theme);
  }

  Widget _buildFloatingBar(BuildContext context, ThemeData theme) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: elevation,
      child: Container(
        height: AppThemePreferences.dotBottomNavigationBarHeight, // Use the theme height directly
        // padding: barPadding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: backgroundColor,
          boxShadow: boxShadow,
        ),
        child: _NavigationBarBody(
          items: items,
          currentIndex: currentIndex,
          theme: theme,
          selectedItemColor: selectedItemColor,
          unselectedItemColor: unselectedItemColor,
          onTap: onTap,
          itemPadding: itemPadding,
          dotIndicatorColor: dotIndicatorColor,
          enablePaddingAnimation: enablePaddingAnimation,
          splashColor: splashColor,
          splashBorderRadius: splashBorderRadius,
          dotMargin: dotMargin,
          iconSize: iconSize,
          dotSize: dotSize,
          duration: duration,
          curve: curve,
        ),
      ),
    );
  }

  Widget _buildStandardBar(BuildContext context, ThemeData theme) {
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: margin,
        child: SizedBox(
          height: AppThemePreferences.dotBottomNavigationBarHeight,
          child: _NavigationBarBody(
            items: items,
            currentIndex: currentIndex,
            theme: theme,
            selectedItemColor: selectedItemColor,
            unselectedItemColor: unselectedItemColor,
            onTap: onTap,
            itemPadding: itemPadding,
            dotIndicatorColor: dotIndicatorColor,
            enablePaddingAnimation: enablePaddingAnimation,
            splashColor: splashColor,
            splashBorderRadius: splashBorderRadius,
            dotMargin: dotMargin,
            iconSize: iconSize,
            dotSize: dotSize,
            duration: duration,
            curve: curve,
          ),
        ),
      ),
    );
  }
}

class DotNavigationBarItem {
  final Widget icon;
  final Color? selectedColor;
  final Color? unselectedColor;

  const DotNavigationBarItem({
    required this.icon,
    this.selectedColor,
    this.unselectedColor,
  });
}

class _NavigationBarBody extends StatelessWidget {
  const _NavigationBarBody({
    required this.items,
    required this.currentIndex,
    required this.theme,
    required this.selectedItemColor,
    required this.unselectedItemColor,
    required this.onTap,
    required this.itemPadding,
    required this.dotIndicatorColor,
    required this.enablePaddingAnimation,
    required this.splashColor,
    required this.splashBorderRadius,
    required this.dotMargin,
    required this.iconSize,
    required this.dotSize,
    required this.duration,
    required this.curve,
  });

  final List<DotNavigationBarItem> items;
  final int currentIndex;
  final ThemeData theme;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final Function(int)? onTap;
  final EdgeInsets itemPadding;
  final Color? dotIndicatorColor;
  final bool enablePaddingAnimation;
  final Color? splashColor;
  final double? splashBorderRadius;
  final double dotMargin;
  final double iconSize;
  final double dotSize;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(items.length, (index) {
        final item = items[index];
        return Expanded(
          child: _NavBarItem(
            item: item,
            isSelected: index == currentIndex,
            theme: theme,
            selectedItemColor: selectedItemColor,
            unselectedItemColor: unselectedItemColor,
            onTap: () => onTap?.call(index),
            itemPadding: itemPadding,
            dotIndicatorColor: dotIndicatorColor,
            enablePaddingAnimation: enablePaddingAnimation,
            splashColor: splashColor,
            splashBorderRadius: splashBorderRadius,
            dotMargin: dotMargin,
            iconSize: iconSize,
            dotSize: dotSize,
            duration: duration,
            curve: curve,
          ),
        );
      }),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.theme,
    required this.selectedItemColor,
    required this.unselectedItemColor,
    required this.onTap,
    required this.itemPadding,
    required this.dotIndicatorColor,
    required this.enablePaddingAnimation,
    required this.splashColor,
    required this.splashBorderRadius,
    required this.dotMargin,
    required this.iconSize,
    required this.dotSize,
    required this.duration,
    required this.curve,
  });

  final DotNavigationBarItem item;
  final bool isSelected;
  final ThemeData theme;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final VoidCallback? onTap;
  final EdgeInsets itemPadding;
  final Color? dotIndicatorColor;
  final bool enablePaddingAnimation;
  final Color? splashColor;
  final double? splashBorderRadius;
  final double dotMargin;
  final double iconSize;
  final double dotSize;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final selectedColor = item.selectedColor ??
        selectedItemColor ??
        theme.primaryColor;

    final unselectedColor = item.unselectedColor ??
        unselectedItemColor ??
        theme.iconTheme.color ??
        Colors.grey;

    return TweenAnimationBuilder<double>(
      tween: Tween(end: isSelected ? 1.0 : 0.0),
      curve: curve,
      duration: duration,
      builder: (context, t, child) {
        return Material(
          color: Colors.transparent,
          borderRadius: splashBorderRadius != null
              ? BorderRadius.circular(splashBorderRadius!)
              : null,
          child: InkWell(
            onTap: onTap,
            splashColor: splashColor ?? selectedColor.withValues(alpha: 0.1),
            highlightColor: splashColor ?? selectedColor.withValues(alpha: 0.1),
            borderRadius: splashBorderRadius != null
                ? BorderRadius.circular(splashBorderRadius!)
                : null,
            child: Container(
              constraints: const BoxConstraints(minWidth: 60, minHeight: 56, ),
              padding: enablePaddingAnimation
                  ? itemPadding.copyWith(
                right: itemPadding.right * (isSelected ? 1 : 0.8),
                left: itemPadding.left * (isSelected ? 1 : 0.8),
              )
                  : itemPadding,
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconTheme(
                    data: IconThemeData(
                      color: Color.lerp(unselectedColor, selectedColor, t),
                      size: iconSize,
                    ),
                    child: item.icon,
                  ),
                  SizedBox(height: dotMargin),
                  _DotIndicator(
                    isVisible: isSelected,
                    color: dotIndicatorColor ?? selectedColor,
                    size: dotSize,
                    duration: duration,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DotIndicator extends StatelessWidget {
  const _DotIndicator({
    required this.isVisible,
    required this.color,
    required this.size,
    required this.duration,
  });

  final bool isVisible;
  final Color color;
  final double size;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: duration,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}