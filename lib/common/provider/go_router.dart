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
    refreshListenable: provider,
    redirect: provider.redirectLogic,
  );
});