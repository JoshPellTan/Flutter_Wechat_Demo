import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp3wechat/mainpages/chatpage/chat_search_bar.dart';

import 'chat_model.dart';

class SearchMainPage extends StatefulWidget {
  final List<Chat> datas;
  const SearchMainPage({Key key, this.datas}) : super(key: key);

  @override
  _SearchMainPageState createState() => _SearchMainPageState();
}

class _SearchMainPageState extends State<SearchMainPage> {

  List<Chat> _models = [];
  String _searchText = '';
  TextStyle _normalStyle = TextStyle(
    fontSize: 17,
    color: Colors.black,
  );
  TextStyle _highlightStyle = TextStyle(
    fontSize: 17,
    color: Colors.green,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SearchBar(valueChanged: (text) {
            _searchData(text);
          }),
          Expanded(
              //可以使Row、Column、Flex等子组件在其主轴方向上展开并填充可用空间，是强制子组件填充可用空间
              flex: 1,
              child: MediaQuery.removePadding(
                  //去掉listview顶部头（默认有头）
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: _models.length,
                    itemBuilder: buildCellforRow,
                  )))
        ],
      ),
    );
  }

  //搜索结果展示cell
  Widget buildCellforRow(BuildContext context, int index) {
    return ListTile(
      title: _titleText(_models[index].name),//如果是搜索结果展示需要高亮处理
      subtitle: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(right: 10),
        height: 20,
        child: Text(
          _models[index].message,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image(
          image: NetworkImage(_models[index].imageUrl),
          width: 44,
          height: 44,
        ),
      ),
    );
  }

  void _searchData(String text) {
    //根据字符串查询
    _models.clear(); //每次先将上次的结果数组清空
    _searchText = text;

    if (text.length > 0) {
      for (int i = 0; i < widget.datas.length; i++) {
        String name = widget.datas[i].name;
        if (name.contains(text)) {
          _models.add(widget.datas[i]);
        }
      }
    }
    setState(() {});
  }

  Widget _titleText(String text){

    List<TextSpan> spans = [];
    List<String> strs = text.split(_searchText);

    for(int i=0; i<strs.length; i++){
     String currentStr = strs[i];
     if(currentStr == '' && i < strs.length-1){
       spans.add(TextSpan(text: _searchText,style: _highlightStyle));
     }else{
       spans.add(TextSpan(text: currentStr,style: _normalStyle));
       if(i < strs.length-1){
         spans.add(TextSpan(text: _searchText,style: _highlightStyle));
       }
     }
    }

    return RichText(text: TextSpan(children: spans));

//不明白就打开下面代码对照理解
    //    List<String> temp = 'baaabcbcbbcb'.split('b');
//    for (int i = 0;i<temp.length;i++){
//      print('----'+temp[i]);
//    }
//    String tempstr = '';
//    for(int i=0; i<temp.length; i++){
//      String currentStr = temp[i];
//      if(currentStr == '' && i < temp.length-1){
//        spans.add(TextSpan(text: _searchText,style: _highlightStyle));
//        tempstr = tempstr + 'b';
//      }else{
//        spans.add(TextSpan(text: currentStr,style: _normalStyle));
//        tempstr = tempstr + currentStr;
//        if(i < temp.length-1){
//          spans.add(TextSpan(text: _searchText,style: _highlightStyle));
//          tempstr = tempstr + 'b';
//        }
//      }
//    }
//    print('结果'+tempstr);
  }
}
