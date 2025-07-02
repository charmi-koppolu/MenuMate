// import 'package:flutter/material.dart';

// const TextStyle appBarTextStyle = TextStyle(
//   fontSize: 24,
//   fontWeight: FontWeight.bold,
//   color: Colors.white,
// );

// class DiningHallPage extends StatelessWidget {
//   final String diningHallName;

//   const DiningHallPage({super.key, required this.diningHallName});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(diningHallName, style: appBarTextStyle),
//         backgroundColor: const Color.fromARGB(255, 12, 97, 15),
//       ),
//       body: Center(
//         child: Text(
//           'Welcome to $diningHallName!',
//           style: const TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }






// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// const TextStyle appBarTextStyle = TextStyle(
//   fontSize: 24,
//   fontWeight: FontWeight.bold,
//   color: Colors.white,
// );

// class DiningHallPage extends StatefulWidget {
//   final String diningHallName;

//   const DiningHallPage({super.key, required this.diningHallName});

//   @override
//   State<DiningHallPage> createState() => _DiningHallPageState();
// }

// class _DiningHallPageState extends State<DiningHallPage> {
//   Map<String, dynamic>? diningHallData;
//   bool isLoading = true;
//   String? errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     fetchDiningHallData();
//   }

//   Future<void> fetchDiningHallData() async {
//     try {
//       setState(() {
//         isLoading = true;
//         errorMessage = null;
//       });

//       final response = await http.get(
//         Uri.parse('http://127.0.0.1:8000/dining/get_dining_hall/${widget.diningHallName}'),
//         headers: {
//           'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYjM5MjlhYmItOWI5ZC00NmRiLTkxMmEtODQzZGQyMDA2ZDM2IiwiZXhwIjoxNzUxNDIwMzYzLCJpYXQiOjE3NTE0MTY3NjN9.h7Gmtx4h5natlS412UE7x4slfvclq25S5Jku4j4NMUM',
//         },
//       );

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         if (jsonData['status'] == 'Success') {
//           setState(() {
//             diningHallData = jsonData['message'];
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             errorMessage = 'Failed to load dining hall data';
//             isLoading = false;
//           });
//         }
//       } else {
//         setState(() {
//           errorMessage = 'Server error: ${response.statusCode}';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Network error: $e';
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.diningHallName, style: appBarTextStyle),
//         backgroundColor: const Color.fromARGB(255, 12, 97, 15),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : errorMessage != null
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.error_outline,
//                         size: 64,
//                         color: Colors.red[300],
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'Error loading menu',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red[700],
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         errorMessage!,
//                         style: const TextStyle(fontSize: 16),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: fetchDiningHallData,
//                         child: const Text('Retry'),
//                       ),
//                     ],
//                   ),
//                 )
//               : diningHallData != null
//                   ? RefreshIndicator(
//                       onRefresh: fetchDiningHallData,
//                       child: ListView(
//                         padding: const EdgeInsets.all(16),
//                         children: [
//                           // Header with dining hall name
//                           Card(
//                             elevation: 4,
//                             child: Padding(
//                               padding: const EdgeInsets.all(16),
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     'Welcome to ${diningHallData!['name']}!',
//                                     style: const TextStyle(
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold,
//                                       color: Color.fromARGB(255, 12, 97, 15),
//                                     ),
//                                   ),
//                                   if (diningHallData!['date'] != null && diningHallData!['date'].toString().isNotEmpty)
//                                     Padding(
//                                       padding: const EdgeInsets.only(top: 8),
//                                       child: Text(
//                                         'Menu for ${diningHallData!['date']}',
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           color: Colors.grey[600],
//                                         ),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
                          
//                           // Menu sections
//                           ...buildMenuSections(),
//                         ],
//                       ),
//                     )
//                   : const Center(
//                       child: Text(
//                         'No data available',
//                         style: TextStyle(fontSize: 18),
//                       ),
//                     ),
//     );
//   }

//   List<Widget> buildMenuSections() {
//     if (diningHallData == null) return [];

//     final sections = diningHallData!['sections'] as Map<String, dynamic>?;
//     final menuItems = diningHallData!['menu_items'] as Map<String, dynamic>?;

//     if (sections == null || menuItems == null) return [];

//     List<Widget> sectionWidgets = [];

//     sections.forEach((sectionName, description) {
//       final items = menuItems[sectionName] as List<dynamic>?;
      
//       // Skip sections with no items or empty descriptions
//       if (items == null || items.isEmpty) return;

//       sectionWidgets.add(
//         Card(
//           elevation: 2,
//           margin: const EdgeInsets.only(bottom: 16),
//           child: ExpansionTile(
//             title: Text(
//               sectionName,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Color.fromARGB(255, 12, 97, 15),
//               ),
//             ),
//             subtitle: description.toString().isNotEmpty
//                 ? Padding(
//                     padding: const EdgeInsets.only(top: 4),
//                     child: Text(
//                       description.toString(),
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   )
//                 : null,
//             initiallyExpanded: false,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ...items.map((item) => Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 4),
//                           child: Row(
//                             children: [
//                               const Icon(
//                                 Icons.restaurant_menu,
//                                 size: 16,
//                                 color: Color.fromARGB(255, 12, 97, 15),
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   item.toString(),
//                                   style: const TextStyle(fontSize: 16),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )),
//                     const SizedBox(height: 8),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });

//     return sectionWidgets;
//   }
// }





import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart'; // Import to access AuthManager

const TextStyle appBarTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

class DiningHallPage extends StatefulWidget {
  final String diningHallName;
  final String? uid;
  final String? jwt;

  const DiningHallPage({
    super.key, 
    required this.diningHallName,
    this.uid,
    this.jwt,
  });

  @override
  State<DiningHallPage> createState() => _DiningHallPageState();
}

class _DiningHallPageState extends State<DiningHallPage> {
  Map<String, dynamic>? diningHallData;
  bool isLoading = true;
  String? errorMessage;
  String? currentJwt;
  String? currentUid;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
    fetchDiningHallData();
  }

  void _initializeAuth() {
    // Get auth data from AuthManager or use passed parameters
    final authData = AuthManager.getAuthData();
    currentJwt = widget.jwt ?? authData['jwt_token'];
    currentUid = widget.uid ?? authData['uid'];
  }

  Future<void> fetchDiningHallData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Check if we have a JWT token
      if (currentJwt == null || currentJwt!.isEmpty) {
        setState(() {
          errorMessage = 'Authentication token not found. Please login again.';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/dining/get_dining_hall/${widget.diningHallName}'),
        headers: {
          'Authorization': 'Bearer $currentJwt',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'Success') {
          setState(() {
            diningHallData = jsonData['message'];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Failed to load dining hall data: ${jsonData['message'] ?? 'Unknown error'}';
            isLoading = false;
          });
        }
      } else if (response.statusCode == 401) {
        // Token expired or invalid
        setState(() {
          errorMessage = 'Session expired. Please login again.';
          isLoading = false;
        });
        _handleAuthError();
      } else {
        setState(() {
          errorMessage = 'Server error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Network error: $e';
        isLoading = false;
      });
    }
  }

  void _handleAuthError() {
    // Clear stored auth data and navigate back to login
    AuthManager.clearAuthData();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.diningHallName, style: appBarTextStyle),
        backgroundColor: const Color.fromARGB(255, 12, 97, 15),
        actions: [
          // Add a logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading menu',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: fetchDiningHallData,
                            child: const Text('Retry'),
                          ),
                          if (errorMessage!.contains('login') || errorMessage!.contains('Session expired'))
                            const SizedBox(width: 10),
                          if (errorMessage!.contains('login') || errorMessage!.contains('Session expired'))
                            ElevatedButton(
                              onPressed: _handleAuthError,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[700],
                              ),
                              child: const Text(
                                'Login Again',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                )
              : diningHallData != null
                  ? RefreshIndicator(
                      onRefresh: fetchDiningHallData,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Header with dining hall name
                          Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Text(
                                    'Welcome to ${diningHallData!['name']}!',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 12, 97, 15),
                                    ),
                                  ),
                                  if (diningHallData!['date'] != null && diningHallData!['date'].toString().isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        'Menu for ${diningHallData!['date']}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  // Show current user info (optional)
                                  if (currentUid != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        'User ID: ${currentUid!.substring(0, 8)}...',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Menu sections
                          ...buildMenuSections(),
                        ],
                      ),
                    )
                  : const Center(
                      child: Text(
                        'No data available',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                AuthManager.clearAuthData();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> buildMenuSections() {
    if (diningHallData == null) return [];

    final sections = diningHallData!['sections'] as Map<String, dynamic>?;
    final menuItems = diningHallData!['menu_items'] as Map<String, dynamic>?;

    if (sections == null || menuItems == null) return [];

    List<Widget> sectionWidgets = [];

    sections.forEach((sectionName, description) {
      final items = menuItems[sectionName] as List<dynamic>?;
      
      // Skip sections with no items or empty descriptions
      if (items == null || items.isEmpty) return;

      sectionWidgets.add(
        Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            title: Text(
              sectionName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 12, 97, 15),
              ),
            ),
            subtitle: description.toString().isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      description.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                : null,
            initiallyExpanded: false,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.restaurant_menu,
                                size: 16,
                                color: Color.fromARGB(255, 12, 97, 15),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });

    return sectionWidgets;
  }
}