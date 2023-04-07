import 'package:flutter/cupertino.dart';
import 'package:riverpod_project/common/provider/pagination_provider.dart';

class PaginationUtils {
  static void paginate({
    required ScrollController controller,
    required PaginationProvider provider,
  }) {
    if (controller.offset > controller.position.maxScrollExtent - 250) {
      provider.paginate(
        fetchMore: true, //추가 데이터 요청
      );
    }
  }
}
