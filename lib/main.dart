import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hashed/datasource/local/member_model_cache_item.dart';
import 'package:hashed/datasource/local/settings_storage.dart';
import 'package:hashed/datasource/remote/firebase/firebase_push_notification_service.dart';
import 'package:hashed/datasource/remote/polkadot_api/chains_repository.dart';
import 'package:hashed/datasource/remote/polkadot_api/polkadot_repository.dart';
import 'package:hashed/domain-shared/app_constants.dart';
import 'package:hashed/seeds_app.dart';
import 'package:hive_flutter/hive_flutter.dart';

InAppLocalhostServer localhostServer = InAppLocalhostServer(port: inappLocalHostPort);

Future<void> main() async {
  // Zone to handle asynchronous errors (Dart).
  // for details: https://docs.flutter.dev/testing/errors
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

// we can put this one back in after we got the jaguar one to work
    await localhostServer.start();
    print("InAppLocalhostServer started at $inappLocalHostPort");

    await Firebase.initializeApp();

    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 24),
    ));

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

    // Init Polkadot JS
    // final network = await chainsRepository.currentNetwork();
    // ignore: unawaited_futures
    chainsRepository.currentNetwork().then(
          (network) => polkadotRepository
              .initService(
                network,
              )
              .then((value) => polkadotRepository.startService()),
        );

    // Called whenever the Flutter framework catches an error.
    FlutterError.onError = (details) async {
      FlutterError.presentError(details);
    };

    runApp(const HashedApp());
  }, (error, stackTrace) async {
    print("Flutter error $error");
    print("Stack Trace: $stackTrace");
  });
}
