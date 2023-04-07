import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_project/common/model/cursor_pagination_model.dart';
import 'package:riverpod_project/common/model/model_with_id.dart';
import 'package:riverpod_project/common/model/pagination_params.dart';
import 'package:riverpod_project/common/repository/base_pagination_repository.dart';

class PaginationProvider<T extends IModelWithId, U extends IBasePaginationRepository<T>> extends StateNotifier<CursorPaginationBase> {
  final U repository;

  PaginationProvider({
    required this.repository,
  }) :super(CursorPaginationLoading()) {
    paginate(); //RestaurantStateNotifier가 생성되는 순간에 paginate 호출
  }



Future<void> paginate({
  int fetchCount = 20,
  //true = 추가로 데이터 더 가져옴, false = 새로고침
  bool fetchMore = false,
  //강제로 다시 로딩하기, true = CursorPaginationLoading()
  bool forceRefetch = false,
}) async {
  try {
    //State 상태의 5가지 가능성

    //  1) CursorPagination - 정상적으로 데이터가 있는 상태
    //  2) CursorPaginationLoading - 데이터가 로딩 중인 상태(현재 캐시 없음)
    //  3) CursorPaginationError - 에러가 있는 상태
    //  4) CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터를 가져올 때
    //  5) CursorPaginationFetchMore - 추가 데이터를 paginate 해오라는 요청을 받았을 때

    /// 바로 반환하는 상황 1
    // 1) hasMore = false (기존 상태에서 이미 다음 데이터가 없다는 값을 들고 있다면)
    if (state is CursorPagination && !forceRefetch) {
      final pState = state as CursorPagination;

      //다음 데이터가 없음
      if (!pState.meta.hasMore) {
        return;
      }
    }

    /// 바로 반환하는 상황 2
    // 2) fetchMore = true (로딩 중일 때) , fetchMore가 아닐 때 = 새로고침 하려는 의도가 있을 수 있다.
    final isLoading = state is CursorPaginationLoading;
    final isRefetching = state is CursorPaginationRefetching;
    final isFetchingMore = state is CursorPaginationfetchingMore;

    if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
      return;
    }

    // PaginationParams 생성
    PaginationParams paginationParams = PaginationParams(
      count: fetchCount,
    );

    // fetchingMore 상황
    // 데이터를 추가로 더 가져오는 상황
    if (fetchMore) {
      final pState = state as CursorPagination<T>;

      state = CursorPaginationfetchingMore(
        meta: pState.meta,
        data: pState.data,
      );

      //마지막 리스트의 id 값만 전달
      paginationParams = paginationParams.copyWith(
        after: pState.data.last.id,
      );
    }
    // 데이터를 처음부터 가져오는 상황
    else {
      //만약 데이터가 있는 상황이라면
      //기존 데이터를 보존한채로 Fetch (API요청) 를 진행
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination<T>;

        state = CursorPaginationRefetching<T>(
          meta: pState.meta,
          data: pState.data,
        );
      }
      // 나머지 상황
      else {
        state = CursorPaginationLoading();
      }
    }

    final resp = await repository.paginate(
      paginationParams: paginationParams,
    );

    print('resp!!!: $resp');

    if (state is CursorPaginationfetchingMore) {
      final pState = state as CursorPaginationfetchingMore<T>;

      //기존 데이터에 새로운 데이터 추가
      state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ]
      );
    } else {
      state = resp;
    }
  } catch (e, stack) {
    print(e);
    print(stack);
    print('페이지네이션 에러');
    state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
  }
}}
