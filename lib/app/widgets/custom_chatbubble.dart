import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isReaded;
  final String timestamp;
  final bool isMe;

  const ChatBubble({
    required this.message,
    required this.timestamp,
    required this.isReaded,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('HH:mm');
    String nowTime = formatter.format(now);
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: isMe ? Colors.green : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            (message.contains('^'))
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: 160,
                            height: 160,
                            child: Image.network(
                              message.split('^')[0],
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                message.split('^')[1],
                                maxLines: 12,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                                ),
                              ),
                              SizedBox(
                                width: 60,
                              ),
                              Row(
                                children: [
                                  Text(
                                    (timestamp == 'null') ? nowTime : timestamp,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isMe
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  (isMe)
                                      ? (isReaded)
                                          ? Icon(
                                              Icons.done_all,
                                              size: 13,
                                            )
                                          : Icon(
                                              Icons.done,
                                              size: 13,
                                            )
                                      : SizedBox()
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        child: Text(
                          message,
                          maxLines: 12,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        (timestamp == 'null') ? nowTime : timestamp,
                        style: TextStyle(
                          fontSize: 12,
                          color: isMe ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      (isMe)
                          ? (isReaded)
                              ? Icon(
                                  Icons.done_all,
                                  size: 13,
                                )
                              : Icon(
                                  Icons.done,
                                  size: 13,
                                )
                          : SizedBox()
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
