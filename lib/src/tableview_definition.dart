import 'package:flutter/material.dart' show Widget;
import 'package:idkit_tableview/src/tableview_indexpath.dart';

/// The main method declaration of the list.
/// Get the number of section in tableView.
typedef NumberOfSectionInTableView = int Function(Widget tableView);

/// Get the number of row in section.
typedef NumberOfRowInSection = int Function(Widget tableView, int section);

/// Get the head of the entire list.
typedef WidgetForHeaderInTableView = Widget Function(Widget tableView);

/// Get the head of the entire list.
typedef WidgetForFooterInTableView = Widget Function(Widget tableView);

typedef HeightForRowAtIndexPath = double Function(
    Widget tableView, int section);

/// Get the head of the entire section.
typedef WidgetForHeaderInSection = Widget Function(
    Widget tableView, int section);

/// Get the head of the entire section.
typedef WidgetForFooterInSection = Widget Function(
    Widget tableView, int section);

/// View construction of list items.
typedef ItemForRowAtIndexPath = Widget Function(
    Widget tableView, IDKitIndexPath indexPath);

/// Split widget between each section.
typedef SeparateInSection = Widget Function(Widget tableView, int section);
