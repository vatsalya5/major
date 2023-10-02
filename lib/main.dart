import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AttendanceApp());

}

class AttendanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Attendance App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );

  }
}


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<UserCredential> _signInWithEmailAndPassword() async {
    return await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  Future<UserCredential> _signUpWithEmailAndPassword() async {
    return await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }
  Future<void> _signOut() async {
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Login'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _signOut().then((_) {
                // Navigate back to the login page here.
                Navigator.pop(context);
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              child: Text('Sign in'),
              onPressed: () {
                _signInWithEmailAndPassword().then((UserCredential user) {
                  print(user);
                  // Navigate to your attendance page here.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AttendancePage()),
                  );
                });
              },
            ),
            ElevatedButton(
              child: Text('Sign up'),
              onPressed: () {
                _signUpWithEmailAndPassword().then((UserCredential user) {
                  print(user);
                  // Navigate to your attendance page here.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AttendancePage()),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Your AttendancePage code goes here.

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final databaseReference = FirebaseDatabase.instance.reference();

  // Initialize your variables here
  List<String> Subject = ['Subject1', 'Subject2', 'Subject3']; // Replace with your subjects
  Map<String, bool> attendance = {};

  @override
  void initState() {
    super.initState();
    // Initialize attendance map
    for (var subject in Subject) {
      attendance[subject] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Add your logout logic here
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: Subject.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(Subject[index]),
            value: attendance[Subject[index]],
            onChanged: (value) {
              setState(() {
                attendance[Subject[index]] = value!;
                databaseReference.child('attendance').child("3rUpu0hXeZTYv1as7SQg").set({'value': value});
              });
            },
          );
        },
      ),
    );
  }
}
