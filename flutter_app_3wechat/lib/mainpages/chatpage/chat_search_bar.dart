import 'package:flutter/material.dart';
import 'package:flutterapp3wechat/const.dart';

class SearchBar extends StatefulWidget {
  final ValueChanged<String> valueChanged;
  const SearchBar({Key key, this.valueChanged}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool _showClear = false;
  _valueChage(String text) {
    //输入框回调
    if (text.length > 0) {
      widget.valueChanged(text);
      setState(() {
        _showClear = true;
      });
    } else {
      widget.valueChanged('');
      setState(() {
        _showClear = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: WeChatThemeColor,
      height: AppBarHeight + ChatSearchBarHeight,
      child: Column(
        children: <Widget>[
          SizedBox(height: AppBarHeight), //顶部状态栏空白占位
          Container(
            height: ChatSearchBarHeight - 4,
            margin: EdgeInsets.only(bottom: 4),
            child: Row(
              children: <Widget>[
                Container(
                  //白色背景部分
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.0)),
                  width: ScreenWidth(context) - 45,
                  height: ChatSearchBarHeight,
                  margin: EdgeInsets.only(left: 5),
                  child: Row(
                    //搜索栏内控件布局
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        //搜索标志
                        image: AssetImage('images/magnifier_clear.png'),
                        width: 20,
                        color: Colors.grey,
                      ),
                      Expanded(
                        //使用Expanded包装是自动填充，使用Container是需要精确计算宽高，不然会布局错乱
                        flex: 1,
                        //输入框
//                        width: ScreenWidth(context) - 45 - 20,
//                        height: ChatSearchBarHeight,
                        child: TextField(
                          controller: _controller,
                          onChanged: _valueChage, //输入框回调
                          autofocus: true,
                          cursorColor: Colors.red, //光标颜色
                          style: TextStyle(fontSize: 17, color: Colors.black),
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 5, bottom: 10),
                              border: InputBorder.none,
                              hintText: '搜索'),
                        ),
                      ),
                      _showClear
                          ? GestureDetector(
                              //有输入内容时，输入框出现的×标志
                              onTap: () {
                                //点击清空搜索数据并初始化输入框状态
                                setState(() {
                                  _controller.clear();
                                  _valueChage('');
                                });
                              },
                              child: Icon(
                                Icons.cancel,
                                size: 20,
                                color: Colors.grey,
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Text('取消'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
