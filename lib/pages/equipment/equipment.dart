import 'package:flutter/material.dart';
import 'package:sparta_go/pages/equipment/equipment_card.dart';
import 'package:sparta_go/common/search_bar_widget.dart';
import 'package:sparta_go/common/filter_chips_widget.dart';
import 'package:sparta_go/pages/facilities/facilities.dart';
import 'package:sparta_go/services/EquipmentService.dart';

class EquipmentPage extends StatefulWidget {
  const EquipmentPage({Key? key}) : super(key: key);

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

  // Helper: Async function to get equipment
  Future<void> _loadEquipment() async {
    final data = await EquipmentService().getAllEquipment();
    setState(() {
      equipment = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadEquipment();
  }

  // Helper: Callback upon navigation tap
  void _onNavTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const FacilitiesPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
    // TODO: Add navigation for other tabs (History, Notification, Profile)
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
              onPressed: () {},
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
                return EquipmentCard(equipment: filteredEquipment[index], onRefresh: () async {await _loadEquipment();},);
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
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Notification',
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