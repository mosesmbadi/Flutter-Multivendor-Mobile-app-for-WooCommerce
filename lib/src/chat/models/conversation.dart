import 'package:cloud_firestore/cloud_firestore.dart';

import 'message.dart';

class ConversationSnippet {
  final String id;
  final String conversationID;
  final String lastMessage;
  final String name;
  final String image;
  final MessageType type;
  final int unseenCount;
  final Timestamp timestamp;

  ConversationSnippet(
      {this.conversationID,
      this.id,
      this.lastMessage,
      this.unseenCount,
      this.timestamp,
      this.name,
      this.image,
      this.type});

  factory ConversationSnippet.fromFirestore(DocumentSnapshot _snapshot) {
    var _data = _snapshot.data();
    var _messageType = MessageType.Text;
    if (_data["type"] != null) {
      switch (_data["type"]) {
        case "text":
          break;
        case "image":
          _messageType = MessageType.Image;
          break;
        default:
      }
    }
    return ConversationSnippet(
      id: _snapshot.id,
      conversationID: _data["conversationID"],
      lastMessage: _data["lastMessage"] != null ? _data["lastMessage"] : "",
      unseenCount: _data["unseenCount"],
      timestamp: _data["timestamp"] != null ? _data["timestamp"] : null,
      name: _data["name"],
      image: _data["image"],
      type: _messageType,
    );
  }
}

class Conversation {
  final String id;
  final List members;
  final List<Message> messages;
  final String userId;
  final String userName;
  final String userAvatar;
  final String vendorId;
  final String vendorName;
  final String vendorAvatar;
  final String chatId;
  final DateTime timeStamp;
  final DateTime vendorLastSeen;
  final DateTime userLastSeen;

  Conversation(
      {this.id,
      this.members,
      this.userId,
      this.messages,
      this.userName,
      this.userAvatar,
      this.vendorId,
      this.vendorName,
      this.vendorAvatar,
      this.chatId,
      this.timeStamp,
      this.vendorLastSeen,
      this.userLastSeen});

  factory Conversation.fromFirestore(DocumentSnapshot _snapshot) {
    var _data = _snapshot.data();
    List _messages = _data["messages"];
    if (_messages != null) {
      _messages = _messages.map(
        (_m) {
          return Message(
              type: _m["type"] == "text" ? MessageType.Text : MessageType.Image,
              content: _m["message"],
              timestamp: _m["timestamp"],
              senderID: _m["senderID"]);
        },
      ).toList();
    } else {
      _messages = [];
    }
    return Conversation(
      id: _snapshot.documentID,
      members: _data["members"],
      userId: _data["userId"],
      messages: _messages,
      userName: _data["userName"],
      userAvatar: _data["userAvatar"],
      vendorId: _data["vendorId"],
      vendorName: _data["vendorName"],
      vendorAvatar: _data["vendorAvatar"],
      chatId: _data["chatId"],
      timeStamp: _data["timeStamp"] == null ? null : _data["timeStamp"],
      vendorLastSeen: _data["vendorLastSeen"] == null ? null : _data["vendorLastSeen"],
      userLastSeen: _data["userLastSeen"] == null ? null : _data["userLastSeen"],
    );
  }
}
