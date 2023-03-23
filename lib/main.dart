import 'package:flutter/material.dart';
import 'package:flutter_riverpod/common/component/custom_text_form_field.dart';
import 'package:flutter_riverpod/common/view/splash_screen.dart';
import 'package:flutter_riverpod/user/view/LoginScreen.dart';

void main() {
  runApp(
    _App(),
  );
}


class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
    );
  }


}