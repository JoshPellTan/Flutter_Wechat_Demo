import 'package:flutter/material.dart';
import 'package:flutterapp3wechat/mainpages/chatpage/chat_mainpage.dart';
import 'package:flutterapp3wechat/mainpages/discover/discover_mainpage.dart';
import 'package:flutterapp3wechat/mainpages/friends/friends_mainpage.dart';
import 'package:flutterapp3wechat/mainpages/mine_mainpage.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {

  int _currentIndex = 0;
  List<Widget> _pages = [ChatPage(),FriendsPage(),DiscoverPage(),MinePage()];//这种写法在页面切换时，每个界面都会重新创建出来，每个页面不是处于flutter的渲染树上
  final PageController _controller = PageController(initialPage: 0);//页面状态保持，使用此方法

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: _pages,
        physics: NeverScrollableScrollPhysics(),//禁止页面滚动
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
          _controller.jumpToPage(index);
        },
        selectedFontSize: 12.0,//bottomitem选中时文字的大小
        currentIndex: _currentIndex,
        fixedColor: Colors.green,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Image.asset('images/tabbar_chat.png',height: 20,width: 20),
              activeIcon: Image.asset('images/tabbar_chat_hl.png',height: 20,width: 20),
              title: Text('微信')),
          BottomNavigationBarItem(
              icon: Image.asset('images/tabbar_friends.png',height: 20,width: 20),
              activeIcon: Image.asset('images/tabbar_friends_hl.png',height: 20,width: 20),
              title: Text('通讯录')),
          BottomNavigationBarItem(
              icon: Image.asset('images/tabbar_discover.png',height: 20,width: 20),
              activeIcon: Image.asset('images/tabbar_discover_hl.png',height: 20,width: 20),
              title: Text('发现')),
          BottomNavigationBarItem(
              icon: Image.asset('images/tabbar_mine.png',height: 20,width: 20),
              activeIcon: Image.asset('images/tabbar_mine_hl.png',height: 20,width: 20),
              title: Text('我')),
        ],
      ),
    );
  }
}


