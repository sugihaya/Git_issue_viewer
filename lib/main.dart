import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:convert'; // http -> json

void main() {
  runApp(MyApp());
}

// Issuesを取得 List?
Future<dynamic> fetchIssues(String query) async {
  var url = Uri.https(
      'api.github.com', 'repos/flutter/flutter/issues', {'labels': query});
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
        children: [
          TabPage(query: ''),
          TabPage(query: 'p: webview'),
          TabPage(query: 'p: shared_preferences'),
          TabPage(query: 'waiting for customer response'),
          TabPage(query: 'severe: new feature'),
          TabPage(query: 'p: share'),
        ],
      ),
    );
  }
}

// タブの中身
class TabPage extends StatefulWidget {
  final String query;

  const TabPage({
    Key key,
    @required this.query,
  }) : super(key: key);

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with AutomaticKeepAliveClientMixin {
  Future<dynamic> _issues;

  @override
  void initState() {
    super.initState();
    _issues = fetchIssues(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<dynamic>(
      future: _issues,
      builder: (context, snapshot) {
        // 取得判定
        if (snapshot.hasData) {
          // リストビューでアイテムを表示
          return ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                // 各アイテムはカードで表示
                child: _createIssueCard(snapshot.data[index]),
              );
            },
            itemCount: snapshot.data.length,
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  // issueのstateによって返すアイコンを切り替える
  Icon _switchIssueIcon(String state) {
    if (state == 'open') {
      return Icon(
        Icons.info_outline,
        color: Colors.green,
      );
    } else if (state == 'close') {
      return Icon(
        Icons.check_circle_outline,
        color: Colors.red,
      );
    } else {
      return Icon(
        Icons.help_outline,
        color: Colors.blue,
      );
    }
  }

  // issueを表示するウィジェット
  Widget _createIssueCard(Map params) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // issueナンバーとコメント数
            Row(
              children: [
                Text('No.' + params['number'].toString()),
                SizedBox(width: 20), // 余白用
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.comment),
                    Text(params['comments'].toString()),
                  ],
                ),
              ],
            ),
            // 状態アイコンとタイトル
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  _switchIssueIcon(params['state']),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        params['title'],
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 作成者
            Wrap(
              children: [
                Text('created by ' + params['user']['login']),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
