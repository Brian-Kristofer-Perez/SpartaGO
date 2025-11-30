import 'package:flutter/material.dart';
import 'package:sparta_go/pages/equipment/equipment_card.dart';
import 'package:sparta_go/common/search_bar_widget.dart';
import 'package:sparta_go/common/filter_chips_widget.dart';
import 'package:sparta_go/pages/facilities/facilities.dart';
import 'package:sparta_go/pages/reservation/reservation.dart';
import 'package:sparta_go/pages/profile/profile.dart';
import 'package:sparta_go/pages/incoming-event/incoming_event.dart';
import 'package:sparta_go/constant/constant.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EquipmentPage extends StatefulWidget {

  Map<String, dynamic> user;

  EquipmentPage({Key? key, required this.user}) : super(key: key);

  @override
  State<EquipmentPage> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  String selectedFilter = 'All';
  String searchQuery = '';

  List<Map<String, dynamic>> equipment = [];


  List<Map<String, dynamic>> get filteredEquipment {
    List<Map<String, dynamic>> filtered = equipment;
    
    if (selectedFilter != 'All') {
      filtered = filtered.where((facility) => facility['type'] == selectedFilter).toList();
    }
    
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((facility) {
        final name = facility['name'].toString().toLowerCase();
        final description = facility['description'].toString().toLowerCase();
        final query = searchQuery.toLowerCase();
        return name.contains(query) || description.contains(query);
      }).toList();
    }
    
    return filtered;
  }

  Future<void> _loadEquipment() async {
    try {
      print('🔄 Fetching equipment from: {$API_URL}/equipment/');
      
      final response = await http.get(
        Uri.parse('$API_URL/equipment/'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('📡 Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<Map<String, dynamic>> data = 
            jsonData.map((item) => item as Map<String, dynamic>).toList();
        
        print('✅ Successfully fetched ${data.length} equipment items');
        
        setState(() {
          equipment = data;
        });
        
      } else {
        print('❌ Error: Status code ${response.statusCode}');
        print('Response body: ${response.body}');
      
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load equipment: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
      
    } catch (e) {
      print('❌ Error fetching equipment: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadEquipment();
  }
  void _onNavTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => FacilitiesPage(user: widget.user),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
    if (index == 2) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => ReservationPage(user: widget.user,),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
    if (index == 3) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(user: widget.user),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 100,
        leading: Center(
          child: Image.asset(
            'assets/images/logo.png',
            width: 80,
            height: 60,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.fitness_center,
              color: Colors.red,
              size: 40,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IncomingEventsPage(user: widget.user),
                  ),
                );
              },
              icon: const Text('View Events', 
                style: TextStyle(fontSize: 13)
              ),
              label: const Icon(Icons.calendar_today, size: 16, color: Color(0xFF991B1B)),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black87,
                side: const BorderSide(color: Colors.grey),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Equipment',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Browse and reserve our premium gym equipment',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SearchBarWidget(
              hintText: 'Search equipment...',
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FilterChipsWidget(
              filters: const ['All', 'Sports Equipment', 'Strength Training'],
              selectedFilter: selectedFilter,
              onFilterSelected: (filter) {
                setState(() {
                  selectedFilter = filter;
                });
              },
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredEquipment.length,
              itemBuilder: (context, index) {
                return EquipmentCard(
                  equipment: filteredEquipment[index],
                  onRefresh: () async {await _loadEquipment();},
                  user: widget.user,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, 
        onTap: _onNavTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF8B1E1E),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Facilities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Equipment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Reservation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}