import 'package:flutter/material.dart';
import 'package:zimcop_connect/services/shared_pref.dart';
import '../views/pages/home_page.dart';
import '../views/pages/welcome_page.dart';
import 'auth_service.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool isSignedIn = false;

  getSignedIn() async {
    isSignedIn = (await SharedPrefHelper().getIsloggedIn())!;
    setState(() {});
  }

  @override
  void initState() {
    getSignedIn();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (AuthService().isLoggedIn() == true) {
      return const HomePage();
    }
    return const WelcomePage();
  }
}
