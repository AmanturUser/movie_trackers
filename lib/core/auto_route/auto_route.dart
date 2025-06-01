import 'package:auto_route/auto_route.dart';
import 'package:movie_tracers/features/app_feature/presentation/initial_screen.dart';
import 'package:movie_tracers/features/movie_feature/presentation/movie_list.dart';
import 'package:movie_tracers/features/web_view_feature/presentation/web_view_screen.dart';
part 'auto_route.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter{
  @override
  List<AutoRoute> get routes=>[
    AutoRoute(page: InitialRoute.page,initial: true),
    AutoRoute(page: MoviesRoute.page),
    AutoRoute(page: WebViewRoute.page)
  ];
}