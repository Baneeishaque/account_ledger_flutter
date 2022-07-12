import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_size/window_size.dart';

import 'account_ledger_material_app.dart';
import 'application_specification.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (UniversalPlatform.isDesktop) {
    setWindowTitle(ApplicationSpecification.applicationName);
  }
  runApp(const AccountLedgerMaterialApp());
}
