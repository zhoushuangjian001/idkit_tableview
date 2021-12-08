import 'dart:async' show StreamController;
import 'dart:collection' show HashMap;
import 'package:flutter/material.dart';
import 'package:idkit_tableview/idkit_tableview.dart';
import 'package:idkit_tableview/src/tableview_definition.dart';
import 'package:idkit_tableview/src/tableview_indexpath.dart';
import 'package:idkit_tableview/src/tableview_stream.dart';
import 'package:idkit_tableview/src/tableview_style.dart';

class IDKitTableView extends StatefulWidget {
  const IDKitTableView({
    Key? key,
    this.controller,
    this.headerInTableView,
    this.footerInTableView,
    this.headerInSection,
    this.footerInSection,
    this.numberOfSection,
    this.numberOfRowInSection,
    this.itemForRowAtIndexPath,
    this.divider,
    this.hideDivider = false,
    this.separateInSection,
    this.updateControl,
    this.style = TableViewStyle.plain,
    this.padding,
    this.margin,
    this.decoration,
    this.color,
    this.width,
    this.height,
    this.physics,
    this.shrinkWrap = false,
    this.primary,
    this.scrollDirection = Axis.vertical,
  }) : super(key: key);

  /// List sliding control object.
  final ScrollController? controller;

  /// The head of the list.
  final WidgetForHeaderInTableView? headerInTableView;

  /// The footer of the list.
  final WidgetForFooterInTableView? footerInTableView;

  /// The head of the section.
  final WidgetForHeaderInSection? headerInSection;

  /// The footer of the section.
  final WidgetForFooterInSection? footerInSection;

  /// The number of inner groups in the list.
  final NumberOfSectionInTableView? numberOfSection;

  /// The number of items in each group.
  final NumberOfRowInSection? numberOfRowInSection;

  /// View construction of list items.
  final ItemForRowAtIndexPath? itemForRowAtIndexPath;

  /// Dividing line between elements.
  final Widget? divider;

  /// Whether to hide the dividing line between elements.
  /// true: hide ; false: Not hidden.
  final bool hideDivider;

  /// Split widget between each section.
  final SeparateInSection? separateInSection;

  /// TableView update control object.
  final IDKitUpdateControl? updateControl;

  /// Type of table view.
  final TableViewStyle style;

  /// The padding of the table view.
  final EdgeInsetsGeometry? padding;

  /// The margins of the table view.
  final EdgeInsetsGeometry? margin;

  /// Rear decoration of table view.
  final Decoration? decoration;

  /// The background color of the table view.
  final Color? color;

  /// The width of the table view.
  final double? width;

  /// The height of the table view.
  final double? height;

  /// The scroll type of the table view.
  final ScrollPhysics? physics;

  /// Table view element display form.
  final bool shrinkWrap;

  /// Whether the table view tracks the parent scroll view scrolling.
  final bool? primary;

  /// The direction in which the table view scrolls.
  final Axis scrollDirection;

  @override
  _IDKitTableViewState createState() => _IDKitTableViewState();
}

class _IDKitTableViewState extends State<IDKitTableView> {
  /// Store all displayed view collections.
  List<Widget> itemsList = <Widget>[];

  /// The key-value collection of the subscribers of each module.
  late HashMap<String, StreamController<bool>> streamControllerMap =
      HashMap<String, StreamController<bool>>();

  /// Prevent scrolling multiple times to build the view.
  late HashMap<String, Widget> widgetsMap = HashMap<String, Widget>();

  /// Reset the collection to avoid duplication.
  void _cleanAllList() {
    itemsList.clear();
    widgetsMap.clear();
    streamControllerMap.clear();
  }

  /// Integrate data into a collection
  void _assembleDataToList() {
    // Process storage collection data.
    _cleanAllList();
    // Top view of table view.
    if (widget.headerInTableView != null) {
      const String key = 'com.idkit.header';
      _addStreamWidgetToList(key, (_, AsyncSnapshot<bool> snapshot) {
        final bool state = snapshot.data!;
        final bool contains = widgetsMap.containsKey(key);
        if (state) {
          final Widget child = widget.headerInTableView!(widget);
          if (contains) {
            widgetsMap.update(key, (_) => child);
          } else {
            widgetsMap.putIfAbsent(key, () => child);
          }
          return child;
        } else {
          if (contains) {
            return widgetsMap[key]!;
          } else {
            final Widget child = widget.headerInTableView!(widget);
            widgetsMap.putIfAbsent(key, () => child);
            return child;
          }
        }
      });
    }

    // View processing for each part of the table view.
    final bool _style = widget.style == TableViewStyle.plain;
    final int totalSection =
        _style ? 1 : (widget.numberOfSection?.call(widget) ?? 1);

    for (int section = 0; section < totalSection; section++) {
      // Header view.
      if (widget.headerInSection != null) {
        final String key = 'com.idkit.section.header-$section';
        _addStreamWidgetToList(key, (_, AsyncSnapshot<bool> snapshot) {
          final bool state = snapshot.data!;
          final bool contains = widgetsMap.containsKey(key);
          if (state) {
            final Widget child = widget.headerInSection!(widget, section);
            if (contains) {
              widgetsMap.update(key, (_) => child);
            } else {
              widgetsMap.putIfAbsent(key, () => child);
            }
            return child;
          } else {
            if (contains) {
              return widgetsMap[key]!;
            } else {
              final Widget child = widget.headerInSection!(widget, section);
              widgetsMap.putIfAbsent(key, () => child);
              return child;
            }
          }
        });
      }
      final int rowCountInSection =
          widget.numberOfRowInSection?.call(widget, section) ?? 0;
      // Row view.
      for (int row = 0; row < rowCountInSection; row++) {
        final IDKitIndexPath indexPath =
            IDKitIndexPath(section: section, row: row);
        final String key = 'com.idkit.section.row-$section-$row';
        _addStreamWidgetToList(key, (_, AsyncSnapshot<bool> snapshot) {
          final bool state = snapshot.data!;
          final bool contains = widgetsMap.containsKey(key);
          if (state) {
            final Widget child =
                widget.itemForRowAtIndexPath?.call(widget, indexPath) ??
                    Container();
            if (contains) {
              widgetsMap.update(key, (_) => child);
            } else {
              widgetsMap.putIfAbsent(key, () => child);
            }
            return child;
          } else {
            if (contains) {
              return widgetsMap[key]!;
            } else {
              final Widget child =
                  widget.itemForRowAtIndexPath?.call(widget, indexPath) ??
                      Container();
              widgetsMap.putIfAbsent(key, () => child);
              return child;
            }
          }
        });
        // Divider line.
        if (!widget.hideDivider) {
          itemsList.add(
            widget.divider ??
                const Divider(color: Colors.green, height: 0.5, thickness: 0.5),
          );
        }
      }
      // Fotter view.
      if (widget.footerInSection != null) {
        final String key = 'com.idkit.section.fotter-$section';
        _addStreamWidgetToList(key, (_, AsyncSnapshot<bool> snapshot) {
          final bool state = snapshot.data!;
          final bool contains = widgetsMap.containsKey(key);
          if (state) {
            final Widget child = widget.footerInSection!(widget, section);
            if (contains) {
              widgetsMap.update(key, (_) => child);
            } else {
              widgetsMap.putIfAbsent(key, () => child);
            }
            return child;
          } else {
            if (contains) {
              return widgetsMap[key]!;
            } else {
              final Widget child = widget.footerInSection!(widget, section);
              widgetsMap.putIfAbsent(key, () => child);
              return child;
            }
          }
        });
      }

      // Separate view in section.
      if (widget.separateInSection != null &&
          section != totalSection - 1 &&
          !_style) {
        final String key = 'com.idkit.separate.section-$section';
        _addStreamWidgetToList(key, (_, AsyncSnapshot<bool> snapshot) {
          final bool state = snapshot.data!;
          final bool contains = widgetsMap.containsKey(key);
          if (state) {
            final Widget child = widget.separateInSection!(widget, section);
            if (contains) {
              widgetsMap.update(key, (_) => child);
            } else {
              widgetsMap.putIfAbsent(key, () => child);
            }
            return child;
          } else {
            if (contains) {
              return widgetsMap[key]!;
            } else {
              final Widget child = widget.separateInSection!(widget, section);
              widgetsMap.putIfAbsent(key, () => child);
              return child;
            }
          }
        });
      }
    }

    // Is it the bottom view of the table view.
    if (widget.footerInTableView != null) {
      const String key = 'com.idkit.fotter';
      _addStreamWidgetToList(key, (_, AsyncSnapshot<bool> snapshot) {
        final bool state = snapshot.data!;
        final bool contains = widgetsMap.containsKey(key);
        if (state) {
          final Widget child = widget.footerInTableView!(widget);
          if (contains) {
            widgetsMap.update(key, (_) => child);
          } else {
            widgetsMap.putIfAbsent(key, () => child);
          }
          return child;
        } else {
          if (contains) {
            return widgetsMap[key]!;
          } else {
            final Widget child = widget.footerInTableView!(widget);
            widgetsMap.putIfAbsent(key, () => child);
            return child;
          }
        }
      });
    }
  }

  /// Add controller components with control stream to the global collection.
  void _addStreamWidgetToList(String key, AsyncWidgetBuilder<bool> builder) {
    final StreamController<bool> streamController =
        StreamController<bool>.broadcast();
    streamControllerMap.putIfAbsent(key, () => streamController);
    final Widget streamWidget =
        StreamWidget(streamController: streamController, builder: builder);
    itemsList.add(streamWidget);
  }

  /// Forward events for updated tableview.
  @override
  void initState() {
    widget.updateControl?.updateStreamController?.stream
        .listen((IDKitUpdateType type) {
      _updateMethod(type);
    });
    super.initState();
  }

  /// Initially build the view.
  @override
  Widget build(BuildContext context) {
    _assembleDataToList();
    return Container(
      padding: widget.padding,
      margin: widget.margin,
      decoration: widget.decoration,
      color: widget.color,
      width: widget.width,
      height: widget.height,
      child: ListView.builder(
        controller: widget.controller,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        primary: widget.primary,
        scrollDirection: widget.scrollDirection,
        itemBuilder: (_, int index) => RepaintBoundary(child: itemsList[index]),
        itemCount: itemsList.length,
        cacheExtent: itemsList.length * 0.4,
      ),
    );
  }

  /// Dispose system.
  @override
  void dispose() {
    disposeStreamController();
    super.dispose();
  }

  /// Dispose of all controlled stream with controller.
  void disposeStreamController() {
    streamControllerMap
        .forEach((_, StreamController<bool> item) => item.close());
  }

  /// The general method of updating the view.
  void _updateMethod(IDKitUpdateType updateType) {
    final String key = updateType.key;
    if (key.isNotEmpty) {
      switch (updateType.refresh) {
        case TableViewRefresh.all:
          if (mounted) {
            setState(() {});
          }
          break;
        case TableViewRefresh.section:
          for (final String keyItem in streamControllerMap.keys) {
            if (keyItem.contains(key)) {
              streamControllerMap[keyItem]?.add(true);
            }
          }
          break;
        default:
          streamControllerMap[key]?.add(true);
      }
    }
  }
}
