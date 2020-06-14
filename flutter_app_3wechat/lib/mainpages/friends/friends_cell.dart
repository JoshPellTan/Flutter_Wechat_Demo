import 'package:flutter/material.dart';
import 'package:flutterapp3wechat/const.dart';

// ignore: must_be_immutable
class FriendsCell extends StatelessWidget {

  final String name;
  final String imageUrl;
  final String imageAssets;
  final String groupTitle;//section标题

  FriendsCell({this.name, this.imageUrl, this.imageAssets, this.groupTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20),
          color: Color.fromRGBO(1, 1, 1, 0.0),
          height: groupTitle != null ? FriendsCellGroupTitleHeight:0,
          child: Text(
            groupTitle != null ? groupTitle : '',
            style: TextStyle(color: Colors.black54,fontSize: 18),
          ),
        ),
        Container(
          color: Colors.white,
          height: FriendsCellHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20,right: 10),
                width: 34,
                height: 34,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image(
                    image: imageUrl != null ? NetworkImage(imageUrl) : AssetImage(imageAssets) ,
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
              Container(
                child: Text(
                  name,
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ],
          ),
        ),
        FriendsCellSepLine(),
      ],
    );
  }
}

class FriendsCellSepLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          Container(width: 50,height: FriendsCellSepLineHeight , color: Colors.white),
          Container(height: FriendsCellSepLineHeight ,color: Colors.grey)
        ]
    );
  }
}

