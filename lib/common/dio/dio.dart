
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_project/common/const/data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_project/common/secure_storage/secure_storage.dart';
import 'package:riverpod_project/user/provider/auth_provider.dart';
import 'package:riverpod_project/user/provider/user_me_provider.dart';


final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomInterceptor(storage: storage, ref: ref),
  );

  return dio;
});


class CustomInterceptor extends Interceptor{
  final FlutterSecureStorage storage;
  final Ref ref;

  CustomInterceptor({
    required this.storage,
    required this.ref,
});


  /// 1) 요청 보낼 때 (매번 토큰을 Header에 직접 넣을 수 없기 때문에 사용)
  // 요청이 보내질 때마다
  // 만약에 요청의 Header에 accessToken이 true 라면, 실제 토큰(storage 저장한 토큰)을 가져와서 헤더를 변경한다.
  //실제 요청을 보내기 전에 실행된다.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print('[CustomInterceptor: REQUEST] [${options.method}] ${options.uri}');

    if(options.headers['accessToken'] == 'true'){
      //헤더 삭제
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      //실제 토큰으로 대체
      options.headers.addAll({
        'authorization' : 'Bearer $token',
      });
    }

    if(options.headers['refreshToken'] == 'true'){
      //헤더 삭제
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      //실제 토큰으로 대체
      options.headers.addAll({
        'authorization' : 'Bearer $token',
      });
    }

    return super.onRequest(options, handler);
  }

  /// 2) 응답을 받았을 때
  // 정상적인 응답을 받았을 경우에만 실행된다.
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('[CustomInterceptor: RESPONSE] [${response.requestOptions.method}] ${response.requestOptions.uri}');



    return super.onResponse(response, handler);
  }



  /// 3) 에러가 났을 때
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // 401 에러가 났을 때(status code)
    // 토큰을 재발급 받는 시도를 하고 재발급 되면 다시 새로운 토큰으로 요청을 한다.
    print('[CustomInterceptor: ERROR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key:REFRESH_TOKEN_KEY);

    // refreshToken이 아예 없으면 에러를 던진다.
    if (refreshToken == null) {
      // dio에서는 handler.reject(err) 사용해서 에러를 던진다.
      return handler.reject(err);
    }

    //에러가 난 코드가 401인지? == 토큰이 잘못됨
    final isStatus401 = err.response?.statusCode == 401;

    //토큰을 새로 발급 받으려고 하다가 난 오류인지?
    final isPathRefresh = err.requestOptions.path == '/auth/token';


    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );

        final accessToken = resp.data['accessToken'];
        final options = err.requestOptions;

        //토큰 변경하기
        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        //요청 재전송
        final response = await dio.fetch(options);

        //실제로는 에러가 발생한 것이지만, 에러를 handling해서 정상적인 response로 보낸다.
        //외부에서는 에러가 보이지 않고, 첫 요청에서 제대로 응답을 받은 것처럼 보여진다.
        return handler.resolve(response);

      } on DioError catch (e) {

        // CircularDependencyError 발생
        // A, B
        // A -> B의 친구
        // B -> A의 친구 A -> B -> A -> B 무한 반복..
        /// 상위에 객체를 하나 만들어서 해결한다.
        ref.read(authProvider.notifier).logout();

        return handler.reject(e);
      }
    }

    return handler.reject(err);
  }
}