import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:zimcop_connect/const/message_const.dart';

class EncryptionService {
  static final encrypter =
      encrypt.Encrypter(encrypt.AES(EncryptionKeys.baseKey));
  //FOR ENCRYPTION
  String encryptData(String plainText) {
    final encrypted = encrypter.encrypt(plainText, iv: EncryptionKeys.ivKey);
    return encrypted.base64;
  }

  //FOR DECRYPTION
  String decryptData(String encryptedText) {
    final decrypted = encrypter.decrypt(
        encrypt.Encrypted.fromBase64(encryptedText.toString()),
        iv: EncryptionKeys.ivKey);
    return decrypted;
  }
}
