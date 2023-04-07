import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_project/common/model/cursor_pagination_model.dart';
import 'package:riverpod_project/common/utils/pagination_utils.dart';
import 'package:riverpod_project/restaurant/component/restaurant_card.dart';
import 'package:riverpod_project/restaurant/provider/restaurant_provider.dart';
import 'package:riverpod_project/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(scrollListener);
  }

  // 현재 위치가 최대 길이보다 조금 덜 되는는 위치까지 왔다면,
  // 새로운 데이터를 추가 요청
  void scrollListener(){
    PaginationUtils.paginate(
        controller: scrollController,
        provider: ref.read(restaurantProvider.notifier)
    );
  }

  @override
  Widget build(BuildContext context) {
    print('현재 페이지: Restaurant 메인 홈');

    final data = ref.watch(restaurantProvider);

    //완전 처음 로딩일 때
    if (data is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 에러 상황일 때
    if(data is CursorPaginationError){
      return Center(
        child: Text(data.message),
      );
    }

    // CursorPagination
    // CursorPaginationFetchingMore
    // CursorPaginationRefetching
    final cp = data as CursorPagination;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: // 홈 ListView
          ListView.separated(
            controller: scrollController,
            itemCount: cp.data.length + 1,
            itemBuilder: (_, index) {
              if(index == cp.data.length){
                return Center(
                  child: data is CursorPaginationfetchingMore
                          ? const CircularProgressIndicator()
                          : const Text('마지막 데이터입니다'),
                );
              }
              final pItem = cp.data[index];

              return GestureDetector(
              onTap: () {
                //메뉴 상세 이동
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => RestaurantDetailScreen(
                      id: pItem.id,
                      name: pItem.name,
                    ),
                  ),
                );
              },
              child: RestaurantCard.fromModel(model: pItem));
        },
        separatorBuilder: (_, index) {
          return const SizedBox(height: 16.0);
        },
      ),
    );
  }
}
