import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String messageID;
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String message;
  final String messageType;
  final String status;
  final Timestamp timestamp;

  Message(
      {required this.messageID,
      required this.senderID,
      required this.senderEmail,
      required this.receiverID,
      required this.message,
      required this.messageType,
      required this.status,
      required this.timestamp});

  //Converting to map
  Map<String, dynamic> toMap() {
    return {
      'messageID': messageID,
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverID': receiverID,
      'message': message,
      'messageType': messageType,
      'status': status,
      'timestamp': timestamp
    };
  }

  // Converting Message from a map
  factory Message.fromMap(Map<String, dynamic> data) {
    return Message(
      messageID: data['messageID'] ?? '',
      senderID: data['senderID'] ?? '',
      senderEmail: data['senderEmail'] ?? '',
      receiverID: data['receiverID'] ?? '',
      message: data['message'] ?? '',
      messageType: data['messageType'] ?? '',
      status: data['status'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
