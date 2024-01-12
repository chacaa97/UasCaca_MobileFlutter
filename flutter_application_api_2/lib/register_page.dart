import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'api_manager.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register(BuildContext context) async {
    final apiManager = Provider.of<ApiManager>(context, listen: false);

    final name = _nameController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      await apiManager.register(name, username, password);
      // Show a toast on successful registration

      Navigator.pushReplacementNamed(context, '/');
      // Handle successful registration
    } catch (e) {
      print('Registration failed. Error: $e');
      // Handle registration failure
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Page', style: TextStyle(color: Colors.white)), // Change text color to white
        backgroundColor: Color.fromARGB(255, 36, 79, 252), // Change app bar color to purple
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add a Padding widget with EdgeInsets 10
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  // Change label color to blue
                  labelStyle: TextStyle(color: Colors.blue),
                  // Change border color to blue
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),
            // Add a Padding widget with EdgeInsets 10
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  // Change label color to red
                  labelStyle: TextStyle(color: Colors.red),
                  // Change border color to red
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ),
            // Add a Padding widget with EdgeInsets 10
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  // Change label color to orange
                  labelStyle: TextStyle(color: Colors.orange),
                  // Change border color to orange
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _register(context),
              child: Text('Register'),
              // Change button style to match the theme
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Change button color to green
                onPrimary: Color.fromARGB(255, 255, 255, 255), // Change text color to white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
