import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_project/common/layout/default_layout.dart';
import 'package:riverpod_project/common/model/cursor_pagination_model.dart';
import 'package:riverpod_project/common/utils/pagination_utils.dart';
import 'package:riverpod_project/product/component/product_card.dart';
import 'package:riverpod_project/rating/component/rating_card.dart';
import 'package:riverpod_project/rating/model/rating_model.dart';
import 'package:riverpod_project/restaurant/component/restaurant_card.dart';
import 'package:riverpod_project/restaurant/model/restaurant_detail_model.dart';
import 'package:riverpod_project/restaurant/model/restaurant_model.dart';
import 'package:riverpod_project/restaurant/provider/restaurant_provider.dart';
import 'package:riverpod_project/restaurant/provider/restaurant_rating_provider.dart';
import 'package:skeletons/skeletons.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String id;
  final String name;

  const RestaurantDetailScreen({
    required this.id,
    required this.name,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
    
    controller.addListener(listener);
  }

  void listener(){
    PaginationUtils.paginate(
        controller: controller,
        provider: ref.read(restaurantRatingProvider(widget.id).notifier
        ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingState = ref.watch(restaurantRatingProvider(widget.id));
    print('ratingState: ${ratingState.toString()}');
    print('ratingState: ${widget.id.toString()}');


    if (state == null) {
      return const DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultLayout(
      title: widget.name,
      child: CustomScrollView(
        controller: controller,
        slivers: [
          //선택한 레스토랑 메뉴 상세
          renderTop(model: state),

          if (state is! RestaurantDetailModel) renderLoading(),
          if (state is RestaurantDetailModel) renderLabel(),
          //하단 메뉴 아이템 리스트
          if (state is RestaurantDetailModel)
            renderProducts(
              products: state.products,
            ),

          // 리뷰 상세
          if (ratingState is CursorPagination<RatingModel>)
            renderRatings(models: ratingState.data),


        ],
      ),
    );
  }
}

//메뉴 상세 리뷰 내용
SliverPadding renderRatings({
  required List<RatingModel> models,
}) {
  return SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    sliver: SliverList(
      delegate: SliverChildBuilderDelegate(
            (_, index) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: RatingCard.fromModel(model: models[index]),
        ),
        childCount: models.length,
      ),
    ),
  );
}

SliverPadding renderLoading() {
  return SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
    sliver: SliverList(
      delegate: SliverChildListDelegate(
        List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: SkeletonParagraph(
              style: const SkeletonParagraphStyle(
                lines: 5,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}


SliverToBoxAdapter renderTop({
  required RestaurantModel model,
}) {
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
            child: ProductCard.fromModel(model: model),
          );
        },
        childCount: products.length,
      ),
    ),
  );
}
