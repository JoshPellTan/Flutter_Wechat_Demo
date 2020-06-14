import 'dart:ui';
import 'package:flutter/material.dart';

//界面主题颜色
final Color WeChatThemeColor = Color.fromRGBO(220, 220, 220, 1.0);


//通讯录单个cell高度
double FriendsCellHeight = 54;
double FriendsCellSepLineHeight = 0.5;
double FriendsCellGroupTitleHeight = 30.0;
double ChatSearchBarHeight = 40;

double AppBarHeight = MediaQueryData.fromWindow(window).padding.top;

//获取屏幕宽高
double ScreenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double ScreenHeight(BuildContext context) => MediaQuery.of(context).size.height;
