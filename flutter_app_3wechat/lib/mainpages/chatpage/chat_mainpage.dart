import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp3wechat/mainpages/chatpage/chat_search_cell.dart';
import 'package:flutterapp3wechat/tools/http_manager.dart';
import 'package:http/http.dart'
    as http; //as用法防止库冲突,可能其他库也有http库同样的函数名，http.get解决此冲突
//hide  隐藏某个不需要的方法，如hide get
//show  只导入某些内容
import 'package:dio/dio.dart';

import '../../const.dart';
import 'chat_model.dart';

/*
  1,appbar右边的加号功能弹出items
  2，数据网络请求
  3，数据整理和展示
 */

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with AutomaticKeepAliveClientMixin<ChatPage> {
  //保持页面状态步骤一(前提是页面必须在渲染树内)

  List<Chat> _chatDatas = [];
  bool _cancleConnect = false;
  Timer _timer;

  //构造方法,保证生命周期内只走一次
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    int _timerCount = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      //事件队列和UI任务在同一优先级，所以不会阻塞UI，但如果像下面使用微任务就会阻塞UI
      //main isolate
//        scheduleMicrotask(() {
//          sleep(Duration(seconds: 2));
//        });
//      print(Isolate.current.debugName);
      _timerCount++;
//      print(_timerCount);
      if (_timerCount == 99) {
        timer.cancel();
      }
    }); //timer需要在生命周期结束时进行销毁

    getChatData(getSuccess: (data) {
      if (!_cancleConnect) {
        setState(() {
          _chatDatas = data;
        });
      }
    });
  }

  @override
  void dispose() {
    //生命周期结束时需要停掉timer
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); //保持页面状态步骤三，
    return Scaffold(
      appBar: AppBar(
        elevation: 0, //appbar下方阴影
        backgroundColor: WeChatThemeColor,
        title: Text('微信'),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: PopupMenuButton(
              color: Colors.black87,
              offset: Offset(0.0, 60.0),
              child: Image(
                image: AssetImage('images/icon_add.png'),
                width: 25,
              ),
              itemBuilder: (BuildContext context) {
                return <PopupMenuItem<String>>[
                  PopupMenuItem(
                    child: _popupItemBuilder(
                        'images/chat_group_create.png', '发起群聊'),
                  ),
                  PopupMenuItem(
                    child: _popupItemBuilder('images/friends_add.png', '添加朋友'),
                  ),
                  PopupMenuItem(
                    child: _popupItemBuilder('images/icon_scan_qr.png', '扫一扫'),
                  ),
                  PopupMenuItem(
                    child: _popupItemBuilder('images/payment.png', '收付款'),
                  ),
                ];
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: _chatDatas.length == 0
            ? Center(child: Text('Loading...'))
            : Container(
                color: WeChatThemeColor,
                child: ListView.builder(
                  itemCount: _chatDatas.length + 1,
                  itemBuilder: _buildCellForRow,
                )),
      ),
    );
  }

  Widget _buildCellForRow(BuildContext context, int index) {
    if (index == 0) {
      return SearchCell(datas: _chatDatas);
    } else {
      index--;
      return _chatCell(index);
    }
  }

  Widget _chatCell(int index) {
    return Container(
      color: Colors.white,
        child: ListTile(
      title: Text(_chatDatas[index].name),
      subtitle: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(right: 10),
        height: 20,
        child: Text(
          _chatDatas[index].message,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image(
          image: NetworkImage(_chatDatas[index].imageUrl),
          width: 44,
          height: 44,
        ),
      ),
    ));
  }

  //网络请求数据
  getChatData({Function(List<Chat>) getSuccess}) {
    _cancleConnect = false;

    HttpManager()
        .get('http://rap2.taobao.org:38080/app/mock/256798/api/chat/list',
            success: (response) {
      if (response.statusCode == 200) {
//      final responseBody = json.decode(response.data);
        //转换为模型数组
        List<Chat> chatList = response.data['chat_list']
            .map<Chat>((item) => Chat.formJsonData(item))
            .toList();

        getSuccess(chatList);
      } else {
        throw Exception('statusCode:${response.statusCode}');
      }
    }, error: (e) {
      print('error:${e.message}');
    });
  }

  Widget _popupItemBuilder(String imageAsset, String title) {
    return Row(
      children: <Widget>[
        Image(
          image: AssetImage(imageAsset),
          width: 20,
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive =>
      true; //保持页面状态步骤二，切换页面会经常刷新页面，这里是避免重复调用initState方法,保持页面状态
}
