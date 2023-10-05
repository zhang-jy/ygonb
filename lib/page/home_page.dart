import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ygonotebook/widget/card_item_widget.dart';

const ratio = 177/254;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "搜索",
      theme: Theme.of(context).copyWith(
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tabIndex = 0;

  final List<TabPageData> _tabPageData = <TabPageData>[
    TabPageData(
      tabIcon: const Icon(Icons.home, color: Colors.grey,),
      activeTabIcon: const Icon(Icons.home, color: Colors.blue,),
      label: "Home",
      page: const Page1(),
    ),
    TabPageData(
      tabIcon: const Icon(Icons.person, color: Colors.grey,),
      activeTabIcon: const Icon(Icons.person, color: Colors.blue,),

      label: "Profile",
      page: const Page2(),
    ),
    TabPageData(
      tabIcon: const Icon(Icons.message, color: Colors.grey,),
      activeTabIcon: const Icon(Icons.message, color: Colors.blue,),
      label: "Chat",
      page: const Page3(),
    ),
    TabPageData(
      tabIcon: const Icon(Icons.settings, color: Colors.grey,),
      activeTabIcon: const Icon(Icons.settings, color: Colors.blue,),
      label: "Settings",
      page: const Page4(),
    ),
  ];

  List<Widget> get _pages => _tabPageData.map((e) => e.page).toList();
  List<BottomNavigationBarItem> get _tabItems => _tabPageData.map((e) => BottomNavigationBarItem(icon: e.tabIcon, activeIcon: e.activeTabIcon, label: e.label)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("搜索"),
      ),
      persistentFooterAlignment: AlignmentDirectional.centerStart,
      bottomNavigationBar: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: BottomNavigationBar(
          currentIndex: tabIndex,
          onTap: (index) {
            tabIndex = index;
            setState(() {});
          },
          selectedLabelStyle: const TextStyle(color: Colors.blueAccent),
          unselectedLabelStyle: const TextStyle(color: Colors.black),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          enableFeedback: false,
          items: _tabItems,
        ),
      ),
      body: IndexedStack(
        index: tabIndex,
        children: _pages,
      ),
    );
  }
}

class TabPageData {
  final Widget tabIcon;
  final Widget activeTabIcon;
  final String label;
  final Widget page;

  TabPageData({required this.tabIcon, required this.activeTabIcon, required this.label, required this.page});
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemBuilder: (ctx, index) {
        return const CardItemWidget();
      },
      itemCount: 20,
      separatorBuilder: (ctx, index) {
        return Container(height: 10,);
      },
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("page2"),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("page3"),
    );
  }
}

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("page4"),
    );
  }
}