import 'package:flutter/material.dart';

class ThemeManager {
  //Text Color
  TextStyle lightTextColor = const TextStyle(color: Colors.white);
  TextStyle darkTextColor = const TextStyle(color: Colors.black);

  //Appbar Color
  Color appBarLightColor = Colors.transparent;
  Color appBarDarkColor = Colors.deepPurple;
  //Scaffold BAckground Color
  Color scaffoldLightColor = Colors.white;
  Color scaffoldDarkColor = Colors.black;
  //Toggle Icon Color
  Color toggleLightColor = Colors.orange;
  Color toggleDarkColor = Colors.white;
  //TextField Icon Color
  Color iconLightColor = Colors.deepPurple;
  Color iconDarkColor = Colors.deepPurple;
  //Cursor Color
  Color cursorLightColor = Colors.black;
  Color cursorDarkColor = Colors.white;
  //Emoji Color
  Color emojiLightColor = Colors.black;
  Color emojiDarkColor = Colors.white;
  //Messages Container Color
  Color messagesUserContainerLightColor = Colors.black;
  Color messagesUserContainerDarkColor = Colors.deepPurple;
  //Messages Container Color
  Color messagesBotContainerLightColor = Colors.deepPurple;
  Color messagesBotContainerDarkColor = Colors.black;
  //Bot Message Text Color
  Color messagesbotTextLightColor = Colors.white;
  Color messagesbotTextDarkColor = Colors.white;
  //Border Color
  Color borderLightColor = Colors.deepPurple;
  Color borderDarkColor = Colors.deepPurple;
  //ScrollCounter Color
  Color ScrollLightColor = Colors.black;
  Color ScrollDarkColor = Colors.deepPurple;

  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
  );

  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
      );

  bool _iconBool = false;
  bool get iconBool => _iconBool;
  set iconBool(bool newValue) {
    _iconBool = newValue;
  }
}
