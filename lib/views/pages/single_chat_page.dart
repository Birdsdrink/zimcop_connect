import 'dart:io';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:intl/intl.dart';
import 'package:voice_message_player/voice_message_player.dart';
import 'package:zimcop_connect/models/message.dart';
import 'package:zimcop_connect/services/encryption_service.dart';
import 'package:zimcop_connect/services/push_notification_service.dart';
import 'package:zimcop_connect/views/widgets/dialog_box.dart';
import 'package:zimcop_connect/views/widgets/video_player_widget.dart';
import '../../const/message_const.dart';
import '../../const/style_const.dart';
import '../../services/auth_service.dart';
import '../../services/chat_service.dart';
import '../../services/media_service.dart';
import '../../services/shared_pref.dart';
import '../widgets/profile_widget.dart';
import 'package:record/record.dart';
import 'package:random_string/random_string.dart';

class SingleChatPage extends StatefulWidget {
  final String rank;
  final String surname;
  final String receiverProfPicUrl;
  final String receiverID;
  final String fcmToken;
  const SingleChatPage(
      {super.key,
      required this.rank,
      required this.surname,
      required this.receiverProfPicUrl,
      required this.receiverID,
      required this.fcmToken});

  @override
  State<SingleChatPage> createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  //INITIALISING CLASSES AND VARIABLES
  final MediaService mediaService = MediaService();
  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();
  final SharedPrefHelper sharedPrefHelper = SharedPrefHelper();
  final PushNotificationService pushNotificationService =
      PushNotificationService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textMessageController = TextEditingController();
  final EncryptionService _encryptionService = EncryptionService();
  final FocusNode myFocusNode = FocusNode();
  final record = AudioRecorder();
  bool _isDisplaySendButton = false,
      _isShowAttachWindow = false,
      _isRecording = false;
  String? chatRoomID,
      myUserName,
      mySurname,
      myUserId,
      myRank,
      workName,
      messageID,
      chatImageDownloadUrl,
      chatVideoDownloadUrl,
      chatDocumentDownloadUrl,
      voiceMessageDownloadUrl,
      filePath;

  //GETTING LOCALLY SAVED DATA
  void getSharedPref() async {
    myUserName = await sharedPrefHelper.getForceNumber();
    mySurname = await sharedPrefHelper.getSurname();
    myRank = await sharedPrefHelper.getRank();
    setState(() {});
  }

  //CREATING CHATROOM ID
  void createChatRoomID() {
    List<String> ids = [myUserId!, widget.receiverID];
    ids.sort(); //to ensure chatroom id is the same for 2 people
    chatRoomID = ids.join('_');
    setState(() {});
  }

  //SENDING A MESSAGE
  void sendMessage(String messageType) {
    switch (messageType) {
      case MessageType.text:
        messageID = randomAlphaNumeric(10);
        chatService.sendMessage(
          messageID: messageID!,
          receiverID: widget.receiverID,
          currentUserID: myUserId!,
          message: _textMessageController.text,
          messageType: messageType,
        );
        workName =
            "${myRank!} ${mySurname![0].toUpperCase() + mySurname!.substring(1)}";
        pushNotificationService.sendMessageNotification(
            senderSurname: workName!,
            senderID: authService.getCurrentUID(),
            content: _textMessageController.text,
            fcmToken: widget.fcmToken);
        updateLastMessage(_textMessageController.text, messageID!);
        _textMessageController.text = "";
        //Scroll down after sending a message
        scrollDown();
        break;

      case MessageType.image:
        messageID = randomAlphaNumeric(10);
        chatService.sendMessage(
          messageID: messageID!,
          receiverID: widget.receiverID,
          currentUserID: myUserId!,
          message: chatImageDownloadUrl!,
          messageType: messageType,
        );
        String lastMessage = "Image 📷";
        updateLastMessage(lastMessage, messageID!);
        "${myRank!} ${mySurname![0].toUpperCase() + mySurname!.substring(1)}";
        workName =
            "${myRank!} ${mySurname![0].toUpperCase() + mySurname!.substring(1)}";
        pushNotificationService.sendMessageNotification(
            senderSurname: workName!,
            senderID: authService.getCurrentUID(),
            content: lastMessage,
            fcmToken: widget.fcmToken);
        //Scroll down after sending a message
        scrollDown();
        break;
      case MessageType.video:
        messageID = randomAlphaNumeric(10);
        chatService.sendMessage(
          messageID: messageID!,
          receiverID: widget.receiverID,
          currentUserID: myUserId!,
          message: chatVideoDownloadUrl!,
          messageType: messageType,
        );
        String lastMessage = "Video 🎬";
        updateLastMessage(lastMessage, messageID!);
        "${myRank!} ${mySurname![0].toUpperCase() + mySurname!.substring(1)}";
        workName =
            "${myRank!} ${mySurname![0].toUpperCase() + mySurname!.substring(1)}";
        pushNotificationService.sendMessageNotification(
            senderSurname: workName!,
            senderID: authService.getCurrentUID(),
            content: lastMessage,
            fcmToken: widget.fcmToken);
        //Scroll down after sending a message
        scrollDown();
        break;

      case MessageType.voice:
        messageID = randomAlphaNumeric(10);
        chatService.sendMessage(
          messageID: messageID!,
          receiverID: widget.receiverID,
          currentUserID: myUserId!,
          message: voiceMessageDownloadUrl!,
          messageType: messageType,
        );
        String lastMessage = "Voice 🔊";
        updateLastMessage(lastMessage, messageID!);
        workName =
            "${myRank!} ${mySurname![0].toUpperCase() + mySurname!.substring(1)}";
        pushNotificationService.sendMessageNotification(
            senderSurname: workName!,
            senderID: authService.getCurrentUID(),
            content: lastMessage,
            fcmToken: widget.fcmToken);
        //Scroll down after sending a message
        scrollDown();
        break;

      case MessageType.document:
        messageID = randomAlphaNumeric(10);
        chatService.sendMessage(
          messageID: messageID!,
          receiverID: widget.receiverID,
          currentUserID: myUserId!,
          message: chatDocumentDownloadUrl!,
          messageType: messageType,
        );
        String lastMessage = "Document 📄";
        updateLastMessage(lastMessage, messageID!);
        "${myRank!} ${mySurname![0].toUpperCase() + mySurname!.substring(1)}";
        workName =
            "${myRank!} ${mySurname![0].toUpperCase() + mySurname!.substring(1)}";
        pushNotificationService.sendMessageNotification(
            senderSurname: workName!,
            senderID: authService.getCurrentUID(),
            content: lastMessage,
            fcmToken: widget.fcmToken);
        //Scroll down after sending a message
        scrollDown();
        break;

      default:
        messageID = randomAlphaNumeric(10);
        chatService.sendMessage(
          messageID: messageID!,
          receiverID: widget.receiverID,
          currentUserID: myUserId!,
          message: _textMessageController.text,
          messageType: messageType,
        );
        workName =
            "${myRank!} ${mySurname![0].toUpperCase() + mySurname!.substring(1)}";
        pushNotificationService.sendMessageNotification(
            senderSurname: workName!,
            senderID: authService.getCurrentUID(),
            content: _textMessageController.text,
            fcmToken: widget.fcmToken);
        updateLastMessage(_textMessageController.text, messageID!);
        _textMessageController.text = "";
        //Scroll down after sending a message
        scrollDown();
        break;
    }
  }

  void updateLastMessage(String lastMessage, String messageID) async {
    Map<String, dynamic> lastMessageMap = {
      'lastMessage': lastMessage,
      'messageID': messageID,
      'timeSend': Timestamp.now(),
      'users': [myUserId, widget.receiverID]
    };
    await chatService.updateLastMessageSent(chatRoomID!, lastMessageMap);
  }

  //START RECORDING AUDIO
  void startRecording() async {
    if (await record.hasPermission()) {
      final directory = await Directory.systemTemp.createTemp();
      filePath = '${directory.path}/voice_message.m4a';
      await record.start(const RecordConfig(), path: filePath!);
      setState(() {
        _isRecording = true;
      });
    }
  }

  //STOP RECORDING
  void stopRecording() async {
    await record.stop();
    setState(() {
      _isRecording = false;
    });
  }

  //BLOCK USER
  blockUser(String messageID, String userID) {
    chatService.reportUser(messageID, userID);
  }

  //SCROLLING DOWN
  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  @override
  void initState() {
    myUserId = authService.getCurrentUID();
    createChatRoomID();
    getSharedPref();

    //Focus Node Listener Scrolling
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });

    //Scroll to the bottom after building Listview
    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    _textMessageController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(widget.receiverID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError || snapshot.data == null) {
            return const Scaffold(
              backgroundColor: homeBackgroundColor,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          var snapData = snapshot.data!;
          return Scaffold(
              backgroundColor: homeBackgroundColor,

              //APPBAR
              appBar: AppBar(
                backgroundColor: homeBackgroundColor,
                leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.blue.withOpacity(0.7),
                    )),
                title: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.rank} ${widget.surname[0].toUpperCase() + widget.surname.substring(1)}",
                          style: const TextStyle(
                              color: tittleTextColor, fontSize: 15),
                        ),
                        snapData['isOnline'] == true
                            ? const Text(
                                "online",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 12),
                              )
                            : Text(
                                "Last seen ${GetTimeAgo.parse(snapData['lastSeen'].toDate())}",
                                style: const TextStyle(
                                    color: subTittleTextColor, fontSize: 10),
                              )
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32.5),
                        child:
                            profileWidget(imageUrl: widget.receiverProfPicUrl),
                      ),
                    ),
                  ],
                ),
              ),

              //BODY
              body: GestureDetector(
                onTap: () {
                  setState(() {
                    _isShowAttachWindow = false;
                  });
                },

                //STACKING COMPONENTS ON TOP OF IMAGE
                child: Stack(
                  children: [
                    Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        top: 0,
                        child: Image.asset(
                          "assets/images/chatbg.png",
                          fit: BoxFit.cover,
                        )),
                    Column(
                      children: [
                        //LIST OF ALL MESSAGES
                        Expanded(child: buildMessageList()),

                        //BOTTOM PART FOR TYPING AND VOICE RECORDING
                        Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 6),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: homeBackgroundColor.withOpacity(0.8),
                                  border: Border.all(
                                      color: Colors.blue.withOpacity(0.3)),
                                  borderRadius: BorderRadius.circular(20),
                                ),

                                //TEXTFIELD FOR TYPING MESSAGE
                                child: TextField(
                                  onTap: () {
                                    setState(() {
                                      _isShowAttachWindow = false;
                                    });
                                  },
                                  controller: _textMessageController,
                                  focusNode: myFocusNode,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      setState(() {
                                        _isDisplaySendButton = true;
                                      });
                                    } else {
                                      setState(() {
                                        _isDisplaySendButton = false;
                                      });
                                    }
                                  },
                                  style: const TextStyle(
                                      color: tittleTextColor, fontSize: 15),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 10),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Wrap(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _isShowAttachWindow =
                                                    !_isShowAttachWindow;
                                              });
                                            },
                                            child: Icon(
                                              Icons.attach_file,
                                              color: zrpBlue.withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    enabled: _isRecording ? false : true,
                                    hintText: _isRecording
                                        ? 'Recording ...'
                                        : 'Type a message',
                                    hintStyle: TextStyle(
                                        color: _isRecording
                                            ? Colors.amber
                                            : subTittleTextColor,
                                        fontSize: 15),
                                    border: InputBorder.none,
                                  ),
                                ),
                              )),
                              const SizedBox(width: 10),

                              //VOICE RECORDING AND SENDING MESSAGE
                              Container(
                                width: _isRecording ? 60 : 50,
                                height: _isRecording ? 60 : 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: _isRecording
                                      ? Colors.orange
                                      : Colors.blue.withOpacity(0.4),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    if (_isDisplaySendButton) {
                                      if (_textMessageController
                                          .text.isNotEmpty) {
                                        sendMessage(MessageType.text);
                                      }
                                    }
                                  },
                                  onLongPress: () {
                                    if (!_isDisplaySendButton) {
                                      startRecording();
                                    }
                                  },
                                  onLongPressUp: () async {
                                    if (!_isDisplaySendButton) {
                                      stopRecording();
                                      voiceMessageDownloadUrl =
                                          await mediaService.uploadVoiceMesage(
                                              filePath: filePath!,
                                              chatID: chatRoomID!);
                                      sendMessage(MessageType.voice);
                                      scrollDown();
                                    }
                                  },
                                  child: Icon(_isDisplaySendButton
                                      ? Icons.send_outlined
                                      : Icons.mic_sharp),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),

                    //ALL ATTACHMENTS IMAGES, VIDEOS, DOCUMENTS
                    _isShowAttachWindow
                        ? Positioned(
                            bottom: 60,
                            left: 15,
                            right: 15,
                            child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.20,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 20),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(25)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  //ATTACH DOCUMENTS
                                  attachWindowItem(
                                    onTap: () async {
                                      setState(() {
                                        _isShowAttachWindow = false;
                                      });
                                      File? file = await mediaService
                                          .getDocumentFromDocuments();
                                      if (file != null) {
                                        chatDocumentDownloadUrl =
                                            await mediaService
                                                .uploadDocumentToChat(
                                          file: file,
                                          chatID: chatRoomID!,
                                        );
                                        sendMessage(MessageType.document);
                                      }
                                    },
                                    icon: Icons.document_scanner,
                                    color: Colors.deepPurpleAccent,
                                    title: "Document",
                                  ),

                                  //ATTACH VIDEOS
                                  attachWindowItem(
                                    onTap: () async {
                                      setState(() {
                                        _isShowAttachWindow = false;
                                      });
                                      File? file = await mediaService
                                          .getvideoFromGallery();
                                      if (file != null) {
                                        chatVideoDownloadUrl =
                                            await mediaService
                                                .uploadVideoToChat(
                                                    file: file,
                                                    chatID: chatRoomID!);
                                        sendMessage(MessageType.video);
                                      }
                                    },
                                    icon: Icons.videocam_rounded,
                                    color: Colors.pinkAccent,
                                    title: "Video",
                                  ),

                                  //ATTACH IMAGE
                                  attachWindowItem(
                                    onTap: () async {
                                      setState(() {
                                        _isShowAttachWindow = false;
                                      });
                                      File? file = await mediaService
                                          .getImageFromGallery();
                                      if (file != null) {
                                        chatImageDownloadUrl =
                                            await mediaService
                                                .uploadImageToChat(
                                                    file: file,
                                                    chatID: chatRoomID!);
                                        sendMessage(MessageType.image);
                                      }
                                    },
                                    icon: Icons.image,
                                    color: Colors.purpleAccent,
                                    title: "Gallery",
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ));
        });
  }

  //METHODS AND WIDGETS
  Widget buildMessageList() {
    return StreamBuilder(
        stream: chatService.getMessages(myUserId!, widget.receiverID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error!",
                style: TextStyle(color: tittleTextColor));
          } else if (snapshot.data == null) {
            return Container();
          }
          // Converting Firestore documents to List<Message>
          List<Message> messages = snapshot.data!.docs.map((doc) {
            return Message.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();

          return ListView.builder(
            itemCount: messages.length,
            physics: const ScrollPhysics(),
            controller: _scrollController,
            itemBuilder: (context, index) {
              final message = messages[index];
              //Updating Read status
              if (message.receiverID == authService.getCurrentUID()) {
                chatService.updateMessageStatus(
                    chatRoomID: chatRoomID!,
                    messageID: message.messageID,
                    status: MessageStatus.read);
              }

              //Displaying different types of messages
              switch (message.messageType) {
                case MessageType.text:
                  return textMessageBubble(message);
                case MessageType.image:
                  return imageMessageBubble(message);
                case MessageType.voice:
                  return voiceMessageBubble(message);
                case MessageType.video:
                  return videoMessageBubble(message);
                case MessageType.document:
                  return documentMessageBubble(message);
                default:
                  return textMessageBubble(message);
              }
            },
          );
        });
  }

  //TEXT MESSAGE BUBBLE/LAYOUT
  Widget textMessageBubble(Message message) {
    bool isShowTick = false;
    bool isCurrentUser = myUserId == message.senderID;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    //Showing tick on sender
    if (isCurrentUser) {
      isShowTick = true;
    } else {
      isShowTick = false;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5.0,
      ),
      child: GestureDetector(
        onLongPress: () {
          showModalBottomSheetOptions(
              context, message.messageID, message.senderID);
        },
        child: Container(
          alignment: alignment,
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.only(left: 15, right: 10, top: 3),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.5),
              borderRadius: isCurrentUser
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15))
                  : const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15)),
            ),
            child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                //decrpted message
                Text(
                  "${_encryptionService.decryptData(message.message)}${isCurrentUser ? "      " : ""}",
                  style: const TextStyle(color: Colors.white),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(DateFormat.jm().format(message.timestamp.toDate()),
                        style: const TextStyle(fontSize: 10, color: greyColor)),
                    const SizedBox(
                      width: 5,
                    ),
                    isShowTick == true
                        ? messageTick(message.status)
                        : Container()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Message Ticks Widget
  Widget messageTick(messageStatus) {
    switch (messageStatus) {
      case MessageStatus.sent:
        return const Icon(
          Icons.done,
          size: 16,
          color: greyColor,
        );
      case MessageStatus.delivered:
        return const Icon(
          Icons.done_all,
          size: 16,
          color: greyColor,
        );
      case MessageStatus.read:
        return const Icon(
          Icons.done_all,
          size: 16,
          color: zrpBlue,
        );
      default:
        return const Icon(
          Icons.done,
          size: 16,
          color: greyColor,
        );
    }
  }

  //IMAGE MESSAGE BUBBLE
  Widget imageMessageBubble(Message message) {
    bool isShowTick = false;
    bool isCurrentUser = myUserId == message.senderID;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    //Showing tick on sender
    if (isCurrentUser) {
      isShowTick = true;
    } else {
      isShowTick = false;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onLongPress: () {
          showModalBottomSheetOptions(
              context, message.messageID, message.senderID);
        },
        child: Container(
          alignment: alignment,
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.only(left: 3, right: 3, top: 3),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: message.message,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) {
                    return CircularProgressIndicator(
                      color: Colors.blue.withOpacity(0.5),
                    );
                  },
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/avatar.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(DateFormat.jm().format(message.timestamp.toDate()),
                        style: const TextStyle(fontSize: 10, color: greyColor)),
                    const SizedBox(
                      width: 5,
                    ),
                    isShowTick == true
                        ? messageTick(message.status)
                        : Container()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //VOICE MESSAGE BUBBLE
  Widget voiceMessageBubble(Message message) {
    bool isShowTick = false;
    bool isCurrentUser = myUserId == message.senderID;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    //Showing tick on sender
    if (isCurrentUser) {
      isShowTick = true;
    } else {
      isShowTick = false;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onLongPress: () {
          showModalBottomSheetOptions(
              context, message.messageID, message.senderID);
        },
        child: Container(
          alignment: alignment,
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.only(left: 15, right: 10, top: 3),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.5),
              borderRadius: isCurrentUser
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15))
                  : const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15)),
            ),
            child: Stack(
              children: [
                VoiceMessagePlayer(
                  controller: VoiceController(
                    maxDuration: const Duration(minutes: 1),
                    isFile: false,
                    audioSrc: message.message,
                    onComplete: () {},
                    onPause: () {},
                    onPlaying: () {},
                    onError: (err) {},
                  ),
                  innerPadding: 0,
                  backgroundColor: const Color.fromARGB(255, 9, 87, 150),
                  cornerRadius: 20,
                  playPauseButtonDecoration: const BoxDecoration(
                      color: Colors.blueGrey, shape: BoxShape.circle),
                ),
                Positioned(
                  bottom: 1,
                  right: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(DateFormat.jm().format(message.timestamp.toDate()),
                          style:
                              const TextStyle(fontSize: 10, color: greyColor)),
                      const SizedBox(
                        width: 5,
                      ),
                      isShowTick == true
                          ? messageTick(message.status)
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //VIDEO MESSAGE BUBBLE
  Widget videoMessageBubble(Message message) {
    bool isShowTick = false;
    bool isCurrentUser = myUserId == message.senderID;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    late VideoPlayerController videoPlayerController;
    late CustomVideoPlayerController _customVideoPlayerController;
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(message.message))
          ..initialize().then((value) => setState(() {}));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
    );

    //Showing tick on sender
    if (isCurrentUser) {
      isShowTick = true;
    } else {
      isShowTick = false;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTapDown: (details) {
          String decryptedUrl = _encryptionService.decryptData(message.message);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerWidget(
                  videoUrl: decryptedUrl, videoTittle: "Datalink Videos"),
            ),
          );
        },
        onLongPress: () {
          showModalBottomSheetOptions(
              context, message.messageID, message.senderID);
        },
        child: Container(
          alignment: alignment,
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.only(left: 3, right: 3, top: 3),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Center(
                    child: Icon(
                      Icons.play_circle_sharp,
                      size: 60,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(DateFormat.jm().format(message.timestamp.toDate()),
                        style: const TextStyle(fontSize: 10, color: greyColor)),
                    const SizedBox(
                      width: 5,
                    ),
                    isShowTick == true
                        ? messageTick(message.status)
                        : Container()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //DOCUMENT MESSAGE BUBBLE
  Widget documentMessageBubble(Message message) {
    bool isShowTick = false;
    bool isCurrentUser = myUserId == message.senderID;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    //Showing tick on sender
    if (isCurrentUser) {
      isShowTick = true;
    } else {
      isShowTick = false;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onLongPress: () {
          showModalBottomSheetOptions(
              context, message.messageID, message.senderID);
        },
        onTap: () {},
        child: Container(
          alignment: alignment,
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.only(left: 10, right: 3, top: 10),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.document_scanner,
                      size: 25,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Document",
                      style: TextStyle(color: tittleTextColor),
                    )
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(DateFormat.jm().format(message.timestamp.toDate()),
                        style: const TextStyle(fontSize: 10, color: greyColor)),
                    const SizedBox(
                      width: 5,
                    ),
                    isShowTick == true
                        ? messageTick(message.status)
                        : Container()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//ATTACH MEDIA WIDGET
  attachWindowItem(
      {IconData? icon, Color? color, String? title, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40), color: color),
            child: Icon(icon),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "$title",
            style: const TextStyle(color: tittleTextColor, fontSize: 13),
          ),
        ],
      ),
    );
  }

  //MODAL BOTTOM SHEET OPTIONS
  void showModalBottomSheetOptions(
      BuildContext context, String messageID, String userID) {
    showModalBottomSheet(
        backgroundColor: Colors.blue.withOpacity(0.8),
        context: context,
        builder: (context) {
          return SafeArea(
              child: Wrap(
            children: [
              //Delete message button
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text("Delete Message"),
                onTap: () {
                  Navigator.pop(context);
                  chatService.deleteMessage(chatRoomID!, messageID);
                },
              ),

              //Report message button
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text("Report"),
                onTap: () {
                  Navigator.pop(context);
                  CustomDialog().yesNoConfirmDialog(
                      context: context,
                      dialogTittle: "REPORT USER",
                      dialogText: "Are you sure you want to report this user",
                      function: blockUser(messageID, userID));
                },
              ),

              //Cancel button
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text("Cancel"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ));
        });
  }
}
