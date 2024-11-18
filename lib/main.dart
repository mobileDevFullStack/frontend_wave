import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:waveflutterapp/data/token/storage_factory.dart';
import 'providers/api_provider.dart';
import 'data/services/api_factory.dart';
import 'views/pages/screens/login_screen.dart';
import 'core/constants/api_constants.dart';
import 'data/services/auth_service.dart';
import 'data/services/transfert_service.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final apiService = createApiService(BASE_API_URL);
  final tokenStorage = createTokenStorage();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ApiProvider>(
          create: (_) => ApiProvider(apiService, tokenStorage),
        ),
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider<TransfertService>(
          create: (_) => TransfertService(apiService, tokenStorage),
        ),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Portefeuille Numérique',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Consumer<ApiProvider>(
        builder: (context, apiProvider, child) {
          return LoginScreen();
        },
      ),
    );
  }
}