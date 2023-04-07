import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_project/common/component/pagination_list_view.dart';
import 'package:riverpod_project/product/component/product_card.dart';
import 'package:riverpod_project/product/model/product_model.dart';
import 'package:riverpod_project/product/provider/product_provider.dart';
import 'package:riverpod_project/restaurant/view/restaurant_detail_screen.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
        provider: productProvider,
        itemBuilder: <ProductModel>(_, index, model) {
          return GestureDetector(
              onTap: () {
                context.goNamed(
                    RestaurantDetailScreen.routeName,
                    params: {
                      'rid' : model.restaurant.id,
                });
              },
              child: ProductCard.fromProductModel(model: model));
        });
  }
}
