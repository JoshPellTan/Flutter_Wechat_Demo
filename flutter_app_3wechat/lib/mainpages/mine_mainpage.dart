import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp3wechat/const.dart';
import 'package:flutterapp3wechat/mainpages/discover/discover_cell.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.blue, //or set color with: Color(0xFF0000FF)
    ));
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              color: WeChatThemeColor,
              child: MediaQuery.removePadding(
                //整体上移，覆盖掉statusbar位置
                removeTop: true,
                context: context,
                child: ListView(
                  children: <Widget>[
                    headerWidget(),
                    SizedBox(height: 5),
                    DiscoverCell(
                      title: '支付',
                      imageName: 'wechat_pay.png',
                    ),
                    SizedBox(height: 5),
                    DiscoverCell(
                      title: '收藏',
                      imageName: 'wechat_collect.png',
                    ),
                    DiscoverCellSepLine(),
                    DiscoverCell(
                      title: '相册',
                      imageName: 'wechat_album.png',
                    ),
                    DiscoverCellSepLine(),
                    DiscoverCell(
                      title: '卡包',
                      imageName: 'wechat_cards.png',
                    ),
                    DiscoverCellSepLine(),
                    DiscoverCell(
                      title: '表情',
                      imageName: 'wechat_emoji.png',
                    ),
                    SizedBox(height: 5),
                    DiscoverCell(
                      title: '设置',
                      imageName: 'wehcat_setting.png',
                    ),
                  ],
                ),
              )),
          Container(
            margin: EdgeInsets.only(top: 50, right: 20),
            height: 25,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Image.asset('images/minecamera.png'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //头部widget
  Widget headerWidget() {
    return Container(
      color: Colors.white,
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 20, top: 100),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image(
                  image: AssetImage('images/tj_header.png'),
                  width: 60,
                  height: 60,
                ),
              ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, top: 100),
            width: ScreenWidth(context) - 120,
            height: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Text(
                    '国安局健哥',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '微信号：帅到掉渣',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      Image(
                        image: AssetImage('images/icon_right.png'),
                        width: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
