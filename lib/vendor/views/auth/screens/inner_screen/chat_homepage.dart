import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sokomoja_project/vendor/views/auth/screens/inner_screen/chat_screen.dart';

class ChatHomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chats'),
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Customers').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('loading..');
        }
        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(context, doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(context, DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    List<String> ids = [_auth.currentUser!.uid, data['customerID']];
    ids.sort();
    String chatroom_Id = ids.join("_");

    return ListTile(
      title: Text(data['email']),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: ((context) {
          return ChatPage(
              receiverUserEmail: data['email'],
              receiverUserId: data['customerID']);
        })));
        //get to chat room
      },
    );
  }
}
