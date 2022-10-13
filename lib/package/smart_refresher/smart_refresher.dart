import 'package:flutter/gestures.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'internals/indicator_wrap.dart';
import 'internals/refresh_physics.dart';
import 'indicator/classic_indicator.dart';
import 'indicator/material_indicator.dart';
import 'internals/slivers.dart';

typedef void OnTwoLevel(bool isOpen);

typedef bool ShouldFollowContent(LoadStatus? status);

typedef IndicatorBuilder = Widget Function();

typedef Widget RefresherBuilder(BuildContext context, RefreshPhysics physics);

enum RefreshStatus {

  idle,
  canRefresh,
  refreshing,
  completed,
  failed,
  canTwoLevel,
  twoLevelOpening,
  twoLeveling,
  twoLevelClosing
}

enum LoadStatus {
  idle,
  canLoading,
  loading,
  noMore,
  failed
}

enum RefreshStyle {
  Follow,
  UnFollow,
  Behind,
  Front
}
enum LoadStyle {
  ShowAlways,
  HideAlways,
  ShowWhenLoading
}
class SmartRefresher extends StatefulWidget {

  final Widget? child;
  final Widget? header;

  final Widget? footer;
  final bool enablePullUp;
  final bool enableTwoLevel;
  final bool enablePullDown;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoading;
  final OnTwoLevel? onTwoLevel;
  final RefreshController controller;
  final RefresherBuilder? builder;
  final Axis? scrollDirection;
  final bool? reverse;
  final ScrollController? scrollController;
  final bool? primary;
  final ScrollPhysics? physics;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior? dragStartBehavior;
  SmartRefresher(
      {Key? key,
      required this.controller,
      this.child,
      this.header,
      this.footer,
      this.enablePullDown: true,
      this.enablePullUp: false,
      this.enableTwoLevel: false,
      this.onRefresh,
      this.onLoading,
      this.onTwoLevel,
      this.dragStartBehavior,
      this.primary,
      this.cacheExtent,
      this.semanticChildCount,
      this.reverse,
      this.physics,
      this.scrollDirection,
      this.scrollController})
      : builder = null,
        super(key: key);
  SmartRefresher.builder({
    Key? key,
    required this.controller,
    required this.builder,
    this.enablePullDown: true,
    this.enablePullUp: false,
    this.enableTwoLevel: false,
    this.onRefresh,
    this.onLoading,
    this.onTwoLevel,
  })  : header = null,
        footer = null,
        child = null,
        scrollController = null,
        scrollDirection = null,
        physics = null,
        reverse = null,
        semanticChildCount = null,
        dragStartBehavior = null,
        cacheExtent = null,
        primary = null,
        super(key: key);

  static SmartRefresher? of(BuildContext? context) {
    return context!.findAncestorWidgetOfExactType<SmartRefresher>();
  }

  static SmartRefresherState? ofState(BuildContext? context) {
    return context!.findAncestorStateOfType<SmartRefresherState>();
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SmartRefresherState();
  }
}

class SmartRefresherState extends State<SmartRefresher> {
  RefreshPhysics? _physics;
  bool _updatePhysics = false;
  double viewportExtent = 0;
  bool _canDrag = true;

  final RefreshIndicator defaultHeader =
      defaultTargetPlatform == TargetPlatform.iOS
          ? ClassicHeader()
          : MaterialClassicHeader();

  final LoadIndicator defaultFooter = ClassicFooter();

  List<Widget>? _buildSliversByChild(BuildContext context, Widget? child,
      RefreshConfiguration? configuration) {
    List<Widget>? slivers;
    if (child is ScrollView) {
      if (child is BoxScrollView) {
        //avoid system inject padding when own indicator top or bottom
        Widget sliver = child.buildChildLayout(context);
        if (child.padding != null) {
          slivers = [SliverPadding(sliver: sliver, padding: child.padding!)];
        } else {
          slivers = [sliver];
        }
      } else {
        slivers = List.from(child.buildSlivers(context), growable: true);
      }
    } else if (child is! Scrollable) {
      slivers = [
        SliverRefreshBody(
          child: child ?? Container(),
        )
      ];
    }
    if (widget.enablePullDown || widget.enableTwoLevel) {
      slivers?.insert(
          0,
          widget.header ??
              (configuration?.headerBuilder != null
                  ? configuration?.headerBuilder!()
                  : null) ??
              defaultHeader);
    }
    //insert header or footer
    if (widget.enablePullUp) {
      slivers?.add(widget.footer ??
          (configuration?.footerBuilder != null
              ? configuration?.footerBuilder!()
              : null) ??
          defaultFooter);
    }

    return slivers;
  }

  ScrollPhysics _getScrollPhysics(
      RefreshConfiguration? conf, ScrollPhysics physics) {
    final bool isBouncingPhysics = physics is BouncingScrollPhysics ||
        (physics is AlwaysScrollableScrollPhysics &&
            ScrollConfiguration.of(context)
                    .getScrollPhysics(context)
                    .runtimeType ==
                BouncingScrollPhysics);
    return _physics = RefreshPhysics(
            dragSpeedRatio: conf?.dragSpeedRatio ?? 1,
            springDescription: conf?.springDescription ??
                const SpringDescription(
                  mass: 2.2,
                  stiffness: 150,
                  damping: 16,
                ),
            controller: widget.controller,
            enableScrollWhenTwoLevel: conf?.enableScrollWhenTwoLevel ?? true,
            updateFlag: _updatePhysics ? 0 : 1,
            enableScrollWhenRefreshCompleted:
                conf?.enableScrollWhenRefreshCompleted ?? false,
            maxUnderScrollExtent: conf?.maxUnderScrollExtent ??
                (isBouncingPhysics ? double.infinity : 0.0),
            maxOverScrollExtent: conf?.maxOverScrollExtent ??
                (isBouncingPhysics ? double.infinity : 60.0),
            topHitBoundary: conf?.topHitBoundary ??
                (isBouncingPhysics
                    ? double.infinity
                    : 0.0), // need to fix default value by ios or android later
            bottomHitBoundary: conf?.bottomHitBoundary ??
                (isBouncingPhysics ? double.infinity : 0.0))
        .applyTo(!_canDrag ? NeverScrollableScrollPhysics() : physics);
  }

  // build the customScrollView
  Widget? _buildBodyBySlivers(
      Widget? childView, List<Widget>? slivers, RefreshConfiguration? conf) {
    Widget? body;
    if (childView is! Scrollable) {
      bool? primary = widget.primary;
      Key? key;
      double? cacheExtent = widget.cacheExtent;

      Axis? scrollDirection = widget.scrollDirection;
      int? semanticChildCount = widget.semanticChildCount;
      bool? reverse = widget.reverse;
      ScrollController? scrollController = widget.scrollController;
      DragStartBehavior? dragStartBehavior = widget.dragStartBehavior;
      ScrollPhysics? physics = widget.physics;
      Key? center;
      double? anchor;
      ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior;
      String? restorationId;
      Clip? clipBehavior;

      if (childView is ScrollView) {
        primary = primary ?? childView.primary;
        cacheExtent = cacheExtent ?? childView.cacheExtent;
        key = key ?? childView.key;
        semanticChildCount = semanticChildCount ?? childView.semanticChildCount;
        reverse = reverse ?? childView.reverse;
        dragStartBehavior = dragStartBehavior ?? childView.dragStartBehavior;
        scrollDirection = scrollDirection ?? childView.scrollDirection;
        physics = physics ?? childView.physics;
        center = center ?? childView.center;
        anchor = anchor ?? childView.anchor;
        keyboardDismissBehavior =
            keyboardDismissBehavior ?? childView.keyboardDismissBehavior;
        restorationId = restorationId ?? childView.restorationId;
        clipBehavior = clipBehavior ?? childView.clipBehavior;
        scrollController = scrollController ?? childView.controller;
      }
      body = CustomScrollView(
        // ignore: DEPRECATED_MEMBER_USE_FROM_SAME_PACKAGE
        controller: scrollController,
        cacheExtent: cacheExtent,
        key: key,
        scrollDirection: scrollDirection ?? Axis.vertical,
        semanticChildCount: semanticChildCount,
        primary: primary,
        clipBehavior: clipBehavior ?? Clip.hardEdge,
        keyboardDismissBehavior:
            keyboardDismissBehavior ?? ScrollViewKeyboardDismissBehavior.manual,
        anchor: anchor ?? 0.0,
        restorationId: restorationId,
        center: center,
        physics:
            _getScrollPhysics(conf, physics ?? AlwaysScrollableScrollPhysics()),
        slivers: slivers!,
        dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
        reverse: reverse ?? false,
      );
    } else if (childView is Scrollable) {
      body = Scrollable(
        physics: _getScrollPhysics(
            conf, childView.physics ?? AlwaysScrollableScrollPhysics()),
        controller: childView.controller,
        axisDirection: childView.axisDirection,
        semanticChildCount: childView.semanticChildCount,
        dragStartBehavior: childView.dragStartBehavior,
        viewportBuilder: (context, offset) {
          Viewport viewport =
              childView.viewportBuilder(context, offset) as Viewport;
          if (widget.enablePullDown) {
            viewport.children.insert(
                0,
                widget.header ??
                    (conf?.headerBuilder != null
                        ? conf?.headerBuilder!()
                        : null) ??
                    defaultHeader);
          }
          //insert header or footer
          if (widget.enablePullUp) {
            viewport.children.add(widget.footer ??
                (conf?.footerBuilder != null ? conf?.footerBuilder!() : null) ??
                defaultFooter);
          }
          return viewport;
        },
      );
    }
    return body;
  }

  bool _ifNeedUpdatePhysics() {
    RefreshConfiguration? conf = RefreshConfiguration.of(context);
    if (conf == null || _physics == null) {
      return false;
    }

    if (conf.topHitBoundary != _physics!.topHitBoundary ||
        _physics!.bottomHitBoundary != conf.bottomHitBoundary ||
        conf.maxOverScrollExtent != _physics!.maxOverScrollExtent ||
        _physics!.maxUnderScrollExtent != conf.maxUnderScrollExtent ||
        _physics!.dragSpeedRatio != conf.dragSpeedRatio ||
        _physics!.enableScrollWhenTwoLevel != conf.enableScrollWhenTwoLevel ||
        _physics!.enableScrollWhenRefreshCompleted !=
            conf.enableScrollWhenRefreshCompleted) {
      return true;
    }
    return false;
  }

  void setCanDrag(bool canDrag) {
    if (_canDrag == canDrag) {
      return;
    }
    setState(() {
      _canDrag = canDrag;
    });
  }

  @override
  void didUpdateWidget(SmartRefresher oldWidget) {
    // TODO: implement didUpdateWidget
    if (widget.controller != oldWidget.controller) {
      widget.controller.headerMode!.value =
          oldWidget.controller.headerMode!.value;
      widget.controller.footerMode!.value =
          oldWidget.controller.footerMode!.value;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_ifNeedUpdatePhysics()) {
      _updatePhysics = !_updatePhysics;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.controller.initialRefresh) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        //  if mounted,it avoid one situation: when init done,then dispose the widget before build.
        //  this   situation mostly TabBarView
        if (mounted) widget.controller.requestRefresh();
      });
    }
    widget.controller._bindState(this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.controller._detachPosition();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RefreshConfiguration? configuration =
        RefreshConfiguration.of(context);
    Widget? body;
    if (widget.builder != null)
      body = widget.builder!(
          context,
          _getScrollPhysics(configuration, AlwaysScrollableScrollPhysics())
              as RefreshPhysics);
    else {
      List<Widget>? slivers =
          _buildSliversByChild(context, widget.child, configuration);
      body = _buildBodyBySlivers(widget.child, slivers, configuration);
    }
    if (configuration == null) {
      body = RefreshConfiguration(child: body!);
    }
    return LayoutBuilder(
      builder: (c2, cons) {
        viewportExtent = cons.biggest.height;
        return body!;
      },
    );
  }
}

/// A controller controll header and footer state,
/// it  can trigger  driving request Refresh ,set the initalRefresh,status if needed
///
/// See also:
///
/// * [SmartRefresher],a widget help you attach refresh and load more function easily
class RefreshController {
  SmartRefresherState? _refresherState;

  /// header status mode controll
  RefreshNotifier<RefreshStatus>? headerMode;

  /// footer status mode controll
  RefreshNotifier<LoadStatus>? footerMode;

  /// the scrollable inner's position
  ///
  /// notice that: position is null before build,
  /// the value is get when the header or footer callback onPositionUpdated
  ScrollPosition? position;

  RefreshStatus? get headerStatus => headerMode?.value;

  LoadStatus? get footerStatus => footerMode?.value;

  bool get isRefresh => headerMode?.value == RefreshStatus.refreshing;

  bool get isTwoLevel =>
      headerMode?.value == RefreshStatus.twoLeveling ||
      headerMode?.value == RefreshStatus.twoLevelOpening ||
      headerMode?.value == RefreshStatus.twoLevelClosing;

  bool get isLoading => footerMode?.value == LoadStatus.loading;

  final bool initialRefresh;

  /// initialRefresh:When SmartRefresher is init,it will call requestRefresh at once
  ///
  /// initialRefreshStatus: headerMode default value
  ///
  /// initialLoadStatus: footerMode default value
  RefreshController(
      {this.initialRefresh: false,
      RefreshStatus? initialRefreshStatus,
      LoadStatus? initialLoadStatus}) {
    this.headerMode =
        RefreshNotifier(initialRefreshStatus ?? RefreshStatus.idle);
    this.footerMode = RefreshNotifier(initialLoadStatus ?? LoadStatus.idle);
  }

  void _bindState(SmartRefresherState state) {
    assert(_refresherState == null,
        "Don't use one refreshController to multiple SmartRefresher,It will cause some unexpected bugs mostly in TabBarView");
    _refresherState = state;
  }

  /// callback when the indicator is builded,and catch the scrollable's inner position
  void onPositionUpdated(ScrollPosition newPosition) {
    position?.isScrollingNotifier.removeListener(_listenScrollEnd);
    position = newPosition;
    position!.isScrollingNotifier.addListener(_listenScrollEnd);
  }

  void _detachPosition() {
    _refresherState = null;
    position?.isScrollingNotifier.removeListener(_listenScrollEnd);
  }

  StatefulElement? _findIndicator(BuildContext context, Type elementType) {
    StatefulElement? result;
    context.visitChildElements((Element e) {
      if (elementType == RefreshIndicator) {
        if (e.widget is RefreshIndicator) {
          result = e as StatefulElement?;
        }
      } else {
        if (e.widget is LoadIndicator) {
          result = e as StatefulElement?;
        }
      }

      result ??= _findIndicator(e, elementType);
    });
    return result;
  }

  /// when bounce out of edge and stopped by overScroll or underScroll, it should be SpringBack to 0.0
  /// but ScrollPhysics didn't provide one way to spring back when outOfEdge(stopped by applyBouncingCondition return != 0.0)
  /// so for making it spring back, it should be trigger goBallistic make it spring back
  void _listenScrollEnd() {
    if (position != null && position!.outOfRange) {
      position?.activity?.applyNewDimensions();
    }
  }

  /// make the header enter refreshing state,and callback onRefresh
  Future<void>? requestRefresh(
      {bool needMove: true,
      bool needCallback: true,
      Duration duration: const Duration(milliseconds: 500),
      Curve curve: Curves.linear}) {
    assert(position != null,
        'Try not to call requestRefresh() before build,please call after the ui was rendered');
    if (isRefresh) return Future.value();
    StatefulElement? indicatorElement =
        _findIndicator(position!.context.storageContext, RefreshIndicator);

    if (indicatorElement == null || _refresherState == null) return null;
    (indicatorElement.state as RefreshIndicatorState).floating = true;

    if (needMove && _refresherState!.mounted)
      _refresherState!.setCanDrag(false);
    if (needMove) {
      return Future.delayed(const Duration(milliseconds: 50)).then((_) async {
        // - 0.0001 is for NestedScrollView.
        await position
            ?.animateTo(position!.minScrollExtent - 0.0001,
                duration: duration, curve: curve)
            .then((_) {
          if (_refresherState != null && _refresherState!.mounted) {
            _refresherState!.setCanDrag(true);
            if (needCallback) {
              headerMode!.value = RefreshStatus.refreshing;
            } else {
              headerMode!.setValueWithNoNotify(RefreshStatus.refreshing);
              if (indicatorElement.state.mounted)
                (indicatorElement.state as RefreshIndicatorState)
                    .setState(() {});
            }
          }
        });
      });
    } else {
      Future.value().then((_) {
        headerMode!.value = RefreshStatus.refreshing;
      });
    }
  }

  /// make the header enter refreshing state,and callback onRefresh
  Future<void> requestTwoLevel(
      {Duration duration: const Duration(milliseconds: 300),
      Curve curve: Curves.linear}) {
    assert(position != null,
        'Try not to call requestRefresh() before build,please call after the ui was rendered');
    headerMode!.value = RefreshStatus.twoLevelOpening;
    return Future.delayed(const Duration(milliseconds: 50)).then((_) async {
      await position?.animateTo(position!.minScrollExtent,
          duration: duration, curve: curve);
    });
  }

  /// make the footer enter loading state,and callback onLoading
  Future<void>? requestLoading(
      {bool needMove: true,
      bool needCallback: true,
      Duration duration: const Duration(milliseconds: 300),
      Curve curve: Curves.linear}) {
    assert(position != null,
        'Try not to call requestLoading() before build,please call after the ui was rendered');
    if (isLoading) return Future.value();
    StatefulElement? indicatorElement =
        _findIndicator(position!.context.storageContext, LoadIndicator);

    if (indicatorElement == null || _refresherState == null) return null;
    (indicatorElement.state as LoadIndicatorState).floating = true;
    if (needMove && _refresherState!.mounted)
      _refresherState!.setCanDrag(false);
    if (needMove) {
      return Future.delayed(const Duration(milliseconds: 50)).then((_) async {
        await position
            ?.animateTo(position!.maxScrollExtent,
                duration: duration, curve: curve)
            .then((_) {
          if (_refresherState != null && _refresherState!.mounted) {
            _refresherState!.setCanDrag(true);
            if (needCallback) {
              footerMode!.value = LoadStatus.loading;
            } else {
              footerMode!.setValueWithNoNotify(LoadStatus.loading);
              if (indicatorElement.state.mounted)
                (indicatorElement.state as LoadIndicatorState).setState(() {});
            }
          }
        });
      });
    } else {
      return Future.value().then((_) {
        footerMode!.value = LoadStatus.loading;
      });
    }
  }

  /// request complete,the header will enter complete state,
  ///
  /// resetFooterState : it will set the footer state from noData to idle
  void refreshCompleted({bool resetFooterState: false}) {
    headerMode?.value = RefreshStatus.completed;
    if (resetFooterState) {
      resetNoData();
    }
  }

  /// end twoLeveling,will return back first floor
  Future<void>? twoLevelComplete(
      {Duration duration: const Duration(milliseconds: 500),
      Curve curve: Curves.linear}) {
    headerMode?.value = RefreshStatus.twoLevelClosing;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      position!
          .animateTo(0.0, duration: duration, curve: curve)
          .whenComplete(() {
        headerMode!.value = RefreshStatus.idle;
      });
    });
    return null;
  }

  /// request failed,the header display failed state
  void refreshFailed() {
    headerMode?.value = RefreshStatus.failed;
  }

  /// not show success or failed, it will set header state to idle and spring back at once
  void refreshToIdle() {
    headerMode?.value = RefreshStatus.idle;
  }

  /// after data returned,set the footer state to idle
  void loadComplete() {
    // change state after ui update,else it will have a bug:twice loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      footerMode?.value = LoadStatus.idle;
    });
  }

  /// If catchError happen,you may call loadFailed indicate fetch data from network failed
  void loadFailed() {
    // change state after ui update,else it will have a bug:twice loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      footerMode?.value = LoadStatus.failed;
    });
  }

  /// load more success without error,but no data returned
  void loadNoData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      footerMode?.value = LoadStatus.noMore;
    });
  }

  /// reset footer noData state  to idle
  void resetNoData() {
    if (footerMode?.value == LoadStatus.noMore) {
      footerMode!.value = LoadStatus.idle;
    }
  }

  /// for some special situation, you should call dispose() for safe,it may throw errors after parent widget dispose
  void dispose() {
    headerMode!.dispose();
    footerMode!.dispose();
    headerMode = null;
    footerMode = null;
  }
}

/// Controls how SmartRefresher widgets behave in a subtree.the usage just like [ScrollConfiguration]
///
/// The refresh configuration determines smartRefresher some behaviours,global setting default indicator
///
/// see also:
///
/// * [SmartRefresher], a widget help attach the refresh and load more function
class RefreshConfiguration extends InheritedWidget {
  final Widget child;

  /// global default header builder
  final IndicatorBuilder? headerBuilder;

  /// global default footer builder
  final IndicatorBuilder? footerBuilder;

  /// custom spring animate
  final SpringDescription springDescription;

  /// If need to refreshing now when reaching triggerDistance
  final bool skipCanRefresh;

  /// if it should follow content for different state
  final ShouldFollowContent? shouldFooterFollowWhenNotFull;

  /// when listView data small(not enough one page) , it should be hide
  final bool hideFooterWhenNotFull;

  /// whether user can drag viewport when twoLeveling
  final bool enableScrollWhenTwoLevel;

  /// whether user can drag viewport when refresh complete and spring back
  final bool enableScrollWhenRefreshCompleted;

  /// whether trigger refresh by  BallisticScrollActivity
  final bool enableBallisticRefresh;

  /// whether trigger loading by  BallisticScrollActivity
  final bool enableBallisticLoad;

  /// whether footer can trigger load by reaching footerDistance when failed state
  final bool enableLoadingWhenFailed;

  /// whether footer can trigger load by reaching footerDistance when inNoMore state
  final bool enableLoadingWhenNoData;

  /// overScroll distance of trigger refresh
  final double headerTriggerDistance;

  ///	the overScroll distance of trigger twoLevel
  final double twiceTriggerDistance;

  /// Close the bottom crossing distance on the second floor, premise:enableScrollWhenTwoLevel is true
  final double closeTwoLevelDistance;

  /// the extentAfter distance of trigger loading
  final double footerTriggerDistance;

  /// the speed ratio when dragging overscroll ,compute=origin physics dragging speed *dragSpeedRatio
  final double dragSpeedRatio;

  /// max overScroll distance when out of edge
  final double? maxOverScrollExtent;

  /// 	max underScroll distance when out of edge
  final double? maxUnderScrollExtent;

  /// The boundary is located at the top edge and stops when inertia rolls over the boundary distance
  final double? topHitBoundary;

  /// The boundary is located at the bottom edge and stops when inertia rolls under the boundary distance
  final double? bottomHitBoundary;

  /// toggle of  refresh vibrate
  final bool enableRefreshVibrate;

  /// toggle of  loadmore vibrate
  final bool enableLoadMoreVibrate;

  RefreshConfiguration(
      {Key? key,
      required this.child,
      this.headerBuilder,
      this.footerBuilder,
      this.dragSpeedRatio: 1.0,
      this.shouldFooterFollowWhenNotFull,
      this.enableScrollWhenTwoLevel: true,
      this.enableLoadingWhenNoData: false,
      this.enableBallisticRefresh: false,
      this.springDescription: const SpringDescription(
        mass: 2.2,
        stiffness: 150,
        damping: 16,
      ),
      this.enableScrollWhenRefreshCompleted: false,
      this.enableLoadingWhenFailed: true,
      this.twiceTriggerDistance: 150.0,
      this.closeTwoLevelDistance: 80.0,
      this.skipCanRefresh: false,
      this.maxOverScrollExtent,
      this.enableBallisticLoad: true,
      this.maxUnderScrollExtent,
      this.headerTriggerDistance: 80.0,
      this.footerTriggerDistance: 15.0,
      this.hideFooterWhenNotFull: false,
      this.enableRefreshVibrate: false,
      this.enableLoadMoreVibrate: false,
      this.topHitBoundary,
      this.bottomHitBoundary})
      : assert(headerTriggerDistance > 0),
        assert(twiceTriggerDistance > 0),
        assert(closeTwoLevelDistance > 0),
        assert(dragSpeedRatio > 0),
        super(key: key, child: child);

  /// Construct RefreshConfiguration to copy attributes from ancestor nodes
  /// If the parameter is null, it will automatically help you to absorb the attributes of your ancestor Refresh Configuration, instead of having to copy them manually by yourself.
  ///
  /// it mostly use in some stiuation is different the other SmartRefresher in App
  RefreshConfiguration.copyAncestor({
    Key? key,
    required BuildContext context,
    required this.child,
    IndicatorBuilder? headerBuilder,
    IndicatorBuilder? footerBuilder,
    double? dragSpeedRatio,
    ShouldFollowContent? shouldFooterFollowWhenNotFull,
    bool? enableScrollWhenTwoLevel,
    bool? enableBallisticRefresh,
    bool? enableBallisticLoad,
    bool? enableLoadingWhenNoData,
    SpringDescription? springDescription,
    bool? enableScrollWhenRefreshCompleted,
    bool? enableLoadingWhenFailed,
    double? twiceTriggerDistance,
    double? closeTwoLevelDistance,
    bool? skipCanRefresh,
    double? maxOverScrollExtent,
    double? maxUnderScrollExtent,
    double? topHitBoundary,
    double? bottomHitBoundary,
    double? headerTriggerDistance,
    double? footerTriggerDistance,
    bool? enableRefreshVibrate,
    bool? enableLoadMoreVibrate,
    bool? hideFooterWhenNotFull,
  })  : assert(RefreshConfiguration.of(context) != null,
            "search RefreshConfiguration anscestor return null,please  Make sure that RefreshConfiguration is the ancestor of that element"),
        headerBuilder =
            headerBuilder ?? RefreshConfiguration.of(context)!.headerBuilder,
        footerBuilder =
            footerBuilder ?? RefreshConfiguration.of(context)!.footerBuilder,
        dragSpeedRatio =
            dragSpeedRatio ?? RefreshConfiguration.of(context)!.dragSpeedRatio,
        twiceTriggerDistance = twiceTriggerDistance ??
            RefreshConfiguration.of(context)!.twiceTriggerDistance,
        headerTriggerDistance = headerTriggerDistance ??
            RefreshConfiguration.of(context)!.headerTriggerDistance,
        footerTriggerDistance = footerTriggerDistance ??
            RefreshConfiguration.of(context)!.footerTriggerDistance,
        springDescription = springDescription ??
            RefreshConfiguration.of(context)!.springDescription,
        hideFooterWhenNotFull = hideFooterWhenNotFull ??
            RefreshConfiguration.of(context)!.hideFooterWhenNotFull,
        maxOverScrollExtent = maxOverScrollExtent ??
            RefreshConfiguration.of(context)!.maxOverScrollExtent,
        maxUnderScrollExtent = maxUnderScrollExtent ??
            RefreshConfiguration.of(context)!.maxUnderScrollExtent,
        topHitBoundary =
            topHitBoundary ?? RefreshConfiguration.of(context)!.topHitBoundary,
        bottomHitBoundary = bottomHitBoundary ??
            RefreshConfiguration.of(context)!.bottomHitBoundary,
        skipCanRefresh =
            skipCanRefresh ?? RefreshConfiguration.of(context)!.skipCanRefresh,
        enableScrollWhenRefreshCompleted = enableScrollWhenRefreshCompleted ??
            RefreshConfiguration.of(context)!.enableScrollWhenRefreshCompleted,
        enableScrollWhenTwoLevel = enableScrollWhenTwoLevel ??
            RefreshConfiguration.of(context)!.enableScrollWhenTwoLevel,
        enableBallisticRefresh = enableBallisticRefresh ??
            RefreshConfiguration.of(context)!.enableBallisticRefresh,
        enableBallisticLoad = enableBallisticLoad ??
            RefreshConfiguration.of(context)!.enableBallisticLoad,
        enableLoadingWhenNoData = enableLoadingWhenNoData ??
            RefreshConfiguration.of(context)!.enableLoadingWhenNoData,
        enableLoadingWhenFailed = enableLoadingWhenFailed ??
            RefreshConfiguration.of(context)!.enableLoadingWhenFailed,
        closeTwoLevelDistance = closeTwoLevelDistance ??
            RefreshConfiguration.of(context)!.closeTwoLevelDistance,
        enableRefreshVibrate = enableRefreshVibrate ??
            RefreshConfiguration.of(context)!.enableRefreshVibrate,
        enableLoadMoreVibrate = enableLoadMoreVibrate ??
            RefreshConfiguration.of(context)!.enableLoadMoreVibrate,
        shouldFooterFollowWhenNotFull = shouldFooterFollowWhenNotFull ??
            RefreshConfiguration.of(context)!.shouldFooterFollowWhenNotFull,
        super(key: key, child: child);

  static RefreshConfiguration? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RefreshConfiguration>();
  }

  @override
  bool updateShouldNotify(RefreshConfiguration oldWidget) {
    return skipCanRefresh != oldWidget.skipCanRefresh ||
        hideFooterWhenNotFull != oldWidget.hideFooterWhenNotFull ||
        dragSpeedRatio != oldWidget.dragSpeedRatio ||
        enableScrollWhenRefreshCompleted !=
            oldWidget.enableScrollWhenRefreshCompleted ||
        enableBallisticRefresh != oldWidget.enableBallisticRefresh ||
        enableScrollWhenTwoLevel != oldWidget.enableScrollWhenTwoLevel ||
        closeTwoLevelDistance != oldWidget.closeTwoLevelDistance ||
        footerTriggerDistance != oldWidget.footerTriggerDistance ||
        headerTriggerDistance != oldWidget.headerTriggerDistance ||
        twiceTriggerDistance != oldWidget.twiceTriggerDistance ||
        maxUnderScrollExtent != oldWidget.maxUnderScrollExtent ||
        oldWidget.maxOverScrollExtent != maxOverScrollExtent ||
        enableBallisticRefresh != oldWidget.enableBallisticRefresh ||
        enableLoadingWhenFailed != oldWidget.enableLoadingWhenFailed ||
        topHitBoundary != oldWidget.topHitBoundary ||
        enableRefreshVibrate != oldWidget.enableRefreshVibrate ||
        enableLoadMoreVibrate != oldWidget.enableLoadMoreVibrate ||
        bottomHitBoundary != oldWidget.bottomHitBoundary;
  }
}

class RefreshNotifier<T> extends ChangeNotifier implements ValueListenable<T> {
  /// Creates a [ChangeNotifier] that wraps this value.
  RefreshNotifier(this._value);
  T _value;

  @override
  T get value => _value;

  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    notifyListeners();
  }

  void setValueWithNoNotify(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}
