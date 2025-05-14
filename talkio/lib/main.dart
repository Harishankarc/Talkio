import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talkio/auth/login.dart';
import 'package:talkio/auth/welcome.dart';
import 'package:talkio/components/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://yiedpkdlsgddfsgliujz.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlpZWRwa2Rsc2dkZGZzZ2xpdWp6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU3NDAxNjUsImV4cCI6MjA2MTMxNjE2NX0.oERJETAsUodKofM8alnhZzwJ2b0Qmj0hcKYykUuYgtM",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = Supabase.instance.client.auth.currentUser;

    return GetMaterialApp(
      title: 'Talkio',
      debugShowCheckedModeBanner: false,
      color: Colors.black,
      theme: ThemeData(
        textTheme: GoogleFonts.urbanistTextTheme(),
      ),
      home: currentUser == null ? const Welcome() : const SplashScreen(),
    );
  }
}
