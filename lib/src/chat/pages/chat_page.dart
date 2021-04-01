import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../src/resources/api_provider.dart';
import '../../models/app_state_model.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../services/cloud_storage_service.dart';
import '../services/db_service.dart';
import '../services/media_service.dart';
import '../../ui/widgets/image_view.dart';

class ChatPage extends StatefulWidget {
  final String vendorId;
  final String vendorName;
  final String vendorAvatar;
  final String chatId;
  const ChatPage({Key key, this.vendorId, this.vendorName, this.vendorAvatar, this.chatId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  double _deviceHeight;
  double _deviceWidth;

  String _conversationID;
  String _userID;

  GlobalKey<FormState> _formKey;
  ScrollController _listViewController;
  final appStateModel = AppStateModel();
  bool notify = true;
  String _messageText;

  @override
  void initState() {
    super.initState();
    _userID = appStateModel.user.id.toString();
    _formKey = GlobalKey<FormState>();
    _listViewController = ScrollController();
    _messageText = "";
    _startChat();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      //backgroundColor: Theme.of(context).brightness == Brightness.light ? Color(0xFFf2f2f2) : Colors.grey[900],
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.vendorName),
            CircleAvatar(
                radius: 18,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(widget.vendorAvatar)),
          ],
        ),
      ),
      body: _conversationPageUI(context),
    );
  }

  Widget _conversationPageUI(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        _messageListView(),
        Align(
          alignment: Alignment.bottomCenter,
          child: _messageField(context),
        ),
      ],
    );
  }

  Widget _messageListView() {
    if (_conversationID != null) {
      return Container(
      padding: EdgeInsets.only(bottom: 40),
      width: _deviceWidth,
      child: StreamBuilder<Conversation>(
        stream: DBService.instance.getConversation(_conversationID),
        builder: (BuildContext _context, _snapshot) {
          Timer(
            Duration(milliseconds: 50),
            () => {
              if(_listViewController.hasClients)
              _listViewController
                  .jumpTo(_listViewController.position.maxScrollExtent),
            },
          );
          var _conversationData = _snapshot.data;
          if (_conversationData != null) {
            if (_conversationData.messages.length != 0) {
              return ListView.builder(
                controller: _listViewController,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                itemCount: _conversationData.messages.length,
                itemBuilder: (BuildContext _context, int _index) {
                  var _message = _conversationData.messages[_index];
                  bool _isOwnMessage = _message.senderID == _userID;
                  return _messageListViewChild(_isOwnMessage, _message);
                },
              );
            } else {
              return Align(
                alignment: Alignment.center,
                child: Container(),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget _messageListViewChild(bool _isOwnMessage, Message _message) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            _isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: _deviceWidth * 0.02),
          _message.type == MessageType.Text
              ? _textMessageCard(
                  _isOwnMessage, _message.content, _message.timestamp)
              : _imageMessageCard(
                  _isOwnMessage, _message.content, _message.timestamp),
        ],
      ),
    );
  }

  Widget _textMessageCard(
      bool _isOwnMessage, String _message, Timestamp _timestamp) {
    return Container(
      width: _deviceWidth * 0.75,
      child: Card(
        color: Colors.grey.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 0.0,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(_message),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  timeago.format(_timestamp.toDate(), locale: appStateModel.appLocale.languageCode),
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageMessageCard(
      bool _isOwnMessage, String _imageURL, Timestamp _timestamp) {
    DecorationImage _image =
        DecorationImage(image: NetworkImage(_imageURL), fit: BoxFit.cover);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Stack(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ImageView(url: _imageURL);
                  }));
                },
                child: Stack(
                  children: [
                    Container(
                      height: _deviceHeight * 0.30,
                      width: _deviceWidth * 0.40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        image: _image,
                      ),
                    ),
                    Container(
                      height: _deviceHeight * 0.30,
                      width: _deviceWidth * 0.40,
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [Colors.black54, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            //begin: FractionalOffset.topCenter,
                            //end: FractionalOffset.center,
                            end: new Alignment(0.0, 0.5),
                            tileMode: TileMode.clamp),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 10,
                bottom: 10,
                child: Text(
                timeago.format(_timestamp.toDate(), locale: appStateModel.appLocale.languageCode),
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),)
            ],
          ),
        ],
      ),
    );
  }

  Widget _messageField(BuildContext _context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide( //                    <--- top side
            color: Theme.of(context).focusColor,
            width: 0.0,
          ),
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      padding: EdgeInsets.only(left: 16),
      height: _deviceHeight * 0.09,
      child: Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(child: _messageTextField()),
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.all(0),
                    icon: Icon(
                      Icons.send,
                    ),
                    onPressed: () {
                      _formKey.currentState.save();
                      if (_formKey.currentState.validate()) {
                        DBService.instance.sendMessage(_conversationID,
                          Message(
                              content: _messageText,
                              timestamp: Timestamp.now(),
                              senderID: _userID,
                              type: MessageType.Text),
                        );
                        _formKey.currentState.reset();
                        FocusScope.of(_context).unfocus();
                        if(notify) {
                          ApiProvider().post('/wp-admin/admin-ajax.php?action=mstore_flutter_new_chat_message', {'message': _messageText, 'vendor_id': widget.vendorId});
                          notify = false;
                        }
                      }
                    }),
                IconButton(
                  onPressed: () async {
                    var _image = await MediaService.instance.getImageFromLibrary();
                    if (_image != null) {
                      var _result = await CloudStorageService.instance
                          .uploadMediaMessage(_userID, _image);
                      var _imageURL = await _result.ref.getDownloadURL();
                      await DBService.instance.sendMessage(
                        _conversationID,
                        Message(
                            content: _imageURL,
                            senderID: _userID,
                            timestamp: Timestamp.now(),
                            type: MessageType.Image),
                      );
                      if(notify) {
                        ApiProvider().post('/wp-admin/admin-ajax.php?action=mstore_flutter_new_chat_message', {'message': _imageURL, 'vendor_id': widget.vendorId});
                      }
                    }
                  },
                  icon: Icon(Icons.attach_file),
                )
              ],
            )
            //_sendMessageButton(_context),
            //_imageMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return TextFormField(
      validator: (_input) {
        if (_input.length == 0) {
          return "Please enter a message";
        }
        return null;
      },
      onSaved: (_input) {
        setState(() {
          _messageText = _input;
        });
      },
      decoration: InputDecoration(
          border: InputBorder.none, hintText: "Type a message"),
      autocorrect: false,
    );
  }

  _startChat() async {
    var userID = _userID;
    var userName = appStateModel.user.firstName + ' ' + appStateModel.user.lastName;
    var userAvatar = appStateModel.user.avatarUrl;
    var vendorID = widget.vendorId;
    var vendorName = widget.vendorName;
    var vendorAvatar = widget.vendorAvatar;
    bool isVendor = appStateModel.isVendor.contains(appStateModel.user.role);
    String conversationID = await DBService.instance.getConversationId(widget.chatId, userID, userName, userAvatar, vendorID, vendorName, vendorAvatar, isVendor);
    setState(() {
      _conversationID = conversationID;
    });
  }
}
