import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:zimcop_connect/const/message_const.dart';
import 'package:zimcop_connect/views/pages/single_chat_page.dart';
import '../../const/style_const.dart';
import '../../services/auth_service.dart';
import '../../services/chat_service.dart';
import '../../services/shared_pref.dart';
import '../widgets/profile_widget.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  //INTANTIATING CLASSES AND DECLARING VARIABLES
  final AuthService authService = AuthService();
  final ChatService chatService = ChatService();
  final SharedPrefHelper sharedPrefHelper = SharedPrefHelper();
  bool isSearch = false;
  String? searchData, mySurname, myUserID;
  Stream? getChatRoomListStream;

  //GETTING LOCALLY SAVED DATA
  void getSharedPref() async {
    mySurname = await sharedPrefHelper.getSurname();
    setState(() {});
  }

  @override
  void initState() {
    myUserID = authService.getCurrentUID();
    getSharedPref();
    getChatRoomListStream = chatService.getChatRooms();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      //APP BAR
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: isSearch == false
            ? GestureDetector(
                onTap: () {},
                child: Image.asset("assets/images/logoBlack.png", height: 50))
            : Container(
                padding: const EdgeInsets.only(left: 5),
                height: 27,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchData = value.toLowerCase();
                      if (isSearch == true) {
                        searchData = value.toLowerCase();
                      } else {
                        value == "";
                      }
                    });
                  },
                  decoration: const InputDecoration.collapsed(
                      hintText: "Search Members",
                      hintStyle: TextStyle(color: subTittleTextColor)),
                  style: const TextStyle(color: tittleTextColor),
                ),
              ),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                isSearch = !isSearch;
                searchData = "";
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                  color: Colors.lightBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(
                isSearch ? Icons.cancel : Icons.search,
                color: isSearch ? Colors.orange : Colors.white70,
                size: 28,
              ),
            ),
          )
        ],
      ),

      //BODY
      body: Column(
        children: [
          isSearch == false
              ? const Text(
                  "M e s s a g e s",
                  style: TextStyle(color: tittleTextColor, fontSize: 20),
                )
              : Container(),

          //CONTACT LIST OR CHATROOM LIST
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border(
                      top: BorderSide(
                          color: Colors.blue.withOpacity(0.3), width: 6)),
                  borderRadius: const BorderRadiusDirectional.only(
                      topStart: Radius.circular(25),
                      topEnd: Radius.circular(25)),
                ),
                child: isSearch ? contactsListTile() : chatRoomListWidget()),
          ),
        ],
      ),
    );
  }

  //CONTACTS WIDGET
  Widget contactsListTile() {
    return StreamBuilder<QuerySnapshot>(
        stream: chatService.searchContactsBySurname(searchData!),
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;

                    //CONTACT LIST OF USERS EXCLDNG ME
                    if (data['uid'] != myUserID) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SingleChatPage(
                                        receiverID: data['uid'],
                                        rank: data['rank'],
                                        surname: data['surname'],
                                        receiverProfPicUrl:
                                            data['profilePicUrl'],
                                        fcmToken: data['fcmToken'],
                                      )));
                          isSearch = false;
                          setState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          height: 73,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.circular(20),
                            border: Border.symmetric(
                                horizontal: BorderSide(
                              color: Colors.blue.withOpacity(0.2),
                              width: 2,
                            )),
                          ),
                          child: ListTile(
                              leading: SizedBox(
                                width: 41,
                                height: 41,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: profileWidget(
                                      imageUrl: "${data['profilePicUrl']}"),
                                ),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    "${data['rank']} ${data['surname'][0].toUpperCase() + data['surname'].substring(1)}",
                                    style: const TextStyle(
                                        color: tittleTextColor, fontSize: 13),
                                  ),
                                  const Spacer(),
                                  Text(
                                    data['forceNo'],
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.lightBlueAccent
                                            .withOpacity(0.5)),
                                  )
                                ],
                              ),
                              subtitle: Text(
                                "${data['situation']}",
                                style:
                                    const TextStyle(color: subTittleTextColor),
                              ),
                              trailing: const Icon(Icons.message, size: 30)),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                )
              : Container();
        });
  }

  //CHAT ROOM LIST WIDGET
  Widget chatRoomListWidget() {
    return StreamBuilder(
        stream: getChatRoomListStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    String senderID =
                        ds.id.replaceAll("_", "").replaceAll(myUserID!, "");

                    return StreamBuilder<QuerySnapshot>(
                      stream: authService.getUserByUserID(senderID),
                      builder: (context, subQuerrySnapshot) {
                        return subQuerrySnapshot.hasData
                            ? ListView(
                                shrinkWrap: true,
                                children:
                                    subQuerrySnapshot.data!.docs.map((subDoc) {
                                  //Updating message delivery status
                                  if (subDoc['uid'] ==
                                      authService.getCurrentUID()) {
                                    chatService.updateMessageStatus(
                                        chatRoomID: ds.id,
                                        messageID: ds['messageID'],
                                        status: MessageStatus.delivered);
                                  }

                                  return chatRoomListTile(
                                    receiverSurname: subDoc['surname'],
                                    receiverRank: subDoc['rank'],
                                    receiverProfileUrl: subDoc['profilePicUrl'],
                                    receiverForceNo: subDoc['forceNo'],
                                    lastMessage: ds['lastMessage'],
                                    timeSend: ds['timeSend'],
                                    receiverID: subDoc['uid'],
                                    fcmToken: subDoc['fcmToken'],
                                  );
                                }).toList())
                            : Container();
                      },
                    );
                  })
              : Container();
        });
  }

  Widget chatRoomListTile({
    required String receiverSurname,
    required String receiverRank,
    required String receiverProfileUrl,
    required String receiverForceNo,
    required String fcmToken,
    required String lastMessage,
    required Timestamp timeSend,
    required String receiverID,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleChatPage(
              receiverID: receiverID,
              rank: receiverRank,
              surname: receiverSurname,
              receiverProfPicUrl: receiverProfileUrl,
              fcmToken: fcmToken,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(20),
          border: Border.symmetric(
              horizontal: BorderSide(
            color: Colors.blue.withOpacity(0.2),
            width: 2,
          )),
        ),
        child: ListTile(
          leading: SizedBox(
            width: 50,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: profileWidget(imageUrl: receiverProfileUrl),
            ),
          ),
          title: Text(
              "$receiverRank ${receiverSurname[0].toUpperCase() + receiverSurname.substring(1)}",
              style: const TextStyle(
                  color: tittleTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14)),
          subtitle: Text(
            lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: subTittleTextColor, fontSize: 13),
          ),
          trailing: Text(
            DateFormat.jm().format(timeSend.toDate()),
            style: const TextStyle(color: tittleTextColor, fontSize: 10),
          ),
        ),
      ),
    );
  }
}
