import 'package:flutter/material.dart';
import 'package:idkit_tableview/idkit_tableview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

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
