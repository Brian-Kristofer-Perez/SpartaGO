import 'package:flutter/material.dart';
import 'package:sparta_go/common/facility_card.dart';

class FacilitiesPage extends StatefulWidget {
  const FacilitiesPage({Key? key}) : super(key: key);

  @override
  State<FacilitiesPage> createState() => _FacilitiesPageState();
}

class _FacilitiesPageState extends State<FacilitiesPage> {
  String selectedFilter = 'All';
  int selectedNavIndex = 0;

  final List<Map<String, dynamic>> facilities = [
    {
      'name': 'Basketball Court',
      'description': 'Indoor basketball court',
      'image': 'assets/images/basketballCourt.jpg',
      'building': 'Building A, Level 1',
      'capacity': '50 people',
      'equipment': ['Basketball', 'Basketball Hoop'],
      'type': 'Court', // Added type field
    },
    {
      'name': 'Volleyball Court',
      'description': 'Indoor volleyball court',
      'image': 'assets/images/volleyballCourt.png',
      'building': 'Building A, Level 1',
      'capacity': '50 people',
      'equipment': ['Volleyball', 'Volleyball Net'],
      'type': 'Court', // Added type field
    },
    {
      'name': 'Sparta Fitness Gym',
      'description': 'Workout Gym with various equipment',
      'image': 'assets/images/spartaGym.png',
      'building': 'Building A, Level 2',
      'capacity': '70 people',
      'equipment': ['Treadmill', 'Exercise Bike'],
      'type': 'Gym', // Added type field
    },
  ];

  // Filter facilities based on selected filter
  List<Map<String, dynamic>> get filteredFacilities {
    if (selectedFilter == 'All') {
      return facilities;
    }
    return facilities.where((facility) => facility['type'] == selectedFilter).toList();
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

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 40, 
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                cursorColor: Colors.black, 
                style: const TextStyle(fontSize: 14), 
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600], size: 20),
                  hintText: 'Search facilities...', 
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12, 
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Filter Chips 
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8.0,
                alignment: WrapAlignment.center,
                children: ['All', 'Gym', 'Court', 'Studio'].map((filter) {
                  final isSelected = selectedFilter == filter;
                  return FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    showCheckmark: false,
                    onSelected: (selected) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xFF8B1E1E),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF8B1E1E)
                          : Colors.grey[300]!,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Facilities Grid - Now uses filteredFacilities
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