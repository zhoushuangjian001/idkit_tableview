## 0.0.1

### Partial update processing of the table view list

##### 1. There are two types of extended lists

```dart
enum TableViewStyle {
  plain, // regular table view
  group, // sections are grouped together
}
```

##### 2. List extension method

```dart
// Set the head view of the table view
1. headerInTableView: (Widget view) -> Widget

// Set the fotter view of the table view
2. footerInTableView: (Widget view) -> Widget

// Set the head view of a group of table views
3. headerInSection: (_, int section) -> Widget

// Set the fotter view of a group of table views
4. footerInSection: (_, int section) -> Widget

// The number of groups in the table view
5. numberOfSection: (_) -> Int

// The number of all elements in each group in the table view
6. numberOfRowInSection: (_, int section) -> Int

// The construction of each group of views containing all elements in the table view
7. itemForRowAtIndexPath: (_, IDKitIndexPath indexPath) -> Widget

// Split view between each group of views in the table view
8. separateInSection: (_, int section) -> Widget

```

##### 3. List update extension method

```dart
/// Update the head view of the tableview.
void updateHeaderTableView()

/// Update the bottom view of the tableview.
void updateFotterTableView()

/// Update the head view of section.
void updateHeaderSection(int section)

/// Update the bottom view of section.
void updateFotterSection(int section)

/// Update the view of a row in section.
void updateRowInSection(IDKitIndexPathindexPath)

/// Update the separate view of section.
void updateSeparateInSection(int section)

/// Update all views in a section.
void updateRowsInSection(int section)

/// All table views are updated.
void updateTableView()
```

##### 4. For a more detailed introduction, please check [README.md](https://github.com/zhoushuangjian001/idkit_tableview#readme)
