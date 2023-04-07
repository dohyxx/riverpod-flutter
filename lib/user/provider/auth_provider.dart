import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_project/common/view/root_tab.dart';
import 'package:riverpod_project/common/view/splash_screen.dart';
import 'package:riverpod_project/restaurant/view/restaurant_detail_screen.dart';
import 'package:riverpod_project/user/model/user_model.dart';
import 'package:riverpod_project/user/provider/user_me_provider.dart';
import 'package:riverpod_project/user/view/login_screen.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
        GoRoute(
            path: '/',
            name: RootTab.routeName,
            builder: (_, __) => RootTab(),
            routes: [
              // 메뉴 상세 페이지
              GoRoute(
                path: 'restaurant/:rid', //route 사용 시 id값을 입력 받음
                name: RestaurantDetailScreen.routeName,
                builder: (_, state) => RestaurantDetailScreen(
                  id: state.params['rid']!, //! = 무조건 존재한다는 의미
                ),
              ),
            ]),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (_, __) => SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (_, __) => LoginScreen(),
        ),
      ];

  // dio.dart에서 userMeProvier를 가져와서 logout을 하게 되면
  // CircularDependencyError 에러 발생.
  // 이유: authProvider <-> userMeProvier를 서로 참조하고 있기 때문.
  // 해결방법: 가장 상위 객체에서 logout 함수를 만들어서 호출하는 방법으로 해결
  void logout(){
    ref.read(userMeProvider.notifier).logout();
  }

  //SplashScreen
  //앱을 처음 시작했을 때, 토큰이 존재하는지 확인하고 로그인 혹은 홈으로 보내줄지 확인하는 과정 필요
  String? redirectLogic(GoRouterState state) {

    final UserModelBase? user = ref.watch(userMeProvider);
    final logginIn = state.location == '/login';
    print('redirectLogic user : $user');


    //유저 정보가 없으면 로그인 중이라면 로그인 페이지에 그대로 두고
    // 로그인 중이 아니면 로그인 페이지로 이동
    if (user == null) {
      print('user is null');

      return logginIn ? null : '/login';
    }

    //userModel
    //사용자 정보가 있는 상태라면 로그인 중이거나 SplashScreen이면 홈으로 이동
    if (user is UserModel) {
      print('user is UserModel: ${user is UserModel}');
      return logginIn || state.location == '/splash' ? '/' : null;
    }


    //UserModelError
    if (user is UserModelError) {
      return !logginIn ? '/login' : null;
    }

    return null;
  }
}
