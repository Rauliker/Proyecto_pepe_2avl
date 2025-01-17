import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:proyecto_raul/config/routes.dart';
import 'package:proyecto_raul/firebase_options.dart';
import 'package:proyecto_raul/presentations/bloc/language/language_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/theme/theme_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/theme/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection_container.dart' as injection_container;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(seconds: 3));
  await dotenv.load(fileName: ".env");

  await injection_container.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
  static MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>();
}

class MyAppState extends State<MyApp> {
  late Locale locale;

  void setLocale(Locale value) {
    setState(() {
      locale = value;
    });
  }

  @override
  void initState() {
    super.initState();
    setLocale(const Locale('en'));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(create: (context) => LanguageBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          SharedPreferences.getInstance().then((prefs) {
            locale = Locale(prefs.getString('lang') ?? 'en');
          });
          return MaterialApp.router(
            locale: locale,
            supportedLocales: const [
              Locale('en'),
              Locale('es'),
              Locale('it'),
              Locale('zh'),
              Locale('ja'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            theme: themeState.currentTheme.getTheme(),
          );
        },
      ),
    );
  }
}
