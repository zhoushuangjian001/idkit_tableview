# idkit_tableview

### 1.Introduction

This component supports two kinds of list display, namely single list and grouped list. It supports the view update of a specified element in the list and the view update of a specified group and the view update of the entire list. It does not support the movement and deletion of element views in the table.

### 2. Two types of lists

```dart
enum TableViewStyle {
  plain, // regular table view
  group, // sections are grouped together
}
```

The default is a regular list.

### 3.The control update object of the table view

##### 1. Class Name: IDKitUpdateControl

##### 2. Class definition

```dart
class IDKitUpdateControl {
  /// Factory method to initialize the object.
  factory IDKitUpdateControl() => IDKitUpdateControl._();

  /// Basic initial construction method.
  IDKitUpdateControl._() {
    _updateStreamController = StreamController<IDKitUpdateType>();
  }

  /// Event forwarding subscribers are generated by default.
  StreamController<IDKitUpdateType>? _updateStreamController;
  StreamController<IDKitUpdateType>? get updateStreamController {
    _updateStreamController =
        _updateStreamController ?? IDKitUpdateControl().updateStreamController;
    return _updateStreamController;
  }
  ...... // 省略代码
}
```

##### 3. Update method

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
  void updateRowInSection(IDKitIndexPath indexPath)

  /// Update the separate view of section.
  void updateSeparateInSection(int section)

  /// Update all views in a section.
  void updateRowsInSection(int section)

  /// All table views are updated.
  void updateTableView()
```

### 4. Introduction to some functions of this component

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

### 5. Component example demonstration

##### 1. Single group list instance

```dart
/// Single table view
class SingleTableView extends StatefulWidget {
  const SingleTableView({Key? key}) : super(key: key);

  @override
  _SingleTableViewState createState() => _SingleTableViewState();
}

class _SingleTableViewState extends State<SingleTableView> {
  final List<int> list = List<int>.generate(10, (int index) => 0);
  final IDKitUpdateControl updateControl = IDKitUpdateControl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Single List'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: IDKitTableView(
          updateControl: updateControl,
          itemForRowAtIndexPath: (_, IDKitIndexPath indexPath) {
            return Container(
              height: 60,
              alignment: Alignment.center,
              color: Colors.red,
              child: Row(
                children: <Widget>[
                  const Icon(Icons.ac_unit_outlined),
                  GestureDetector(
                    onTap: () {
                      list[indexPath.row] += 1;
                      updateControl.updateRowInSection(indexPath);
                    },
                    child: Text('item -- ${indexPath.row}'),
                  ),
                  const Spacer(),
                  Text(list[indexPath.row].toString()),
                ],
              ),
            );
          },
          numberOfRowInSection: (_, __) {
            return list.length;
          },
        ),
      ),
    );
  }
}
```

##### 2. Multi-group list instance

```dart
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Map<String, String> map = <String, String>{
    'Num': '110',
    'Count': '220'
  };
  List<int> list = <int>[1, 2, 3, 4, 5, 6];
  final IDKitUpdateControl _updateTableView = IDKitUpdateControl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiple List'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: IDKitTableView(
          style: TableViewStyle.group,
          updateControl: _updateTableView,
          headerInTableView: (Widget view) {
            return Container(
              height: 100,
              color: Colors.pink,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Text(' Single update-${map['Num']}'),
                    ),
                    onTap: () {
                      map['Num'] = '330';
                      _updateTableView.updateHeaderTableView();
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Text('Multiple updates-${map['Num']}'),
                    ),
                    onTap: () {
                      map['Num'] = '430';
                      list = list.map((int e) => e * 10).toList();
                      _updateTableView.updateRowsInSection(1);
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Text('Update all-${map['Num']}'),
                    ),
                    onTap: () {
                      _updateTableView.updateTableView();
                    },
                  )
                ],
              ),
            );
          },
          footerInTableView: (_) {
            return Container(
              height: 100,
              color: Colors.pink,
              child: Text('Table view bottom - ${map['Num']}'),
            );
          },
          headerInSection: (_, int section) {
            return Container(
              height: 60,
              color: Colors.yellow,
              child: Text(
                  'Table view head view of $section group - ${map['Num']}'),
            );
          },
          footerInSection: (_, int section) {
            return Container(
              height: 60,
              color: Colors.yellow,
              child: Text('Table view fotter view of $section group'),
            );
          },
          numberOfSection: (_) => 4,
          numberOfRowInSection: (_, int section) {
            final int res = section % 2;
            return res == 0 ? 2 : 6;
          },
          itemForRowAtIndexPath: (_, IDKitIndexPath indexPath) {
            if (indexPath.section == 1) {
              return Card(
                child: Text('Card - ${list[indexPath.row]}'),
              );
            } else {
              return Container(
                alignment: Alignment.center,
                child: Row(
                  children: const <Widget>[
                    Icon(Icons.access_alarm_outlined),
                    Text('Item'),
                  ],
                ),
                height: 100,
              );
            }
          },
          hideDivider: false,
          separateInSection: (_, int section) {
            return Container(
              height: 20,
              color: Colors.white,
              child:
                  Text('------------ Group split view -$section ------------'),
            );
          },
        ),
      ),
    );
  }
}
```
