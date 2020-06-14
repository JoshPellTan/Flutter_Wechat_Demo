import 'package:flutter/material.dart';
import 'package:flutterapp3wechat/mainpages/chatpage/chat_search_page.dart';

import '../../const.dart';
import 'chat_model.dart';

class SearchCell extends StatelessWidget {

  final List<Chat> datas;
  const SearchCell({Key key, this.datas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (d) {
        Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) {
          return SearchMainPage(datas: datas,);
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 5,right: 5,bottom: 5),
        height: ChatSearchBarHeight,
        color: WeChatThemeColor,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.0)
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(image: AssetImage('images/magnifier_clear.png'),width: 20,color: Colors.grey,),
                SizedBox(width: 5),
                Text('搜索',style: TextStyle(fontSize: 17,color: Colors.grey),)
              ],
            )
          ],
        ),
      ),
    );
  }
}
