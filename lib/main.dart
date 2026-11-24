import 'package:di/di_data.dart';
import 'package:di/di_domain.dart';
import 'package:flutter/material.dart';
import 'package:test_pam/test_pam_widget.dart';

// Punctul de intrare: înregistrează dependențele (Retrofit, repository, use case-uri), apoi pornește UI-ul.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  injectData();
  injectDomain();
  runApp(const TestPamWidget());
}
