import 'package:flutter/material.dart';
import 'package:sparta_go/common/facility_card.dart';
import 'package:sparta_go/common/search_bar_widget.dart';
import 'package:sparta_go/common/filter_chips_widget.dart';

class FacilitiesPage extends StatefulWidget {
  const FacilitiesPage({Key? key}) : super(key: key);

  @override
  State<FacilitiesPage> createState() => _FacilitiesPageState();
}

class _FacilitiesPageState extends State<FacilitiesPage> {
  String selectedFilter = 'All';
  int selectedNavIndex = 0;
  String searchQuery = '';

  final List<Map<String, dynamic>> facilities = [
    {
      'name': 'Basketball Court',
      'description': 'Indoor basketball court',
      'image': 'assets/images/basketballCourt.jpg',
      'building': 'Building A, Level 1',
      'capacity': '50 people',
      'equipment': ['Basketball', 'Basketball Hoop'],
      'type': 'Court',
    },
    {
      'name': 'Volleyball Court',
      'description': 'Indoor volleyball court',
      'image': 'assets/images/volleyballCourt.png',
      'building': 'Building A, Level 1',
      'capacity': '50 people',
      'equipment': ['Volleyball', 'Volleyball Net'],
      'type': 'Court', 
    },
    {
      'name': 'Sparta Fitness Gym',
      'description': 'Workout Gym with various equipment',
      'image': 'assets/images/spartaGym.png',
      'building': 'Building A, Level 2',
      'capacity': '70 people',
      'equipment': ['Treadmill', 'Exercise Bike'],
      'type': 'Gym',
    },
  ];

  List<Map<String, dynamic>> get filteredFacilities {
    List<Map<String, dynamic>> filtered = facilities;
    
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

              // TODO: View events
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

          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gym Facilities',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Browse and reserve our premium gym facilities',
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
              hintText: 'Search facilities...',
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
              filters: const ['All', 'Gym', 'Court', 'Studio'],
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
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredFacilities.length,
              itemBuilder: (context, index) {
                return FacilityCard(facility: filteredFacilities[index]);
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedNavIndex,
        onTap: (index) {
          setState(() {
            selectedNavIndex = index;
          });
        },
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