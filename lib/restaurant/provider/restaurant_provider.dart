import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_project/common/model/cursor_pagination_model.dart';
import 'package:riverpod_project/common/provider/pagination_provider.dart';
import 'package:riverpod_project/restaurant/model/restaurant_model.dart';
import 'package:riverpod_project/restaurant/repository/restaurant_repository.dart';


// restaurant 상세 메뉴에 대한 정보를 찾기 위한 Provider
final restaurantDetailProvider = Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if(state is! CursorPagination){
    return null;
  }

  print('<======= restaurant Provider!!: $id ');
  return state.data.firstWhere((element) => element.id == id);
});


//메인 restaurant 전체 리스트를 가지고 있는 Provider
final restaurantProvider = StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);

  final notifier = RestaurantStateNotifier(repository: repository);

  return notifier;
},
);


class RestaurantStateNotifier extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  RestaurantStateNotifier({
    required super.repository,
  });


  /// RestaurantDetail 캐시 관리
  void getDetail({
    required String id,
}) async {
    //만약에 아직 데이터가 하나도 없는 상태라면 (CursorPagiantion이 아니라면)
    //데이터를 가져오는 시도를 한다.
    if(state is! CursorPagination){
      await paginate();
    }

    //state가 CursorPagination이 아닐 때는 그냥 return
    if(state is! CursorPagination){
      return;
    }

    //원래 기존에 있던 데이터
    final pState = state as CursorPagination;

    //새로 데이터 요청
    final resp = await repository.getRestaurantDetail(id: id);

    state =  pState.copyWith(
      data: pState.data.map<RestaurantModel>((e) => e.id == id ? resp : e).toList(),
    );
  }
}