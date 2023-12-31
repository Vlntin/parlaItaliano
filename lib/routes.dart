import 'package:go_router/go_router.dart';

import 'home_screen.dart';
import 'screen_one.dart';

final _router = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
  GoRoute(path: '/screen_one/:id/:tablename', name:'screen_one', builder: (context, state) => ScreenOne(id: state.pathParameters['id'], tableName: state.pathParameters['tablename']),)
]);



GoRouter createRouter() {
  return _router;
}