import 'package:flutter_riverpod/restaurant/model/restaurant_model.dart';
import 'package:flutter_riverpod/common/const/data.dart';


class RestaurantDetailModel extends RestaurantModel {
  final String detail;
  final List<RestaurantProductModel> products;

  RestaurantDetailModel({
    required super.id,
    required super.name,
    required super.thumbUrl,
    required super.priceRange,
    required super.tags,
    required super.ratings,
    required super.ratingsCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required this.detail,
    required this.products,
  });

  factory RestaurantDetailModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return RestaurantDetailModel(
      id: json['id'],
      name: json['name'],
      thumbUrl: 'http://$ip${json['thumbUrl']}',
      priceRange: RestaurantPriceRange.values.firstWhere(
              (element) => element.name == json['priceRange']),
      tags: List<String>.from(json['tags']),
      ratings: json['ratings'],
      ratingsCount: json['ratingsCount'],
      deliveryTime: json['deliveryTime'],
      deliveryFee: json['deliveryFee'],
      detail: json['detail'],
      products: json['products'].map<RestaurantProductModel>(
            (x) =>
            RestaurantProductModel.fromJson(json: x),
      ).toList(),
    );
  }

}


class RestaurantProductModel {
  final String id;
  final String name;
  final String imgUrl;
  final String detail;
  final int price;

  RestaurantProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });

  factory RestaurantProductModel.fromJson({
    required Map<String, dynamic> json,
  }){
    return RestaurantProductModel(
        id: json['id'],
        name: json['name'],
        imgUrl: 'http://$ip${json['imgUrl']}',
        detail: json['detail'],
        price: json['price'],
    );
  }
}

// "products": [
// {
// "id": "1952a209-7c26-4f50-bc65-086f6e64dbbd",
// "name": "마라맛 코팩 떡볶이",
// "imgUrl": "/img/img.png",
// "detail": "서울에서 두번째로 맛있는 떡볶이집! 리뷰 이벤트 진행중~",
// "price": 8000