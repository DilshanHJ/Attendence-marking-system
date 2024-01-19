import 'package:flutter/material.dart';
import 'package:sqlite3/sqlite3.dart';

class LandingPage extends StatefulWidget {
  const LandingPage(this.db, {super.key});
  final Database db;
  @override
  State<LandingPage> createState() => _LandingPageState(db);
}

class _LandingPageState extends State<LandingPage> {
  _LandingPageState(this.db);
  final Database db;
  bool loggedIn = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.orange,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(top: 150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white54,
            ),
            child: const Text(
              'Welcome to the\nAttendence Marking System\nFaculty of Applied Sciences\nWayamba University of Sri Lanka',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150, left: 10, right: 10),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () async {
                  try {
                    final ResultSet result = db.select('SELECT * FROM user');
                    if (result.isEmpty) {
                      Navigator.pushNamed(context, '/registration');
                    }
                    Navigator.pushNamed(context, '/home');
                  } catch (e) {
                    Navigator.pushNamed(context, '/registration');
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      const MaterialStatePropertyAll<Color>(Colors.white),
                  side: const MaterialStatePropertyAll(BorderSide.none),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ),
                child: const Text(
                  'Start',
                  style: TextStyle(fontSize: 18, color: Colors.orange),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
