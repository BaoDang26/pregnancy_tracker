import 'package:flutter/material.dart';

import '../util/app_export.dart';

class CustomTextStyles {
  static get titleMediumBlack => theme.textTheme.titleMedium!.copyWith(
        color: Colors.black,
        fontSize: 18.fSize,
        fontWeight: FontWeight.bold,
      );

  static get titleMedium16Black => theme.textTheme.titleMedium!.copyWith(
        color: Colors.black,
        fontSize: 16.fSize,
        fontWeight: FontWeight.bold,
      );

  static get titleMediumWhite => theme.textTheme.titleMedium!.copyWith(
        color: Colors.white,
        fontSize: 18.fSize,
        fontWeight: FontWeight.bold,
      );

  static get bodyMediumGreen500 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.green500,
        // fontWeight: FontWeight.bold,
      );

  static get bodyMedium11Red700 => theme.textTheme.bodyMedium!
      .copyWith(color: appTheme.red700, fontSize: 11.fSize);

  static get bodyMedium14Red => theme.textTheme.bodyMedium!
      .copyWith(color: Colors.red, fontSize: 14.fSize);

  static get bodyMedium14Green => theme.textTheme.bodyMedium!
      .copyWith(color: Colors.green, fontSize: 14.fSize);

  static get bodyMedium16Red => theme.textTheme.bodyMedium!
      .copyWith(color: Colors.red, fontSize: 16.fSize);

  static get bodyMedium16Green => theme.textTheme.bodyMedium!
      .copyWith(color: Colors.green, fontSize: 16.fSize);

  static get bodyMedium14 => theme.textTheme.bodyMedium!
      .copyWith(color: Colors.black, fontSize: 14.fSize);

  static get bodyMedium14White => theme.textTheme.bodyMedium!
      .copyWith(color: Colors.white, fontSize: 14.fSize);

  static get bodyMedium16 => theme.textTheme.bodyMedium!
      .copyWith(color: Colors.black, fontSize: 16.fSize);

  static get bodyMedium16Green500 => theme.textTheme.bodyMedium!
      .copyWith(color: appTheme.green500, fontSize: 16.fSize);

  static get bodyMedium16Grey300 => theme.textTheme.bodyMedium!
      .copyWith(color: appTheme.grey300, fontSize: 16.fSize);

  static get bodyMedium16Grey500 => theme.textTheme.bodyMedium!
      .copyWith(color: appTheme.grey500, fontSize: 16.fSize);

  static get bodyMedium16BlueA700 => theme.textTheme.bodyMedium!
      .copyWith(color: appTheme.blueA700, fontSize: 16.fSize);

  static get bodyMedium16Orange500 => theme.textTheme.bodyMedium!
      .copyWith(color: appTheme.orange500, fontSize: 16.fSize);

  static get linkTextStyle14 => theme.textTheme.bodyMedium!
      .copyWith(color: Colors.blue, fontSize: 14.fSize);
}
