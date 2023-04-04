import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_project/common/model/cursor_pagination_model.dart';
import 'package:riverpod_project/restaurant/component/restaurant_card.dart';
import 'package:riverpod_project/restaurant/model/restaurant_model.dart';
import 'package:riverpod_project/restaurant/repository/restaurant_repository.dart';
import 'package:riverpod_project/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({Key? key}) : super(key: key);


  // Future<List<RestaurantModel>> paginateRestaurant(WidgetRef ref) async {
  //   final dio = ref.watch(dioProvider);
  //
  //   //CursorPagination paginate 인스턴스를 받아온다. 즉, RestaurantModel 리턴.
  //   final resp = await RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant').paginate();
  //
  //   return resp.data;
  // }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FutureBuilder<CursorPagination<RestaurantModel>>(
              future: ref.watch(restaurantRepositoryProvider).paginate(),
              builder: (context, AsyncSnapshot<CursorPagination<RestaurantModel>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // 홈 ListView
                return ListView.separated(
                  itemCount: snapshot.data!.data.length,
                  itemBuilder: (_, index) {
                    final pItem = snapshot.data!.data[index];

                    return GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => RestaurantDetailScreen(
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
                );
              },
            )),
      ),
    );
  }
}
