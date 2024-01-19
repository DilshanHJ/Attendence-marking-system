//import 'package:attendence/homepage.dart';
import 'package:attendence/homepage.dart';
import 'package:attendence/landingpage.dart';
import 'package:attendence/registerpage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' as p;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }
  final db = sqlite3.open(p.join(dir.path, 'my_database.db'));

  runApp(MyApp(db));
}

class MyApp extends StatelessWidget {
  const MyApp(this.db, {super.key});
  final Database db;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendence Marker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      //home: RegisterPage(db),
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(db),
        '/registration': (context) => RegisterPage(db),
        '/home': (context) => Homepage(db)
      },
    );
  }
}
