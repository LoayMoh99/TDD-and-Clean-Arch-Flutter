import 'package:flutter/material.dart';
import 'package:number_trivia_app/features/presentation_layer/pages/number_trivia_page.dart';
import 'package:number_trivia_app/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Number Trivia',
      home: NumberTriviaPage(),
    );
  }
}
