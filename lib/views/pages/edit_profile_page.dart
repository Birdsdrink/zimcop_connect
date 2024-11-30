import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../const/style_const.dart';
import '../../services/auth_service.dart';
import '../../services/media_service.dart';
import '../widgets/button.dart';
import '../widgets/profile_widget.dart';
import '../widgets/text_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _forceNumberController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();

  File? selectedImage;
  final MediaService mediaService = MediaService();

  String forceNumber = "",
      rank = "Cst",
      surname = "",
      profilePicUrl = "",
      situation = "",
      userId = "";
  final authService = AuthService();

  //Getting Current User Details rom FireStore
  void getMyAccountDetails() async {
    QuerySnapshot querySnapshot =
        await authService.getUserByUid(authService.getCurrentUID());
    forceNumber = "${querySnapshot.docs[0]["forceNo"]}";
    rank = "${querySnapshot.docs[0]["rank"]}";
    surname = "${querySnapshot.docs[0]["surname"]}";
    profilePicUrl = "${querySnapshot.docs[0]["profilePicUrl"]}";
    situation = "${querySnapshot.docs[0]["situation"]}";
    userId = "${querySnapshot.docs[0]["uid"]}";

    surname = surname[0].toUpperCase() + surname.substring(1);

    _forceNumberController.text = forceNumber;
    _surnameController.text = surname;
    setState(() {});
  }

  //Submitting Edited details to Firebase Firestore
  void submitDetails() async {
    AuthService authService = AuthService();

    //Upload Profile Image
    profilePicUrl = (await mediaService.uploadUserProfilePic(
        file: selectedImage!, uid: AuthService().getCurrentUID()))!;

    Map<String, dynamic> updatedInfo = {
      'forceNo': _forceNumberController.text,
      'surname': _surnameController.text,
      'rank': rank,
      //'profilePicUrl': profilePicUrl
    };

    await authService.updateUserDetails(updatedInfo);
  }

  @override
  void initState() {
    getMyAccountDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: homeBackgroundColor,
        appBar: AppBar(
            backgroundColor: homeBackgroundColor,
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.blue.withOpacity(0.7),
                )),
            title: Image.asset("assets/images/logoBlack.png", height: 50)),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 5),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.blue, width: 2),
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    const Text(
                      "E d i t      P r o f i l e",
                      style: TextStyle(
                          color: tittleTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        File? file = await mediaService.getImageFromGallery();
                        if (file != null) {
                          selectedImage = file;
                          setState(() {});
                        }
                      },
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(59),
                          child: profileWidget(
                              image: selectedImage, imageUrl: profilePicUrl),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    InputFields(
                        hintText: "Force Number",
                        obscureText: false,
                        controller: _forceNumberController,
                        icon: Icons.local_police_outlined),
                    const SizedBox(height: 15),
                    InputFields(
                        hintText: "Surname",
                        obscureText: false,
                        controller: _surnameController,
                        icon: Icons.person),
                    const SizedBox(height: 15),
                    Container(
                      height: 35,
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.only(left: 25, right: 5),
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(12)),
                      child: DropdownButton<String>(
                        value: rank,
                        isExpanded: true,
                        focusColor: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        menuMaxHeight: 400,
                        underline: Container(height: 0),
                        dropdownColor: Colors.indigo,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.blue.withOpacity(0.9),
                          size: 35,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            rank = newValue!;
                          });
                        },
                        items: const [
                          DropdownMenuItem<String>(
                              value: 'CGP',
                              child: Text("Commissioner General")),
                          DropdownMenuItem<String>(
                              value: 'DCG',
                              child: Text("Deputy Commissioner General")),
                          DropdownMenuItem<String>(
                              value: 'CMM', child: Text("Commissioner")),
                          DropdownMenuItem<String>(
                              value: 'Ass Comm',
                              child: Text("Assistant Commissioner")),
                          DropdownMenuItem<String>(
                              value: 'C/ Supt', child: Text("Chief Supt")),
                          DropdownMenuItem<String>(
                              value: 'Supt', child: Text("Superintendent")),
                          DropdownMenuItem<String>(
                              value: 'C/Insp', child: Text("Chief Inspector")),
                          DropdownMenuItem<String>(
                              value: 'Insp', child: Text("Inspector")),
                          DropdownMenuItem<String>(
                              value: 'Ass Insp',
                              child: Text("Assistant Inspector")),
                          DropdownMenuItem<String>(
                              value: 'S/M', child: Text("Sergeant Major")),
                          DropdownMenuItem<String>(
                              value: 'Sgt', child: Text("Sergeant")),
                          DropdownMenuItem<String>(
                              value: 'Cst', child: Text("Constable")),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    GestureDetector(
                        onTap: () {
                          submitDetails();
                        },
                        child: const Button(
                          btnText: "Submit Details",
                          isLoading: false,
                          loadingMessage: "Submitting Details",
                        )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
