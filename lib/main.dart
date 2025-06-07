import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'src/core/config/constants.dart';
import 'src/core/config/router.dart';
import 'src/core/config/themes.dart';
import 'src/features/firebase/bloc/firebase_bloc.dart';
import 'src/features/firebase/data/firebase_repository.dart';
import 'src/features/firebase/firebase_options.dart';
import 'src/features/onboard/data/onboard_repository.dart';
import 'src/features/internet/bloc/internet_bloc.dart';
import 'src/features/home/bloc/home_bloc.dart';
import 'src/features/photo/bloc/photo_bloc.dart';
import 'src/features/photo/data/photo_repository.dart';
import 'src/features/share/bloc/share_bloc.dart';
import 'src/features/vip/bloc/vip_bloc.dart';
import 'src/features/vip/data/vip_repository.dart';

// final colors = Theme.of(context).extension<MyColors>()!;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final prefs = await SharedPreferences.getInstance();
  // await prefs.clear();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (Platform.isIOS) {
    await Purchases.configure(
      PurchasesConfiguration('appl_QXIwkJLeTRKxrxoaXxAgYijODVh'),
    );
  }

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<OnboardRepository>(
          create: (context) => OnboardRepositoryImpl(prefs: prefs),
        ),
        RepositoryProvider<FirebaseRepository>(
          create: (context) => FirebaseRepositoryImpl(prefs: prefs),
        ),
        RepositoryProvider<VipRepository>(
          create: (context) => VipRepositoryImpl(prefs: prefs),
        ),
        RepositoryProvider<PhotoRepository>(
          create: (context) => PhotoRepositoryImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => HomeBloc()),
          BlocProvider(create: (context) => ShareBloc()..add(ListenToShare())),
          BlocProvider(
            create: (context) => InternetBloc()..add(CheckInternet()),
          ),
          BlocProvider(
            create: (context) =>
                VipBloc(repository: context.read<VipRepository>())
                  ..add(
                    CheckVip(
                      identifier: Identifiers.paywall1,
                      initial: true,
                    ),
                  ),
          ),
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
