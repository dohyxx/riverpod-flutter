import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_project/user/provider/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // watch - 값이 변경될 때마다 다시 빌드
  // read - 한 번만 일고 값이 변경되도 다시 빌드하지 않음
  final provider = ref.read(authProvider);

  print('GoRouter!!!!');

  return GoRouter(
    routes: provider.routes,
    initialLocation: '/splash',
    redirect: provider.redirectLogic, //페이지 이동할 때만 호출
    refreshListenable: provider,      // authProvider의 notifyListeners가 호출될 때마다 자동으로 redirect 함수(redirectLogic)를 실행한다.
  );
});