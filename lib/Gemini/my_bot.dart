import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gemini_ai/Utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MyBot extends StatefulWidget {
  const MyBot({super.key});

  @override
  State<MyBot> createState() => _MyBotState();
}

class _MyBotState extends State<MyBot> {
  ChatUser myUser = ChatUser(id: '1', firstName: 'Fasih');
  ChatUser geminiBot = ChatUser(id: '2', firstName: 'Ai');
  bool _iconBool = false;

  List<ChatMessage> allMessages = [];
  List<ChatUser> typing = [];
  final String url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyDD5030tEgd03oIcKVQvApHVxfk8mEFCu8";

  final header = {
    "Content-Type": "application/json",
  };

  get _iconLight => _iconLight;
  get _iconLDark => _iconLDark;

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
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 10,
          centerTitle: true,
          title: Text(
            'AI CHATBOT',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _iconBool = !_iconBool;
                });
              },
              icon: Icon(_iconBool ? _iconLDark : _iconLight),
            ),
            const SizedBox(
              width: 15,
            ),
          ],
          backgroundColor: Colors.black,
        ),
        body: DashChat(
          messageOptions: MessageOptions(
            timePadding: const EdgeInsets.only(top: 20),
            showTime: true,
            timeFormat: DateFormat.jm(),
            containerColor: Colors.black,
            textColor: Colors.white,
            showCurrentUserAvatar: true,
            currentUserContainerColor: Colors.black,
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
                    color: Colors.deepPurple,
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
            cursorStyle: const CursorStyle(color: Colors.black),
            inputTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            inputDecoration: ownDecoration(context),
            sendOnEnter: true,
            alwaysShowSend: true,
            inputToolbarPadding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
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
                      color: Colors.deepPurple,
                    ),
                  ),
                  child: const Icon(
                    Icons.emoji_emotions_outlined,
                    color: Colors.deepPurple,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration ownDecoration(BuildContext context) {
  return const InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(50),
      ),
      borderSide: BorderSide(
        style: BorderStyle.solid,
        color: Colors.black,
        width: 2,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(50),
      ),
      borderSide: BorderSide(
        style: BorderStyle.solid,
        color: Colors.deepPurple,
        width: 2,
      ),
    ),
    hintText: "Write a message.....",
    hintStyle: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 17,
    ),
    suffixIcon: Padding(
      padding: EdgeInsets.only(right: 10),
      child: Icon(
        Icons.insert_photo,
        color: Colors.deepPurple,
        size: 30,
      ),
    ),
  );
}
