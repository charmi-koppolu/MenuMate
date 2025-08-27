// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dining_hall_page.dart';
// import 'main.dart'; // For AuthManager
//
// const TextStyle appBarTextStyle = TextStyle(
//   fontSize: 24,
//   fontWeight: FontWeight.bold,
//   color: Colors.white,
// );
//
// class HomePage extends StatefulWidget {
//   final String uid;
//   final String jwt;
//
//   const HomePage({super.key, required this.uid, required this.jwt});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   List<String> diningHalls = [];
//   List<Map<String, String>> favorites = [];
//   bool isLoading = true;
//   bool isFavoritesLoading = false;
//   int _selectedIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     AuthManager.setContext(context);
//     fetchDiningHalls();
//   }
//
//   Future<void> fetchDiningHalls() async {
//     final url = Uri.parse('http://10.0.2.2:8000/dining/get_all_dining_halls/');
//     try {
//       final response = await http.get(
//         url,
//         headers: AuthManager.getAuthHeader(),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final List<dynamic> halls = data['data']['dining_halls'];
//         setState(() {
//           diningHalls = halls.map((hall) => hall.toString()).toList();
//           isLoading = false;
//         });
//       } else {
//         print('❌ Failed to fetch dining halls: ${response.statusCode}');
//         setState(() => isLoading = false);
//       }
//     } catch (e) {
//       print('❌ Exception during fetch: $e');
//       setState(() => isLoading = false);
//     }
//   }
//
//   Future<void> fetchFavorites() async {
//     setState(() => isFavoritesLoading = true);
//
//     final url = Uri.parse('http://10.0.2.2:8000/favorites/get_all_favorites/');
//     try {
//       final response = await http.get(
//         url,
//         headers: AuthManager.getAuthHeader(),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final List<dynamic> favoritesData = data['data'];
//         setState(() {
//           favorites = favoritesData.map((fav) => {
//             'fid': fav['fid'].toString(),
//             'fname': fav['fname'].toString(),
//           }).toList();
//           isFavoritesLoading = false;
//         });
//       } else {
//         print('❌ Failed to fetch favorites: ${response.statusCode}');
//         setState(() => isFavoritesLoading = false);
//       }
//     } catch (e) {
//       print('❌ Exception during favorites fetch: $e');
//       setState(() => isFavoritesLoading = false);
//     }
//   }
//
//   Future<void> deleteFavorite(String fid, String fname) async {
//     final url = Uri.parse('http://10.0.2.2:8000/favorites/delete/$fid');
//     try {
//       final response = await http.delete(
//         url,
//         headers: AuthManager.getAuthHeader(),
//       );
//
//       if (response.statusCode == 200) {
//         // Remove the item from the local list and refresh UI
//         setState(() {
//           favorites.removeWhere((favorite) => favorite['fid'] == fid);
//         });
//
//         // Show success message
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Removed "$fname" from favorites'),
//               backgroundColor: Colors.green,
//               duration: const Duration(seconds: 2),
//             ),
//           );
//         }
//       } else {
//         print('❌ Failed to delete favorite: ${response.statusCode}');
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Failed to remove from favorites'),
//               backgroundColor: Colors.red,
//               duration: Duration(seconds: 2),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       print('❌ Exception during favorite deletion: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Error removing from favorites'),
//             backgroundColor: Colors.red,
//             duration: Duration(seconds: 2),
//           ),
//         );
//       }
//     }
//   }
//
//   Widget buildFavoritesPage() {
//     if (isFavoritesLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     if (favorites.isEmpty) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.favorite_border,
//               size: 64,
//               color: Colors.grey,
//             ),
//             SizedBox(height: 16),
//             Text(
//               'No favorites yet',
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.grey,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Add items to your favorites to see them here',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey,
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: favorites.length,
//       itemBuilder: (context, index) {
//         final favorite = favorites[index];
//         return Card(
//           margin: const EdgeInsets.only(bottom: 12),
//           elevation: 2,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: ListTile(
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 8,
//             ),
//             leading: Container(
//               width: 48,
//               height: 48,
//               decoration: BoxDecoration(
//                 color: Colors.green[100],
//                 borderRadius: BorderRadius.circular(24),
//               ),
//               child: Icon(
//                 Icons.favorite,
//                 color: Colors.green[700],
//                 size: 24,
//               ),
//             ),
//             title: Text(
//               favorite['fname']!,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Unfavorite button
//                 IconButton(
//                   icon: Icon(
//                     Icons.delete,
//                     color: Colors.red[600],
//                     size: 24,
//                   ),
//                   onPressed: () {
//                     // Show confirmation dialog
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: const Text('Remove Favorite'),
//                           content: Text('Remove "${favorite['fname']}" from your favorites?'),
//                           actions: [
//                             TextButton(
//                               onPressed: () => Navigator.of(context).pop(),
//                               child: const Text('Cancel'),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                                 deleteFavorite(favorite['fid']!, favorite['fname']!);
//                               },
//                               style: TextButton.styleFrom(
//                                 foregroundColor: Colors.red,
//                               ),
//                               child: const Text('Remove'),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                   tooltip: 'Remove from favorites',
//                 ),
//               ],
//             ),
//             onTap: () {
//               // TODO: Navigate to item details or implement action
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('Tapped on ${favorite['fname']}'),
//                   duration: const Duration(seconds: 1),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   Widget buildProfilePage() {
//     return Padding(
//       padding: const EdgeInsets.all(24.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 30),
//           const Text(
//             'User Information',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const Divider(thickness: 1.5),
//           const SizedBox(height: 20),
//           const Text(
//             'UID:',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 4),
//           Text(widget.uid),
//           const SizedBox(height: 20),
//           const Text(
//             'JWT Token:',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 4),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Text(widget.jwt),
//           ),
//           const SizedBox(height: 40),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 AuthManager.clearAuthData();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 padding: const EdgeInsets.symmetric(vertical: 15),
//               ),
//               child: const Text(
//                 'Logout',
//                 style: TextStyle(fontSize: 16, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget getBody() {
//     switch (_selectedIndex) {
//       case 0:
//         return isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : GridView.builder(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: diningHalls.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                 ),
//                 itemBuilder: (context, index) {
//                   final hallName = diningHalls[index];
//                   final imageName = 'assets/dining/${hallName.toLowerCase().replaceAll(' ', '_')}.png';
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => DiningHallPage(diningHallName: hallName),
//                         ),
//                       );
//                     },
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Expanded(
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Image.asset(
//                               imageName,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) => Container(
//                                 color: Colors.grey[300],
//                                 child: const Center(child: Icon(Icons.image_not_supported)),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           hallName,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               );
//       case 1:
//         return buildFavoritesPage();
//       case 2:
//         return buildProfilePage();
//       default:
//         return const SizedBox();
//     }
//   }
//
//   String getTitle() {
//     switch (_selectedIndex) {
//       case 0:
//         return 'Dining Halls';
//       case 1:
//         return 'Favorites';
//       case 2:
//         return 'Profile';
//       default:
//         return '';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(getTitle(), style: appBarTextStyle),
//         backgroundColor: const Color.fromARGB(255, 12, 97, 15),
//       ),
//       body: getBody(),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.green[900],
//         onTap: (index) {
//           setState(() => _selectedIndex = index);
//           // Fetch favorites when user switches to favorites tab
//           if (index == 1) {
//             fetchFavorites();
//           }
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.restaurant),
//             label: 'Dining Halls',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite),
//             label: 'Favorites',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }



//#################################################




import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dining_hall_page.dart';
import 'main.dart'; // For AuthManager

const TextStyle appBarTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

class HomePage extends StatefulWidget {
  final String uid;
  final String jwt;

  const HomePage({super.key, required this.uid, required this.jwt});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> diningHalls = [];
  List<Map<String, String>> favorites = [];
  Map<String, dynamic> userProfile = {};
  bool isLoading = true;
  bool isFavoritesLoading = false;
  bool isProfileLoading = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    AuthManager.setContext(context);
    fetchDiningHalls();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    setState(() => isProfileLoading = true);

    // Using your existing get_user endpoint
    final url = Uri.parse('http://10.0.2.2:8000/user/get_user/');
    try {
      final response = await http.get(
        url,
        headers: AuthManager.getAuthHeader(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userProfile = data['data']; // Adjust based on your API response structure
          isProfileLoading = false;
        });
      } else {
        print('❌ Failed to fetch user profile: ${response.statusCode}');
        setState(() => isProfileLoading = false);
      }
    } catch (e) {
      print('❌ Exception during profile fetch: $e');
      setState(() => isProfileLoading = false);
    }
  }

  String getUserInitial() {
    final username = userProfile['username'] ?? 'User';
    return username.toString().isNotEmpty ? username.toString()[0].toUpperCase() : 'U';
  }

  String getDisplayName() {
    return userProfile['username'] ?? 'User';
  }

  Future<void> fetchDiningHalls() async {
    final url = Uri.parse('http://10.0.2.2:8000/dining/get_all_dining_halls/');
    try {
      final response = await http.get(
        url,
        headers: AuthManager.getAuthHeader(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> halls = data['data']['dining_halls'];
        setState(() {
          diningHalls = halls.map((hall) => hall.toString()).toList();
          isLoading = false;
        });
      } else {
        print('❌ Failed to fetch dining halls: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('❌ Exception during fetch: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchFavorites() async {
    setState(() => isFavoritesLoading = true);

    final url = Uri.parse('http://10.0.2.2:8000/favorites/get_all_favorites/');
    try {
      final response = await http.get(
        url,
        headers: AuthManager.getAuthHeader(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> favoritesData = data['data'];
        setState(() {
          favorites = favoritesData.map((fav) => {
            'fid': fav['fid'].toString(),
            'fname': fav['fname'].toString(),
          }).toList();
          isFavoritesLoading = false;
        });
      } else {
        print('❌ Failed to fetch favorites: ${response.statusCode}');
        setState(() => isFavoritesLoading = false);
      }
    } catch (e) {
      print('❌ Exception during favorites fetch: $e');
      setState(() => isFavoritesLoading = false);
    }
  }

  Future<void> deleteFavorite(String fid, String fname) async {
    final url = Uri.parse('http://10.0.2.2:8000/favorites/delete/$fid');
    try {
      final response = await http.delete(
        url,
        headers: AuthManager.getAuthHeader(),
      );

      if (response.statusCode == 200) {
        setState(() {
          favorites.removeWhere((favorite) => favorite['fid'] == fid);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Removed "$fname" from favorites'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        print('❌ Failed to delete favorite: ${response.statusCode}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to remove from favorites'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Exception during favorite deletion: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error removing from favorites'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Widget buildFavoritesPage() {
    if (isFavoritesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (favorites.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No favorites yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add items to your favorites to see them here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final favorite = favorites[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.favorite,
                color: Colors.green[700],
                size: 24,
              ),
            ),
            title: Text(
              favorite['fname']!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red[600],
                    size: 24,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Remove Favorite'),
                          content: Text('Remove "${favorite['fname']}" from your favorites?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                deleteFavorite(favorite['fid']!, favorite['fname']!);
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Remove'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  tooltip: 'Remove from favorites',
                ),
              ],
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tapped on ${favorite['fname']}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget buildProfileInfoCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfilePage() {
    if (isProfileLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // Profile Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                // Profile Picture with First Letter
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      getUserInitial(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  getDisplayName(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userProfile['email'] ?? 'No email provided',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Account Information Section
          const Text(
            'Account Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Username Card
          buildProfileInfoCard(
            'Username',
            userProfile['username'] ?? 'Not provided',
            Icons.person_outline,
            Colors.blue[600]!,
          ),

          // Age Card
          buildProfileInfoCard(
            'Age',
            userProfile['age']?.toString() ?? 'Not provided',
            Icons.cake_outlined,
            Colors.purple[600]!,
          ),

          // Email Card
          buildProfileInfoCard(
            'Email',
            userProfile['email'] ?? 'Not provided',
            Icons.email_outlined,
            Colors.green[600]!,
          ),

          // UID Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.account_circle_outlined,
                    color: Colors.blue[600],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User ID',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '••••••••',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('User ID'),
                          content: SelectableText(
                            widget.uid,
                            style: const TextStyle(fontFamily: 'monospace'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'View',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // JWT Token Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.security_outlined,
                    color: Colors.orange[600],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Session Token',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '••••••••••••••••',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Session Token'),
                          content: SizedBox(
                            width: double.maxFinite,
                            child: SingleChildScrollView(
                              child: SelectableText(
                                widget.jwt,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'View',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Logout Button
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
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
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('Logout'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget getBody() {
    switch (_selectedIndex) {
      case 0:
        return isLoading
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: diningHalls.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final hallName = diningHalls[index];
            final imageName = 'assets/dining/${hallName.toLowerCase().replaceAll(' ', '_')}.png';
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiningHallPage(diningHallName: hallName),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        imageName,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: const Center(child: Icon(Icons.image_not_supported)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    hallName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        );
      case 1:
        return buildFavoritesPage();
      case 2:
        return buildProfilePage();
      default:
        return const SizedBox();
    }
  }

  String getTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Dining Halls';
      case 1:
        return 'Favorites';
      case 2:
        return 'Profile';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTitle(), style: appBarTextStyle),
        backgroundColor: const Color.fromARGB(255, 12, 97, 15),
      ),
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[900],
        onTap: (index) {
          setState(() => _selectedIndex = index);
          // Fetch favorites when user switches to favorites tab
          if (index == 1) {
            fetchFavorites();
          }
          // Fetch user profile when user switches to profile tab
          if (index == 2 && userProfile.isEmpty) {
            fetchUserProfile();
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Dining Halls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}