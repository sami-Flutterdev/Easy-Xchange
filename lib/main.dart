import 'package:easy_xchange/view_model/complaint_controller.dart';
import 'package:flutter/material.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/view/auth%20screens/splash_screen.dart';
import 'package:easy_xchange/view_model/authViewModel.dart';
import 'package:easy_xchange/view_model/googleMapViewModel.dart';
import 'package:easy_xchange/view_model/userViewModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ueumcttkkjoxrvwwzcnr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVldW1jdHRra2pveHJ2d3d6Y25yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM2MTU3ODEsImV4cCI6MjA2OTE5MTc4MX0.SteYkEuhV7ckUiZDT9DJwKY4xLt-rRVw6cgXS_15hjs',
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ComplaintProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => GoogleMapViewModel(),
        ),
      ],
      child: MaterialApp(
          title: "Easy Xchange",
          theme: ThemeData(
            primarySwatch: Colors.teal,
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen()),
    );
  }
}
