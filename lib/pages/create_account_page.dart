import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _reenteredPassword = '';
  String _username = ''; // Add username

  Future<void> _submitCreateAccount() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_password == _reenteredPassword) {
        // Send data to your server to create an account
        bool success = await _createAccountOnServer(_username, _email, _password);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account created and logged in successfully!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account creation failed')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
      }
    }
  }

  Future<bool> _createAccountOnServer(String username, String email, String password) async {
    final url = Uri.parse('http://apistarbook.duckdns.org:5000/register');
    
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'Username': username,
          'Password': password,
          'email': email,
        }),
      );

      print('Registration Status Code: ${response.statusCode}');
      print('Registration Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final userid = responseBody['UserID'];

        // Save login state and user info in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userEmail', email);
        await prefs.setString('userId', userid.toString());
        await prefs.setString('username', username);

        return true; // Account created successfully, logged in
      } else if (response.statusCode == 409) {
        final responseBody = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody['error'])),
        );
        return false;
      } else {
        return false;
      }
    } catch (error) {
      print('Registration Error: $error');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) => value!.isEmpty ? 'Please enter a username' : null,
                onSaved: (value) => _username = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Please enter your password' : null,
                onSaved: (value) => _password = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Re-enter Password'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Please re-enter your password' : null,
                onSaved: (value) => _reenteredPassword = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitCreateAccount,
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
