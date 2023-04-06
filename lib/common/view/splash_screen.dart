import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_project/common/const/colors.dart';
import 'package:riverpod_project/common/const/data.dart';
import 'package:riverpod_project/common/dio/dio.dart';
import 'package:riverpod_project/common/layout/default_layout.dart';
import 'package:riverpod_project/common/secure_storage/secure_storage.dart';
import 'package:riverpod_project/common/view/root_tab.dart';
import 'package:riverpod_project/user/view/login_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {

  @override
  void initState() {
    super.initState();

    // deleteToken();
    checkToken();
  }

  void deleteToken() async {
    final storage = ref.read(secureStorageProvider);

    await storage.deleteAll();
  }


  //토근이 있는지, 유효한지 체크
  void checkToken() async {
    final storage = ref.read(secureStorageProvider);
    final dio = ref.read(dioProvider);

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    try{
      // final resp = await dio.post('http://$ip/auth/token',
      //   options: Options(
      //     headers: {
      //       'authorization' : 'Bearer $refreshToken',
      //     },
      //   ),
      // );
      //
      // await storage.write(key: ACCESS_TOKEN_KEY, value: resp.data['accessToken']);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (_) => const RootTab(),
          ), (route) => false
      );

    }catch(e){
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (_) => const LoginScreen(),
          ), (route) => false
      );

    }
  }


  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        backgroundColor: PRIMARY_COLOR,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'asset/img/logo/logo.png',
                width: MediaQuery.of(context).size.width / 2,
              ),
              const SizedBox(
                height: 16.0,
              ),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ));
  }
}
