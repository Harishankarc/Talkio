import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Authentication {
  String? email;
  String? password;
  String? name;
  final supabase = Supabase.instance.client;

  Future<int> signUpUser(String email, String password, String name) async {
    final supabase = Supabase.instance.client;
    final response = await supabase.auth.signUp(
        data: {'name': name},
        email: email,
        password: password);
    if (response.user != null) {
      print("sign up sucessfull: ${response}");
      return 200;
    } else {
      print("Signup failed");
      return 500;
    }
  }

  Future<int> loginUser(String email, String password) async {
    final supabase = Supabase.instance.client;
    final response = await supabase.auth
        .signInWithPassword(email: email, password: password);
    if (response.user != null) {
      print("Login sucessfull: ${response}");
      return 200;
    } else {
      print("Login failed");
      return 500;
    }
  }

  Future<int> logOutUser() async {
    await Supabase.instance.client.auth.signOut();
    print("User Signed Out");
    return 200;
  }

  Future<int> SignInWithGoogle() async {
    print('Signing in with Google');
    GoogleSignIn _googleSignIn = GoogleSignIn(
        clientId:
            '900159421523-bi0rg97fudrumt16979g1l590bun9ba2.apps.googleusercontent.com',
        scopes: <String>[
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ]);
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;
    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }
    final response = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
    if (response.user != null) {
      print('Signed in with Google: ${response.user!.email}');
      return 200;
    } else {
      print('Failed to sign in with Google');
      return 500;
    }
  }
}
