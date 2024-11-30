import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zimcop_connect/views/pages/welcome_page.dart';
import 'package:zimcop_connect/views/widgets/dialog_box.dart';
import 'package:zimcop_connect/views/widgets/snack_bar.dart';
import '../../const/style_const.dart';
import '../../services/auth_service.dart';
import '../widgets/profile_widget.dart';
import 'edit_profile_page.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  String forceNumber = "",
      rank = "",
      surname = "",
      profPicUrl = "",
      situation = "",
      userId = "";
  final authService = AuthService();
  void getMyAccountDetails() async {
    QuerySnapshot querySnapshot =
        await authService.getUserByUid(authService.getCurrentUID());
    forceNumber = "${querySnapshot.docs[0]["forceNo"]}";
    rank = "${querySnapshot.docs[0]["rank"]}";
    surname = "${querySnapshot.docs[0]["surname"]}";
    profPicUrl = "${querySnapshot.docs[0]["profilePicUrl"]}";
    situation = "${querySnapshot.docs[0]["situation"]}";
    userId = "${querySnapshot.docs[0]["uid"]}";
    surname = surname[0].toUpperCase() + surname.substring(1);
    setState(() {});
  }

  //logout Progress Indicator
  logout() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text(
                  "Signing Out...",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );

    //Logging Out
    authService.signOut();
    //delay for the progress indicator
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const WelcomePage()),
          (route) => true);
      CustomSnackbar().successSnackbar(context, "Logged out Successfully");
    });
  }

  @override
  void initState() {
    getMyAccountDetails();
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homeBackgroundColor,
      appBar: AppBar(
          backgroundColor: homeBackgroundColor,
          title: Image.asset("assets/images/logoBlack.png", height: 50)),
      body: Column(
        children: [
          //TITTLE
          const Center(
              child: Text("A c c o u n t",
                  style: TextStyle(color: tittleTextColor, fontSize: 20))),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.only(top: 10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border(
                  top: BorderSide(
                      color: Colors.blue.withOpacity(0.3), width: 6)),
              borderRadius: const BorderRadiusDirectional.only(
                  topStart: Radius.circular(25), topEnd: Radius.circular(25)),
            ),
            child: Column(
              children: [
                //PROFILE PIC
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: profileWidget(imageUrl: profPicUrl),
                  ),
                ),
                const SizedBox(height: 10),

                //FORCE NUMBER
                Text(
                  forceNumber,
                  style: const TextStyle(fontSize: 12, color: Colors.blue),
                ),

                //RANK AND SURNAME
                Text(
                  "$rank $surname",
                  style: const TextStyle(fontSize: 20, color: Colors.blue),
                ),

                //SITUATION
                Text(situation,
                    style: const TextStyle(color: subTittleTextColor))
              ],
            ),
          ),

          //EDIT PROFILE
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfilePage()));
            },
            leading: const Icon(Icons.edit),
            title: const Text("Edit Profile",
                style: TextStyle(color: tittleTextColor)),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          const SizedBox(height: 10),

          //SETTINGS
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.settings),
            title: const Text("Settings",
                style: TextStyle(color: tittleTextColor)),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          const SizedBox(height: 10),

          //LOGOUT
          ListTile(
            onTap: () {
              CustomDialog().yesNoConfirmDialog(
                context: context,
                dialogTittle: "LOGOUT",
                dialogText: "Are you sure you want to logout",
                function: logout(),
              );
            },
            leading: const Icon(Icons.logout),
            title:
                const Text("Logout", style: TextStyle(color: tittleTextColor)),
            trailing: const Icon(Icons.arrow_forward_ios),
          )
        ],
      ),
    );
  }
}
