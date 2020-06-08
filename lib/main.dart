import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:preferences/preference_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:svpullach/src/TeamPage.dart';
import 'package:svpullach/src/bloc/Authentication/bloc.dart';
import 'package:svpullach/src/bloc/simple_bloc_delegate.dart';
import 'package:svpullach/src/pages/SplashScreen.dart';
import 'package:svpullach/src/pages/login/login.dart';
import 'package:svpullach/src/repositories/user_repository.dart';
import 'package:svpullach/src/Widgets/SvpScaffold.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init(prefix: 'pref_');
//  PrefService.setDefaultValues({'user_description': 'This is my description!'});

  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(
        userRepository: userRepository,
      )..add(AppStarted()),
      child: MyApp(userRepository: userRepository),
    ),
  );

}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;

  WebViewController _controller;

  MyApp({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Unauthenticated) {
            return LoginScreen(userRepository: _userRepository);
          }
          if (state is Authenticated) {
//            return HomeScreen(name: state.displayName);
              return TeamPage();
          }
          return SplashScreen();
        },
      ),
    );
  }




}