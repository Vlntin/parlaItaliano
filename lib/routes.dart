import 'package:go_router/go_router.dart';

import 'screens/ugoScreen.dart';
import 'screen_one.dart';
import 'screens/start_screen.dart';
import 'screens/vocabularyListScreen.dart';
import 'screens/vocabularyDetailsScreen.dart';
import 'screens/signInScreen.dart';

final _router = GoRouter(routes: [
  GoRoute(path: '/ugoScreen', builder: (context, state) => const HomeScreen()),
  GoRoute(path: '/startScreen', builder: (context, state) => const StartScreen()),
  GoRoute(path: '/vocabularyListsScreen', builder: (context, state) => const VocabularyListsScreen()),
  GoRoute(path: '/', builder: (context, state) => const SignInScreen()),
  GoRoute(path: '/screen_one/:id/:tablename', name:'screen_one', builder: (context, state) => ScreenOne(id: state.pathParameters['id'], tableName: state.pathParameters['tablename']),),
  GoRoute(path: '/vocabularies_details/:tablename/:table_id', name:'vocabularies_details', builder: (context, state) => VocabularyDetailsScreen(tablename: state.pathParameters['tablename'], table_id: state.pathParameters['table_id']),)
]);

GoRouter createRouter() {
  return _router;
}