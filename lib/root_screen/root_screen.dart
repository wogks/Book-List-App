import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import '../book_list/book_list_screen.dart';


class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          User? user = snapshot.data;

          if (user == null) {
            return const SignInScreen(
  providerConfigs: [
    EmailProviderConfiguration(),
    GoogleProviderConfiguration(
      clientId: '1035661118378-n9gge9nfshl04beof9f16gufl8g9vrrn.apps.googleusercontent.com',
    ),
  ],
);
          }

          return BookListScreen();
        });
  }
}
