import 'package:flutter/cupertino.dart';
import 'package:cabwire/core/utility/logger_utility.dart';
import 'package:cabwire/presentation/initial_app.dart';

/// Utility class for retrieving the screen dimensions of the device.
///
/// The `AppScreen` class provides static methods and properties to access
/// the width and height of the device's screen. It relies on the `Get` package
/// to obtain the screen dimensions.
///
///
/// Example usage:
///
/// ```dart
/// AppScreen.setUp();
/// double screenWidth = AppScreen.width;
/// double screenHeight = AppScreen.height;
/// ```
///
/// Rationale:
///
/// - The `AppScreen` class provides a convenient way to access the screen dimensions
/// of the device. By centralizing the screen dimension retrieval logic within a class,
/// it promotes code re-usability and improves code readability.
///
/// - The class utilizes the `Get` package, which is a popular package for state management
/// and navigation in Flutter applications. By relying on a well-established package,
/// the `AppScreen` class benefits from its reliability and compatibility with different
/// screen sizes and orientations.
///
/// - The `setUp` method allows for explicit initialization of the screen dimensions. This
/// ensures that the dimensions are retrieved only when needed and avoids unnecessary
/// calculations or potential errors caused by accessing uninitialized values.
///
/// - The `_resetIfInvalid` method checks if the screen dimensions are valid. If the dimensions
/// are less than 10 pixels in either width or height, an error is logged, and the dimensions
/// are set to `null`. This prevents the usage of invalid or unreliable screen dimensions
/// throughout the application.
///
///

class AppScreen {
  AppScreen._();

  static void setUp(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    _height = size.height;
    _width = size.width;
    _resetIfInvalid();
  }

  static double? _width;
  static double? _height;

  static Size get _size => MediaQuery.sizeOf(InitialApp.globalContext);

  static double get width {
    _width ??= _size.width;
    return _width!;
  }

  static double get height {
    _height ??= _size.height;
    return _height!;
  }

  static void _resetIfInvalid() {
    if (_width! < 10 || _height! < 10) {
      logErrorStatic(
        'AppScreen size not initialized. Please initialize AppScreen and try again.',
        "InitialApp",
      );
      _width = null;
      _height = null;
    }
  }
}

extension AppScreenWidth on Widget {
  static double? _onePercentWidth;

  double get onePercentWidth {
    const double onePercent = 0.01;
    _onePercentWidth ??= AppScreen.width * onePercent;
    return _onePercentWidth!;
  }

  static double? _twoPercentWidth;

  double get twoPercentWidth {
    const double twoPercent = 0.02;
    _twoPercentWidth ??= AppScreen.width * twoPercent;
    return _twoPercentWidth!;
  }

  static double? _fiftyPercentHeight;

  double get fiftyPercentHeight {
    const double fiftyPercent = 0.50;
    _fiftyPercentHeight ??= AppScreen.height * fiftyPercent;
    return _fiftyPercentHeight!;
  }

  static double? _threePercentWidth;

  double get threePercentWidth {
    const double threePercent = 0.03;
    _threePercentWidth ??= AppScreen.width * threePercent;
    return _threePercentWidth!;
  }

  static double? _fourPercentWidth;

  double get fourPercentWidth {
    _fourPercentWidth ??= 4.percentWidth;
    return _fourPercentWidth!;
  }

  static double? _fivePercentWidth;

  double get fivePercentWidth {
    _fivePercentWidth ??= 5.percentWidth;
    return _fivePercentWidth!;
  }

  static double? _sixPercentWidth;

  double get sixPercentWidth {
    const double sixPercent = 0.06;
    _sixPercentWidth ??= AppScreen.width * sixPercent;
    return _sixPercentWidth!;
  }

  static double? _sevenPercentWidth;

  double get sevenPercentWidth {
    const double sevenPercent = 0.07;
    _sevenPercentWidth ??= AppScreen.width * sevenPercent;
    return _sevenPercentWidth!;
  }

  static double? _eightPercentWidth;

  double get eightPercentWidth {
    const double eightPercent = 0.08;
    _eightPercentWidth ??= AppScreen.width * eightPercent;
    return _eightPercentWidth!;
  }

  static double? _tenPercentWidth;

  double get tenPercentWidth {
    const double tenPercentWidth = 0.10;
    _tenPercentWidth ??= AppScreen.width * tenPercentWidth;
    return _tenPercentWidth!;
  }

  static double? _fortyPercentWidth;

  double get fortyPercentWidth {
    const double fortyPercent = 0.40;
    _fortyPercentWidth ??= AppScreen.width * fortyPercent;
    return _fortyPercentWidth!;
  }

  static double? _thirtyPercentWidth;

  double get thirtyPercentWidth {
    const double thirtyPercentWidth = 0.32;
    _thirtyPercentWidth ??= AppScreen.width * thirtyPercentWidth;
    return _thirtyPercentWidth!;
  }

  static double? _sixtySixPercentWidth;

  double get sixtySixPercentWidth {
    _sixtySixPercentWidth ??= 66.percentWidth;
    return _sixtySixPercentWidth!;
  }

  static double? _fiftyFivePercentWidth;

  double get fiftyFivePercentWidth {
    _fiftyFivePercentWidth ??= 55.percentWidth;
    return _fiftyFivePercentWidth!;
  }

  static double? _seventyPercentWidth;

  double get seventyPercentWidth {
    const double seventyPercent = 0.70;
    _seventyPercentWidth ??= AppScreen.width * seventyPercent;
    return _seventyPercentWidth!;
  }

  static double? _tweentyEightPercentWidth;

  double get tweentyEightPercentWidth {
    const double tweentyEightPercentWidth = 0.28;
    _tweentyEightPercentWidth ??= AppScreen.width * tweentyEightPercentWidth;
    return _tweentyEightPercentWidth!;
  }

  static double? _twentyPercentWidth;

  double get twentyPercentWidth {
    const double twentyPercentWidth = 0.20;
    _twentyPercentWidth ??= AppScreen.width * twentyPercentWidth;
    return _twentyPercentWidth!;
  }

  static double? _twentyFivePercentWidth;

  double get twentyFivePercentWidth {
    const double twentyFivePercentWidth = 0.25;
    _twentyFivePercentWidth ??= AppScreen.width * twentyFivePercentWidth;
    return _twentyFivePercentWidth!;
  }

  static double? _twentySixPercentWidth;

  double get twentySixPercentWidth {
    const double twentySixPercentWidth = 0.26;
    _twentySixPercentWidth ??= AppScreen.width * twentySixPercentWidth;
    return _twentySixPercentWidth!;
  }

  static double? _twentyThreePercentWidth;

  double get twentyThreePercentWidth {
    const double twentyThreePercentWidth = 0.23;
    _twentyThreePercentWidth ??= AppScreen.width * twentyThreePercentWidth;
    return _twentyThreePercentWidth!;
  }

  static double? _fourtyPercentWidth;

  double get fourtyPercentWidth {
    const double fourtyPercentWidth = 0.40;
    _fourtyPercentWidth ??= AppScreen.width * fourtyPercentWidth;
    return _fourtyPercentWidth!;
  }

  static double? _twentyPercentHeight;

  double get twentyPercentHeight {
    const double twentyPercent = 0.20;
    _twentyPercentHeight ??= AppScreen.height * twentyPercent;
    return _twentyPercentHeight!;
  }

  static double? _tenPercentHeight;

  double get tenPercentHeight {
    const double tenPercentHeight = 0.10;
    _tenPercentHeight ??= AppScreen.height * tenPercentHeight;
    return _tenPercentHeight!;
  }

  static double? _twelvePercentHeight;

  double get twelvePercentHeight {
    const double twentyPercent = 0.12;
    _twelvePercentHeight ??= AppScreen.height * twentyPercent;
    return _twelvePercentHeight!;
  }

  static double? _fourteenPercentHeight;

  double get fourteenPercentHeight {
    const double fourteenPercentHeight = 0.14;
    _fourteenPercentHeight ??= AppScreen.height * fourteenPercentHeight;
    return _fourteenPercentHeight!;
  }

  static double? _tweentyPercentHeight;

  double get tweentyPercentHeight {
    const double tweentyPercentHeight = 0.20;
    _tweentyPercentHeight ??= AppScreen.height * tweentyPercentHeight;
    return _tweentyPercentHeight!;
  }
}

double? _px1;
double get px1 {
  _px1 ??= 1.px;
  return _px1!;
}

double? _px2;
double get px2 {
  _px2 ??= 2.px;
  return _px2!;
}

double? _px3;
double get px3 {
  _px3 ??= 3.px;
  return _px3!;
}

double? _px4;
double get px4 {
  _px4 ??= 4.px;
  return _px4!;
}

double? _px5;
double get px5 {
  _px5 ??= 5.px;
  return _px5!;
}

double? _px6;
double get px6 {
  _px6 ??= 6.px;
  return _px6!;
}

double? _px7;
double get px7 {
  _px7 ??= 7.px;
  return _px7!;
}

double? _px8;
double get px8 {
  _px8 ??= 8.px;
  return _px8!;
}

double? _px9;
double get px9 {
  _px9 ??= 9.px;
  return _px9!;
}

double? _px10;
double get px10 {
  _px10 ??= 10.px;
  return _px10!;
}

double? _px11;
double get px11 {
  _px11 ??= 11.px;
  return _px11!;
}

double? _px12;
double get px12 {
  _px12 ??= 12.px;
  return _px12!;
}

double? _px13;
double get px13 {
  _px13 ??= 13.px;
  return _px13!;
}

double? _px14;
double get px14 {
  _px14 ??= 14.px;
  return _px14!;
}

double? _px15;
double get px15 {
  _px15 ??= 15.px;
  return _px15!;
}

double? _px16;
double get px16 {
  _px16 ??= 16.px;
  return _px16!;
}

double? _px17;
double get px17 {
  _px17 ??= 17.px;
  return _px17!;
}

double? _px18;
double get px18 {
  _px18 ??= 18.px;
  return _px18!;
}

double? _px19;
double get px19 {
  _px19 ??= 19.px;
  return _px19!;
}

double? _px20;
double get px20 {
  _px20 ??= 20.px;
  return _px20!;
}

double? _px21;
double get px21 {
  _px21 ??= 21.px;
  return _px21!;
}

double? _px22;
double get px22 {
  _px22 ??= 22.px;
  return _px22!;
}

double? _px23;
double get px23 {
  _px23 ??= 23.px;
  return _px23!;
}

double? _px24;
double get px24 {
  _px24 ??= 24.px;
  return _px24!;
}

double? _px25;
double get px25 {
  _px25 ??= 25.px;
  return _px25!;
}

double? _px26;
double get px26 {
  _px26 ??= 26.px;
  return _px26!;
}

double? _px27;
double get px27 {
  _px27 ??= 27.px;
  return _px27!;
}

double? _px28;
double get px28 {
  _px28 ??= 28.px;
  return _px28!;
}

double? _px29;
double get px29 {
  _px29 ??= 29.px;
  return _px29!;
}

double? _px30;
double get px30 {
  _px30 ??= 30.px;
  return _px30!;
}

double? _px31;
double get px31 {
  _px31 ??= 31.px;
  return _px31!;
}

double? _px32;
double get px32 {
  _px32 ??= 32.px;
  return _px32!;
}

double? _px33;
double get px33 {
  _px33 ??= 33.px;
  return _px33!;
}

double? _px34;
double get px34 {
  _px34 ??= 34.px;
  return _px34!;
}

double? _px35;
double get px35 {
  _px35 ??= 35.px;
  return _px35!;
}

double? _px36;
double get px36 {
  _px36 ??= 36.px;
  return _px36!;
}

double? _px37;
double get px37 {
  _px37 ??= 37.px;
  return _px37!;
}

double? _px38;
double get px38 {
  _px38 ??= 38.px;
  return _px38!;
}

double? _px39;
double get px39 {
  _px39 ??= 39.px;
  return _px39!;
}

double? _px40;
double get px40 {
  _px40 ??= 40.px;
  return _px40!;
}

double? _px41;
double get px41 {
  _px41 ??= 41.px;
  return _px41!;
}

double? _px42;
double get px42 {
  _px42 ??= 42.px;
  return _px42!;
}

double? _px43;
double get px43 {
  _px43 ??= 43.px;
  return _px43!;
}

double? _px44;
double get px44 {
  _px44 ??= 44.px;
  return _px44!;
}

double? _px45;
double get px45 {
  _px45 ??= 45.px;
  return _px45!;
}

double? _px46;
double get px46 {
  _px46 ??= 46.px;
  return _px46!;
}

double? _px47;
double get px47 {
  _px47 ??= 47.px;
  return _px47!;
}

double? _px48;
double get px48 {
  _px48 ??= 48.px;
  return _px48!;
}

double? _px49;
double get px49 {
  _px49 ??= 49.px;
  return _px49!;
}

double? _px50;
double get px50 {
  _px50 ??= 50.px;
  return _px50!;
}

double? _px51;
double get px51 {
  _px51 ??= 51.px;
  return _px51!;
}

double? _px52;
double get px52 {
  _px52 ??= 52.px;
  return _px52!;
}

double? _px53;
double get px53 {
  _px53 ??= 53.px;
  return _px53!;
}

double? _px54;
double get px54 {
  _px54 ??= 54.px;
  return _px54!;
}

double? _px55;
double get px55 {
  _px55 ??= 55.px;
  return _px55!;
}

double? _px56;
double get px56 {
  _px56 ??= 56.px;
  return _px56!;
}

double? _px57;
double get px57 {
  _px57 ??= 57.px;
  return _px57!;
}

double? _px58;
double get px58 {
  _px58 ??= 58.px;
  return _px58!;
}

double? _px59;
double get px59 {
  _px59 ??= 59.px;
  return _px59!;
}

double? _px60;
double get px60 {
  _px60 ??= 60.px;
  return _px60!;
}

double? _px61;
double get px61 {
  _px61 ??= 61.px;
  return _px61!;
}

double? _px62;
double get px62 {
  _px62 ??= 62.px;
  return _px62!;
}

double? _px63;
double get px63 {
  _px63 ??= 63.px;
  return _px63!;
}

double? _px64;
double get px64 {
  _px64 ??= 64.px;
  return _px64!;
}

double? _px65;
double get px65 {
  _px65 ??= 65.px;
  return _px65!;
}

double? _px66;
double get px66 {
  _px66 ??= 66.px;
  return _px66!;
}

double? _px67;
double get px67 {
  _px67 ??= 67.px;
  return _px67!;
}

double? _px68;
double get px68 {
  _px68 ??= 68.px;
  return _px68!;
}

double? _px69;
double get px69 {
  _px69 ??= 69.px;
  return _px69!;
}

double? _px70;
double get px70 {
  _px70 ??= 70.px;
  return _px70!;
}

double? _px71;
double get px71 {
  _px71 ??= 71.px;
  return _px71!;
}

double? _px72;
double get px72 {
  _px72 ??= 72.px;
  return _px72!;
}

double? _px73;
double get px73 {
  _px73 ??= 73.px;
  return _px73!;
}

double? _px74;
double get px74 {
  _px74 ??= 74.px;
  return _px74!;
}

double? _px75;
double get px75 {
  _px75 ??= 75.px;
  return _px75!;
}

double? _px76;
double get px76 {
  _px76 ??= 76.px;
  return _px76!;
}

double? _px77;
double get px77 {
  _px77 ??= 77.px;
  return _px77!;
}

double? _px78;
double get px78 {
  _px78 ??= 78.px;
  return _px78!;
}

double? _px79;
double get px79 {
  _px79 ??= 79.px;
  return _px79!;
}

double? _px80;
double get px80 {
  _px80 ??= 80.px;
  return _px80!;
}

double? _px81;
double get px81 {
  _px81 ??= 81.px;
  return _px81!;
}

double? _px82;
double get px82 {
  _px82 ??= 82.px;
  return _px82!;
}

double? _px83;
double get px83 {
  _px83 ??= 83.px;
  return _px83!;
}

double? _px84;
double get px84 {
  _px84 ??= 84.px;
  return _px84!;
}

double? _px85;
double get px85 {
  _px85 ??= 85.px;
  return _px85!;
}

double? _px86;
double get px86 {
  _px86 ??= 86.px;
  return _px86!;
}

double? _px87;
double get px87 {
  _px87 ??= 87.px;
  return _px87!;
}

double? _px88;
double get px88 {
  _px88 ??= 88.px;
  return _px88!;
}

double? _px89;
double get px89 {
  _px89 ??= 89.px;
  return _px89!;
}

double? _px90;
double get px90 {
  _px90 ??= 90.px;
  return _px90!;
}

double? _px91;
double get px91 {
  _px91 ??= 91.px;
  return _px91!;
}

double? _px92;
double get px92 {
  _px92 ??= 92.px;
  return _px92!;
}

double? _px93;
double get px93 {
  _px93 ??= 93.px;
  return _px93!;
}

double? _px94;
double get px94 {
  _px94 ??= 94.px;
  return _px94!;
}

double? _px95;
double get px95 {
  _px95 ??= 95.px;
  return _px95!;
}

double? _px96;
double get px96 {
  _px96 ??= 96.px;
  return _px96!;
}

double? _px97;
double get px97 {
  _px97 ??= 97.px;
  return _px97!;
}

double? _px98;
double get px98 {
  _px98 ??= 98.px;
  return _px98!;
}

double? _px99;
double get px99 {
  _px99 ??= 99.px;
  return _px99!;
}

double? _px100;
double get px100 {
  _px100 ??= 100.px;
  return _px100!;
}

double? _px101;
double get px101 {
  _px101 ??= 101.px;
  return _px101!;
}

double? _px102;
double get px102 {
  _px102 ??= 102.px;
  return _px102!;
}

double? _px103;
double get px103 {
  _px103 ??= 103.px;
  return _px103!;
}

double? _px104;
double get px104 {
  _px104 ??= 104.px;
  return _px104!;
}

double? _px105;
double get px105 {
  _px105 ??= 105.px;
  return _px105!;
}

double? _px106;
double get px106 {
  _px106 ??= 106.px;
  return _px106!;
}

double? _px107;
double get px107 {
  _px107 ??= 107.px;
  return _px107!;
}

double? _px108;
double get px108 {
  _px108 ??= 108.px;
  return _px108!;
}

double? _px109;
double get px109 {
  _px109 ??= 109.px;
  return _px109!;
}

double? _px110;
double get px110 {
  _px110 ??= 110.px;
  return _px110!;
}

double? _px111;
double get px111 {
  _px111 ??= 111.px;
  return _px111!;
}

double? _px112;
double get px112 {
  _px112 ??= 112.px;
  return _px112!;
}

double? _px113;
double get px113 {
  _px113 ??= 113.px;
  return _px113!;
}

double? _px114;
double get px114 {
  _px114 ??= 114.px;
  return _px114!;
}

double? _px115;
double get px115 {
  _px115 ??= 115.px;
  return _px115!;
}

double? _px116;
double get px116 {
  _px116 ??= 116.px;
  return _px116!;
}

double? _px117;
double get px117 {
  _px117 ??= 117.px;
  return _px117!;
}

double? _px118;
double get px118 {
  _px118 ??= 118.px;
  return _px118!;
}

double? _px119;
double get px119 {
  _px119 ??= 119.px;
  return _px119!;
}

double? _px120;
double get px120 {
  _px120 ??= 120.px;
  return _px120!;
}

double? _px121;
double get px121 {
  _px121 ??= 121.px;
  return _px121!;
}

double? _px122;
double get px122 {
  _px122 ??= 122.px;
  return _px122!;
}

double? _px123;
double get px123 {
  _px123 ??= 123.px;
  return _px123!;
}

double? _px124;
double get px124 {
  _px124 ??= 124.px;
  return _px124!;
}

double? _px125;
double get px125 {
  _px125 ??= 125.px;
  return _px125!;
}

double? _px126;
double get px126 {
  _px126 ??= 126.px;
  return _px126!;
}

double? _px127;
double get px127 {
  _px127 ??= 127.px;
  return _px127!;
}

double? _px128;
double get px128 {
  _px128 ??= 128.px;
  return _px128!;
}

double? _px129;
double get px129 {
  _px129 ??= 129.px;
  return _px129!;
}

double? _px130;
double get px130 {
  _px130 ??= 130.px;
  return _px130!;
}

double? _px131;
double get px131 {
  _px131 ??= 131.px;
  return _px131!;
}

double? _px132;
double get px132 {
  _px132 ??= 132.px;
  return _px132!;
}

double? _px133;
double get px133 {
  _px133 ??= 133.px;
  return _px133!;
}

double? _px134;
double get px134 {
  _px134 ??= 134.px;
  return _px134!;
}

double? _px135;
double get px135 {
  _px135 ??= 135.px;
  return _px135!;
}

double? _px136;
double get px136 {
  _px136 ??= 136.px;
  return _px136!;
}

double? _px137;
double get px137 {
  _px137 ??= 137.px;
  return _px137!;
}

double? _px138;
double get px138 {
  _px138 ??= 138.px;
  return _px138!;
}

double? _px139;
double get px139 {
  _px139 ??= 139.px;
  return _px139!;
}

double? _px140;
double get px140 {
  _px140 ??= 140.px;
  return _px140!;
}

double? _px141;
double get px141 {
  _px141 ??= 141.px;
  return _px141!;
}

double? _px142;
double get px142 {
  _px142 ??= 142.px;
  return _px142!;
}

double? _px143;
double get px143 {
  _px143 ??= 143.px;
  return _px143!;
}

double? _px144;
double get px144 {
  _px144 ??= 144.px;
  return _px144!;
}

double? _px145;
double get px145 {
  _px145 ??= 145.px;
  return _px145!;
}

double? _px146;
double get px146 {
  _px146 ??= 146.px;
  return _px146!;
}

double? _px147;
double get px147 {
  _px147 ??= 147.px;
  return _px147!;
}

double? _px148;
double get px148 {
  _px148 ??= 148.px;
  return _px148!;
}

double? _px149;
double get px149 {
  _px149 ??= 149.px;
  return _px149!;
}

double? _px150;
double get px150 {
  _px150 ??= 150.px;
  return _px150!;
}

double? _px151;
double get px151 {
  _px151 ??= 151.px;
  return _px151!;
}

double? _px152;
double get px152 {
  _px152 ??= 152.px;
  return _px152!;
}

double? _px153;
double get px153 {
  _px153 ??= 153.px;
  return _px153!;
}

double? _px154;
double get px154 {
  _px154 ??= 154.px;
  return _px154!;
}

double? _px155;
double get px155 {
  _px155 ??= 155.px;
  return _px155!;
}

double? _px156;
double get px156 {
  _px156 ??= 156.px;
  return _px156!;
}

double? _px157;
double get px157 {
  _px157 ??= 157.px;
  return _px157!;
}

double? _px158;
double get px158 {
  _px158 ??= 158.px;
  return _px158!;
}

double? _px159;
double get px159 {
  _px159 ??= 159.px;
  return _px159!;
}

double? _px160;
double get px160 {
  _px160 ??= 160.px;
  return _px160!;
}

double? _px161;
double get px161 {
  _px161 ??= 161.px;
  return _px161!;
}

double? _px162;
double get px162 {
  _px162 ??= 162.px;
  return _px162!;
}

double? _px163;
double get px163 {
  _px163 ??= 163.px;
  return _px163!;
}

double? _px164;
double get px164 {
  _px164 ??= 164.px;
  return _px164!;
}

double? _px165;
double get px165 {
  _px165 ??= 165.px;
  return _px165!;
}

double? _px166;
double get px166 {
  _px166 ??= 166.px;
  return _px166!;
}

double? _px167;
double get px167 {
  _px167 ??= 167.px;
  return _px167!;
}

double? _px168;
double get px168 {
  _px168 ??= 168.px;
  return _px168!;
}

double? _px169;
double get px169 {
  _px169 ??= 169.px;
  return _px169!;
}

double? _px170;
double get px170 {
  _px170 ??= 170.px;
  return _px170!;
}

double? _px171;
double get px171 {
  _px171 ??= 171.px;
  return _px171!;
}

double? _px172;
double get px172 {
  _px172 ??= 172.px;
  return _px172!;
}

double? _px173;
double get px173 {
  _px173 ??= 173.px;
  return _px173!;
}

double? _px174;
double get px174 {
  _px174 ??= 174.px;
  return _px174!;
}

double? _px175;
double get px175 {
  _px175 ??= 175.px;
  return _px175!;
}

double? _px176;
double get px176 {
  _px176 ??= 176.px;
  return _px176!;
}

double? _px177;
double get px177 {
  _px177 ??= 177.px;
  return _px177!;
}

double? _px178;
double get px178 {
  _px178 ??= 178.px;
  return _px178!;
}

double? _px179;
double get px179 {
  _px179 ??= 179.px;
  return _px179!;
}

double? _px180;
double get px180 {
  _px180 ??= 180.px;
  return _px180!;
}

double? _px181;
double get px181 {
  _px181 ??= 181.px;
  return _px181!;
}

double? _px182;
double get px182 {
  _px182 ??= 182.px;
  return _px182!;
}

double? _px183;
double get px183 {
  _px183 ??= 183.px;
  return _px183!;
}

double? _px184;
double get px184 {
  _px184 ??= 184.px;
  return _px184!;
}

double? _px185;
double get px185 {
  _px185 ??= 185.px;
  return _px185!;
}

double? _px186;
double get px186 {
  _px186 ??= 186.px;
  return _px186!;
}

double? _px187;
double get px187 {
  _px187 ??= 187.px;
  return _px187!;
}

double? _px188;
double get px188 {
  _px188 ??= 188.px;
  return _px188!;
}

double? _px189;
double get px189 {
  _px189 ??= 189.px;
  return _px189!;
}

double? _px190;
double get px190 {
  _px190 ??= 190.px;
  return _px190!;
}

double? _px191;
double get px191 {
  _px191 ??= 191.px;
  return _px191!;
}

double? _px192;
double get px192 {
  _px192 ??= 192.px;
  return _px192!;
}

double? _px193;
double get px193 {
  _px193 ??= 193.px;
  return _px193!;
}

double? _px194;
double get px194 {
  _px194 ??= 194.px;
  return _px194!;
}

double? _px195;
double get px195 {
  _px195 ??= 195.px;
  return _px195!;
}

double? _px196;
double get px196 {
  _px196 ??= 196.px;
  return _px196!;
}

double? _px197;
double get px197 {
  _px197 ??= 197.px;
  return _px197!;
}

double? _px198;
double get px198 {
  _px198 ??= 198.px;
  return _px198!;
}

double? _px199;
double get px199 {
  _px199 ??= 199.px;
  return _px199!;
}

double? _px200;
double get px200 {
  _px200 ??= 200.px;
  return _px200!;
}

double? _heightPercent;
double? _widthPercent;
double? appScreenWidthQuarterPercentage;

/// A set of extensions for numerical types that provide convenience methods for
/// converting values to specific units based on the device's screen dimensions.
///
///
/// Example usage:
///
/// ```dart
/// double fontSizeInPixels = 16.px;
/// double containerHeightInPercentage = 50.percentHeight;
/// double containerWidthInPercentage = 75.percentWidth;
/// ```
///
/// Rationale:
///
/// - The `DeviceExt` extension provides convenience methods for converting numerical values
/// to specific units based on the device's screen dimensions. By encapsulating the conversion logic
/// within extension methods, it promotes code reusability and improves code readability.
///
/// - The extension methods `px`, `percentHeight`, and `percentWidth` allow developers to express
/// sizes or positions in a more intuitive and adaptable way, based on the device's screen size.
///
/// - By calculating the conversion factors only once and storing them in variables (`_heightPercent`,
/// `_widthPercent`, and `_AppScreenWidthQuarterPercentage`), subsequent conversions for the same
/// type of unit can be performed efficiently without the need for repeated calculations.
extension DeviceExt on num {
  /// The `px` method converts a numerical value to pixels by multiplying it with a factor
  /// representing a quarter of the screen width percentage. The factor is calculated using the
  /// `_calculateAppScreenWidthQuarterPercentage` function.
  ///
  ///
  /// Example usage:
  ///
  /// ```dart
  /// double fontSizeInPixels = 16.px;
  /// ```
  double get px {
    appScreenWidthQuarterPercentage ??=
        _calculateAppScreenWidthQuarterPercentage();
    return this * (appScreenWidthQuarterPercentage ?? 0);
  }

  /// The `percentHeight` method converts a numerical value to a percentage of the device's
  /// screen height. It multiplies the numerical value with a factor representing the ratio between
  /// the device's screen height and 100. The factor is calculated once and stored in the `_heightPercent`
  /// variable.
  ///
  ///
  /// Example usage:
  ///
  /// ```dart
  /// double containerHeightInPercentage = 50.percentHeight;
  /// ```
  double get percentHeight {
    _heightPercent ??= AppScreen.height / 100;
    return this * (_heightPercent ?? 0);
  }

  /// The `percentWidth` method converts a numerical value to a percentage of the device's
  /// screen width. It multiplies the numerical value with a factor representing the ratio between
  /// the device's screen width and 100. The factor is calculated once and stored in the `_widthPercent`
  /// variable.
  ///
  ///
  /// Example usage:
  ///
  /// ```dart
  /// double containerWidthInPercentage = 75.percentWidth;
  /// ```
  double get percentWidth {
    _widthPercent ??= AppScreen.width / 100;
    return this * (_widthPercent ?? 0);
  }
}

/// Calculates the quarter percentage of the Tutor screen width.
///
/// The `_calculateAppScreenWidthQuarterPercentage` function calculates and returns
/// a factor that represents a quarter of the Tutor screen width percentage. It is used
/// by the `px` method in the `DeviceExt` extension to convert numerical values to pixels.
/// The quarter percentage is calculated as the ratio between one-quarter of the Tutor
/// screen width and 100.
///
/// This function assumes that the `AppScreen` class, containing the width property,
/// is properly defined and accessible within the scope of this function.
double _calculateAppScreenWidthQuarterPercentage() {
  return (AppScreen.width / 3.9) / 100;
}
