import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api_manager.dart';
import 'user_manager.dart';

class AuthPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _authenticate(BuildContext context) async {
    final apiManager = Provider.of<ApiManager>(context, listen: false);
    final userManager = Provider.of<UserManager>(context, listen: false);

    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      final token = await apiManager.authenticate(username, password);
      userManager.setAuthToken(token);
      Navigator.pushReplacementNamed(context, '/userList');
    } catch (e) {
      print('Authentication failed. Error: $e');
      // Handle authentication failure
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page',
            style:
                TextStyle(color: Colors.white)), // Change text color to white
        backgroundColor: Colors.blue, // Change app bar color to blue
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _authenticate(context),
              child: Text('Login'),
              // Change button style to match the theme
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Change button color to green
                onPrimary: Colors.white, // Change text color to white
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: Text('Register'),
              // Change button style to match the theme
              style: ElevatedButton.styleFrom(
                primary: Colors.orange, // Change button color to orange
                onPrimary: Colors.white, // Change text color to white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
