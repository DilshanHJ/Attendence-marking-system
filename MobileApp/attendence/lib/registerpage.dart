// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:sqlite3/sqlite3.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage(this.db, {super.key});
  final Database db;
  @override
  // ignore: no_logic_in_create_state
  State<RegisterPage> createState() => _RegisterPageState(db);
}

String index = '';
String password = '';
bool error = false;

class _RegisterPageState extends State<RegisterPage> {
  _RegisterPageState(this.db);
  final Database db;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Center(
          child: Text(
            'Attendence Marking System',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(
            top: 50,
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  color: Colors.orange.shade400,
                ),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Register for the Attendence Marking System Here.\n\n Your credentials can be obtained from the Faculty office',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              if (error == true)
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: const EdgeInsets.only(left: 12, right: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.red,
                  ),
                  child: const Text(
                    'Somthing went wrong... Try again',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.account_circle),
                    prefixIconColor: Colors.orangeAccent,
                    hintText: 'Index Number',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.orange.shade600,
                    )),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.orange.shade900,
                    )),
                  ),
                  onChanged: (value) {
                    index = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.password),
                    prefixIconColor: Colors.orangeAccent,
                    hintText: 'Password',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.orange.shade800,
                    )),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.orange.shade900,
                    )),
                  ),
                  onChanged: (value) {
                    password = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: OutlinedButton(
                      onPressed: () async {
                        final response = await registerUser(index, password);
                        if (response.statusCode == 500) {
                          setState(() {
                            error = true;
                          });
                        } else {
                          setState(() {
                            error = false;
                          });
                          User student = User.fromJson(jsonDecode(response.body)
                              as Map<String, dynamic>);
                          try {
                            db.execute(
                                'CREATE TABLE user(indexnumber INTEGER NOT NULL PRIMARY KEY, id TEXT , name TEXT );');
                            db.execute(
                                "INSERT INTO user VALUES( ${student.index},'${student.id}' ,'${student.name}' );");
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamed(context, '/home');
                          } catch (e) {
                            setState(() {
                              error = true;
                            });
                          }
                        }
                      },
                      style: ButtonStyle(
                          side: const MaterialStatePropertyAll(
                              BorderSide(color: Colors.orange)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          backgroundColor:
                              const MaterialStatePropertyAll<Color>(
                                  Colors.orange)),
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class User {
  late final int index;
  late final String name;
  late final String id;

  User({required this.index, required this.name, required this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      index: json['index'] as int,
      name: json['name'] as String,
      id: json['_id'] as String,
    );
  }
}

Future<http.Response> registerUser(String index, String password) async {
  return await http.post(
    Uri.parse('http://192.168.8.100:3000/register'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'index': index,
      'password': password,
    }),
  );
}
