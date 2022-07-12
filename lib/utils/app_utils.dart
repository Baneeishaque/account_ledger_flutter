import 'package:flutter/services.dart';
import 'package:minimize_app/minimize_app.dart';
import 'package:universal_io/io.dart';
import 'package:universal_platform/universal_platform.dart';

class AppUtils {
  static void closeApp() {
    if (UniversalPlatform.isAndroid) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } else if (UniversalPlatform.isIOS) {
      MinimizeApp.minimizeApp();
    } else {
      // Desktop & Others
      exit(0);
    }
  }
}
