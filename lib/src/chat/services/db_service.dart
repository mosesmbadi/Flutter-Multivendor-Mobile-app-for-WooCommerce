import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/conversation.dart';
import '../models/message.dart';

class DBService {
  static DBService instance = DBService();

  FirebaseFirestore _db;

  DBService() {
    _db = FirebaseFirestore.instance;
  }

  String _conversationsCollection = "Conversations";

  Future<void> updateChatTimeStamp(String _conversationID) {
    var _ref = _db.collection(_conversationsCollection).doc(_conversationID);
    return _ref.update({"timestamp": Timestamp.now()});
  }

  Future<void> sendMessage(String _conversationID, Message _message) {
    var _ref =
        _db.collection(_conversationsCollection).doc(_conversationID);
    var _messageType = "";
    switch (_message.type) {
      case MessageType.Text:
        _messageType = "text";
        break;
      case MessageType.Image:
        _messageType = "image";
        break;
      default:
    }
    return _ref.update({
      "messages": FieldValue.arrayUnion(
        [
          {
            "message": _message.content,
            "senderID": _message.senderID,
            "timestamp": _message.timestamp,
            "type": _messageType,
          },
        ],
      ),
    }).then((value) => updateChatTimeStamp(_conversationID));
  }

  Stream<Conversation> getConversation(String _conversationID) {
    var _ref =
        _db.collection(_conversationsCollection).doc(_conversationID);
    return _ref.snapshots().map(
      (_doc) {
        return Conversation.fromFirestore(_doc);
      },
    );
  }

  Stream<List<Conversation>> getConversations(String id) {
    var _ref = _db
        .collection(_conversationsCollection)
        .orderBy("timestamp", descending: true) //Uncomment this line after creating indexes in firebase other will this query will not work
        .where("members", arrayContains: id);
    //Don't delete this, uncommenting this will give and erro in console with url to create indexes in firebase console.
    //click the url and create indexs
    _ref.get().catchError((e) => print(e));
    return _ref.get().asStream().map((_snapshot) {
      return _snapshot.docs.map((_doc) {
        return Conversation.fromFirestore(_doc);
      }).toList();
    });
  }

  Future<String> getConversationId(String chatId, String userId, String userName, String userAvatar, String vendorId, String vendorName, String vendorAvatar, bool isVendor) async {
    var _ref = _db.collection(_conversationsCollection);
    try {
      var conversation = await _ref.doc(chatId).get();
      if (conversation.data() != null) {
        return chatId;//conversation.data["conversationID"];
      } else {
        await _ref.doc(chatId).set(
          {
            "members": [userId, vendorId],
            'messages': [],
            "userId": userId,
            'userName': userName,
            'userAvatar': userAvatar,
            'vendorId': vendorId,
            'vendorName': vendorName,
            'vendorAvatar': vendorAvatar,
            'chatId': chatId
          }, SetOptions(merge: true)
        );
        return chatId; //TODO Replace with return value after adding docs
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  onError(e) {
    print(e);
  }
}
