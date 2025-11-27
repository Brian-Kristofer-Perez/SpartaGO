import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:sparta_go/pages/admin-equipment/equipment_manager.dart';
import 'package:sparta_go/pages/admin-facillities/facilities_manager.dart';
import 'package:sparta_go/pages/admin-reservation/reservation_manager.dart';
import 'package:sparta_go/pages/admin-user_manager/user_detail.dart';
import 'package:sparta_go/constant/constant.dart';

class UserManagerPage extends StatefulWidget {
  const UserManagerPage({Key? key}) : super(key: key);

  @override
  State<UserManagerPage> createState() => _UserManagerPageState();
}

class _UserManagerPageState extends State<UserManagerPage> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _allUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  /// -------------------------------
  /// FETCH USERS FROM API
  /// -------------------------------
  Future<void> _fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse("{$API_URL}/"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);

        setState(() {
          _allUsers = jsonList.map<Map<String, dynamic>>((user) {
            return {
              "name": user["name"] ?? "Unknown",
              "email": user["email"] ?? "",
              "password": user["password"] ?? "",
            };
          }).toList();

          _isLoading = false;
        });
      } else {
        throw Exception("Failed to fetch users: ${response.statusCode}");
      }
    } catch (e) {
      print("ERROR FETCHING USERS: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// FILTER USERS
  List<Map<String, dynamic>> get _filteredUsers {
    if (_searchController.text.isEmpty) return _allUsers;

    final query = _searchController.text.toLowerCase();
    return _allUsers.where((user) {
      final name = user["name"].toLowerCase();
      final id = user["id"].toLowerCase();
      final email = user["email"].toLowerCase();

      return name.contains(query) ||
          id.contains(query) ||
          email.contains(query);
    }).toList();
  }

  /// ----------------------------------------
  /// UI BUILD
  /// ----------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            const SizedBox(height: 10),
            Image.asset(
              'assets/images/logo.png',
              height: 60,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.fitness_center,
                color: Colors.red,
                size: 40,
              ),
            )
          ],
        ),
        centerTitle: true,
      ),

      /// BODY
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "User Manager",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Manage Users of SpartaGo",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// SEARCH BAR
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.grey),
                      hintText: "Search users...",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 20),

                  /// USER LIST
                  Expanded(
                    child: _filteredUsers.isEmpty
                        ? _noUsersFound()
                        : ListView.builder(
                            itemCount: _filteredUsers.length,
                            itemBuilder: (context, index) {
                              return _buildUserCard(_filteredUsers[index]);
                            },
                          ),
                  )
                ],
              ),
            ),

      /// BOTTOM NAVIGATION
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  /// ----------------------------------------
  /// CARD UI FOR EACH USER
  /// ----------------------------------------
  Widget _buildUserCard(Map<String, dynamic> user) {
    bool hasImage = user["hasImage"];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UserDetailPage(user: user),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.white,
        ),
        child: Row(
          children: [
            /// PROFILE
            CircleAvatar(
              radius: 26,
              backgroundColor:
                  hasImage ? Colors.orange.shade100 : Colors.grey.shade200,
              child: Icon(
                hasImage ? Icons.person : Icons.person_outline,
                size: 30,
                color: hasImage ? Colors.orange.shade700 : Colors.grey,
              ),
            ),
            const SizedBox(width: 16),

            /// USER INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user["name"],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    user["id"],
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.email, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          user["email"],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// NO USERS FOUND WIDGET
  Widget _noUsersFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off_outlined,
              size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            "No users found",
            style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          )
        ],
      ),
    );
  }

  /// BOTTOM NAVIGATION BAR
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: const Color(0xFF8B1E1E),
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        setState(() => _currentIndex = index);

        switch (index) {
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ReservationManagerPage()),
            );
            break;

          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const FacilityManagerPage()),
            );
            break;

          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const EquipmentManagerPage()),
            );
            break;

          case 4:
            _showLogoutDialog();
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.people), label: "Users"),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today), label: "Reservations"),
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), label: "Facilities"),
        BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined), label: "Equipment"),
        BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Logout"),
      ],
    );
  }

  /// LOGOUT POPUP
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text("Logout", style: TextStyle(color: Color(0xFF8B1E1E))),
          ),
        ],
      ),
    );
  }
}
