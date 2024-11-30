import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zimcop_connect/const/message_const.dart';
import 'package:zimcop_connect/services/encryption_service.dart';
import '../models/message.dart';
import 'auth_service.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EncryptionService _encryptionService = EncryptionService();

  //GETTING CHATROOM LIST
  Stream<QuerySnapshot> getChatRooms() {
    return _firestore
        .collection("chat_rooms")
        .orderBy("timeSend", descending: true)
        .where("users", arrayContains: AuthService().getCurrentUID())
        .snapshots();
  }

  //SENDING MESSAGES
  Future<void> sendMessage(
      {required String messageID,
      required String receiverID,
      required String currentUserID,
      required String message,
      required String messageType}) async {
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    //encrypting
    String encrytedMessage = _encryptionService.encryptData(message);

    //Creating a new Message
    Message newMessage = Message(
        messageID: messageID,
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: encrytedMessage,
        messageType: messageType,
        status: MessageStatus.sent,
        timestamp: timestamp);

    //Chat room ID for two users to ensure uniqueness
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); //to ensure chatroom id is the same for 2 people
    String chatRoomID = ids.join('_');

    //Adding new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .doc(messageID)
        .set(newMessage.toMap());
  }

  //DELETE MESSAGE
  Future<void> deleteMessage(String chatRoomID, messageID) async {
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .doc(messageID)
        .delete();
  }

  //UPDATING LAST MESSAGE SENT
  Future<void> updateLastMessageSent(
      String chatRoomID, Map<String, dynamic> lastMessageMap) async {
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .set(lastMessageMap);
  }

  //UPDATING MESSAGE STATUS TO DELIVERED
  Future<void> updateDeliveredMessages() async {
    // Listen for messages sent to the current user
    _firestore
        .collection("chat_rooms")
        .where('receiverId', isEqualTo: AuthService().getCurrentUID())
        .where('status', isEqualTo: MessageStatus.sent)
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        // Update the status to 'delivered'
        _firestore
            .collection("chat_rooms")
            .doc(doc.id)
            .collection("messages")
            .doc()
            .update({'status': MessageStatus.delivered});
      }
    });
  }

  //UPDATING MESSAGE STATUS TO READ
  Future<void> updateMessageStatus(
      {required String chatRoomID,
      required String messageID,
      required status}) async {
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection('messages')
        .doc(messageID)
        .update({
      'status': status,
    });
  }

  //GETTING MESSAGES
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    //Chat room ID for two users to ensure uniqueness
    List<String> ids = [userID, otherUserID];
    ids.sort(); //to ensure chatroom id is the same for 2 people
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  //SEARCHING MEMBERS TO CHAT WITH BY SURNAME
  Stream<QuerySnapshot> searchContactsBySurname(String surname) {
    return _firestore
        .collection("Users")
        .orderBy('surname')
        .startAt([surname]).endAt(["$surname\uf8ff"]).snapshots();
  }

  //SETTING ONLINE STATUS
  Future<void> setOnlineStatus({required bool value}) async {
    await _firestore
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .update({'isOnline': value});
  }

  //SETTING LAST SEEN STATUS
  Future<void> setLastSeen({required Timestamp value}) async {
    await _firestore
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .update({'lastSeen': value});
  }

  //REPORTING USER
  Future<void> reportUser(String messageID, String userID) async {
    final report = {
      'reportedBy': _auth.currentUser!.uid,
      'messageID': messageID,
      'messageOwnerID': userID,
      'timastamp': FieldValue.serverTimestamp()
    };

    await _firestore.collection('Reports').add(report);
  }
}
