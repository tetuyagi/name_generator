import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/button_builder.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:name_generator/views/random_words_view.dart';
import 'package:name_generator/views/saved_suggestions_view.dart';
import 'package:name_generator/views/loading_view.dart';
import 'package:name_generator/views/error_page_view.dart';
import 'package:name_generator/models/constants.dart';
import 'package:name_generator/views/register_page.dart';
import 'package:name_generator/views/signin_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

  await Firebase.initializeApp();
  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runApp(AuthExampleApp());
  //runApp(MyApp());
}

Future<UserCredential> signInWithGoogle() async {
  print("sing in with google");
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("error = ${snapshot.error}");
          return ErrorPage();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MainPage();
        }

        return Loading();
      },
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: titleName,
      initialRoute: '/',
      routes: {
        '/': (context) => RandomWordsView(titleName: titleName),
        '/saved': (context) =>
            SavedSuggestionsView(titleName: 'Saved Suggestions'),
      },
    );
  }
}

class AuthExampleApp extends StatefulWidget {
  const AuthExampleApp({Key? key}) : super(key: key);

  @override
  _AuthExampleAppState createState() => _AuthExampleAppState();
}

class _AuthExampleAppState extends State<AuthExampleApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Firebase Example App',
        theme: ThemeData.dark(),
        home: Scaffold(
          body: AuthTypeSelector(),
        ));
  }
}

class AuthTypeSelector extends StatelessWidget {
  const AuthTypeSelector({Key? key}) : super(key: key);

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Firebase Example App"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: SignInButtonBuilder(
                icon: Icons.person_add,
                backgroundColor: Colors.indigo,
                text: 'Registration',
                onPressed: () => _pushPage(context, RegisterPage()),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: SignInButtonBuilder(
                icon: Icons.verified_user,
                backgroundColor: Colors.orange,
                text: 'Sign In',
                onPressed: () => _pushPage(context, SignInPage()),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: SignInButtonBuilder(
                backgroundColor: Colors.orange,
                text: 'Google login',
                onPressed: () async {
                  print("google login");
                  UserCredential _credential = await signInWithGoogle();
                  print("login succeeded");
                  print(_credential);
                },
              ),
            ),
          ],
        ));
  }
}
