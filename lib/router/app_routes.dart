import 'package:flutter/material.dart';
import 'package:flutter_movie_app/models/menu_option.dart';
import 'package:flutter_movie_app/screens/screens.dart';

class AppRoutes {
  static const initialRoute = 'home';

  static final menuOptions = <MenuOption>[
    MenuOption(route: 'details', screen: const DetailScreen())
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    appRoutes.addAll({'home': (BuildContext context) => const HomeScreen()});

    for (var menuOption in menuOptions) {
      appRoutes.addAll(
          {menuOption.route: (BuildContext contex) => menuOption.screen});
    }

    return appRoutes;
  }

  static Route<dynamic> Function(RouteSettings) onGenerateRoute = (settings) {
    return MaterialPageRoute(builder: (context) => const NotFoundScreen());
  };
}
