// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'home_page.dart';

// const TextStyle appBarTextStyle = TextStyle(
//   fontSize: 24,
//   fontWeight: FontWeight.bold,
//   color: Colors.white,
// );

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'MenuMate',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade900),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'MSU MenuMate'),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   Future<void> handleLogin() async {
//     final String email = emailController.text.trim();
//     final String password = passwordController.text.trim();
//     final Uri url = Uri.parse('http://127.0.0.1:8000/user/login/');

//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'email': email, 'password': password}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => HomePage(
//               uid: data['uid'],
//               jwt: data['jwt_token'],
//             ),
//           ),
//         );
//       } else {
//         print("❌ Login failed: ${response.statusCode}");
//         print(response.body);
//       }
//     } catch (e) {
//       print("❌ Error during login: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 12, 97, 15),
//         title: Text(
//           widget.title,
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
//                 Image.asset(
//                   'assets/msu logo.png',
//                   width: 300,
//                   height: 300,
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Login to MenuMate',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 30),
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
//                   controller: passwordController,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Password',
//                     prefixIcon: Icon(Icons.lock),
//                   ),
//                   obscureText: true,
//                 ),
//                 const SizedBox(height: 30),
//                 ElevatedButton(
//                   onPressed: handleLogin,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green[800],
//                     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                   ),
//                   child: const Text(
//                     'Login',
//                     style: TextStyle(fontSize: 16, color: Colors.white),
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






// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'home_page.dart';
// import 'register_page.dart';

// const TextStyle appBarTextStyle = TextStyle(
//   fontSize: 24,
//   fontWeight: FontWeight.bold,
//   color: Colors.white,
// );

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'MenuMate',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade900),
//         useMaterial3: true,
//       ),
//       home: const WelcomePage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class WelcomePage extends StatelessWidget {
//   const WelcomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 12, 97, 15),
//         title: const Text(
//           'MSU MenuMate',
//           style: appBarTextStyle,
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Image.asset(
//                 'assets/msu logo.png',
//                 width: 300,
//                 height: 300,
//               ),
//               const SizedBox(height: 40),
//               const Text(
//                 'Welcome to MenuMate',
//                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Michigan State University',
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//               const SizedBox(height: 50),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const LoginPage()),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green[800],
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                   ),
//                   child: const Text(
//                     'Login',
//                     style: TextStyle(fontSize: 16, color: Colors.white),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               SizedBox(
//                 width: double.infinity,
//                 child: OutlinedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const RegisterPage()),
//                     );
//                   },
//                   style: OutlinedButton.styleFrom(
//                     side: BorderSide(color: Colors.green[800]!),
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                   ),
//                   child: Text(
//                     'Create Account',
//                     style: TextStyle(fontSize: 16, color: Colors.green[800]),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool isLoading = false;

//   Future<void> handleLogin() async {
//     final String email = emailController.text.trim();
//     final String password = passwordController.text.trim();

//     if (email.isEmpty || password.isEmpty) {
//       _showSnackBar('Please fill in all fields');
//       return;
//     }

//     setState(() => isLoading = true);

//     final Uri url = Uri.parse('http://127.0.0.1:8000/user/login/');

//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'email': email, 'password': password}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => HomePage(
//               uid: data['uid'],
//               jwt: data['jwt_token'],
//             ),
//           ),
//         );
//       } else {
//         final errorData = jsonDecode(response.body);
//         _showSnackBar(errorData['message'] ?? 'Login failed');
//       }
//     } catch (e) {
//       _showSnackBar('Network error. Please try again.');
//     } finally {
//       setState(() => isLoading = false);
//     }
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
//           'Login',
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
//                   'Welcome Back!',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 30),
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
//                   controller: passwordController,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Password',
//                     prefixIcon: Icon(Icons.lock),
//                   ),
//                   obscureText: true,
//                 ),
//                 const SizedBox(height: 30),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: isLoading ? null : handleLogin,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green[800],
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                     ),
//                     child: isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                             'Login',
//                             style: TextStyle(fontSize: 16, color: Colors.white),
//                           ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (context) => const RegisterPage()),
//                     );
//                   },
//                   child: Text(
//                     "Don't have an account? Sign up",
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





// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'home_page.dart';
// import 'register_page.dart';

// const TextStyle appBarTextStyle = TextStyle(
//   fontSize: 24,
//   fontWeight: FontWeight.bold,
//   color: Colors.white,
// );

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'MenuMate',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade900),
//         useMaterial3: true,
//       ),
//       home: const AuthWrapper(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class AuthWrapper extends StatefulWidget {
//   const AuthWrapper({super.key});

//   @override
//   State<AuthWrapper> createState() => _AuthWrapperState();
// }

// class _AuthWrapperState extends State<AuthWrapper> {
//   bool isLoading = true;
//   bool isLoggedIn = false;
//   String? uid;
//   String? jwt;

//   @override
//   void initState() {
//     super.initState();
//     _checkAuthStatus();
//   }

//   Future<void> _checkAuthStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedUid = prefs.getString('uid');
//     final savedJwt = prefs.getString('jwt_token');

//     if (savedUid != null && savedJwt != null) {
//       setState(() {
//         uid = savedUid;
//         jwt = savedJwt;
//         isLoggedIn = true;
//         isLoading = false;
//       });
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     if (isLoggedIn && uid != null && jwt != null) {
//       return HomePage(uid: uid!, jwt: jwt!);
//     }

//     return const WelcomePage();
//   }
// }

// class WelcomePage extends StatelessWidget {
//   const WelcomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 12, 97, 15),
//         title: const Text(
//           'MSU MenuMate',
//           style: appBarTextStyle,
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Image.asset(
//                 'assets/msu logo.png',
//                 width: 300,
//                 height: 300,
//               ),
//               const SizedBox(height: 40),
//               const Text(
//                 'Welcome to MenuMate',
//                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Michigan State University',
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//               const SizedBox(height: 50),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const LoginPage()),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green[800],
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                   ),
//                   child: const Text(
//                     'Login',
//                     style: TextStyle(fontSize: 16, color: Colors.white),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               SizedBox(
//                 width: double.infinity,
//                 child: OutlinedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const RegisterPage()),
//                     );
//                   },
//                   style: OutlinedButton.styleFrom(
//                     side: BorderSide(color: Colors.green[800]!),
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                   ),
//                   child: Text(
//                     'Create Account',
//                     style: TextStyle(fontSize: 16, color: Colors.green[800]),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool isLoading = false;

//   Future<void> handleLogin() async {
//     final String email = emailController.text.trim();
//     final String password = passwordController.text.trim();

//     if (email.isEmpty || password.isEmpty) {
//       _showSnackBar('Please fill in all fields');
//       return;
//     }

//     setState(() => isLoading = true);

//     final Uri url = Uri.parse('http://127.0.0.1:8000/user/login/');

//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'email': email, 'password': password}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
        
//         // Save authentication data to SharedPreferences
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('uid', data['uid']);
//         await prefs.setString('jwt_token', data['jwt_token']);
        
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (context) => HomePage(
//               uid: data['uid'],
//               jwt: data['jwt_token'],
//             ),
//           ),
//           (route) => false, // Remove all previous routes
//         );
//       } else {
//         final errorData = jsonDecode(response.body);
//         _showSnackBar(errorData['message'] ?? 'Login failed');
//       }
//     } catch (e) {
//       _showSnackBar('Network error. Please try again.');
//     } finally {
//       setState(() => isLoading = false);
//     }
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
//           'Login',
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
//                   'Welcome Back!',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 30),
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
//                   controller: passwordController,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Password',
//                     prefixIcon: Icon(Icons.lock),
//                   ),
//                   obscureText: true,
//                 ),
//                 const SizedBox(height: 30),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: isLoading ? null : handleLogin,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green[800],
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                     ),
//                     child: isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                             'Login',
//                             style: TextStyle(fontSize: 16, color: Colors.white),
//                           ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (context) => const RegisterPage()),
//                     );
//                   },
//                   child: Text(
//                     "Don't have an account? Sign up",
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

// // Utility class for managing authentication state
// class AuthManager {
//   static Future<void> saveAuthData(String uid, String jwt) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('uid', uid);
//     await prefs.setString('jwt_token', jwt);
//   }

//   static Future<Map<String, String?>> getAuthData() async {
//     final prefs = await SharedPreferences.getInstance();
//     return {
//       'uid': prefs.getString('uid'),
//       'jwt_token': prefs.getString('jwt_token'),
//     };
//   }

//   static Future<void> clearAuthData() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('uid');
//     await prefs.remove('jwt_token');
//   }

//   static Future<bool> isLoggedIn() async {
//     final authData = await getAuthData();
//     return authData['uid'] != null && authData['jwt_token'] != null;
//   }
// }





import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart'; // Commented out temporarily
import 'home_page.dart';
import 'register_page.dart';

const TextStyle appBarTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MenuMate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade900),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
      routes: {
        '/': (context) => const AuthWrapper(),
        '/welcome': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isLoading = true;
  bool isLoggedIn = false;
  String? uid;
  String? jwt;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Temporary: Check in-memory storage
    final savedUid = AuthManager._uid;
    final savedJwt = AuthManager._jwt;

    if (savedUid != null && savedJwt != null) {
      setState(() {
        uid = savedUid;
        jwt = savedJwt;
        isLoggedIn = true;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (isLoggedIn && uid != null && jwt != null) {
      return HomePage(uid: uid!, jwt: jwt!);
    }

    return const WelcomePage();
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 12, 97, 15),
        title: const Text(
          'MSU MenuMate',
          style: appBarTextStyle,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/msu logo.png',
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 40),
              const Text(
                'Welcome to MenuMate',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Michigan State University',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800],
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.green[800]!),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    'Create Account',
                    style: TextStyle(fontSize: 16, color: Colors.green[800]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> handleLogin() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill in all fields');
      return;
    }

    setState(() => isLoading = true);

    final Uri url = Uri.parse('http://127.0.0.1:8000/user/login/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Save authentication data temporarily in memory
        AuthManager._uid = data['uid'];
        AuthManager._jwt = data['jwt_token'];
        
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              uid: data['uid'],
              jwt: data['jwt_token'],
            ),
          ),
          (route) => false, // Remove all previous routes
        );
      } else {
        final errorData = jsonDecode(response.body);
        _showSnackBar(errorData['message'] ?? 'Login failed');
      }
    } catch (e) {
      _showSnackBar('Network error. Please try again.');
    } finally {
      setState(() => isLoading = false);
    }
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
          'Login',
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
                  'Welcome Back!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
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
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Login',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                  child: Text(
                    "Don't have an account? Sign up",
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

// Utility class for managing authentication state
class AuthManager {
  static String? _uid;
  static String? _jwt;

  static void saveAuthData(String uid, String jwt) {
    _uid = uid;
    _jwt = jwt;
  }

  static Map<String, String?> getAuthData() {
    return {
      'uid': _uid,
      'jwt_token': _jwt,
    };
  }

  static void clearAuthData() {
    _uid = null;
    _jwt = null;
  }

  static bool isLoggedIn() {
    return _uid != null && _jwt != null;
  }
}