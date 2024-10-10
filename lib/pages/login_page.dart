import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For local storage
import 'package:http/http.dart' as http; // For API calls
import 'dart:convert'; // For JSON encoding/decoding
import 'home_screen.dart';
import 'create_account_page.dart'; // Import the Create Account page

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _identifier = ''; // This will be either email or username
  String _password = '';

  // Function to make the API call to your server
  Future<void> _submitLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final url = Uri.parse('http://apistarbook.duckdns.org:5000/login');

      try {
        final response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'Identifier': _identifier, // Send Identifier (either email or username)
            'Password': _password,
          }),
        );

        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200) {
          final responseBody = json.decode(response.body);

          if (responseBody['UserID'] != null) {
            final userid = responseBody['UserID'];

            // Fetch the username after login
            final usernameResponse = await http.get(
              Uri.parse('http://apistarbook.duckdns.org:5000/get_username/$userid'),
            );

            if (usernameResponse.statusCode == 200) {
              final username = json.decode(usernameResponse.body)['Username'];

              // Save login state, UserID, email, and username locally using SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', true);
              await prefs.setString('userEmail', _identifier); // Save email/identifier locally
              await prefs.setString('userId', userid); // Save UserID
              await prefs.setString('username', username); // Save Username

              // Navigate to the HomeScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to retrieve username')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login failed: Invalid credentials')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${json.decode(response.body)['error']}')),
          );
        }
      } catch (error) {
        print('Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $error')),
        );
      }
    }
  }

  void _navigateToCreateAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateAccountPage()), // Navigate to Create Account page
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email or Username'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your email or username' : null,
                    onSaved: (value) => _identifier = value!, // Save either email or username
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your password' : null,
                    onSaved: (value) => _password = value!,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitLogin,
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _navigateToCreateAccount, // Button to navigate to Create Account page
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
