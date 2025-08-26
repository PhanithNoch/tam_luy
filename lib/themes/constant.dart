import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Colors
const kBackgroundColor = Color(0xFFE7EEFB);
const kSidebarBackgroundColor = Color(0xFFF1F4FB);
const kCardPopupBackgroundColor = Color(0xFFF5F8FF);
var kPrimaryLabelColor = const Color(0xFF242629);
var kPrimaryLabelColorLight = const Color(0xFFF1F4FB);
const kSecondaryLabelColor = Color(0xFF797F8A);
const kShadowColor = Color.fromRGBO(72, 76, 82, 0.16);
const kElementIconColor = Color(0xFF17294D);
const kElementTitleColor = Color(0xFF17294D);
const kBackgroundColorDark = Color(0xFF191919);
// Text Styles
var kLargeTitleStyle = TextStyle(
  fontSize: 28.0,
  fontWeight: FontWeight.bold,
  color: kPrimaryLabelColor,
  // fontFamily: Platform.isIOS ? 'SF Pro Text' : null,
  /// if locale is khmer then use font family Khmer OS else use SF Pro Text
  fontFamily: Get.locale?.languageCode == 'kh' ? 'Battambang' : 'SF Pro Text',
  decoration: TextDecoration.none,
);
var kTitle1StyleDark = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  // color: kPrimaryLabelColor,
  fontFamily: Platform.isIOS ? 'SF Pro Text' : null,
  // decoration: TextDecoration.none,
);
var kTitle1Style = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
  // color: kPrimaryLabelColor,
  // color: kPrimaryLabelColor,
  fontFamily: Platform.isIOS ? 'SF Pro Text' : null,
  // decoration: TextDecoration.none,
);

var kTitle1LightStyle = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
  color: kPrimaryLabelColorLight,
  // color: kPrimaryLabelColor,
  fontFamily: Platform.isIOS ? 'SF Pro Text' : null,
  // decoration: TextDecoration.none,
);
var kCardTitleStyle = TextStyle(
  fontFamily: 'SF Pro Text',
  fontWeight: FontWeight.bold,
  color: kPrimaryLabelColor,

  // color: Colors.white,
  fontSize: 22.0,
  decoration: TextDecoration.none,
);
var kTitle2Style = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  color: kPrimaryLabelColor,

  // color: kPrimaryLabelColor,
  fontFamily: 'SF Pro Text',
  decoration: TextDecoration.none,
);
const kHeadlineLabelStyle = TextStyle(
  fontSize: 17.0,
  fontWeight: FontWeight.w800,
  // color: kPrimaryLabelColor,
  fontFamily: 'SF Pro Text',
  decoration: TextDecoration.none,
);
const kSubtitleStyle = TextStyle(
  fontSize: 16.0,
  // color: kSecondaryLabelColor,
  fontFamily: 'SF Pro Text',
  decoration: TextDecoration.none,
);
const kBodyLabelStyle = TextStyle(
  fontSize: 16.0,
  // color: Colors.black,
  fontFamily: 'SF Pro Text',
  decoration: TextDecoration.none,
);
var kCalloutLabelStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.w800,
  color: kPrimaryLabelColor,
  fontFamily: 'SF Pro Text',
  decoration: TextDecoration.none,
);
const kSecondaryCalloutLabelStyle = TextStyle(
  fontSize: 16.0,
  color: kSecondaryLabelColor,
  fontFamily: 'SF Pro Text',
  decoration: TextDecoration.none,
);
const kSearchPlaceholderStyle = TextStyle(
  fontSize: 13.0,
  color: kSecondaryLabelColor,
  fontFamily: 'SF Pro Text',
  decoration: TextDecoration.none,
);
var kSearchTextStyle = TextStyle(
  fontSize: 13.0,
  color: kPrimaryLabelColor,
  fontFamily: 'SF Pro Text',
  decoration: TextDecoration.none,
);
const kCardSubtitleStyle = TextStyle(
  fontFamily: 'SF Pro Text',
  fontWeight: FontWeight.bold,
  color: Color(0xE6FFFFFF),
  fontSize: 13.0,
  decoration: TextDecoration.none,
);
const kCaptionLabelStyle = TextStyle(
  fontSize: 12.0,
  color: kSecondaryLabelColor,
  fontFamily: 'SF Pro Text',
  decoration: TextDecoration.none,
);

ThemeData getEnglishTheme() {
  return ThemeData(
    // Define your English theme settings
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontFamily: 'SF Pro Text'),
    ),
  );
}

ThemeData getKhmerTheme() {
  return ThemeData(
    // Define your French theme settings
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontFamily: 'Battambang'),
    ),
  );
}
