import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class MediaService {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  //PICKING IMAGE FROM GALLERY
  Future<File?> getImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  //PICKING VIDEO FROM GALLERY
  Future<File?> getvideoFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  //PICKING DOCUMENT FROM DOCUMENTS
  Future<File?> getDocumentFromDocuments() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'xls',
        'xlsx',
        'ppt',
        'pptx',
        'txt',
        'rtf',
        'zip',
        'rar',
        'csv',
        'md'
      ],
    );
    if (pickedFile != null) {
      return File(pickedFile.files.single.path!);
    }
    return null;
  }

  //UPLOADING PROFILE PICTURE IMAGE
  Future<String?> uploadUserProfilePic(
      {required File file, required String uid}) async {
    Reference fileRef = _firebaseStorage
        .ref('users/profilePics')
        .child('$uid${p.extension(file.path)}');
    UploadTask task = fileRef.putFile(file);
    return task.then((p) {
      if (p.state == TaskState.success) {
        return fileRef.getDownloadURL();
      }
      return null;
    });
  }

  //UPLOADING CHAT IMAGE
  Future<String?> uploadImageToChat(
      {required File file, required String chatID}) {
    Reference fileRef = _firebaseStorage
        .ref('chats/images/$chatID')
        .child('${DateTime.now().toIso8601String()}${p.extension(file.path)}');
    UploadTask task = fileRef.putFile(file);
    return task.then((p) {
      if (p.state == TaskState.success) {
        return fileRef.getDownloadURL();
      }
      return null;
    });
  }

  //UPLOADING CHAT IMAGE
  Future<String?> uploadVideoToChat(
      {required File file, required String chatID}) {
    Reference fileRef = _firebaseStorage
        .ref('chats/videos/$chatID')
        .child('${DateTime.now().toIso8601String()}${p.extension(file.path)}');
    UploadTask task = fileRef.putFile(file);
    return task.then((p) {
      if (p.state == TaskState.success) {
        return fileRef.getDownloadURL();
      }
      return null;
    });
  }

  //UPLOADING VOICE RECORD
  Future<String?> uploadVoiceMesage(
      {required filePath, required String chatID}) async {
    File file = File(filePath!);
    Reference fileRef = _firebaseStorage
        .ref('chats/voice_messages/$chatID')
        .child('${DateTime.now().toIso8601String()}.m4a');
    UploadTask task = fileRef.putFile(file);
    return task.then((p) {
      if (p.state == TaskState.success) {
        return fileRef.getDownloadURL();
      }
      return null;
    });
  }

  //UPLOADING DOCUMENT TO CHAT
  Future<String?> uploadDocumentToChat(
      {required File file, required String chatID}) {
    Reference fileRef = _firebaseStorage
        .ref('chats/Documents/$chatID')
        .child('${DateTime.now().toIso8601String()}${p.extension(file.path)}');
    UploadTask task = fileRef.putFile(file);
    return task.then((p) {
      if (p.state == TaskState.success) {
        return fileRef.getDownloadURL();
      }
      return null;
    });
  }
}
