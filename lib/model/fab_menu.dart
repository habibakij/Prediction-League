

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

///need to set floatingActionButtonLocation to fabMenuLocation
const _FabLocation fabMenuLocation = const _FabLocation();

///A FloatingActionButton with expandable menu
class FabMenu extends StatefulWidget {
  final List<MenuData> menus;

  ///Default to Icons.add
  final IconData mainIcon;

  ///Default to const Duration(milliseconds:200)
  final Duration duration;

  ///Default to Colors.white
  final Color maskColor;

  ///Default to Colors.white
  final Color mainButtonColor;

  ///Default to Theme.of(context).primaryColor
  final Color menuButtonColor;

  ///Default to Theme.of(context).primaryColor
  final Color mainButtonBackgroundColor;

  ///Default to Colors.white
  final Color menuButtonBackgroundColor;

  ///Default to Theme.of(context).cardColor
  final Color labelBackgroundColor;

  ///Default to Theme.of(context).primaryColor
  final Color labelTextColor;

  ///Default to 0.5
  final double maskOpacity;

  FabMenu({
    required this.menus,
    required this.mainIcon,
    this.duration: const Duration(milliseconds: 200),
    required this.mainButtonColor,
    required this.mainButtonBackgroundColor,
    required this.menuButtonColor,
    required this.menuButtonBackgroundColor,
    required this.labelTextColor,
    required this.labelBackgroundColor,
    this.maskColor: Colors.white,
    this.maskOpacity: 0,
  }) : assert(menus != null);

  @override
  _FabMenuState createState() =>  _FabMenuState();
}

class _FabMenuState extends State<FabMenu> with TickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller =
     AnimationController(vsync: this, duration: widget.duration)
      ..addStatusListener((state) {
        switch (state) {
          case AnimationStatus.forward:
          case AnimationStatus.dismissed:
            setState(() {});
            break;
          default:
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: <Widget>[_buildFabMask(), _buildFabButton()],
    );
  }

  _buildFabMask() {
      return  Offstage(
        offstage: _controller!.isDismissed,
        child:  AnimatedBuilder(
            animation: _controller!,
            builder: (context, child) {
              return  GestureDetector(
                onTap: () {
                  if (!_controller!.isDismissed) {
                    _controller!.reverse();
                  }
                },
                behavior: HitTestBehavior.opaque,
                child:  Opacity(
                  opacity: _controller!.value * widget.maskOpacity,
                  child:  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: widget.maskColor,
                  ),
                ),
              );
            }),
      );
  }

  _buildFabButton() {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children:  List.generate(widget.menus.length, (int index) {
        Widget child =  Container(
          height: 60.0,
          alignment: Alignment.centerLeft,
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
               ScaleTransition(
                scale:  CurvedAnimation(
                    parent: _controller!,
                    curve:  Interval(
                        0.0, 1.0 - index / widget.menus.length / 2.0,
                        curve: Curves.easeOut)),
                child:  Card(
                  elevation: 6.0,
                  color: widget.menus[index].enable
                      ? widget.labelBackgroundColor
                      : Colors.grey[100],
                  child:  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child:  Text(
                      widget.menus[index].labelText,
                      style:  TextStyle(
                          color: widget.menus[index].enable
                              ? widget.labelTextColor
                              : Colors.grey),
                    ),
                  ),
                ),
              ),
               SizedBox(
                width: 8.0,
              ),
               ScaleTransition(
                scale:  CurvedAnimation(
                  parent: _controller!,
                  curve:  Interval(
                      0.0, 1.0 - index / widget.menus.length / 2.0,
                      curve: Curves.easeOut),
                ),
                child:  FloatingActionButton(

                    heroTag: 'menuFab$index',
                    backgroundColor: widget.menus[index].enable
                        ? widget.menuButtonBackgroundColor
                        : Colors.grey[100],
                    mini: true,
                    tooltip: widget.menus[index].labelText,
                    child:  Image.asset(
                      widget.menus[index].icon,
                      color: widget.menus[index].enable
                          ? Colors.white
                          : Colors.grey,
                      height: 20,
                      width: 20,
                    ),
                    onPressed: () {
                      if (!_controller!.isDismissed) _controller!.reverse();
                      widget.menus[index]
                          .onClick(context, widget.menus[index]);
                    }),
              ),
              const SizedBox(
                width: 8.0,
              )
            ],
          ),
        );
        return child;
      }).toList()
        ..add( FloatingActionButton(
            heroTag: 'mainFab',
            backgroundColor: widget.mainButtonBackgroundColor,
            child:  AnimatedBuilder(
                animation: _controller!,
                builder: (context, child) {
                  return  Transform(
                    transform:  Matrix4.rotationZ(
                        _controller!.value * 0.5 * math.pi),
                    alignment: FractionalOffset.center,
                    child:  Icon(
                      _controller!.isDismissed
                          ? widget.mainIcon
                          : Icons.close,
                      color: Colors.white ,
                    ),
                  );
                }),
            onPressed: () {
              if (_controller!.isDismissed) {
                _controller!.forward();
              } else {
                _controller!.reverse();
              }
            })),
    );
  }
}

typedef MenuClicked(BuildContext context, MenuData menuData);

class MenuData {
  String icon;
  String labelText;
  MenuClicked onClick;
  bool enable;

  MenuData(this.icon, this.onClick, {required this.labelText, this.enable = true})
      : assert(icon != null),
        assert(labelText != null && labelText.isNotEmpty);
}

class _FabLocation extends FloatingActionButtonLocation {
  const _FabLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Compute the x-axis offset.
    double fabX;
    switch (scaffoldGeometry.textDirection) {
      case TextDirection.rtl:
      // In RTL, the end of the screen is the left.
        final double endPadding = scaffoldGeometry.minInsets.left;
        fabX = endPadding;
        break;
      case TextDirection.ltr:
      // In LTR, the end of the screen is the right.
        final double endPadding = scaffoldGeometry.minInsets.right;
        fabX = scaffoldGeometry.scaffoldSize.width -
            scaffoldGeometry.floatingActionButtonSize.width -
            endPadding;
        break;
    }

    // Compute the y-axis offset.
    final double contentBottom = scaffoldGeometry.contentBottom;
    final double bottomSheetHeight = scaffoldGeometry.bottomSheetSize.height;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double snackBarHeight = scaffoldGeometry.snackBarSize.height;

    double fabY = contentBottom - fabHeight;
    if (snackBarHeight > 0.0) {
      fabY = math.min(fabY, contentBottom - snackBarHeight - fabHeight);
    }
    if (bottomSheetHeight > 0.0) {
      fabY =
          math.min(fabY, contentBottom - bottomSheetHeight - fabHeight / 2.0);
    }

    return  Offset(fabX, fabY);
  }
}

