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
      home: SingleTableView(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Map<String, String> map = <String, String>{'a': '110', 'b': '220'};
  List<int> list = [1, 2, 3, 4, 5, 6];
  final IDKitUpdateControl _updateTableView = IDKitUpdateControl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: IDKitTableView(
          style: TableViewStyle.group,
          updateControl: _updateTableView,
          headerInTableView: (Widget view) {
            return Container(
              height: 100,
              color: Colors.pink,
              child: Row(
                children: [
                  GestureDetector(
                    child: Text('更新按钮 ---${map['a']}'),
                    onTap: () {
                      map['a'] = '330';
                      _updateTableView.updateHeaderTableView();
                    },
                  ),
                  GestureDetector(
                    child: Text('更新按钮 ---${map['a']}'),
                    onTap: () {
                      map['a'] = '430';
                      list = list.map((e) => e * 10).toList();
                      _updateTableView.updateRowsInSection(1);
                    },
                  ),
                  GestureDetector(
                    child: Text('更新按钮 ---${map['a']}'),
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
              child: Text('列表--底部- ${map['a']}'),
            );
          },
          headerInSection: (_, int section) {
            return Container(
              height: 60,
              color: Colors.yellow,
              child: Text('组头 - $section--${map['a']}'),
            );
          },
          footerInSection: (_, int section) {
            return Container(
              height: 60,
              color: Colors.yellow,
              child: Text('组尾 - $section'),
            );
          },
          numberOfSection: (_) => 6,
          numberOfRowInSection: (_, int section) {
            return section % 2 == 0 ? 2 : 6;
          },
          itemForRowAtIndexPath: (_, IDKitIndexPath indexPath) {
            if (indexPath.section == 1) {
              return Card(
                child: Text('卡片 - ${list[indexPath.row]}'),
              );
            } else {
              return Container(
                child: Text('子元素'),
                height: 100,
              );
            }
          },
          hideDivider: false,
          separateInSection: (_, int section) {
            return Container(
              height: 20,
              color: Colors.white,
              child: const Text('----------组分割-------------'),
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
