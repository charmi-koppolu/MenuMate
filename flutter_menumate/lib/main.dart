// import 'dart:io';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'home_page.dart';
// import 'register_page.dart';
//
// const TextStyle appBarTextStyle = TextStyle(
//   fontSize: 24,
//   fontWeight: FontWeight.bold,
//   color: Colors.white,
// );
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('📩 [BG] Message ID: ${message.messageId}');
//   print('📩 [BG] Data: ${message.data}');
// }
//
// FirebaseMessaging messaging = FirebaseMessaging.instance;
//
// final FlutterSecureStorage secureStorage = FlutterSecureStorage();
// Future<void> initFcmAndHandleToken() async {
//   NotificationSettings settings = await messaging.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//
//   if (Platform.isAndroid) {
//     if (await Permission.notification.isDenied) {
//       await Permission.notification.request();
//     }
//   }
//
//   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//     await saveFcmToken(); // Merged into one
//
// FirebaseMessaging.onMessage.listen((message) {
//       print('📥 [FOREGROUND] Message: ${message.notification?.title}');
//       print('📦 [NOTIFICATION] Full message: ${message.toMap()}');
//       _showLocalNotification(message);
//     });
//
//     print('✅ [FCM] onMessage listener ATTACHED because authorization was granted.');
//
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       print('📲 [OPENED] App opened via notification: ${message.data}');
//       print('📲 [OPENED] Notification tapped');
//       print('📦 [NOTIFICATION] Full message: ${message.toMap()}');
//     });
//   } else {
//     print('🚫 [FCM] Permission denied');
//   }
// }
//
// Future<void> saveFcmToken() async {
//   final fcmToken = await messaging.getToken();
//   print('🔑 [FCM] Token: $fcmToken');
//
//   if (fcmToken == null) return;
//
//   final storedToken = await secureStorage.read(key: 'fcmToken');
//
//   if (storedToken != fcmToken) {
//     await secureStorage.write(key: 'fcmToken', value: fcmToken);
//     print('🔄 [FCM] Token updated in secure storage');
//   } else {
//     print('✅ [FCM] Token already up-to-date');
//   }
// }
//
// Future<void> _showLocalNotification(RemoteMessage message) async {
//   print("⚡ Notification function called!");
//   print("🔔 Title: ${message.notification?.title}");
//   print("📜 Body: ${message.notification?.body}");
//   print("🚀 Showing notification...");
//   const androidDetails = AndroidNotificationDetails(
//     'default_channel_id',
//     'Default Channel',
//     channelDescription: 'For general notifications',
//     importance: Importance.max,
//     priority: Priority.high,
//   );
//   const notificationDetails = NotificationDetails(android: androidDetails);
//
//   await flutterLocalNotificationsPlugin.show(
//     message.notification.hashCode,
//     message.notification?.title ?? 'No Title',
//     message.notification?.body ?? 'No Body',
//     notificationDetails,
//   );
// }
//
//
// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await AuthManager.initialize();
// //   runApp(const MyApp());
// // }
//
// Future<void> main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await AuthManager.initialize();
//
//   await Firebase.initializeApp();
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//   const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//   const initSettings = InitializationSettings(android: androidInit);
//   await flutterLocalNotificationsPlugin.initialize(initSettings);
//
//   await flutterLocalNotificationsPlugin.initialize(
//     initSettings,
//     onDidReceiveNotificationResponse: (NotificationResponse response) async {
//       print("🔍 Notification tapped! Payload: ${response.payload}");
//     },
//   );
//
//   await initFcmAndHandleToken();
//
//   FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
//     print("🔁 [FCM] Token refreshed: $newToken");
//
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getString('userId');
// if (userId != null && userId.isNotEmpty) {
//       await secureStorage.write(key: 'fcmToken', value: newToken);
//       await sendFcmTokenToBackend(newToken);
//       print("✅ [FCM] Refreshed token saved and sent to backend");
//     } else {
//       print("⚠️ [FCM] Refreshed token available but userId not found");
//     }
//   });
//
//
//   runApp(const MyApp());
// }
//
// Future<void> sendFcmTokenToBackend(String fcmToken) async {
//   final uri = Uri.parse('http://10.0.2.2:8000/user/update/');
//   final body = jsonEncode({
//     'fcm_token': fcmToken,
//   });
//
//   final prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString("jwt");
// try {
//     final response = await http.patch(
//       uri,
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization" : "Bearer $token"
//       },
//       body: body,
//     );
//
//     if (response.statusCode == 200) {
//       print("✅ [FCM] Token successfully updated on backend");
//     } else {
//       print("⚠️ [FCM] Failed to update token: ${response.statusCode} - ${response.body}");
//     }
//   } catch (e) {
//     print("❌ [FCM] Exception while sending token to backend: $e");
//   }
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'MenuMate',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade900),
//         useMaterial3: true,
//       ),
//       home: const AuthWrapper(),
//       routes: {
//         // '/': (context) => const AuthWrapper(),
//         '/welcome': (context) => const WelcomePage(),
//         '/login': (context) => const LoginPage(),
//         '/register': (context) => const RegisterPage(),
//       },
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class AuthWrapper extends StatefulWidget {
//   const AuthWrapper({super.key});
//
//   @override
//   State<AuthWrapper> createState() => _AuthWrapperState();
// }
//
// class _AuthWrapperState extends State<AuthWrapper> {
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkAuthStatus();
//   }
//
//   Future<void> _checkAuthStatus() async {
//     setState(() => isLoading = true);
//     await AuthManager.loadAuthData();
//     setState(() => isLoading = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }
//
//     if (AuthManager.isLoggedIn()) {
//       return HomePage(uid: AuthManager.uid!, jwt: AuthManager.jwt!);
//     }
//
//     return const WelcomePage();
//   }
// }
//
// class WelcomePage extends StatelessWidget {
//   const WelcomePage({super.key});
//
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
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool isLoading = false;
//
//   Future<void> handleLogin() async {
//     print("111");
//     final String email = emailController.text.trim();
//     final String password = passwordController.text.trim();
//
//     if (email.isEmpty || password.isEmpty) {
//       _showSnackBar('Please fill in all fields');
//       return;
//     }
//
//     setState(() => isLoading = true);
//
//     final Uri url = Uri.parse('http://10.0.2.2:8000/user/login/');
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'email': email, 'password': password}),
//       );
//       print(response.statusCode);
//       print(response.body);
//       print(url);
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         await AuthManager.saveAuthData(data['uid'], data['jwt_token']);
//         await saveFcmToken();
//         final fcmToken = await messaging.getToken();
//           if (fcmToken != null) {
//             await sendFcmTokenToBackend(fcmToken);
//           }
//
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (context) => HomePage(
//               uid: data['uid'],
//               jwt: data['jwt_token'],
//             ),
//           ),
//           (route) => false,
//         );
//       } else {
//         final errorData = jsonDecode(response.body);
//         _showSnackBar(errorData['message'] ?? 'Login failed');
//       }
//     } catch (e) {
//       _showSnackBar('Network error. Please try again.');
//       print(e);
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
//
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
//
// class AuthManager {
//   static String? uid;
//   static String? jwt;
//   static BuildContext? _context;
//
//   static Future<void> initialize() async {
//     await loadAuthData();
//   }
//
//   static Future<void> saveAuthData(String newUid, String newJwt) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('uid', newUid);
//     await prefs.setString('jwt', newJwt);
//     uid = newUid;
//     jwt = newJwt;
//   }
//
//   static Future<void> loadAuthData() async {
//     final prefs = await SharedPreferences.getInstance();
//     uid = prefs.getString('uid');
//     jwt = prefs.getString('jwt');
//   }
//
//   static Future<void> clearAuthData() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('uid');
//     await prefs.remove('jwt');
//     uid = null;
//     jwt = null;
//     if (_context != null) {
//       Navigator.of(_context!).pushNamedAndRemoveUntil('/welcome', (route) => false);
//     }
//   }
//
//   static bool isLoggedIn() {
//     return uid != null && jwt != null;
//   }
//
//   static Map<String, String> getAuthHeader() {
//     return {
//       'Authorization': 'Bearer $jwt',
//       'Content-Type': 'application/json',
//     };
//   }
//
//   static void setContext(BuildContext context) {
//     _context = context;
//   }
// }




import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'register_page.dart';

const TextStyle appBarTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📩 [BG] Message ID: ${message.messageId}');
  print('📩 [BG] Data: ${message.data}');
}

FirebaseMessaging messaging = FirebaseMessaging.instance;

final FlutterSecureStorage secureStorage = FlutterSecureStorage();
Future<void> initFcmAndHandleToken() async {
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (Platform.isAndroid) {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    await saveFcmToken(); // Merged into one

    FirebaseMessaging.onMessage.listen((message) {
      print('📥 [FOREGROUND] Message: ${message.notification?.title}');
      print('📦 [NOTIFICATION] Full message: ${message.toMap()}');
      _showLocalNotification(message);
    });

    print('✅ [FCM] onMessage listener ATTACHED because authorization was granted.');

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('📲 [OPENED] App opened via notification: ${message.data}');
      print('📲 [OPENED] Notification tapped');
      print('📦 [NOTIFICATION] Full message: ${message.toMap()}');
    });
  } else {
    print('🚫 [FCM] Permission denied');
  }
}

Future<void> saveFcmToken() async {
  final fcmToken = await messaging.getToken();
  print('🔑 [FCM] Token: $fcmToken');

  if (fcmToken == null) return;

  final storedToken = await secureStorage.read(key: 'fcmToken');

  if (storedToken != fcmToken) {
    await secureStorage.write(key: 'fcmToken', value: fcmToken);
    print('🔄 [FCM] Token updated in secure storage');
  } else {
    print('✅ [FCM] Token already up-to-date');
  }
}

Future<void> _showLocalNotification(RemoteMessage message) async {
  print("⚡ Notification function called!");
  print("🔔 Title: ${message.notification?.title}");
  print("📜 Body: ${message.notification?.body}");
  print("🚀 Showing notification...");
  const androidDetails = AndroidNotificationDetails(
    'default_channel_id',
    'Default Channel',
    channelDescription: 'For general notifications',
    importance: Importance.max,
    priority: Priority.high,
  );
  const notificationDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    message.notification.hashCode,
    message.notification?.title ?? 'No Title',
    message.notification?.body ?? 'No Body',
    notificationDetails,
  );
}


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await AuthManager.initialize();
//   runApp(const MyApp());
// }

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await AuthManager.initialize();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      print("🔍 Notification tapped! Payload: ${response.payload}");
    },
  );

  await initFcmAndHandleToken();

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    print("🔁 [FCM] Token refreshed: $newToken");

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null && userId.isNotEmpty) {
      await secureStorage.write(key: 'fcmToken', value: newToken);
      await sendFcmTokenToBackend(newToken);
      print("✅ [FCM] Refreshed token saved and sent to backend");
    } else {
      print("⚠️ [FCM] Refreshed token available but userId not found");
    }
  });


  runApp(const MyApp());
}

Future<void> sendFcmTokenToBackend(String fcmToken) async {
  final uri = Uri.parse('http://10.0.2.2:8000/user/update/');
  final body = jsonEncode({
    'fcm_token': fcmToken,
  });

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("jwt");
  try {
    final response = await http.patch(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization" : "Bearer $token"
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print("✅ [FCM] Token successfully updated on backend");
    } else {
      print("⚠️ [FCM] Failed to update token: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("❌ [FCM] Exception while sending token to backend: $e");
  }
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
        // '/': (context) => const AuthWrapper(),
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

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    setState(() => isLoading = true);
    await AuthManager.loadAuthData();
    setState(() => isLoading = false);
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

    if (AuthManager.isLoggedIn()) {
      return HomePage(uid: AuthManager.uid!, jwt: AuthManager.jwt!);
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
    print("111");
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill in all fields');
      return;
    }

    setState(() => isLoading = true);

    final Uri url = Uri.parse('http://10.0.2.2:8000/user/login/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      print(response.statusCode);
      print(response.body);
      print(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await AuthManager.saveAuthData(data['uid'], data['jwt_token']);
        await saveFcmToken();
        final fcmToken = await messaging.getToken();
        if (fcmToken != null) {
          await sendFcmTokenToBackend(fcmToken);
        }

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              uid: data['uid'],
              jwt: data['jwt_token'],
            ),
          ),
              (route) => false,
        );
      } else {
        final errorData = jsonDecode(response.body);
        _showSnackBar(errorData['message'] ?? 'Login failed');
      }
    } catch (e) {
      _showSnackBar('Network error. Please try again.');
      print(e);
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

class AuthManager {
  static String? uid;
  static String? jwt;
  static BuildContext? _context;

  static Future<void> initialize() async {
    await loadAuthData();
  }

  static Future<void> saveAuthData(String newUid, String newJwt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', newUid);
    await prefs.setString('jwt', newJwt);
    uid = newUid;
    jwt = newJwt;
  }

  static Future<void> loadAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    jwt = prefs.getString('jwt');
  }

  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    await prefs.remove('jwt');
    uid = null;
    jwt = null;
    if (_context != null) {
      Navigator.of(_context!).pushNamedAndRemoveUntil('/welcome', (route) => false);
    }
  }

  static bool isLoggedIn() {
    return uid != null && jwt != null;
  }

  static Map<String, String> getAuthHeader() {
    return {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };
  }

  static void setContext(BuildContext context) {
    _context = context;
  }
}