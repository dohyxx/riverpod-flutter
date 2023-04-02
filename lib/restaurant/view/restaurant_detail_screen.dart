import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/common/const/data.dart';
import 'package:flutter_riverpod/common/layout/default_layout.dart';
import 'package:flutter_riverpod/product/component/product_card.dart';
import 'package:flutter_riverpod/restaurant/component/restaurant_card.dart';
import 'package:flutter_riverpod/restaurant/model/restaurant_detail_model.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;
  final String name;

  const RestaurantDetailScreen({
    required this.id,
    required this.name,
    Key? key,
  }) : super(key: key);


  // 레스토랑 상세 API
  Future<Map<String, dynamic>> getRestaurantDetail() async {
    final dio = Dio();
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get(
      'http://$ip/restaurant/$id',
      options: Options(headers: {
        'authorization': 'Bearer $accessToken',
      }),
    );
    return resp.data;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: name,
        child: FutureBuilder<Map<String, dynamic>>(
          future: getRestaurantDetail(),
          builder: (_, AsyncSnapshot<Map<String, dynamic>> snapshot){
            if(!snapshot.hasData){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final item = RestaurantDetailModel.fromJson(snapshot.data!,);

            return CustomScrollView(
              slivers: [
                //선택한 레스토랑 메뉴 상세
                renderTop(model: item),

                renderLabel(),

                //하단 메뉴 아이템 리스트
                renderProducts(products: item.products),
              ],
            );
          },
        ));
  }
}


SliverToBoxAdapter renderTop({required RestaurantDetailModel model}) {
  return SliverToBoxAdapter(
    child: RestaurantCard.fromModel(
      model: model,
      isDetail: true,
    ),
  );
}


SliverPadding renderLabel() {
  return const SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    sliver: SliverToBoxAdapter(
      child: Text(
        '메뉴',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

SliverPadding renderProducts({required List<RestaurantProductModel> products}) {
  return SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    sliver: SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final model = products[index];
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ProductCard.fromModel(
                model: model),
          );
        },
        childCount: products.length,
      ),
    ),
  );
}

