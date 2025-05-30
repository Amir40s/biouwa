// // // chat_detail_page.dart
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import '../../model/message/message_model.dart';
// // import '../../provider/chat/chat_provider.dart';
// //
// //
// // class ChatScreen extends StatefulWidget {
// //   final String conversationId;
// //   final String conversationTitle;
// //
// //   ChatScreen({required this.conversationId, required this.conversationTitle});
// //
// //   @override
// //   _ChatDetailPageState createState() => _ChatDetailPageState();
// // }
// //
// // class _ChatDetailPageState extends State<ChatScreen> {
// //   final TextEditingController _controller = TextEditingController();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(widget.conversationTitle),
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: StreamBuilder<List<Message>>(
// //               stream: Provider.of<ChatProvider>(context).getMessages(widget.conversationId),
// //               builder: (context, snapshot) {
// //                 if (snapshot.connectionState == ConnectionState.waiting) {
// //                   return Center(child: CircularProgressIndicator());
// //                 } else if (snapshot.hasError) {
// //                   return Center(child: Text('Error: ${snapshot.error}'));
// //                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //                   return Center(child: Text('No messages'));
// //                 }
// //
// //                 final messages = snapshot.data!;
// //                 return ListView.builder(
// //                   reverse: true,
// //                   itemCount: messages.length,
// //                   itemBuilder: (context, index) {
// //                     final message = messages[index];
// //                     return ListTile(
// //                       title: Text(message.text),
// //                       subtitle: Text(message.sender),
// //                       trailing: Text(message.timestamp.toIso8601String()),
// //                     );
// //                   },
// //                 );
// //               },
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   child: TextField(
// //                     controller: _controller,
// //                     decoration: InputDecoration(
// //                       labelText: 'Send a message...',
// //                     ),
// //                   ),
// //                 ),
// //                 IconButton(
// //                   icon: Icon(Icons.send),
// //                   onPressed: () {
// //                     if (_controller.text.isNotEmpty) {
// //                       Provider.of<ChatProvider>(context, listen: false).sendMessage(
// //                         widget.conversationId,
// //                         _controller.text,
// //                         'User', // Replace with the actual sender
// //                       );
// //                       _controller.clear();
// //                     }
// //                   },
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// import 'package:biouwa/constant.dart';
// import 'package:biouwa/helper/custom_textfield.dart';
// import 'package:biouwa/helper/text_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:timeago/timeago.dart' as timeago;
//
// import '../../helper/chat_header.dart';
// import '../../provider/chat/chat_provider.dart';
//
// class ChatScreen extends StatelessWidget {
//   final String userUID, name, image, otherEmail, chatRoomId;
//
//   const ChatScreen(
//       {super.key,
//       required this.userUID,
//       required this.name,
//       required this.image,
//       required this.otherEmail,
//       required this.chatRoomId});
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<ChatProvider>(context, listen: false);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             ChatHeader(
//               imageUrl: image,
//               name: name,
//               otherEmail: otherEmail,
//             ),
//             Expanded(
//               child: StreamBuilder(
//                 stream: context.read<ChatProvider>().getMessages(chatRoomId),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   provider.markMessageAsRead(chatRoomId);
//                   provider.updateDeliveryStatus(chatRoomId);
//                   final messages = snapshot.data!.docs;
//                   List<Widget> messageWidgets = [];
//                   for (var message in messages) {
//                     final messageText = message["text"];
//                     final messageSender = message["sender"];
//                     final messageTimestamp = message["timestamp"];
//                     final isDelivered = message["delivered"];
//
//                     final relativeTime = messageTimestamp != null
//                         ? timeago.format(messageTimestamp.toDate())
//                         : '';
//
//                     // return ListView
//                     final isCurrentUser =
//                         messageSender == auth.currentUser?.email;
//
//                     final messageWidget = Align(
//                       alignment: isCurrentUser
//                           ? Alignment.centerRight
//                           : Alignment.centerLeft,
//                       child: Column(
//                         mainAxisAlignment: isCurrentUser
//                             ? MainAxisAlignment.end
//                             : MainAxisAlignment.start,
//                         crossAxisAlignment: isCurrentUser
//                             ? CrossAxisAlignment.end
//                             : CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                               color: isCurrentUser ? primaryColor : Colors.blue,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             padding: const EdgeInsets.all(10),
//                             margin: const EdgeInsets.symmetric(
//                                 vertical: 5, horizontal: 10),
//                             child: Column(
//                               crossAxisAlignment: isCurrentUser
//                                   ? CrossAxisAlignment.start
//                                   : CrossAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   messageText,
//                                   style: const TextStyle(color: Colors.white),
//                                 ),
//                                 const SizedBox(height: 3),
//                                 Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(
//                                       relativeTime,
//                                       style: const TextStyle(
//                                         color: Colors.white70,
//                                         fontSize: 10,
//                                       ),
//                                     ),
//                                     if (isCurrentUser) ...[
//                                       const SizedBox(width: 5),
//                                       Icon(
//                                         message["read"]
//                                             ? Icons.done_all
//                                             : Icons.done,
//                                         color: message["read"]
//                                             ? Colors.white
//                                             : Colors.white70,
//                                         size: 12,
//                                       ),
//                                     ],
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           if (isCurrentUser)
//                             Container(
//                                 margin:
//                                     const EdgeInsets.symmetric(horizontal: 10),
//                                 child: TextWidget(
//                                     text: isDelivered ? "seen" : "deliver",
//                                     size: 12.0))
//                         ],
//                       ),
//                     );
//
//                     messageWidgets.add(messageWidget);
//                   }
//                   return ListView(
//                     reverse: true,
//                     children: messageWidgets,
//                   );
//                 },
//               ),
//             ),
//             _buildMessageInput(context, provider, otherEmail),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMessageInput(
//       BuildContext context, ChatProvider provider, String otherEmail) {
//     final provider = Provider.of<ChatProvider>(context, listen: false);
//     final TextEditingController controller = TextEditingController();
//
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: CustomTextField(
//               controller: controller,
//               hintText: "Send a message",
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.send),
//             onPressed: () async {
//               final text = controller.text;
//               if (text.isNotEmpty) {
//                 provider.sendMessage(
//                     chatRoomId: chatRoomId,
//                     message: text,
//                     otherEmail: otherEmail);
//                 controller.clear();
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/chat_header.dart';
import 'package:biouwa/helper/custom_textfield.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:biouwa/provider/chat/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends StatelessWidget {
  final String userUID, name, image, otherEmail, chatRoomId;

  ChatScreen(
      {Key? key,
      required this.userUID,
      required this.name,
      required this.image,
      required this.otherEmail,
      required this.chatRoomId})
      : super(key: key);

  final List<String> badWords = [
    // Mild
    "hell",
    "damn",
    "idiot",
    "stupid",
    "shut up",

    // Strong/profane
    "fuck",
    "fucked",
    "fucker",
    "motherfucker",
    "mf",
    "bitch",
    "bastard",
    "asshole",
    "dick",
    "dickhead",
    "cock",
    "pussy",
    "slut",
    "whore",
    "cunt",

    // Sexually explicit
    "sex",
    "anal",
    "oral",
    "blowjob",
    "handjob",
    "porn",
    "nude",
    "nudes",
    "horny",
    "boobs",
    "tits",
    "vagina",
    "penis",
    "cum",
    "suck",
    "bang",
    "jerk off",
    "masturbate",

    // Hate speech or racism
    "nigger",
    "nigga",
    "chink",
    "spic",
    "kike",
    "fag",
    "faggot",
    "tranny",
    "retard",

    // Self-harm/suicide trigger words (App Store sometimes flags these)
    "kill myself",
    "suicide",
    "cutting",
    "hang myself",
    "die alone",

    // Threats
    "i'll kill you",
    "go die",
    "i’ll hurt you",

    // Drug references
    "weed",
    "marijuana",
    "cocaine",
    "meth",
    "heroin",
    "ecstasy",
    "lsd",
    "shrooms",

    // Gambling
    "casino",
    "betting",
    "lottery",

    // Others
    "ass",
    "arse",
    "screw you",
    "crap",
    "shit",
    "bullshit",
    "goddamn",
  ];

  bool containsBadWords(String message) {
    for (var word in badWords) {
      if (message.toLowerCase().contains(word.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            ChatHeader(imageUrl: image, name: name, otherEmail: otherEmail),
            Expanded(
              child: StreamBuilder(
                stream: context.read<ChatProvider>().getMessages(chatRoomId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  provider.markMessageAsRead(chatRoomId);
                  provider.updateDeliveryStatus(chatRoomId);
                  final messages = snapshot.data!.docs;
                  List<Widget> messageWidgets = [];
                  for (var message in messages) {
                    final messageText = message["text"];
                    final messageSender = message["sender"];
                    final messageTimestamp = message["timestamp"];
                    final isDelivered = message["delivered"];
                    final relativeTime = messageTimestamp != null
                        ? timeago.format(messageTimestamp.toDate())
                        : '';
                    final isCurrentUser =
                        messageSender == auth.currentUser?.email;

                    final messageWidget = Align(
                      alignment: isCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: isCurrentUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment: isCurrentUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: isCurrentUser ? primaryColor : Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: isCurrentUser
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.end,
                              children: [
                                Text(
                                  messageText,
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(height: 3),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      relativeTime,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 10,
                                      ),
                                    ),
                                    if (isCurrentUser) ...[
                                      SizedBox(width: 5),
                                      Icon(
                                        message["read"]
                                            ? Icons.done_all
                                            : Icons.done,
                                        color: message["read"]
                                            ? Colors.white
                                            : Colors.white70,
                                        size: 12,
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (isCurrentUser)
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: TextWidget(
                                    text: isDelivered ? "seen" : "deliver",
                                    size: 12.0))
                        ],
                      ),
                    );

                    messageWidgets.add(messageWidget);
                  }
                  return ListView(
                    reverse: true,
                    children: messageWidgets,
                  );
                },
              ),
            ),
            _buildMessageInput(context, provider, otherEmail),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(
      BuildContext context, ChatProvider provider, String otherEmail) {
    final TextEditingController _controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: _controller,
              hintText: "Send a message",
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () async {
              final text = _controller.text;
              if (text.isNotEmpty) {
                if (!containsBadWords(text)) {
                  provider.sendMessage(
                      chatRoomId: chatRoomId,
                      message: text,
                      otherEmail: otherEmail);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Your message contains bad words!"),
                    ),
                  );
                }
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
