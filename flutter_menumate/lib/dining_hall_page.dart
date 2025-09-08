import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart'; // Import for AuthManager

const TextStyle appBarTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

class DiningHallPage extends StatefulWidget {
  final String diningHallName;

  const DiningHallPage({super.key, required this.diningHallName});

  @override
  State<DiningHallPage> createState() => _DiningHallPageState();
}

class _DiningHallPageState extends State<DiningHallPage> {
  Map<String, dynamic>? diningHallData;
  bool isLoading = true;
  String? errorMessage;
  Set<String> favoriteItems = {}; // Track favorited items
  Set<String> pendingFavorites = {}; // Track items being favorited

  @override
  void initState() {
    super.initState();
    fetchDiningHallData();
  }

  Future<void> fetchDiningHallData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Check if user is still logged in
      if (!AuthManager.isLoggedIn()) {
        setState(() {
          errorMessage = 'Authentication required. Please log in again.';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/dining/get_dining_hall/${widget.diningHallName}'),
        headers: AuthManager.getAuthHeader(), // Use AuthManager instead of hardcoded token
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
            errorMessage = 'Failed to load dining hall data';
            isLoading = false;
          });
        }
      } else if (response.statusCode == 401) {
        // Handle unauthorized access - token might be expired
        setState(() {
          errorMessage = 'Session expired. Please log in again.';
          isLoading = false;
        });
        // Optionally clear auth data and redirect to login
        AuthManager.clearAuthData();
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

  Future<void> addToFavorites(String itemName) async {
    if (!AuthManager.isLoggedIn()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add favorites')),
      );
      return;
    }

    setState(() {
      pendingFavorites.add(itemName);
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/favorites/add_favorite/'),
        headers: {
          'Content-Type': 'application/json',
          ...AuthManager.getAuthHeader(),
        },
        body: json.encode({
          'fname': itemName,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'Success' || jsonData['message'] == 'Success') {
          setState(() {
            favoriteItems.add(itemName);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$itemName added to favorites!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add favorite: ${jsonData['message'] ?? 'Unknown error'}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else if (response.statusCode == 300) {
        // Item already favorited
        setState(() {
          favoriteItems.add(itemName); // Mark as favorited in UI
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Already Favorited'),
              content: const Text('This item has been already favorited.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else if (response.statusCode == 401) {
        AuthManager.clearAuthData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session expired. Please log in again.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Server error: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        pendingFavorites.remove(itemName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.diningHallName, style: appBarTextStyle),
        backgroundColor: const Color.fromARGB(255, 12, 97, 15),
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
                      Text(
                        errorMessage!,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: fetchDiningHallData,
                        child: const Text('Retry'),
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

  List<Widget> buildMenuSections() {
    if (diningHallData == null) return [];

    final sections = diningHallData!['sections'] as Map<String, dynamic>?;
    final menuItems = diningHallData!['menu_items'] as Map<String, dynamic>?;

    if (sections == null || menuItems == null) return [];

    List<Widget> sectionWidgets = [];

    sections.forEach((sectionName, description) {
      final items = menuItems[sectionName] as List<dynamic>?;
      
      // Skip sections with no items
      if (items == null || items.isEmpty) return;

      sectionWidgets.add(
        Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section header with expandable description
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        sectionName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 12, 97, 15),
                        ),
                      ),
                    ),
                    if (description.toString().isNotEmpty)
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(sectionName),
                                content: Text(
                                  description.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.info_outline,
                          color: Color.fromARGB(255, 12, 97, 15),
                        ),
                        tooltip: 'View section description',
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Menu items with favorite buttons
                ...items.map((item) {
                  final itemName = item.toString();
                  final isFavorited = favoriteItems.contains(itemName);
                  final isPending = pendingFavorites.contains(itemName);
                  
                  return Padding(
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
                            itemName,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        // Favorite button
                        IconButton(
                          onPressed: isPending || isFavorited ? null : () => addToFavorites(itemName),
                          icon: isPending 
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Icon(
                                  isFavorited ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorited 
                                      ? Colors.red 
                                      : const Color.fromARGB(255, 12, 97, 15),
                                  size: 20,
                                ),
                          tooltip: isFavorited ? 'Already favorited' : 'Add to favorites',
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      );
    });

    return sectionWidgets;
  }
}