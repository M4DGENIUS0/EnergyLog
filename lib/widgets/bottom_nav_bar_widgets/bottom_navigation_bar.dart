import 'package:app/file/common/constants.dart';
import 'package:app/file/generic_methods/utility_methods.dart';
import 'package:app/widgets/bottom_nav_bar_widgets/bottom_navy_bar.dart';
import 'package:app/widgets/bottom_nav_bar_widgets/dot_navigation_bar.dart';
import 'package:app/widgets/generic_text_widget.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  final String? design;
  final int currentIndex;
  final void Function(int) onTap;
  final Map<String, dynamic> itemsMap;
  final Color backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final Curve? curve;
  final Duration? duration;
  final bool? enablePaddingAnimation;
  final bool enableFloatingNavBar;
  final double? splashBorderRadius;
  final EdgeInsetsGeometry? paddingR;
  final Color? splashColor;
  final EdgeInsets? margin;
  final EdgeInsets? itemPadding;
  final List<BoxShadow>? boxShadow;
  final double? borderRadius;
  final double? dotMargin;
  final EdgeInsetsGeometry? barMargin;
  final EdgeInsetsGeometry? barPadding;
  final double? dotSize;
  final double? elevation;
  final double? iconSize;


  const BottomNavigationBarWidget({
    Key? key,
    required this.itemsMap,
    this.design,
    this.currentIndex = 0,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.curve,
    this.duration,
    this.enablePaddingAnimation,
    this.splashBorderRadius,
    this.paddingR,
    this.splashColor,
    this.margin,
    this.itemPadding,
    this.boxShadow,
    this.borderRadius,
    this.dotMargin,
    this.enableFloatingNavBar = false,
    this.barMargin,
    this.barPadding,
    this.dotSize,
    this.elevation,
    this.iconSize,
  }) : super(key: key);

  @override
  State<BottomNavigationBarWidget> createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.design == DESIGN_02){
      return BottomNavyBar(
        showElevation: true,
        backgroundColor: widget.backgroundColor,
        selectedIndex: widget.currentIndex,
        onItemSelected: widget.onTap,
        items: getBottomNavyBarItemsList(widget.itemsMap),
        curve: Curves.ease,
      );
    }else if(widget.design == DESIGN_03){
      return DotNavigationBar(
        backgroundColor: widget.backgroundColor,
        dotIndicatorColor: widget.selectedItemColor,
        selectedItemColor: widget.selectedItemColor!,
        unselectedItemColor: widget.unselectedItemColor,
        enableFloatingNavBar: widget.enableFloatingNavBar,
        curve: widget.curve ?? Curves.ease,
        duration: widget.duration ?? const Duration(milliseconds: 300),
        enablePaddingAnimation: widget.enablePaddingAnimation ?? true,
        splashBorderRadius: widget.splashBorderRadius,
        splashColor: widget.splashColor ?? Colors.grey,
        margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 8),
        itemPadding: widget.itemPadding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        boxShadow: widget.boxShadow ?? [],
        currentIndex: widget.currentIndex,
        onTap: widget.onTap,
        items: getDotNavigationBarItemsList(widget.itemsMap),
        borderRadius: widget.borderRadius ?? 30,
        dotMargin: widget.dotMargin ?? 8.0,
        barMargin: widget.barMargin ?? EdgeInsets.zero,
        barPadding: widget.barPadding ?? EdgeInsets.zero,
        dotSize: widget.dotSize ?? 8.0,
        elevation: widget.elevation ?? 0.0,
        iconSize: widget.iconSize ?? 24.0,
      );
    }

    return BottomNavigationBar(
      backgroundColor: widget.backgroundColor,
      selectedItemColor: widget.selectedItemColor,
      unselectedItemColor: widget.unselectedItemColor,
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      type: BottomNavigationBarType.fixed, //For 4 or more items, set the type to fixed.
      items: getBottomNavigationBarItemsList(widget.itemsMap),
    );
  }

  List<BottomNavigationBarItem> getBottomNavigationBarItemsList(Map<String, dynamic> itemsMap){
    List<BottomNavigationBarItem> list = [];
    if(itemsMap.isNotEmpty){
      itemsMap.forEach((key, value) {
        list.add(
          BottomNavigationBarItem(
            icon: Icon(value),
            label: UtilityMethods.getLocalizedString(key),
          ),
        );
      });
    }
    return list;
  }

  List<BottomNavyBarItem> getBottomNavyBarItemsList(Map<String, dynamic> itemsMap){
    List<BottomNavyBarItem> list = [];
    if(itemsMap.isNotEmpty){
      itemsMap.forEach((key, value) {
        list.add(
          BottomNavyBarItem(
            icon: Icon(value, color: value == Icons.fiber_manual_record_outlined
                ? Colors.transparent : null,),
            title: GenericTextWidget(UtilityMethods.getLocalizedString(key)),
            activeColor: widget.selectedItemColor!,
            inactiveColor: widget.unselectedItemColor,
          ),
        );
      });
    }
    return list;
  }

  List<DotNavigationBarItem> getDotNavigationBarItemsList(Map<String, dynamic> itemsMap){
    List<DotNavigationBarItem> list = [];
    if(itemsMap.isNotEmpty){
      itemsMap.forEach((key, value) {
        list.add(
          DotNavigationBarItem(
            icon: Icon(value),
            selectedColor: widget.selectedItemColor!,
            unselectedColor: widget.unselectedItemColor,
          ),
        );
      });
    }
    return list;
  }
}