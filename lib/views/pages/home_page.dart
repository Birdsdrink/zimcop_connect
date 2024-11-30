import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:zimcop_connect/services/push_notification_service.dart';
import '../../services/chat_service.dart';
import 'account_info.dart';
import 'calls_history_page.dart';
import 'chat_room_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final PushNotificationService pushNotificationService =
      PushNotificationService();

  int _currentIndex = 0;

  List<Widget> pages = const [ChatRoom(), CallsHistoryPage(), AccountInfo()];

  //IMPLEMENTING ONLINE STATUS AND LAST SEEN
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        ChatService().setOnlineStatus(value: true);
        break;

      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        ChatService().setOnlineStatus(value: false);
        ChatService().setLastSeen(value: Timestamp.fromDate(DateTime.now()));
        break;

      default:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  getFcmToken() async {
    String? fcmToken = await pushNotificationService.getFcmToken();
    pushNotificationService.saveTokenToFirestore(token: fcmToken!);
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    //Getting and saving my fcm token to firebase
    getFcmToken();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: GNav(
              iconSize: 21,
              backgroundColor: Colors.black,
              color: Colors.cyanAccent,
              activeColor: Colors.black,
              tabBackgroundColor: Colors.blueGrey,
              padding: const EdgeInsets.all(8),
              onTabChange: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              tabs: const [
                GButton(
                  icon: Icons.message,
                  gap: 8,
                  text: 'M e s s a g e s',
                ),
                GButton(icon: Icons.call_end, gap: 8, text: 'C a l l s'),
                GButton(icon: Icons.person, gap: 8, text: 'A c c o u n t'),
              ]),
        ),
      ),
    );
  }
}
