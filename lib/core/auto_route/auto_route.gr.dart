part of 'auto_route.dart';


abstract class _$AppRouter extends RootStackRouter{
  @override
  final Map<String, PageFactory> pagesMap={
    MoviesRoute.name: (routeData){
      return AutoRoutePage<dynamic>(
          routeData: routeData,
          child: const MovieListScreen()
      );
    },

    WebViewRoute.name: (routeData){
      return AutoRoutePage<dynamic>(
          routeData: routeData,
          child: WebViewScreen()
      );
    },

    InitialRoute.name: (routeData){
      return AutoRoutePage<dynamic>(
          routeData: routeData,
          child: InitialScreen()
      );
    }
  };
}

class MoviesRoute extends PageRouteInfo<void>{
  static const String name='MoviesRoute';
  static const PageInfo<void> page=PageInfo<void>(name);
  const MoviesRoute({List<PageRouteInfo>? children}): super(MoviesRoute.name,initialChildren: children);
}

class WebViewRoute extends PageRouteInfo<void> {
  const WebViewRoute({List<PageRouteInfo>? children})
      : super(
    WebViewRoute.name,
    initialChildren: children,
  );
  static const String name = 'WebViewRoute';
  static const PageInfo<void> page = PageInfo<void>(name);
}

class InitialRoute extends PageRouteInfo<void> {
  const InitialRoute({List<PageRouteInfo>? children})
      : super(
    InitialRoute.name,
    initialChildren: children,
  );
  static const String name = 'InitialRoute';
  static const PageInfo<void> page = PageInfo<void>(name);
}
