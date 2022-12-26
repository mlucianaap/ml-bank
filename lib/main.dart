// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:mlbank/controller/adm_controller.dart';
import 'package:mlbank/controller/card_controller.dart';
import 'package:mlbank/controller/client_controller.dart';
import 'package:mlbank/pages/add_card.dart';
import 'package:mlbank/pages/card_view_adm.dart';
import 'package:mlbank/pages/card_view_client.dart';
import 'package:mlbank/pages/client_view.dart';
import 'package:mlbank/pages/home_adm.dart';
import 'package:mlbank/pages/password_forgot.dart';
import 'package:mlbank/pages/preview_card.dart';
import 'package:mlbank/pages/profile.dart';
import 'package:mlbank/pages/register_adm.dart';
import 'package:mlbank/pages/register_card.dart';
import 'package:mlbank/pages/register_client.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mlbank/pages/forgot_password.dart';
import 'package:mlbank/pages/home_page.dart';
import 'package:mlbank/pages/login.dart';
import 'package:mlbank/pages/publicity.dart';
import 'package:mlbank/pages/splash.dart';
import 'package:mlbank/pages/view_cards_create.dart';
import 'package:mlbank/pages/view_cards_register.dart';
import 'package:mlbank/pages/view_clients.dart';
import 'package:mlbank/theme/app_theme.dart';
import 'package:mlbank/utils/app_routes.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      Provider(
        create: (_) => ClientController(),
      ),
      Provider(
        create: (_) => CardController(),
      ),
      Provider(
        create: (_) => AdmController(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appThemeData,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (ctx) => const Splash(),
        AppRoutes.publicity: (ctx) => const Publicity(),
        AppRoutes.registerClient: (ctx) => const RegisterClient(),
        AppRoutes.login: (ctx) => const LoginPage(),
        AppRoutes.home: (ctx) => const HomePage(),
        AppRoutes.forgotPassword: (ctx) => const ForgotPasswordPage(),
        AppRoutes.profile: (ctx) => const Profile(),
        AppRoutes.addCard: (cxt) => const AddCard(),
        AppRoutes.passwordForgot: (cxt) => const PasswordForgot(),
        AppRoutes.cardViewAdm: (cxt) => const CardViewAdm(),
        AppRoutes.cardViewClient: (cxt) => const CardViewClient(),
        AppRoutes.registerCard: (cxt) => RegisterCard(),
        AppRoutes.homeAdm: (cxt) => const HomeAdm(),
        AppRoutes.registerAdm: (ctx) => const RegisterAdm(),
        AppRoutes.clientView: (ctx) => const ClientView(),
        AppRoutes.viewClients: (ctx) => const ViewClients(),
        AppRoutes.cardsCreate: (ctx) => const ViewCardsClients(),
        AppRoutes.cardsRegister: (ctx) => const ViewCardsRegister(),
        AppRoutes.previewCard: (ctx) => const PreviewCard(),
      },
    );
  }
}
