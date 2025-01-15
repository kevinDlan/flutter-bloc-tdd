import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/core/services/injection_container.dart';
import 'package:education_app/core/services/router.dart';
import 'package:education_app/core/themes/app_theme.dart';
import 'package:education_app/features/dashboard/providers/dashboard_controller.dart';
import 'package:education_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider<DashboardController>(
          create: (_) => DashboardController(),
        ),
      ],
      child: MaterialApp(
        title: 'Education App',
        theme: AppTheme.lightTheme,
        onGenerateRoute: generateRoute,
        initialRoute: '/',
      ),
    );
  }
}

// Very good cli : https://cli.vgv.dev/docs/templates/core
