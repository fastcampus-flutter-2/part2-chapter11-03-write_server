import 'package:di/di.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

enum ClindRoute {
  root,
  community,
  write,
  unknown;

  static String encode(ClindRoute value) => value.path;

  static ClindRoute decode(String value) => ClindRoute.values.firstWhere(
        (e) => e.path == value,
        orElse: () => ClindRoute.unknown,
      );
}

extension ClindRouteExtension on ClindRoute {
  String get path {
    const String root = '/';
    if (this == ClindRoute.root) return root;
    if (this == ClindRoute.write) {
      return '${ClindRoute.community.path}/$name';
    }
    return '$root$name';
  }
}

abstract class IClindRoutes {
  static Route<dynamic> find(RouteSettings settings) {
    final Uri uri = Uri.tryParse(settings.name ?? '') ?? Uri();
    final Map<String, String> queryParameters = {...uri.queryParameters};
    final bool fullscreenDialog = bool.tryParse(queryParameters['fullscreenDialog'] ?? '') ?? false;
    return MaterialPageRoute(
      builder: (context) => findScreen(uri),
      settings: settings,
      fullscreenDialog: fullscreenDialog,
    );
  }

  static Widget findScreen(Uri uri) {
    final ClindRoute route = ClindRoute.decode(uri.path);
    switch (route) {
      case ClindRoute.root:
        return const HomeBlocProvider(
          child: HomeScreen(),
        );
      case ClindRoute.community:
        return const CommunityBlocProvider(
          child: CommunityScreen(),
        );
      case ClindRoute.write:
        return const WriteScreen();
      case ClindRoute.unknown:
        return const SizedBox();
    }
  }
}

abstract class IClindRouteTo {
  static Future<T?> pushNamed<T extends Object?>(
    BuildContext context, {
    required String path,
    Map<String, String>? queryParameters,
    bool fullscreenDialog = false,
  }) async {
    final Map<String, String> params = {
      if (queryParameters != null) ...queryParameters,
      'fullscreenDialog': fullscreenDialog.toString(),
    };

    final Uri uri = Uri(
      path: path,
      queryParameters: params,
    );

    final Object? result = await Navigator.of(context).pushNamed<Object?>(uri.toString());
    return result as T?;
  }

  static Future<T?> push<T extends Object?>(
    BuildContext context, {
    required ClindRoute route,
    Map<String, String>? queryParameters,
    bool fullscreenDialog = false,
  }) {
    return pushNamed<T>(
      context,
      path: route.path,
      queryParameters: queryParameters,
      fullscreenDialog: fullscreenDialog,
    );
  }

  static Future<void> root(BuildContext context) {
    return push<void>(
      context,
      route: ClindRoute.root,
    );
  }

  static Future<void> community(BuildContext context) {
    return push<void>(
      context,
      route: ClindRoute.community,
    );
  }

  static Future<void> write(BuildContext context) {
    return push<void>(
      context,
      route: ClindRoute.write,
      fullscreenDialog: true,
    );
  }
}
