import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hashed/datasource/local/member_model_cache_item.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/datasource/remote/firebase/firebase_push_notification_service.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/seeds_app.dart';
import 'package:hive_flutter/hive_flutter.dart';

InAppLocalhostServer localhostServer = InAppLocalhostServer();

Future<void> main() async {
  // Zone to handle asynchronous errors (Dart).
  // for details: https://docs.flutter.dev/testing/errors
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

// we can put this one back in after we got the jaguar one to work
    await localhostServer.start();
    print("InAppLocalhostServer started");

    await Firebase.initializeApp();
    await settingsStorage.initialise();
    await PushNotificationService().initialise();
    await Hive.initFlutter();
    Hive.registerAdapter(MemberModelCacheItemAdapter());
    GoogleFonts.config.allowRuntimeFetching = false;
    LicenseRegistry.addLicense(() async* {
      final license = await rootBundle.loadString('assets/google_fonts/OFL.txt');
      yield LicenseEntryWithLineBreaks(['google_fonts'], license);
    });
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    // ignore: unawaited_futures
    polkadotRepository.initService().then((_) => polkadotRepository.startService());

    // Called whenever the Flutter framework catches an error.
    FlutterError.onError = (details) async {
      FlutterError.presentError(details);
      // TODO(Raul): use FirebaseCrashlytics or whatever
      //await FirebaseCrashlytics.instance.recordFlutterError(details);
    };

    // if (kDebugMode) {
    //   /// Bloc logs only in debug (for better performance in release)
    //   BlocOverrides.runZoned(() => runApp(const SeedsApp()), blocObserver: DebugBlocObserver());
    // } else {
    runApp(const SeedsApp());
    // }
  }, (error, stackTrace) async {
    //await FirebaseCrashlytics.instance.recordError(error, stack);
  });
}
