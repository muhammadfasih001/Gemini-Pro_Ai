import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gemini_ai/Dark%20Theme/dark_theme.dart';
import 'package:gemini_ai/Utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});
  final ThemeManager themeManager = ThemeManager();
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final key = GlobalKey<ScaffoldState>();
  ChatUser myUser = ChatUser(
      id: '1', firstName: 'FASIH', profileImage: 'assets/images/student.jpg');
  ChatUser geminiBot =
      ChatUser(id: '2', firstName: 'AI', profileImage: 'assets/images/ai.jpg');

  List<ChatMessage> allMessages = [];
  List<ChatUser> typing = [];
  final String url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyDD5030tEgd03oIcKVQvApHVxfk8mEFCu8";

  final header = {
    "Content-Type": "application/json",
  };

  getGeminiApiResponse(ChatMessage message) async {
    setState(() {
      typing.add(geminiBot);
      allMessages.insert(0, message);
    });

    var data = {
      "contents": [
        {
          "parts": [
            {"text": message.text},
          ],
        },
      ],
    };
    await http
        .post(Uri.parse(url), headers: header, body: jsonEncode(data))
        .then((value) {
      if (value.statusCode == 200) {
        var response = jsonDecode(value.body);
        // ignore: avoid_print
        print(response['candidates'][0]['content']['parts'][0]['text']);

        setState(() {
          ChatMessage message2 = ChatMessage(
            user: geminiBot,
            text: response['candidates'][0]['content']['parts'][0]['text'],
            createdAt: DateTime.now(),
          );

          allMessages.insert(0, message2);
        });
      } else {
        Utils().toastMessage("Error Ocured");
      }
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
    });

    setState(() {
      typing.remove(geminiBot);
    });
  }

  @override
  Widget build(BuildContext context) {
    const IconData iconLight = Icons.wb_sunny;
    const IconData iconDark = Icons.nights_stay;
    return MaterialApp(
        theme: widget.themeManager.iconBool
            ? widget.themeManager.darkTheme
            : widget.themeManager.lightTheme,
        title: 'Google Gemini ChatBot',
        debugShowCheckedModeBanner: false,
        home: AnnotatedRegion(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarColor: widget.themeManager.iconBool
                ? widget.themeManager.scaffoldDarkColor
                : widget.themeManager.scaffoldLightColor,
          ),
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text(
                'AI CHATBOT',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  textStyle: widget.themeManager.iconBool
                      ? widget.themeManager.lightTextColor
                      : widget.themeManager.darkTextColor,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      widget.themeManager.iconBool =
                          !widget.themeManager.iconBool;
                    });
                  },
                  icon: Icon(
                    widget.themeManager.iconBool ? iconDark : iconLight,
                    color: widget.themeManager.iconBool
                        ? widget.themeManager.toggleDarkColor
                        : widget.themeManager.toggleLightColor,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
              backgroundColor: widget.themeManager.iconBool
                  ? widget.themeManager.appBarDarkColor
                  : widget.themeManager.appBarLightColor,
            ),
            body: DashChat(
              scrollToBottomOptions: ScrollToBottomOptions(
                scrollToBottomBuilder: (scrollController) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          scrollController.animateTo(
                            scrollController.position.minScrollExtent,
                            duration: const Duration(milliseconds: 260),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: widget.themeManager.iconBool
                                ? widget.themeManager.ScrollDarkColor
                                : widget.themeManager.ScrollLightColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(Icons.keyboard_arrow_down_rounded,
                              size: 30, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
              messageOptions: MessageOptions(
                showOtherUsersAvatar: true,
                timePadding: const EdgeInsets.only(top: 20),
                showTime: true,
                timeFormat: DateFormat.jms(),
                containerColor: widget.themeManager.iconBool
                    ? widget.themeManager.messagesBotContainerDarkColor
                    : widget.themeManager.messagesBotContainerLightColor,
                textColor: Colors.white,
                currentUserTextColor: Colors.white,
                showCurrentUserAvatar: true,
                currentUserContainerColor: widget.themeManager.iconBool
                    ? widget.themeManager.messagesUserContainerDarkColor
                    : widget.themeManager.messagesUserContainerLightColor,
              ),
              typingUsers: typing,
              currentUser: myUser,
              onSend: (ChatMessage message) {
                getGeminiApiResponse(message);
              },
              messages: allMessages,
              inputOptions: InputOptions(
                sendButtonBuilder: (send) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, top: 2),
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: widget.themeManager.iconBool
                            ? widget.themeManager.iconDarkColor
                            : widget.themeManager.iconLightColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        onPressed: () {
                          send();
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
                cursorStyle: CursorStyle(
                    color: widget.themeManager.iconBool
                        ? widget.themeManager.cursorDarkColor
                        : widget.themeManager.cursorLightColor),
                inputTextStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                ),
                inputDecoration: ownDecoration(context),
                sendOnEnter: true,
                alwaysShowSend: true,
                inputToolbarPadding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 20),
                leading: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          width: 10,
                          style: BorderStyle.solid,
                          color: widget.themeManager.iconBool
                              ? widget.themeManager.iconDarkColor
                              : widget.themeManager.iconLightColor,
                        ),
                      ),
                      child: Icon(
                        Icons.emoji_emotions_outlined,
                        color: widget.themeManager.iconBool
                            ? widget.themeManager.emojiDarkColor
                            : widget.themeManager.emojiLightColor,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

InputDecoration ownDecoration(BuildContext context) {
  final ThemeManager themeManager = ThemeManager();
  return InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(50),
      ),
      borderSide: BorderSide(
        style: BorderStyle.solid,
        color: themeManager.iconBool
            ? themeManager.borderDarkColor
            : themeManager.borderLightColor,
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(50),
      ),
      borderSide: BorderSide(
        style: BorderStyle.solid,
        color: themeManager.iconBool
            ? themeManager.borderDarkColor
            : themeManager.borderLightColor,
        width: 1,
      ),
    ),
    hintText: "Write a message.....",
    hintStyle: const TextStyle(
      // color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 17,
    ),
    suffixIcon: Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Icon(
        Icons.insert_photo,
        color: themeManager.iconBool
            ? themeManager.iconDarkColor
            : themeManager.iconLightColor,
        size: 30,
      ),
    ),
  );
}
