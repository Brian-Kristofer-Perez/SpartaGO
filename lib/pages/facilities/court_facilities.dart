import 'package:flutter/material.dart';
import 'package:sparta_go/common/facility_card.dart';

class CourtFacilitiesPage extends StatefulWidget {
  const CourtFacilitiesPage({Key? key}) : super(key: key);

  @override
  State<CourtFacilitiesPage> createState() => _CourtFacilitiesPageState();
}

class _CourtFacilitiesPageState extends State<CourtFacilitiesPage> {
  String selectedFilter = 'Court';
  int selectedNavIndex = 0;

  final List<Map<String, dynamic>> facilities = [
    {
      'name': 'Basketball Court',
      'description': 'Indoor basketball court',
      'image': 'assets/images/basketballCourt.jpg',
      'building': 'Building A, Level 1',
      'capacity': '50 people',
      'equipment': ['Basketball', 'Basketball Hoop'],
    },
    {
      'name': 'Volleyball Court',
      'description': 'Indoor volleyball court',
      'image': 'assets/images/volleyballCourt.png',
      'building': 'Building A, Level 1',
      'capacity': '50 people',
      'equipment': ['Volleyball', 'Volleyball Net'],
    },
  ];

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
              label: const Icon(Icons.calendar_today, size: 16, color: const Color(0xFF991B1B),),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0,),
            child: Container(
              height: 28,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 7,
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

          // Facilities Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: facilities.length,
              itemBuilder: (context, index) {
                return FacilityCard(facility: facilities[index]);
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