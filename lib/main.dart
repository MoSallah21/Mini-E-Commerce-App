// ============================================
// E-Commerce Flutter App - Main Entry Point
// ============================================

// Core & utility imports
import 'package:ecommerce/core/cache/cache_helper.dart';
import 'package:ecommerce/features/auth/presentation/pages/login_page.dart';
import 'package:ecommerce/features/auth/presentation/provider/sign_out_state.dart';
import 'package:ecommerce/features/profile/presentation/pages/add_profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'core/home_page.dart';
import 'features/localization/presentation/locale_provider.dart';
import 'features/products/presentation/provider/cart_state.dart';
import 'injection_container.dart' as di;
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:intl/intl.dart';

import 'l10n/app_localizations.dart';

// ==========================
// Firebase Background Handler
// ==========================
// Handles push notifications when the app is in background or terminated.
// Must initialize Firebase before accessing messaging features.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling a background message: ${message.messageId}');
}
// Global instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
// ==========================
// Main Function - App Entry
// ==========================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // Make status bar transparent
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Transparent status bar
    statusBarIconBrightness: Brightness.dark, // Dark icons (use .light for white)
    statusBarBrightness: Brightness.light, // For iOS
  ));
  await Firebase.initializeApp();
  await di.init();
  CacheHelper.init();

  // Stripe
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
  await Stripe.instance.applySettings();

  // Local Notifications setup
  const AndroidInitializationSettings androidInitializationSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
  InitializationSettings(android: androidInitializationSettings);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

// ==========================
// Root Widget - MyApp
// ==========================
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
  }

  // ==========================
  // Setup Firebase Messaging
  // ==========================
  void _setupFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request notification permissions from user
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('User granted permission: ${settings.authorizationStatus}');

    // Retrieve or generate FCM token
    String? cachedToken = CacheHelper.getData(key: 'fcm_token');
    String token;
    if (cachedToken == null) {
      token = (await messaging.getToken())!;
      debugPrint('Generated new FCM Token: $token');
      CacheHelper.saveData(key: 'fcm_token', value: token);
    } else {
      token = cachedToken;
      debugPrint('Using cached FCM Token: $token');
    }

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('Received a message in foreground: ${message.notification?.title} / ${message.notification?.body}');

      if (message.notification != null) {
        // Local Notification details
        const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel', // id
          'General Notifications', // name
          channelDescription: 'This channel is used for general notifications.',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );

        const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

        // Show local notification
        await flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title,
          message.notification!.body,
          notificationDetails,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // MultiProvider to manage global state for authentication and cart
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider(di.sl())),
        ChangeNotifierProvider(create: (_) => SignOutState(di.sl())),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'E-Commerce App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            locale: context.watch<LocaleProvider>().locale,
            supportedLocales: AppLocalizations.supportedLocales,

            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const HomePage(),
          );
        },
      ),
    );
  }
}

