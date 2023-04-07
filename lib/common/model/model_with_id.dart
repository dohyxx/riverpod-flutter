abstract class IModelWithId {
  //IModelWithId을 implement한 클래스는 id를 갖고 있게끔 강제
  final String id;

  IModelWithId({
    required this.id,
  });
}
