import 'package:flutter/material.dart';
import 'package:sparta_go/pages/equipment-borrow-request/EquipmentBorrowRequestPage.dart';
import 'package:sparta_go/pages/equipment/equipment_card.dart';
import 'package:sparta_go/common/search_bar_widget.dart';
import 'package:sparta_go/common/filter_chips_widget.dart';

class EquipmentPage extends StatefulWidget {
  const EquipmentPage({Key? key}) : super(key: key);

  @override
  State<EquipmentPage> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  String selectedFilter = 'All';
  int selectedNavIndex = 0;
  String searchQuery = '';

  final List<Map<String, dynamic>> equipment = [
    {
      'name': 'Basketball',
      'description': 'Official Size Basketball',
      'image': 'assets/images/basketball.jpg',
      'available': 15,
      'total': 20,
      'type': 'Sports Equipment',
    },
    {
      'name': 'Volleyball',
      'description': 'Official Size Volleyball',
      'image': 'assets/images/volleyball.jpg',
      'available': 15,
      'total': 20,
      'type': 'Sports Equipment',
    },
    {
      'name': 'Badminton Racket',
      'description': 'Durable racket for power and precision',
      'image': 'assets/images/badminton.jpg',
      'available': 15,
      'total': 20,
      'type': 'Sports Equipment',
    },
    {
      'name': 'Shuttlecock',
      'description': 'High-quality for matches',
      'image': 'assets/images/shuttlcock.jpg',
      'available': 15,
      'total': 20,
      'type': 'Sports Equipment',
    },
    {
      'name': 'Yoga Mat',
      'description': 'Premium non-slip yoga mat',
      'image': 'assets/images/yoga mat.jpg',
      'available': 15,
      'total': 20,
      'type': 'Strength Training',
    },
    {
      'name': 'Resistance Band',
      'description': 'Stretchable for all levels',
      'image': 'assets/images/resistance band.jpg',
      'available': 15,
      'total': 20,
      'type': 'Strength Training',
    },
    {
      'name': 'Dumbbell',
      'description': 'Durable for strength workouts',
      'image': 'assets/images/dumbbell.jpg',
      'available': 15,
      'total': 20,
      'type': 'Strength Training',
    },
    {
      'name': 'Jump Rope',
      'description': 'Portable for cardio workouts',
      'image': 'assets/images/jump rope.jpg',
      'available': 15,
      'total': 20,
      'type': 'Strength Training',
    },
    {
      'name': 'Table Tennis Paddle',
      'description': 'Comfortable grip for control',
      'image': 'assets/images/table tennis paddle.jpg',
      'available': 15,
      'total': 20,
      'type': 'Sports Equipment',
    },
    {
      'name': 'Table Tennis Ball',
      'description': 'Smooth spin and bounce',
      'image': 'assets/images/table tennis ball.jpg',
      'available': 15,
      'total': 20,
      'type': 'Sports Equipment',
    },
  ];

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
                return EquipmentCard(equipment: filteredEquipment[index]);
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