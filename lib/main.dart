import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:convert'; // http -> json

void main() {
  runApp(MyApp());
}

// Issuesを取得 List?
Future<dynamic> fetchIssues() async {
  var url = Uri.https('api.github.com', 'repos/flutter/flutter/issues');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    // エラー
    throw Exception('Failed to load album');
  }
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
  Future<dynamic> _issues;

  // TabControllerの初期化
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _issues = fetchIssues();
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
      body: Center(
        child: FutureBuilder<dynamic>(
          future: _issues,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data[0]);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget _createTab(Tab tab) {
    return FutureBuilder<dynamic>(
      future: _issues,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data.title);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}
