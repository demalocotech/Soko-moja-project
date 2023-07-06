import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sokomoja_project/Models/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///send message
  Future<void> sendMessage(String receiverId, String message) async {
    //get current user

    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //create message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
    );
    //construct chatroom id
    List<String> ids = [currentUserId, receiverId];
    ids.sort();

    String chatRoomId = ids.join("_");

    //add message to db
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  ///get message
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
