import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_project/common/const/data.dart';
import 'package:riverpod_project/common/dio/dio.dart';
import 'package:riverpod_project/common/layout/default_layout.dart';
import 'package:riverpod_project/product/component/product_card.dart';
import 'package:riverpod_project/restaurant/component/restaurant_card.dart';
import 'package:riverpod_project/restaurant/model/restaurant_detail_model.dart';
import 'package:riverpod_project/restaurant/repository/restaurant_repository.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;
  final String name;

  const RestaurantDetailScreen({
    required this.id,
    required this.name,
    Key? key,
  }) : super(key: key);


  // 레스토랑 상세 API
  Future<RestaurantDetailModel> getRestaurantDetail() async {
    final dio = Dio();
    final repository = RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');

    dio.interceptors.add(
      CustomInterceptor(
        storage: storage,
      ),
    );

    return repository.getRestaurantDetail(id: id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: name,
        child: FutureBuilder<RestaurantDetailModel>(
          future: getRestaurantDetail(),
          builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot){
          if(snapshot.hasError){
            return Center(
                child: Text(snapshot.error.toString()),
            );
          }

            if(!snapshot.hasData){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return CustomScrollView(
              slivers: [
                //선택한 레스토랑 메뉴 상세
                renderTop(model: snapshot.data!),

                renderLabel(),

                //하단 메뉴 아이템 리스트
                renderProducts(products: snapshot.data!.products),
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

