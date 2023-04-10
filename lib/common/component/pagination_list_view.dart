import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_project/common/model/cursor_pagination_model.dart';
import 'package:riverpod_project/common/model/model_with_id.dart';
import 'package:riverpod_project/common/provider/pagination_provider.dart';
import 'package:riverpod_project/common/utils/pagination_utils.dart';

typedef PaginationWidgetBuilder<T extends IModelWithId> =
Widget Function(BuildContext context, int index, T model);

class PaginationListView<T extends IModelWithId> extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider, CursorPaginationBase> provider;
  final PaginationWidgetBuilder<T> itemBuilder;

  const PaginationListView({
    required this.provider,
    required this.itemBuilder,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<PaginationListView> createState() => _PaginationListViewState<T>();
}

class _PaginationListViewState<T extends IModelWithId> extends ConsumerState<PaginationListView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(listener);
  }

  // 현재 위치가 최대 길이보다 조금 덜 되는는 위치까지 왔다면,
  // 새로운 데이터를 추가 요청
  void listener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(widget.provider.notifier),
    );
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    //완전 처음 로딩일 때
    if (state is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    // 에러 상황일 때
    if (state is CursorPaginationError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16.0,
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(widget.provider.notifier).paginate(
                    forceRefetch: true,
                  );
            },
            child: Text(
              '다시 시도',
            ),
          ),
        ],
      );
    }

    final cp = state as CursorPagination<T>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: RefreshIndicator(
        onRefresh: () async {
          ref.read(widget.provider.notifier).paginate(
            forceRefetch: true, //강제로 처음부터 데이터를 가져옴
          );
        },
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: controller,
          itemCount: cp.data.length + 1,
          itemBuilder: (_, index) {
            if (index == cp.data.length) {
              return Center(
                child: cp is CursorPaginationfetchingMore
                    ? const CircularProgressIndicator()
                    : const Text('마지막 데이터입니다'),
              );
            }
            final pItem = cp.data[index];

           return widget.itemBuilder(
             context,
             index,
             pItem,
           );
          },
          separatorBuilder: (_, index) {
            return const SizedBox(height: 16.0);
          },
        ),
      ),
    );
  }
}
