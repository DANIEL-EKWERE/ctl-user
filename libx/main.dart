import 'localization/app_localization.dart';
import 'routes/app_routes.dart';
import 'utils/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'core/app_export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  DataBase dataBase = Get.put(DataBase());

  var token = await dataBase.getToken();

  String initialRoute = token.isNotEmpty
      ? AppRoutes.loginThreeScreen
      : AppRoutes.initialRoute;
      
  runApp(MyApp(initialRoute: initialRoute));

  Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return OverlayKit(
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            translations: AppLocalization(),
            locale: Locale('en', ''),
            fallbackLocale: Locale('en', ''),
            title: 'ctl_user',
            initialRoute: initialRoute,
            getPages: AppRoutes.pages,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(1.0)),
                child: child!,
              );
            },
          ),
        );
      },
    );
  }
}
