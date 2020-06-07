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

  @override
  void initState() {
    super.initState();
  }
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

  String html = '<body>' +
  '<h1>Sportverein Pullach i. Isartal e.V.</h1>' +
  '<h4>Abteilung Handball im Deutschen Handballbund (DHB)</h4>' +
  '<p>Vereinsregister (Hauptverein): Amtsgericht München, VR 8796</p>' +
  '<p>Gistlstraße. 2, D-82049 Pullach i.Isartal</p>' +
  '<p>Vertretungsberechtigt für den SV Pullach Abt. Handball ist der Vorsitzende<br>' +
  'Dirk Trautmann, Kastanienallee 6, 82049 Pullach<br>' +
  'E-Mail: <a href="mailto:vorstand@svpullach-handball.de">vorstand@svpullach-handball.de</a></p>' +
  '<p>sowie dessen Stellvertreter' +
  'Benedikt Thelen, Wolfratshauser Str. 76, 82049 Pullach<br>' +
  'E-Mail:<span>&nbsp;</span><a href="mailto:benedikt.thelen@svpullach-handball.de">benedikt.thelen@svpullach-handball.de</a></p>' +
  '<h1>Sponsoren</h1>' +
  '<table>' +
  '<tbody>' +
  '<tr>' +
  '<td><a href="https://www.edeka.de/eh/sdbayern/edeka-hltkemeyer-theresienhhe-12/index.jsp" target="_blank" rel="noopener"><img style="display: block; margin-left: auto; margin-right: auto;" src="http://www.svpullach-handball.de/wp-content/uploads/2019/07/Logo-Edeka_Theresie-01.png" width="350"  alt="" /></a></td>' +
  '</tr>' +
  '<tr>' +
  '<td><a href="https://www.allfinanz.ag/Oliver.Muehldorfer/index.html" target="_blank" rel="noopener"><img src="http://www.svpullach-handball.de/wp-content/uploads/2019/07/oliver_muehldorfer_logo.png" alt="" width="350" height="175" /></a></td>' +
  '</tr>' +
  '<tr style="text-align: center;">' +
  '<td><a href="www.weplayhandball.de" target="_blank" rel="noopener"><img style="display: block; margin-left: auto; margin-right: auto;" src="http://www.svpullach-handball.de/wp-content/uploads/2015/01/WPH_Logo.jpg" alt="" /></a></td>' +
  '</tbody>' +
  '</table>' +
      '</body>'  ;


  _loadHtmlFromString() async {
    _controller.loadUrl( Uri.dataFromString(
        html,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
  }

}