import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'src/core/utils.dart';
import 'src/core/config/router.dart';
import 'src/core/config/themes.dart';
import 'src/features/firebase/bloc/firebase_bloc.dart';
import 'src/features/firebase/firebase_options.dart';
import 'src/features/firebase/data/firebase_repository.dart';
import 'src/features/onboard/data/onboard_repository.dart';
import 'src/features/internet/bloc/internet_bloc.dart';
import 'src/features/home/bloc/home_bloc.dart';
import 'src/features/photo/bloc/photo_bloc.dart';
import 'src/features/photo/data/photo_repository.dart';
import 'src/features/printer/data/printer_repository.dart';
import 'src/features/vip/bloc/vip_bloc.dart';

// final colors = Theme.of(context).extension<MyColors>()!;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    await dotenv.load(fileName: ".env");
    await Purchases.configure(
      PurchasesConfiguration(dotenv.env['API_KEY'] ?? 'xyz'),
    );
  } catch (e) {
    logger(e);
  }

  final prefs = await SharedPreferences.getInstance();
  // await prefs.clear();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<OnboardRepository>(
          create: (context) => OnboardRepositoryImpl(prefs: prefs),
        ),
        RepositoryProvider<FirebaseRepository>(
          create: (context) => FirebaseRepositoryImpl(prefs: prefs),
        ),
        RepositoryProvider<PrinterRepository>(
          create: (context) => PrinterRepositoryImpl(),
        ),
        RepositoryProvider<PhotoRepository>(
          create: (context) => PhotoRepositoryImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => InternetBloc()),
          BlocProvider(create: (context) => HomeBloc()),
          BlocProvider(create: (context) => VipBloc()),
          BlocProvider(
            create: (context) => FirebaseBloc(
              repository: context.read<FirebaseRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => PhotoBloc(
              repository: context.read<PhotoRepository>(),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: theme,
      routerConfig: routerConfig,
    );
  }
}
