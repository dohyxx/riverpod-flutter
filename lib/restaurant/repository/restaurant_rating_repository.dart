import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';
import 'package:riverpod_project/common/const/data.dart';
import 'package:riverpod_project/common/dio/dio.dart';
import 'package:riverpod_project/common/model/cursor_pagination_model.dart';
import 'package:riverpod_project/common/model/pagination_params.dart';
import 'package:riverpod_project/common/repository/base_pagination_repository.dart';
import 'package:riverpod_project/rating/model/rating_model.dart';

part 'restaurant_rating_repository.g.dart';


final restaurantRatingRepositoryProvider = Provider.family<RestaurantRatingRepository, String>((ref, id){
  final dio = ref.watch(dioProvider);

  print('<==== restaurantRatingRepositoryProvider: $id');
  return RestaurantRatingRepository(dio, baseUrl: 'http://$ip/restaurant/$id/rating');
});

// http://ip/restaurant/:rid/rating
@RestApi()
abstract class RestaurantRatingRepository implements IBasePaginationRepository<RatingModel> {

  factory RestaurantRatingRepository(Dio dio, {String baseUrl}) = _RestaurantRatingRepository;

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<CursorPagination<RatingModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}
