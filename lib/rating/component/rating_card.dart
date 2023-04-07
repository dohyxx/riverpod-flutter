import 'package:flutter/material.dart';
import 'package:riverpod_project/common/const/colors.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_project/rating/model/rating_model.dart';

class RatingCard extends StatelessWidget {
  //NetworkImage
  //AssetImage

  // CircleAvatar
  final ImageProvider avatarimage;

  // 리스트로 위젯 이미지를 보여줄 때
  final List<Image> images;

  // 별점
  final int rating;

  // 이메일
  final String email;

  // 리뷰 내용
  final String content;

  const RatingCard({
    Key? key,
    required this.avatarimage,
    // 리스트로 위젯 이미지를 보여줄 때
    required this.images,
    // 별점
    required this.rating,
    // 이메일
    required this.email,
    // 리뷰 내용
    required this.content,
  }) : super(key: key);

  factory RatingCard.fromModel({
    required RatingModel model,
  }){
    return RatingCard(
      avatarimage: NetworkImage(
        model.user.imageUrl,
      ),
      images: model.imgUrls.map((e) => Image.network(e)).toList(),
      rating: model.rating,
      email: model.user.username,
      content: model.content,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          avatarimage: avatarimage,
          email: email,
          rating: rating,
        ),

        const SizedBox(height: 8.0,),

        _Body(
          content: content,
        ),

        if(images.length > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SizedBox(
              height: 100,
              child: _Images(
                images: images,
              ),
            ),
          ),
      ],
    );
  }
}


class _Header extends StatelessWidget {
  final ImageProvider avatarimage;
  final String email;
  final int rating;

  const _Header({
    Key? key,
    required this.avatarimage,
    required this.email,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12.0,
          backgroundImage: avatarimage,
        ),

        const SizedBox(width: 8.0,),

        Expanded(
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...List.generate(5, (index) =>
            Icon(
              index < rating ? Icons.star : Icons.star_border_outlined,
              color: PRIMARY_COLOR,
            ),),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;

  const _Body({
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            content,
            style: const TextStyle(
              color: BODY_TEXT_COLOR,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}

class _Images extends StatelessWidget {
  final List<Image> images;

  const _Images({
    required this.images,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children:
      images.mapIndexed((index, e) =>
          Padding(
            padding: EdgeInsets.only(
                right: index == images.length - 1 ? 0 : 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: e,
            ),
          ),
      ).toList(),
    );
  }
}



