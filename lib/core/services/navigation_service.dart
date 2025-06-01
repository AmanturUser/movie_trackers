import '../auto_route/auto_route.dart';

class NavigationService {
  static final _appRouter = AppRouter();
  static AppRouter get router => _appRouter;
}