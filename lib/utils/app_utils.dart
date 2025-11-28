import 'package:flutter/services.dart';
import 'package:flutter_app_minimizer_plus/flutter_app_minimizer_plus.dart';
import 'package:universal_io/io.dart';
import 'package:universal_platform/universal_platform.dart';

class AppUtils {
  static void closeApp() {
    if (UniversalPlatform.isAndroid) {
      FlutterAppMinimizerPlus.minimizeApp();
    } else if (UniversalPlatform.isIOS) {
      // iOS doesn't support app minimization, use system navigation
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } else {
      // Desktop & Others
      exit(0);
    }
  }
}
