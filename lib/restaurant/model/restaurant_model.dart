
import 'package:flutter_riverpod/common/const/data.dart';
import 'package:flutter_riverpod/common/enum/enum.dart';


// 홈 화면 메뉴 리스트 모델
class RestaurantModel {
  final String id;
  final String name;
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.priceRange,
    required this.tags,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  // factory method
  factory RestaurantModel.fromJson({
    required Map<String, dynamic> json,

  }) {
    print('RestaurantModel Data Parsing!!');

    return RestaurantModel(
        id: json['id'],
        name: json['name'],
        thumbUrl: 'http://$ip${json['thumbUrl']}',
        priceRange: RestaurantPriceRange.values.firstWhere((element) => element.name == json['priceRange']),
        tags: List<String>.from(json['tags']),
        ratings: json['ratings'],
        ratingsCount: json['ratingsCount'],
        deliveryTime: json['deliveryTime'],
        deliveryFee: json['deliveryFee']
    );
  }


}