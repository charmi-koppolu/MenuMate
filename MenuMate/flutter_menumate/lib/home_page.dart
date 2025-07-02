// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dining_hall_page.dart';

// const TextStyle appBarTextStyle = TextStyle(
//   fontSize: 24,
//   fontWeight: FontWeight.bold,
//   color: Colors.white,
// );

// class HomePage extends StatefulWidget {
//   final String uid;
//   final String jwt;

//   const HomePage({super.key, required this.uid, required this.jwt});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   List<String> diningHalls = [];
//   bool isLoading = true;
//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     fetchDiningHalls();
//   }

//   Future<void> fetchDiningHalls() async {
//     final url = Uri.parse('http://127.0.0.1:8000/dining/get_all_dining_halls/');
//     try {
//       final response = await http.get(
//         url,
//         headers: {
//           'Authorization': 'Bearer ${widget.jwt}',
//           'Content-Type': 'application/json',
//         },
//       );

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
//         return const Center(child: Text('Favorites', style: TextStyle(fontSize: 24)));
//       case 2:
//         return const Center(child: Text('Profile', style: TextStyle(fontSize: 24)));
//       default:
//         return const SizedBox();
//     }
//   }

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






import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dining_hall_page.dart';

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
  bool isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchDiningHalls();
  }

  Future<void> fetchDiningHalls() async {
    final url = Uri.parse('http://127.0.0.1:8000/dining/get_all_dining_halls/');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.jwt}',
          'Content-Type': 'application/json',
        },
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

  Widget buildProfilePage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          const Text(
            'User Information',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(thickness: 1.5),
          const SizedBox(height: 20),
          Text(
            'UID:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(widget.uid),
          const SizedBox(height: 20),
          Text(
            'JWT Token:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(widget.jwt),
          ),
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
        return const Center(child: Text('Favorites', style: TextStyle(fontSize: 24)));
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
