
import 'dart:convert';

import 'package:riverpod_project/common/const/data.dart';

class DataUtils{
  static DateTime stringToDateTime(String value){
    return DateTime.parse(value);
  }


  static String pathToUrl(String value) {
    return 'http://$ip$value';
  }


  static List<String> listPathToUrls(List paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }



  static String plainToBase64(String plain){
    //base 64 encoding
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(plain);

    return encoded;
  }

}