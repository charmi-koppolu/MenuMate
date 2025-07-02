// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'otp_verification_page.dart';

// const TextStyle appBarTextStyle = TextStyle(
//   fontSize: 24,
//   fontWeight: FontWeight.bold,
//   color: Colors.white,
// );

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();
//   final TextEditingController ageController = TextEditingController();
  
//   bool isLoading = false;
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;

//   Future<void> handleRegister() async {
//     final String username = usernameController.text.trim();
//     final String email = emailController.text.trim();
//     final String password = passwordController.text.trim();
//     final String confirmPassword = confirmPasswordController.text.trim();
//     final String ageText = ageController.text.trim();

//     // Validation
//     if (username.isEmpty || email.isEmpty || password.isEmpty || 
//         confirmPassword.isEmpty || ageText.isEmpty) {
//       _showSnackBar('Please fill in all fields');
//       return;
//     }

//     if (!_isValidEmail(email)) {
//       _showSnackBar('Please enter a valid email address');
//       return;
//     }

//     if (password != confirmPassword) {
//       _showSnackBar('Passwords do not match');
//       return;
//     }

//     if (password.length < 6) {
//       _showSnackBar('Password must be at least 6 characters long');
//       return;
//     }

//     int? age = int.tryParse(ageText);
//     if (age == null || age < 13 || age > 120) {
//       _showSnackBar('Please enter a valid age (13-120)');
//       return;
//     }

//     setState(() => isLoading = true);

//     try {
//       // First, register the user
//       final registerResponse = await _registerUser(username, email, password, age);
      
//       if (registerResponse) {
//         // If registration successful, send OTP
//         final otpResponse = await _sendOTP(email);
        
//         if (otpResponse) {
//           // Navigate to OTP verification page
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => OTPVerificationPage(email: email),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       _showSnackBar('Network error. Please try again.');
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Future<bool> _registerUser(String username, String email, String password, int age) async {
//     final Uri url = Uri.parse('http://127.0.0.1:8000/user/register/');

//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'username': username,
//           'email': email,
//           'password': password,
//           'age': age,
//           'fcm_token': 'default_token', // You can replace this with actual FCM token
//         }),
//       );

//       if (response.statusCode == 200) {
//         return true;
//       } else {
//         final errorData = jsonDecode(response.body);
//         _showSnackBar(errorData['message'] ?? 'Registration failed');
//         return false;
//       }
//     } catch (e) {
//       throw e;
//     }
//   }

//   Future<bool> _sendOTP(String email) async {
//     final Uri url = Uri.parse('http://127.0.0.1:8000/generate_otp/$email');

//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         _showSnackBar('OTP sent to your email');
//         return true;
//       } else {
//         final errorData = jsonDecode(response.body);
//         _showSnackBar(errorData['message'] ?? 'Failed to send OTP');
//         return false;
//       }
//     } catch (e) {
//       throw e;
//     }
//   }

//   bool _isValidEmail(String email) {
//     return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 12, 97, 15),
//         title: const Text(
//           'Create Account',
//           style: appBarTextStyle,
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 const Text(
//                   'Join MenuMate',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 30),
//                 TextField(
//                   controller: usernameController,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Username',
//                     prefixIcon: Icon(Icons.person),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 TextField(
//                   controller: emailController,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Email',
//                     prefixIcon: Icon(Icons.email),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//                 const SizedBox(height: 20),
//                 TextField(
//                   controller: ageController,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Age',
//                     prefixIcon: Icon(Icons.cake),
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 20),
//                 TextField(
//                   controller: passwordController,
//                   decoration: InputDecoration(
//                     border: const OutlineInputBorder(),
//                     labelText: 'Password',
//                     prefixIcon: const Icon(Icons.lock),
//                     suffixIcon: IconButton(
//                       icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
//                       onPressed: () {
//                         setState(() => _obscurePassword = !_obscurePassword);
//                       },
//                     ),
//                   ),
//                   obscureText: _obscurePassword,
//                 ),
//                 const SizedBox(height: 20),
//                 TextField(
//                   controller: confirmPasswordController,
//                   decoration: InputDecoration(
//                     border: const OutlineInputBorder(),
//                     labelText: 'Confirm Password',
//                     prefixIcon: const Icon(Icons.lock_outline),
//                     suffixIcon: IconButton(
//                       icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
//                       onPressed: () {
//                         setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
//                       },
//                     ),
//                   ),
//                   obscureText: _obscureConfirmPassword,
//                 ),
//                 const SizedBox(height: 30),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: isLoading ? null : handleRegister,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green[800],
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                     ),
//                     child: isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                             'Create Account',
//                             style: TextStyle(fontSize: 16, color: Colors.white),
//                           ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                     "Already have an account? Login",
//                     style: TextStyle(color: Colors.green[800]),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'otp_verification_page.dart';

const TextStyle appBarTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  
  bool isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> handleRegister() async {
    final String username = usernameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();
    final String ageText = ageController.text.trim();

    // Validation
    if (username.isEmpty || email.isEmpty || password.isEmpty || 
        confirmPassword.isEmpty || ageText.isEmpty) {
      _showSnackBar('Please fill in all fields');
      return;
    }

    if (!_isValidEmail(email)) {
      _showSnackBar('Please enter a valid email address');
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar('Passwords do not match');
      return;
    }

    if (password.length < 6) {
      _showSnackBar('Password must be at least 6 characters long');
      return;
    }

    int? age = int.tryParse(ageText);
    if (age == null || age < 13 || age > 120) {
      _showSnackBar('Please enter a valid age (13-120)');
      return;
    }

    setState(() => isLoading = true);

    try {
      // Send OTP first, don't register user yet
      final otpResponse = await _sendOTP(email);
      
      if (otpResponse) {
        // Navigate to OTP verification page with user data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerificationPage(
              email: email,
              userData: {
                'username': username,
                'email': email,
                'password': password,
                'age': age,
                'fcm_token': 'default_token', // You can replace this with actual FCM token
              },
            ),
          ),
        );
      }
    } catch (e) {
      _showSnackBar('Network error. Please try again.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<bool> _sendOTP(String email) async {
    final Uri url = Uri.parse('http://127.0.0.1:8000/generate_otp/$email');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        _showSnackBar('OTP sent to your email');
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        _showSnackBar(errorData['message'] ?? 'Failed to send OTP');
        return false;
      }
    } catch (e) {
      throw e;
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 12, 97, 15),
        title: const Text(
          'Create Account',
          style: appBarTextStyle,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Join MenuMate',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Age',
                    prefixIcon: Icon(Icons.cake),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                      },
                    ),
                  ),
                  obscureText: _obscureConfirmPassword,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Create Account',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Already have an account? Login",
                    style: TextStyle(color: Colors.green[800]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}