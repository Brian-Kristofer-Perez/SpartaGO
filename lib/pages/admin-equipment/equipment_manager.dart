import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sparta_go/pages/admin-facillities/facilities_manager.dart';
import 'package:sparta_go/pages/admin-reservation/reservation_manager.dart';
import 'dart:convert';
import 'package:sparta_go/pages/admin-user_manager/user_manager.dart';

// Reusable Filter Chips Widget
class FilterChipsWidget extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;
  final Color? selectedColor;
  final Color? backgroundColor;
  final Color? selectedBorderColor;
  final Color? unselectedBorderColor;

  const FilterChipsWidget({
    Key? key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
    this.selectedColor = const Color(0xFF8B1E1E),
    this.backgroundColor = Colors.white,
    this.selectedBorderColor,
    this.unselectedBorderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 8.0,
        alignment: WrapAlignment.center,
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;
          return FilterChip(
            label: Text(filter),
            selected: isSelected,
            showCheckmark: false,
            onSelected: (selected) {
              onFilterSelected(filter);
            },
            backgroundColor: backgroundColor,
            selectedColor: selectedColor,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            side: BorderSide(
              color: isSelected
                  ? (selectedBorderColor ?? selectedColor!)
                  : (unselectedBorderColor ?? Colors.grey[300]!),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class EquipmentManagerPage extends StatefulWidget {
  const EquipmentManagerPage({Key? key}) : super(key: key);

  @override
  State<EquipmentManagerPage> createState() => _EquipmentManagerPageState();
}

class _EquipmentManagerPageState extends State<EquipmentManagerPage> {
  int _currentIndex = 3; // Equipment tab selected
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _equipment = [];
  bool _isLoading = true;
  String? _expandedEquipmentId; // Track which equipment is expanded

  @override
  void initState() {
    super.initState();
    _loadEquipmentData();
  }

  Future<void> _loadEquipmentData() async {
    try {
      final equipmentString = await rootBundle.loadString('assets/files/equipment.json');
      final equipmentJson = json.decode(equipmentString) as List;

      setState(() {
        _equipment = List<Map<String, dynamic>>.from(equipmentJson);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading equipment data: $e');
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

  List<Map<String, dynamic>> get _filteredEquipment {
    List<Map<String, dynamic>> filtered = _equipment;

    // Filter by type
    if (_selectedFilter != 'All') {
      filtered = filtered.where((equipment) {
        return equipment['type'] == _selectedFilter;
      }).toList();
    }

    // Filter by search query
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((equipment) {
        final name = equipment['name'].toString().toLowerCase();
        return name.contains(query);
      }).toList();
    }

    return filtered;
  }

  String _getEquipmentStatus(Map<String, dynamic> equipment) {
    final available = equipment['available'] as int? ?? 0;
    if (available > 0) {
      return 'Available';
    }
    return 'Out of Stock';
  }

  void _toggleEquipmentExpansion(Map<String, dynamic> equipment) {
    setState(() {
      final equipmentId = equipment['id']?.toString() ?? equipment['name'];
      if (_expandedEquipmentId == equipmentId) {
        _expandedEquipmentId = null; // Collapse if already expanded
      } else {
        _expandedEquipmentId = equipmentId; // Expand
      }
    });
  }

  void _showDeleteConfirmation(Map<String, dynamic> equipment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Equipment'),
        content: Text('Are you sure you want to delete ${equipment['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement delete functionality
              Navigator.pop(context);
              setState(() {
                _expandedEquipmentId = null; // Collapse after delete
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${equipment['name']} deleted'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFF8B1E1E)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Equipment Manager',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage Equipments in SpartaGo',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Search Bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      hintText: 'Search equipments...',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),

                  const SizedBox(height: 16),

                  // Filter Chips (Centered)
                  FilterChipsWidget(
                    filters: const ['All', 'Sports Equipment', 'Strength Training'],
                    selectedFilter: _selectedFilter,
                    onFilterSelected: (filter) {
                      setState(() {
                        _selectedFilter = filter;
                        _expandedEquipmentId = null; // Collapse when filter changes
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // Equipment List
                  Expanded(
                    child: _filteredEquipment.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 64,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No equipment found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _filteredEquipment.length,
                            itemBuilder: (context, index) {
                              final equipment = _filteredEquipment[index];
                              final equipmentId = equipment['id']?.toString() ?? equipment['name'];
                              final isExpanded = _expandedEquipmentId == equipmentId;
                              return _buildEquipmentCard(equipment, isExpanded);
                            },
                          ),
                  ),

                  const SizedBox(height: 16),

                  // Add Equipment Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Navigate to Add Equipment page
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Add Equipment feature coming soon'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B1E1E),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Add Equipment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 0) {
            // Navigate to Users
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const UserManagerPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (index == 1) {
            // Navigate to Reservations
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const ReservationManagerPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (index == 2) {
            // Navigate to Facilities
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const FacilityManagerPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (index == 4) {
            _showLogoutDialog();
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF8B1E1E),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Reservations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Facilities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Equipment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentCard(Map<String, dynamic> equipment, bool isExpanded) {
    final status = _getEquipmentStatus(equipment);
    
    return GestureDetector(
      onTap: () => _toggleEquipmentExpansion(equipment),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isExpanded ? const Color(0xFF8B1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isExpanded ? const Color(0xFF8B1E1E) : Colors.grey.shade300,
            width: isExpanded ? 2 : 1,
          ),
        ),
        child: isExpanded 
            ? _buildExpandedCard(equipment, status)
            : _buildCollapsedCard(equipment, status),
      ),
    );
  }

  Widget _buildCollapsedCard(Map<String, dynamic> equipment, String status) {
    final available = equipment['available'] ?? 0;
    final total = equipment['total'] ?? 0;
    
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Equipment Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: equipment['image'] != null
                  ? Image.asset(
                      equipment['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.inventory_2_outlined,
                        size: 40,
                        color: Colors.grey.shade400,
                      ),
                    )
                  : Icon(
                      Icons.inventory_2_outlined,
                      size: 40,
                      color: Colors.grey.shade400,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          // Equipment Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  equipment['name'] ?? 'Unknown Equipment',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  equipment['description'] ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.inventory,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Qty: $available/$total',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: status == 'Available' 
                        ? Colors.green.shade50 
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Status: $status',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: status == 'Available' 
                          ? Colors.green.shade700 
                          : Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedCard(Map<String, dynamic> equipment, String status) {
    final available = equipment['available'] ?? 0;
    final total = equipment['total'] ?? 0;
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: equipment['image'] != null
                  ? Image.asset(
                      equipment['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade300,
                        child: Icon(
                          Icons.inventory_2_outlined,
                          size: 50,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey.shade300,
                      child: Icon(
                        Icons.inventory_2_outlined,
                        size: 50,
                        color: Colors.grey.shade400,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),

          // Equipment Name
          Text(
            equipment['name'] ?? 'Unknown Equipment',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            equipment['description'] ?? '',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // Quantity
          Row(
            children: [
              const Icon(
                Icons.inventory,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                'Qty: $available/$total',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: status == 'Available' 
                  ? Colors.green.shade600 
                  : Colors.red.shade600,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Status: $status',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Delete Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showDeleteConfirmation(equipment);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF8B1E1E),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Delete Equipment',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Back Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _toggleEquipmentExpansion(equipment),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide.none,
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text(
                'Back',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Color(0xFF8B1E1E)),
            ),
          ),
        ],
      ),
    );
  }
}