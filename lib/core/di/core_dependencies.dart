import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Add this import
import 'package:tatbeeqi/core/network/network_info.dart';
import 'package:tatbeeqi/core/services/database/database_service.dart';

Future<void> initCoreDependencies(
    GetIt sl, BackgroundMessageHandler onBackgroundMessage) async {
  // --- External Dependencies ---
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Supabase Client
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // Firebase Messaging & Local Notifications
  sl.registerLazySingleton(() => FirebaseMessaging.instance);
  sl.registerLazySingleton(() => FlutterLocalNotificationsPlugin());

  // --- Core Services ---

  sl.registerLazySingleton(() => DatabaseService());

  // Network Info
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  // Register other core services (e.g., HttpClient, Analytics) here
}
