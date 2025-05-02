import 'package:flutter/material.dart';
import 'package:releaf/UI/Home/homepage.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() {
    // Basic validation
    if (_emailController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Add your sign-up logic here (e.g., API call)
    print('Email: ${_emailController.text}');
    print('Username: ${_usernameController.text}');
    print('Password: ${_passwordController.text}');

    // Navigate to Homepage after successful sign-up
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Homepage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5EC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Releaf logo at the top
              Container(
                height: 300,
                width: 330,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("assets/Releaf.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),

              TextField(
                cursorColor: const Color(0xFF609254),
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'treelover',
                  prefixIcon: Icon(Icons.person_outline),
                  labelStyle: const TextStyle(color: Colors.grey),
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.green, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Email TextField
              TextField(
                cursorColor: const Color(0xFF609254),
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'example@gmail.com',
                  prefixIcon: Icon(Icons.email_outlined),
                  labelStyle: const TextStyle(color: Colors.grey),
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.green, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.green, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.green, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Username TextField

              // Password TextField
              TextField(
                cursorColor: const Color(0xFF609254),
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: '••••••••',
                  prefixIcon: Icon(Icons.lock_outline),
                  labelStyle: const TextStyle(color: Colors.grey),
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.green, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.green, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.green, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Sign Up Button
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B812A),
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ))),
              const SizedBox(height: 20),

              // Sign In Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Sign In page (to be implemented)
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Homepage()),
                      );
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        color: Color(0xFF3B812A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
