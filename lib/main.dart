import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_project/common/view/splash_screen.dart';

void main() {
  runApp(
    const ProviderScope(
        child: _App()),
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