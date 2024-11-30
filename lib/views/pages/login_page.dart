// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zimcop_connect/main.dart';
import 'package:zimcop_connect/views/pages/sign_up.dart';
import 'package:zimcop_connect/views/widgets/my_text_form_field.dart';
import 'package:zimcop_connect/views/widgets/password_text_form_field.dart';
import 'package:zimcop_connect/views/widgets/snack_bar.dart';
import '../../const/style_const.dart';
import '../../services/auth_service.dart';
import '../../services/shared_pref.dart';
import '../widgets/button.dart';
import 'home_page.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoggingIn = false;
  String forceNumber = "",
      rank = "",
      surname = "",
      profPicUrl = "",
      situation = "",
      userId = "";

  //LOGIN METHOD
  void login(BuildContext context) async {
    //Loading circle
    setState(() {
      isLoggingIn = true;
    });

    //Auth Service
    final authService = AuthService();
    //Loging in
    try {
      User? user = await authService.signInWithEmailPassword(
          emailController.text, passwordController.text);

      if (user != null) {
        //After Successfully logging Take User details from database
        QuerySnapshot querySnapshot =
            await authService.getUserByEmail(emailController.text);
        forceNumber = "${querySnapshot.docs[0]["forceNo"]}";
        rank = "${querySnapshot.docs[0]["rank"]}";
        surname = "${querySnapshot.docs[0]["surname"]}";
        profPicUrl = "${querySnapshot.docs[0]["profilePicUrl"]}";
        situation = "${querySnapshot.docs[0]["situation"]}";
        userId = "${querySnapshot.docs[0]["uid"]}";

        //Save Details Locally
        SharedPrefHelper().saveForceNumber(forceNumber);
        SharedPrefHelper().saveRank(rank);
        SharedPrefHelper().saveSurname(surname);
        SharedPrefHelper().saveProfPicUrl(profPicUrl);
        SharedPrefHelper().saveSituation(situation);
        SharedPrefHelper().saveUserID(userId);
        SharedPrefHelper().saveEmail(emailController.text);
        SharedPrefHelper().saveIsloggedIn(true);
        SharedPrefHelper().saveScreenHeight(MediaQuery.of(context).size.height);
        SharedPrefHelper().saveScreenWidth(MediaQuery.of(context).size.width);

        navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => true);
        CustomSnackbar().successSnackbar(context, "Logged in Successfully");
        isLoggingIn = false;
        setState(() {});
      }
    }

    //catch errors
    catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.toString()),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: homeBackgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 30),

            //FORM FOR USER INPUT
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //LOGO
                Image.asset(
                  "assets/images/logoBlack.png",
                  height: 60,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.blue, width: 2),
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(80),
                        topRight: Radius.circular(80)),
                  ),

                  //FORM FOR USER INPUT
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const Text(
                          "Login",
                          style: TextStyle(
                              color: tittleTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        MyTextFormField(
                          hintText: "Email",
                          labelText: "Email",
                          passwordController: emailController,
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
                        const SizedBox(height: 20),
                        PasswordTextFormField(
                          hintText: "Password",
                          labelText: "Password",
                          passwordController: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '*Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 50),

                        //LOGIN BUTTON
                        GestureDetector(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                login(context);
                              }
                            },
                            child: Button(
                              btnText: "LOGIN",
                              isLoading: isLoggingIn,
                              loadingMessage: "Logging In...",
                            )),
                        const SizedBox(height: 70),

                        //LINK TO SIGN UP
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have any account?  ",
                                style: TextStyle(color: subTittleTextColor)),
                            GestureDetector(
                                onTap: () => Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const SignUp()),
                                    (route) => route.isFirst),
                                child: const Text(
                                  "Sign Up",
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
}
