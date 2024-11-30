import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zimcop_connect/main.dart';
import 'package:zimcop_connect/models/police_officer.dart';
import 'package:zimcop_connect/services/push_notification_service.dart';
import 'package:zimcop_connect/views/pages/video_call.dart';
import 'package:zimcop_connect/views/pages/voice_call.dart';
import '../../const/style_const.dart';
import '../../services/auth_service.dart';
import '../../services/chat_service.dart';
import '../widgets/profile_widget.dart';

class CallsHistoryPage extends StatefulWidget {
  const CallsHistoryPage({super.key});

  @override
  State<CallsHistoryPage> createState() => _CallsHistoryPageState();
}

class _CallsHistoryPageState extends State<CallsHistoryPage> {
  String myUserID = AuthService().getCurrentUID();

  bool isSearch = false;

  String searchData = "";
  String? myToken, callID;
  String myUserId = AuthService().getCurrentUID();

  void createChatRoomID(String receiverID) {
    List<String> ids = [myUserId, receiverID];
    ids.sort(); //to ensure chatroom id is the same for 2 people
    callID = ids.join('_');
    setState(() {});
  }

  void getFcmToken() async {
    myToken = await PushNotificationService().getFcmToken();
    setState(() {});
  }

  getFcmTokenn() async {
    String? fcmToken = await PushNotificationService().getFcmToken();
    PushNotificationService().saveTokenToFirestore(token: fcmToken!);
  }

  @override
  void initState() {
    getFcmToken();
    getFcmTokenn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homeBackgroundColor,
      appBar: AppBar(
        backgroundColor: homeBackgroundColor,
        title: Image.asset("assets/images/logoBlack.png", height: 50),
      ),
      body: Column(
        children: [
          const Text("C a l l s",
              style: TextStyle(color: tittleTextColor, fontSize: 20)),
          searchBar(),
          Expanded(
            child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border(
                        top: BorderSide(
                            color: Colors.blue.withOpacity(0.3), width: 6)),
                    borderRadius: const BorderRadiusDirectional.only(
                        topStart: Radius.circular(25),
                        topEnd: Radius.circular(25))),
                child: contactsListTile()),
          ),
        ],
      ),
    );
  }

  //CONTACTS WIDGET
  Widget contactsListTile() {
    return StreamBuilder<QuerySnapshot>(
        stream: ChatService().searchContactsBySurname(searchData),
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

                    //LIST USERS WHO ARE NOT ME
                    if (data['uid'] != myUserID) {
                      return GestureDetector(
                        onTap: () {
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
                            title: Text(
                              "${data['rank']} ${data['surname'][0].toUpperCase() + data['surname'].substring(1)}",
                              style: const TextStyle(
                                  color: tittleTextColor, fontSize: 13),
                            ),
                            subtitle: Text(
                              "${data['situation']}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: subTittleTextColor, fontSize: 12),
                            ),
                            trailing: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "FN ${data['forceNo']}",
                                  style: const TextStyle(
                                      fontSize: 8, color: tittleTextColor),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        DateTime dateTime =
                                            data['lastSeen'].toDate();
                                        PoliceOfficer officer = PoliceOfficer(
                                            surname: data['surname'],
                                            forceNo: data['forceNo'],
                                            rank: data['rank'],
                                            uid: data['uid'],
                                            email: data['email'],
                                            profilePicUrl:
                                                data['profilePicUrl'],
                                            situation: data['situation'],
                                            isOnline: data['isOnline'],
                                            lastSeen: dateTime,
                                            fcmToken: data['fcmToken']);

                                        createChatRoomID(officer.uid!);

                                        String? surname =
                                            "${officer.rank!} ${officer.surname![0].toUpperCase() + officer.surname!.substring(1)}";

                                        PushNotificationService()
                                            .sendCallNotification(
                                                callID: callID!,
                                                calleeID: officer.uid!,
                                                callerSurname: surname,
                                                fcmToken: officer.fcmToken,
                                                hasVideo: "false");

                                        navigatorKey.currentState!
                                            .push(MaterialPageRoute(
                                                builder: (context) => VoiceCall(
                                                      callID: callID!,
                                                      userID: myUserID,
                                                      surname: surname,
                                                      picUrl: officer
                                                          .profilePicUrl!,
                                                    )));
                                      },
                                      child: Icon(Icons.call,
                                          size: 25,
                                          color: Colors.blue.withOpacity(0.4)),
                                    ),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () async {
                                        DateTime dateTime =
                                            data['lastSeen'].toDate();
                                        PoliceOfficer officer = PoliceOfficer(
                                            surname: data['surname'],
                                            forceNo: data['forceNo'],
                                            rank: data['rank'],
                                            uid: data['uid'],
                                            email: data['email'],
                                            profilePicUrl:
                                                data['profilePicUrl'],
                                            situation: data['situation'],
                                            isOnline: data['isOnline'],
                                            lastSeen: dateTime,
                                            fcmToken: data['fcmToken']);

                                        createChatRoomID(officer.uid!);

                                        String? surname =
                                            "${officer.rank!} ${officer.surname![0].toUpperCase() + officer.surname!.substring(1)}";

                                        navigatorKey.currentState!.push(
                                            MaterialPageRoute(
                                                builder: (context) => VideoCall(
                                                    callID: callID!,
                                                    userID: myUserID,
                                                    surname: surname)));

                                        PushNotificationService()
                                            .sendCallNotification(
                                                callID: callID!,
                                                calleeID: officer.uid!,
                                                callerSurname: surname,
                                                fcmToken: officer.fcmToken,
                                                hasVideo: "true");
                                      },
                                      child: Icon(Icons.video_call,
                                          size: 25,
                                          color: Colors.blue.withOpacity(0.4)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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

  //SEARCH BAR
  Widget searchBar() {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      height: 27,
      width: MediaQuery.of(context).size.width * 0.95,
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
    );
  }
}
