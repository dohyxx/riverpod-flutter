
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_project/common/const/data.dart';
import 'package:riverpod_project/common/secure_storage/secure_storage.dart';
import 'package:riverpod_project/user/model/user_model.dart';
import 'package:riverpod_project/user/repository/auth_repository.dart';
import 'package:riverpod_project/user/repository/user_me_repository.dart';

final userMeProvider = StateNotifierProvider<UserMeStateNotifier, UserModelBase?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userMeRepository = ref.watch(userMeRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);

  return UserMeStateNotifier(
      authRepository: authRepository,
      repository: userMeRepository,
      storage: storage);
});

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserMeRepository repository;
  final FlutterSecureStorage storage;

  UserMeStateNotifier({
    required this.authRepository,
    required this.repository,
    required this.storage,
  }) : super(UserModelLoading()) {
    //내 정보 가져오기
    getMe();
  }

  //현재 로그인한 사용자 정보 가져오기
  Future<void> getMe() async {
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if (accessToken == null || refreshToken == null) {
      state = null; //로그아웃 상태로 변경
      return;
    }

    try{
      final resp = await repository.getMe();

      state = resp; //현재 상태에 UserModel 저장
    }catch(e, stack){
      print(e);
      print(stack);
      state = null;
    }

  }


  // 유저 로그인
  Future<UserModelBase> login({
    required String username,
    required String password,
  }) async {
    try {
      state = UserModelLoading();

      final resp = await authRepository.login(
        username: username,
        password: password,
      );
      await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);

      //토큰 발급 및 저장 후 해당 사용자 정보 가져오기
      final userResp = await repository.getMe();
      state = userResp;
      print('userMeProvider login(): $state');

      return userResp;

    } catch (e) {
      state = UserModelError(message: '로그인에 실패했습니다.');
      return Future.value(state);
    }
  }

  // 로그아웃
  Future<void> logout() async {
    state = null;
    print('로그아웃: $state');


    // TIP>> 두 개를 동시에 실행하고, 두 개가 모두 끝날 때까지 await : 조금 더 빠름
    await Future.wait([
      storage.delete(key: REFRESH_TOKEN_KEY),
      storage.delete(key: ACCESS_TOKEN_KEY),
    ]);
  }
}
