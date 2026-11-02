import 'package:axscend_tech_test/config/app_theme.dart';
import 'package:axscend_tech_test/networking/api_client.dart';
import 'package:axscend_tech_test/routing/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [const Locale('en', 'GB')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const AxscendApp(),
    ),
  );
}

class AxscendApp extends StatelessWidget {
  const AxscendApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => ApiClient(),
      dispose: (_, ApiClient api) => api.close(),
      child: MaterialApp.router(
        routerConfig: router,
        theme: AppTheme.light,
        locale: context.locale,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
      ),
    );
  }
}
