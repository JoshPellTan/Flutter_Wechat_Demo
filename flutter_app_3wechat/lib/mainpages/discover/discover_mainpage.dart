import 'package:flutter/material.dart';
import 'package:flutterapp3wechat/mainpages/discover/discover_cell.dart';


class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}


class _DiscoverPageState extends State<DiscoverPage> {

  Color _itemColor = Color.fromRGBO(220, 220, 220, 1.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        backgroundColor: widget._itemColor,//如果定义在class DiscoverPage extends StatefulWidget 方法中，如此使用
        backgroundColor: _itemColor,
        //为安卓端做的设置
        centerTitle: true,//安卓特有，app间切换，左上角安卓显示文字，ios不用设置
        title: Text('发现'),
        elevation: 0.0,//底部边栏
      ),
      body: Container(
        color: _itemColor,
        height: 800,
        child: ListView(
          children: <Widget>[
            DiscoverCell(
              title: '朋友圈',
              imageName: 'friend_circle.png',
            ),
            SizedBox(height: 10),
            DiscoverCell(
              title: '扫一扫',
              imageName: 'scan_qr.png',
            ),
            DiscoverCellSepLine(),
            DiscoverCell(
              title: '摇一摇',
              imageName: 'shake.png',
            ),
            SizedBox(height: 10),
            DiscoverCell(
              title: '看一看',
              imageName: 'takealook.png',
            ),
            DiscoverCellSepLine(),
            DiscoverCell(
              title: '搜一搜',
              imageName: 'search.png',
            ),
            SizedBox(height: 10),
            DiscoverCell(
              title: '附近的人',
              imageName: 'nearpeople.png',
            ),
            SizedBox(height: 10),
            DiscoverCell(
              title: '购物',
              imageName: 'shopping.png',
              subTitle: '618限时折扣',
              subImageName: 'badge.png',
            ),
            DiscoverCellSepLine(),
            DiscoverCell(
              title: '游戏',
              imageName: 'game.png',
            ),
            SizedBox(height: 10),
            DiscoverCell(
              title: '小程序',
              imageName: 'applets.png',
            ),
          ],
        ),
      )
    );
  }
}
