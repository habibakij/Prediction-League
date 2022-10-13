
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:prediction/util/size_reporting_widget.dart';
class ExpandablePageView extends StatefulWidget {
  final List<Widget> children;
  final int hmm;
  const ExpandablePageView({
    Key? key,
    required this.children,
    required this.hmm
  }) : super(key: key);

  @override
  _ExpandablePageViewState createState() => _ExpandablePageViewState();
}

class _ExpandablePageViewState extends State<ExpandablePageView> with TickerProviderStateMixin {
  PageController? _pageController;
  List<double>? _heights;
  int _currentPage = 0;
  double get _currentHeight => _heights![_currentPage];
  late Timer timer;

  @override
  void initState() {
    _heights = widget.children.map((e) => 0.0).toList();
    super.initState();
    _pageController = PageController() //
      ..addListener(() {
        final _newPage = _pageController!.page!.round();
        if (_currentPage != _newPage) {
          setState(() => _currentPage = _newPage);
        }
      });
    timer=Timer.periodic(Duration(seconds: 2), (timer) {
      if(_currentPage<widget.children.length){
        _currentPage++;
      }else{
        _currentPage=0;
      }
      _pageController!.animateToPage(_currentPage, duration: Duration(milliseconds: 600), curve: Curves.easeIn);
    });
  }


  @override
  void dispose() {
    _pageController!.dispose();
    if(timer.isActive){
      timer.cancel();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      curve: Curves.easeInOutCubic,
      duration: const Duration(milliseconds: 100),
      tween: Tween<double>(begin: _heights![0], end: _currentHeight),
      builder: (context, value, child) => SizedBox(height: value, child: child),
      child: PageView(
        controller: _pageController,
        children: _sizeReportingChildren
            .asMap() //
            .map((index, child) => MapEntry(index, child))
            .values
            .toList(),
      ),
    );
  }

  List<Widget> get _sizeReportingChildren => widget.children
      .asMap() //
      .map(
        (index, child) => MapEntry(
      index,
      OverflowBox(
        //needed, so that parent won't impose its constraints on the children, thus skewing the measurement results.
        minHeight: 0,
        maxHeight: double.infinity,
        alignment: Alignment.topCenter,
        child: SizeReportingWidget(
          onSizeChange: (size) => setState(() => _heights![index] = size.height ?? 0),
          child: Align(child: child),
        ),
      ),
    ),
  )
      .values
      .toList();
}