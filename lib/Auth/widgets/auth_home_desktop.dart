import 'package:aiso/Auth/widgets/auth_details.dart';
import 'package:aiso/Auth/widgets/auth_form.dart';
import 'package:aiso/Home/widgets/centered_view.dart';
import 'package:aiso/NavBar/views/navgation_bar.dart';
import 'package:flutter/material.dart';

class AuthHomeDesktop extends StatelessWidget {
  const AuthHomeDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CenteredView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MyNavigationBar(),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AuthDetails(isCentered: false),
                  AuthForm()
              ]),
            )
          ]
          ),
      ),
    );
  }
}