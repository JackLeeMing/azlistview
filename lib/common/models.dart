import 'dart:convert';

import 'package:azlistview/azlistview/az_common.dart';
import 'package:flutter/material.dart';

import './github_language_colors.dart';

class CityModel extends ISuspensionBean {
  String name;
  String? tagIndex;
  String? namePinyin;

  CityModel({
    required this.name,
    this.tagIndex,
    this.namePinyin,
  });

  CityModel.fromJson(Map<String, dynamic> json) : name = json['name'];

  Map<String, dynamic> toJson() => {
        'name': name,
//        'tagIndex': tagIndex,
//        'namePinyin': namePinyin,
//        'isShowSuspension': isShowSuspension
      };

  @override
  String getSuspensionTag() => tagIndex!;

  @override
  String toString() => json.encode(this);
}

class ContactInfo extends ISuspensionBean {
  String name;
  String? tagIndex;
  String? namePinyin;

  Color? bgColor;
  IconData? iconData;

  String? img;
  String? id;
  String? firstletter;

  ContactInfo({
    required this.name,
    this.tagIndex,
    this.namePinyin,
    this.bgColor,
    this.iconData,
    this.img,
    this.id,
    this.firstletter,
  });

  ContactInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        img = json['img'],
        id = json['id']?.toString(),
        firstletter = json['firstletter'];

  Map<String, dynamic> toJson() => {
//        'id': id,
        'name': name,
        'img': img,
//        'firstletter': firstletter,
//        'tagIndex': tagIndex,
//        'namePinyin': namePinyin,
//        'isShowSuspension': isShowSuspension
      };

  @override
  String getSuspensionTag() => tagIndex!;

  @override
  String toString() => json.encode(this);
}

class Languages extends GithubLanguage implements ISuspensionBean {
  String? tagIndex;
  String? pinyin;
  String? shortPinyin;
  bool _isShowSuspension = false;

  @override
  bool get isShowSuspension => _isShowSuspension;

  @override
  set isShowSuspension(bool value) => _isShowSuspension = value;

  Languages.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = super.toJson();
    void addIfNonNull(String fieldName, dynamic value) {
      if (value != null) {
        map[fieldName] = value;
      }
    }

//    addIfNonNull('tagIndex', tagIndex);
    return map;
  }

  @override
  String getSuspensionTag() {
    return tagIndex!;
  }

  @override
  String toString() {
    return json.encode(this);
  }
}
