import 'package:encrypt/encrypt.dart' as encrypt;

//MESSAGE TYPE CONSTATNTS
class MessageType {
  static const String text = "text";
  static const String image = "image";
  static const String video = "video";
  static const String voice = "voice";
  static const String document = "document";
}

//MESSAGE STATUS CONSTANTS
class MessageStatus {
  static const String sent = "sent";
  static const String delivered = "delivered";
  static const String read = "read";
}

//ENCRYPTION KEYS
class EncryptionKeys {
  static final baseKey =
      encrypt.Key.fromUtf8("zimcopconnectisthebesteversince.");
  static final ivKey = encrypt.IV.fromUtf8('1234567890123456');
}

//PUSH NOTIFICATION
class NotificationType {
  static const String call = "INCOMING CALL";
  static const String message = "NEW MESSAGE";
}
