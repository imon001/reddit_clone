import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import 'features/auth/screens/log_in_screen.dart';
import 'features/home/screens/home_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),

  // '/create-community': (_) => const MaterialPage(child: CreateCommunityScreen()),
  // '/r/:name': (route) => MaterialPage(
  //         child: CommunityScreen(
  //       name: route.pathParameters['name']!,
  //     )),
  // '/mod-tools/:name': (routeData) => MaterialPage(
  //         child: ModToolsScreen(
  //       name: routeData.pathParameters['name']!,
  //     )),
  // '/edit-community/:name': (routeData) => MaterialPage(
  //         child: EditCommunityScreen(
  //       name: routeData.pathParameters['name']!,
  //     )),
  // '/add-mods/:name': (routeData) => MaterialPage(
  //         child: AddModScreen(
  //       name: routeData.pathParameters['name']!,
  //     )),
});
