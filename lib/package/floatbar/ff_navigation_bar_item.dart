import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'ff_navigation_bar_theme.dart';

// This class has mutable instance properties as they are used to store
// calculated values required by multiple build functions but not known
// (or required to be specified) at creation of instance parameters.
// For example, a color attribute will be modified depending on whether
// the item is selected or not.
// They are also used to store values retrieved from a Provider allowing
// properties to be communicated from the navigation bar to the individual
// items of the bar.

// ignore: must_be_immutable
class FFNavigationBarItem extends StatelessWidget {
  final String? label;
  final String? iconData;
  final Duration animationDuration;
  Color? selectedBackgroundColor;
  Color? selectedForegroundColor;
  Color? selectedLabelColor;

  int index=0;
  int selectedIndex=0;
  FFNavigationBarTheme? theme;
  bool showSelectedItemShadow=false;
  double itemWidth=0.0;

  void setIndex(int index) {
    this.index = index;
  }

  Color? _getDerivedBorderColor() {
    return theme?.selectedItemBorderColor ?? theme?.barBackgroundColor;
  }

  Color? _getBorderColor(bool isOn) {
    return isOn ? _getDerivedBorderColor() : Colors.transparent;
  }

  bool _isItemSelected() {
    return index == selectedIndex;
  }

  static const kDefaultAnimationDuration = Duration(milliseconds: 1500);

  FFNavigationBarItem({
    Key? key,
     this.label,
    this.itemWidth = 60,
    this.selectedBackgroundColor,
    this.selectedForegroundColor,
    this.selectedLabelColor,
     this.iconData,
    this.animationDuration = kDefaultAnimationDuration,
  }) : super(key: key);

  Center _makeLabel(String label) {
    bool isSelected = _isItemSelected();
    return Center(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11,fontWeight: FontWeight.w400,color: Colors.white,letterSpacing: isSelected ? 1.1 : 1.0,
          height: isSelected ? 2.4 : 1.0,)

      ),
    );
  }

  Widget _makeIconArea(double itemWidth, String iconData) {
    bool isSelected = _isItemSelected();
    double radius = itemWidth / 2;
    double innerBoxSize = itemWidth - 3;
    double innerRadius = (itemWidth - 8) / 2 - 4;

    return CircleAvatar(
      radius: isSelected ? radius : radius * 0.7,
      backgroundColor: _getBorderColor(isSelected),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: SizedBox(
          width: innerBoxSize,
          height: isSelected ? innerBoxSize : innerBoxSize / 3,
          child: CircleAvatar(
            radius: innerRadius,
            backgroundColor: isSelected
                ? selectedBackgroundColor ?? theme?.selectedItemBackgroundColor
                : theme?.unselectedItemBackgroundColor,
            child: _makeIcon(iconData),
          ),
        ),
      ),
    );
  }

  Widget _makeIcon(
    String iconData,
  ) {
    bool isSelected = _isItemSelected();
    return Image.asset(
      iconData,
      color: isSelected
          ? selectedForegroundColor ?? theme?.selectedItemIconColor
          : theme?.unselectedItemIconColor,
      height: selectedIndex==0?50:20,
      width: selectedIndex==0?50:20,
    );
  }

  Widget _makeShadow() {
    bool isSelected = _isItemSelected();
    double height = isSelected ? 4 : 0;
    double width = isSelected ? itemWidth + 6 : 0;

    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(itemWidth / 2, 2)),
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    theme = Provider.of<FFNavigationBarTheme>(context);
    showSelectedItemShadow = theme!.showSelectedItemShadow;
    itemWidth = theme!.itemWidth;
    selectedIndex = Provider.of<int>(context);

    selectedBackgroundColor =
        selectedBackgroundColor ?? theme?.selectedItemBackgroundColor;
    selectedForegroundColor =
        selectedForegroundColor ?? theme?.selectedItemIconColor;
    selectedLabelColor = selectedLabelColor ?? theme?.selectedItemLabelColor;

    bool isSelected = _isItemSelected();
    double itemHeight = itemWidth - 20;
    double topOffset = isSelected ? -38 : -10;
    double iconTopSpacer = isSelected ? 0 : 2;
    double shadowTopSpacer = 0;

    Widget labelWidget = _makeLabel(label!);
    Widget iconAreaWidget = _makeIconArea(itemWidth, iconData!);
    Widget shadowWidget = showSelectedItemShadow ? _makeShadow() : Container();

    return AnimatedContainer(
      width: itemWidth,
      height: double.maxFinite,
      duration: animationDuration,
      child: SizedBox(
        width: itemWidth,
        height: itemHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned(
              top: topOffset,
              left: -itemWidth / 2,
              right: -itemWidth / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: iconTopSpacer),
                  iconAreaWidget,
                  labelWidget,
                  SizedBox(height: shadowTopSpacer),
                  shadowWidget,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
