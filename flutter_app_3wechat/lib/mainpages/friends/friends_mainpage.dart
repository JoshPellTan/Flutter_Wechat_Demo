import 'package:flutter/material.dart';
import 'package:flutterapp3wechat/mainpages/discover/discover_child_page.dart';
import 'package:flutterapp3wechat/mainpages/friends/friends_cell.dart';
import 'package:flutterapp3wechat/mainpages/friends/friends_index_bar.dart';
import 'package:flutterapp3wechat/mainpages/friends/friends_model.dart';

import '../../const.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  //组title对应的滚动视图偏移位置的字典
  final Map _groupOffsetMap = {INDEX_WORDS[0]: 0.0, INDEX_WORDS[1]: 0.0};
  //头部cell数据
  final List<Friends> _headerData = [
    Friends(imageUrl: 'images/new_friend.png', name: '新的朋友'),
    Friends(imageUrl: 'images/group_chat.png', name: '群聊'),
    Friends(imageUrl: 'images/tags.png', name: '标签'),
    Friends(imageUrl: 'images/public_chat.png', name: '公众号'),
  ];
  //通讯录cell数据
  final List<Friends> _listDatas = [];

  ScrollController _scrollController;

  @override
  //当插入渲染树的时候调用，这个函数在生命周期中只调用一次。这里可以做一些初始化工作，比如初始化State的变量
  void initState() {
    // TODO: implement initState
    super.initState();

    _scrollController = ScrollController();

    _listDatas.addAll(datas);
    //乱序通讯录排序
    _listDatas.sort((Friends a, Friends b) {
      return a.indexLetter.compareTo(b.indexLetter);
    });

    //计算配置组title偏移量字典
    var _groupOffset =
        (FriendsCellHeight + FriendsCellSepLineHeight) * _headerData.length;
    for (int i = 0; i < _listDatas.length; i++) {
      if (i < 1) {
        //第一个必有组title
        _groupOffsetMap.addAll({_listDatas[i].indexLetter: _groupOffset});
        _groupOffset += (FriendsCellGroupTitleHeight +
            FriendsCellHeight +
            FriendsCellSepLineHeight);
      } else if (_listDatas[i].indexLetter != _listDatas[i - 1].indexLetter) {
        //这个i对应的数据与前一个的组title不一样时需增加高度
        _groupOffsetMap.addAll({_listDatas[i].indexLetter: _groupOffset});
        _groupOffset += (FriendsCellGroupTitleHeight +
            FriendsCellHeight +
            FriendsCellSepLineHeight);
      } else {
        //普通的没有组title的数据
        _groupOffset += (FriendsCellHeight + FriendsCellSepLineHeight);
      }
    }
  }

  //cellForRow
  Widget _itemForRow(BuildContext context, int index) {
    if (index < _headerData.length) {
      return FriendsCell(
        name: _headerData[index].name,
        imageAssets: _headerData[index].imageUrl,
      );
    } else {
      //通讯录数据第0个和每组的第一个需要显示组title
      bool _hideIndexLetter = index > _headerData.length &&
          _listDatas[index - _headerData.length - 1]
                  .indexLetter /*上一个indexLetter*/ ==
              _listDatas[index - _headerData.length]
                  .indexLetter /*本次index对应的indexLetter*/;
      return FriendsCell(
        name: datas[index - _headerData.length].name,
        imageUrl: datas[index - _headerData.length].imageUrl,
        groupTitle: _hideIndexLetter
            ? null
            : _listDatas[index - _headerData.length].indexLetter,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WeChatThemeColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: WeChatThemeColor,
        title: Text('通讯录'),
        actions: <Widget>[
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: Image(
                image: AssetImage('images/icon_friends_add.png'),
                width: 25,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      DiscoverChildPage(title: '添加朋友')));
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            controller: _scrollController,
            itemCount: datas.length + _headerData.length,
            itemBuilder: _itemForRow,
          ),
          FriendsIndexBar(
            indexBarCallBack: (String str) {
              if (_groupOffsetMap[str] != null) {
                print('sdfsdfsdfsd');
                _scrollController.animateTo(_groupOffsetMap[str],
                    duration: Duration(microseconds: 200),
                    curve: Curves.easeIn);
              }
            },
          ),
        ],
      ),
    );
  }
}
