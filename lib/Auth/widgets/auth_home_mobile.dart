import 'package:aiso/Auth/widgets/auth_details.dart';
import 'package:aiso/Auth/widgets/auth_form.dart';
import 'package:aiso/Home/widgets/centered_view.dart';
import 'package:aiso/NavBar/views/navgation_bar.dart';
import 'package:flutter/material.dart';

class AuthHomeMobile extends StatelessWidget {

  const AuthHomeMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CenteredView(
        child: Column(
          children: <Widget>[
            MyNavigationBar(),
            Expanded(
              child: Column(
                children: [
                  AuthDetails(isCentered: true),
                  Expanded(
                    child: Center(
                      child: AuthForm(),
                    ),
                  )
                ]
              ),
            )
          ]
        ),
      ),
    );
  }
}