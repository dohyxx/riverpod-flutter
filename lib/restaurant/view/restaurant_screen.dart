import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_project/common/component/pagination_list_view.dart';
import 'package:riverpod_project/restaurant/component/restaurant_card.dart';
import 'package:riverpod_project/restaurant/provider/restaurant_provider.dart';
import 'package:riverpod_project/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('현재 페이지: Restaurant 메인 홈');

    return PaginationListView(
        provider: restaurantProvider,
        itemBuilder: <RestaurantModel>(_, index, model) {
          return GestureDetector(
              onTap: () {
                //메뉴 상세 이동
                // context.go('/restaurant/${model.id}'); //restaurant/:rid
                context.goNamed(
                  RestaurantDetailScreen.routeName,
                  params: {
                    'rid': model.id,
                  },
                );
              },
              child: RestaurantCard.fromModel(model: model));
        });
  }
}
