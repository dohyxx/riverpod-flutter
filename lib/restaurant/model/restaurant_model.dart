
import 'package:riverpod_project/common/enum/enum.dart';
import 'package:riverpod_project/common/model/model_with_id.dart';
import 'package:riverpod_project/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';
part 'restaurant_model.g.dart';

// 홈 화면 메뉴 리스트 모델
@JsonSerializable()
class RestaurantModel implements IModelWithId{
  final String id;
  final String name;
  @JsonKey(
      fromJson: DataUtils.pathToUrl
  )
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


 factory RestaurantModel.fromJson(Map<String, dynamic> json)
 => _$RestaurantModelFromJson(json);


 Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);
}