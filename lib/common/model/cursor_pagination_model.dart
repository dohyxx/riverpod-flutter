
import 'package:json_annotation/json_annotation.dart';
part 'cursor_pagination_model.g.dart';

abstract class CursorPaginationBase {}


// CursorPaginationError
//응답받은 json을 기반으로 인스턴스를 만들지 않을 것이기 때문에 JsonSerializable 사용 X
class CursorPaginationError extends CursorPaginationBase {
  final String message;

  CursorPaginationError({
    required this.message,
  });
}

// CursorPaginationLoading
class CursorPaginationLoading extends CursorPaginationBase {}



@JsonSerializable(
  genericArgumentFactories: true, //generic 설정 필요
)
class CursorPagination<T> extends CursorPaginationBase { //generic 사용
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({
    required this.meta,
    required this.data,
  });

  CursorPagination copyWith({
    CursorPaginationMeta? meta,
    List<T>? data,
  }) {
    return CursorPagination(
        meta: meta ?? this.meta,
        data: data ?? this.data,
    );
  }

  factory CursorPagination.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT)
  => _$CursorPaginationFromJson(json, fromJsonT);
}


@JsonSerializable()
class CursorPaginationMeta{
  final int count;
  final bool hasMore;

  CursorPaginationMeta({
    required this.count,
    required this.hasMore,
  });

  CursorPaginationMeta copyWith({
    int? count,
    bool? hasMore,
  }) {
    return CursorPaginationMeta(
      count: count ?? this.count,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json)
  => _$CursorPaginationMetaFromJson(json);
}


//새로고침 할 때
class CursorPaginationRefetching<T> extends CursorPagination<T> {
  CursorPaginationRefetching({
    required super.meta,
    required super.data,
  });
}


//리스트의 맨 아래로 내려서
//추가 데이터를 요청하는 중
class CursorPaginationfetchingMore<T> extends CursorPagination<T> {
  CursorPaginationfetchingMore({
    required super.meta,
    required super.data,
  });
}
