import 'package:flutter/material.dart';

import '../../const.dart';

class FriendsIndexBar extends StatefulWidget {
  //外部使用变量，本控件拖动时候的回调，操作外部
  final void Function(String str) indexBarCallBack;
  FriendsIndexBar({Key key, this.indexBarCallBack});

  @override
  _FriendsIndexBarState createState() => _FriendsIndexBarState();
}

class _FriendsIndexBarState extends State<FriendsIndexBar> {

  Color _blackColor = Color.fromRGBO(1, 1, 1, 0.0);
  Color _textColor = Colors.black;

  double _indicatorY = 0.0;
  String _indicatorText = 'A';
  bool _indicatorHidden = true;

  final List<Widget> words = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < INDEX_WORDS.length; i++) {
      words.add(Expanded(//让 Row、Column、Flex等子组件在其主轴方向上展开并填充可用空间,使用时必须配合Row、Column或Flex来使用，否则会报错
          child: Text(
        INDEX_WORDS[i],
        style: TextStyle(fontSize: 10, color: _textColor),
      )));
    }
  }

  Widget build(BuildContext context) {
    return Positioned(
      top: ScreenHeight(context) / 8,
      right: 0,
      height: ScreenHeight(context) / 2,
      width: 120,
      child: Row(
        children: <Widget>[
          Container(
            //选择title时左边的放大指示器
            alignment: Alignment(0, _indicatorY),
            width: 100,
            child: _indicatorHidden
                ? null
                : Stack(
                    alignment: Alignment(-0.2, 0),
                    children: <Widget>[
                      Image(
                        image: AssetImage('images/bubble.png'),
                        width: 60,
                      ),
                      Text(
                        _indicatorText,
                        style: TextStyle(fontSize: 35, color: Colors.white),
                      )
                    ],
                  ),
          ),
          GestureDetector(//GestureDetector在Flutter中负责处理跟用户的简单手势交互,有丰富的回调操作
            child: Container(
              width: 20,
              color: _blackColor,
//              color: Colors.red,
              child: Column(
                children: words,
              ),
            ),
            onVerticalDragDown: (DragDownDetails details){
              int index = getIndex(context, details.globalPosition);
              widget.indexBarCallBack(INDEX_WORDS[index]);
              setState(() {
                _indicatorText = INDEX_WORDS[index];
                _indicatorY = 2.25/28*index-1.1;//左边指示器经过实际比对，最小值为-0.94对应A，最大值1.08对应Z，所以以此计算
                _indicatorHidden = false;
                _blackColor = Color.fromRGBO(1, 1, 1, 0.5);
                _textColor = Colors.white;
              });
            },
            onVerticalDragUpdate: (DragUpdateDetails details) {
              int index = getIndex(context, details.globalPosition);
              widget.indexBarCallBack(INDEX_WORDS[index]);
              _indicatorText = INDEX_WORDS[index];
              _indicatorY = 2.25/28*index-1.1;
              _indicatorHidden = false;
              setState(() {});
            },
            onVerticalDragEnd: (DragEndDetails details){
              setState(() {
                _indicatorHidden = true;
                _blackColor = Color.fromRGBO(1, 1, 1, 0.0);
                _textColor = Colors.black;
              });
            },
          )
        ],
      ),
    );
  }
}

int getIndex(BuildContext context, Offset globalPosition){
  //RenderBox实际上就是表示使用了 2D 笛卡尔坐标系来标识位置，这与原生开发是一致的，坐标系原点位于左上，x 轴正向指向屏幕右侧，y 轴正向指向屏幕下侧
  RenderBox box = context.findRenderObject();
  //点击位置的y值
  double y = box.globalToLocal(globalPosition).dy;
  //每个字符所占的高度
  final itemHeight = ScreenHeight(context)/2/INDEX_WORDS.length;
  //算出当前坐标对应哪一个item
  int index = (y ~//*向下取整*/ itemHeight).clamp(0, INDEX_WORDS.length-1);//给定范围的数字取整
  return index;
}

const INDEX_WORDS = [
  '🔍',
  '☆',
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z'
];
