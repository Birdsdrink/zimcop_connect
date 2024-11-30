// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zimcop_connect/main.dart';
import 'package:zimcop_connect/views/pages/home_page.dart';
import 'package:zimcop_connect/views/widgets/my_text_form_field.dart';
import 'package:zimcop_connect/views/widgets/password_text_form_field.dart';
import 'package:zimcop_connect/views/widgets/snack_bar.dart';
import '../../const/style_const.dart';
import '../../services/auth_service.dart';
import '../../services/media_service.dart';
import '../../services/shared_pref.dart';
import '../widgets/button.dart';
import '../widgets/profile_widget.dart';
import 'login_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final SharedPrefHelper sharedPrefHelper = SharedPrefHelper();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _forceNumberController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? rank;
  String profilePicUrl = "";
  final String situation = "Law enforcement till i die";
  final bool isOnline = false;
  File? selectedImage;
  MediaService mediaService = MediaService();
  bool isSigningUp = false;
  final List<String> items = const [
    "CGP",
    "DCG",
    "CMM",
    "Ass Comm",
    "C/Supt",
    "Supt",
    "C/Insp",
    "Insp",
    "Ass Insp",
    "S/M",
    "Sgt",
    "Cst"
  ];

  //SIGNING UP
  void registerUser(BuildContext context) async {
    final auth = AuthService();
    String surname = _surnameController.text.toLowerCase();
    setState(() {
      isSigningUp = true;
    });

    try {
      //SIGNING IN
      User? user = await auth.signUpWithEmailPassword(
          _emailController.text, _passwordController.text);

      //IF SUCCESSFULLY LOGGED IN->Do the following
      if (user != null) {
        //UPLOAD PROF PICTURE TO FIREBASE STORAGE
        if (selectedImage != null) {
          profilePicUrl = (await mediaService.uploadUserProfilePic(
              file: selectedImage!, uid: AuthService().getCurrentUID()))!;
        }
        //SEND USER DETAILS TO CLOUD FIRESTORE
        await auth.createUserDetails(
            surname.toString(),
            _forceNumberController.text,
            rank.toString(),
            profilePicUrl.toString(),
            situation.toString(),
            isOnline,
            DateTime.now());

        //SAVING SHARED PREFERENCES LOCALLY
        sharedPrefHelper.saveForceNumber(_forceNumberController.text);
        sharedPrefHelper.saveRank(_forceNumberController.text);
        sharedPrefHelper.saveSurname(_surnameController.text);
        sharedPrefHelper.saveEmail(_emailController.text);
        sharedPrefHelper.saveProfPicUrl(profilePicUrl);
        sharedPrefHelper.saveSituation(situation);
        sharedPrefHelper.saveIsloggedIn(true);
        sharedPrefHelper.saveScreenHeight(MediaQuery.of(context).size.height);
        sharedPrefHelper.saveScreenWidth(MediaQuery.of(context).size.width);

        navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false);
        CustomSnackbar().successSnackbar(context, "Registration Successfull");
        isSigningUp = false;
        setState(() {});
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.toString()),
              ));
      setState(() {
        isSigningUp = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: homeBackgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logoBlack.png",
                  height: 60,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.blue, width: 2),
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(80),
                        topRight: Radius.circular(80)),
                  ),

                  //FORM WIDGET FOR USER DETAIL VALIDATION
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const Text(
                          "Sign Up",
                          style: TextStyle(
                              color: tittleTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: () async {
                            File? file =
                                await mediaService.getImageFromGallery();
                            if (file != null) {
                              selectedImage = file;
                              setState(() {});
                            }
                          },
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: profileWidget(image: selectedImage),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        rankDropDownMenu(),
                        const SizedBox(height: 10),
                        MyTextFormField(
                          hintText: "Force Number",
                          labelText: "Force Number",
                          passwordController: _forceNumberController,
                          icon: Icons.local_police_outlined,
                          textInputType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '*Please enter your Force Number';
                            }
                            const forceNumberPattern = r'^[09]\d{5}[a-zA-Z]$';
                            final regex = RegExp(forceNumberPattern);
                            if (!regex.hasMatch(value)) {
                              return '*Please enter a valid Force Number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        MyTextFormField(
                          hintText: "Surname",
                          labelText: "Surname",
                          passwordController: _surnameController,
                          icon: Icons.person,
                          textInputType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '*Please enter your surname';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        MyTextFormField(
                          hintText: "Email",
                          labelText: "Email",
                          passwordController: _emailController,
                          icon: Icons.email_outlined,
                          textInputType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '*Please enter your email';
                            }
                            const emailPattern =
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                            final regex = RegExp(emailPattern);
                            if (!regex.hasMatch(value)) {
                              return '*Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        PasswordTextFormField(
                          hintText: "Password",
                          labelText: "Password",
                          passwordController: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '*Please enter your password';
                            } else if (value.length < 6) {
                              return '*Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        PasswordTextFormField(
                          hintText: "Confirm Password",
                          labelText: "Confirm Password",
                          passwordController: _confirmPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '*Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return '*Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                registerUser(context);
                              }
                            },
                            child: Button(
                              btnText: "SIGN UP",
                              isLoading: isSigningUp,
                              loadingMessage: "Signing In...",
                            )),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?  ",
                              style: TextStyle(color: subTittleTextColor),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LogInPage()),
                                      (route) => route.isFirst);
                                },
                                child: const Text(
                                  "Log In",
                                  style: TextStyle(color: Colors.amber),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  //WIDGET FOR CHOOSING RANK
  Widget rankDropDownMenu() {
    return Container(
      height: 45,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withOpacity(0.7)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.stars_outlined,
            color: Colors.blue,
            size: 20,
          ),
          const SizedBox(width: 13),
          DropdownButton<String>(
            hint: const Row(
              children: [
                Text(
                  'Please select your Rank',
                  style: TextStyle(color: Colors.white54, fontSize: 17),
                ),
              ],
            ),
            dropdownColor: const Color.fromARGB(255, 7, 35, 58),
            style: const TextStyle(color: Colors.white54),
            borderRadius: BorderRadius.circular(20),
            menuMaxHeight: 300,
            underline: Container(height: 0),
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.blue.withOpacity(0.9),
              size: 35,
            ), // Hint text
            value: rank,
            onChanged: (String? newValue) {
              setState(() {
                rank = newValue!;
              });
            },
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
