import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Issue Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'GitHub Issue Viewer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  // Tabウィジェットのリスト
  final List<Tab> tabs = <Tab>[
    Tab(text: '全て'),
    Tab(text: 'p: webview'),
    Tab(text: 'p: shared_preferences'),
    Tab(text: 'waiting for customer response'),
    Tab(text: 'severe: new feature'),
    Tab(text: 'p: share'),
  ];

  TabController _tabController;

  // TabControllerの初期化
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            tabs: tabs,
            controller: _tabController,
            isScrollable: true,
            unselectedLabelStyle: TextStyle(fontSize: 12.0),
            labelStyle: TextStyle(fontSize: 16.0),
            indicatorWeight: 2,
          )),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((tab) {
          return _createTab(tab);
        }).toList(),
      ),
    );
  }

  Widget _createTab(Tab tab) {
    return Center(
      child: Text('test'),
    );
  }
}
