import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sparta_go/common/back_button.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class UserActivityPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const UserActivityPage({Key? key, required this.user}) : super(key: key);

  @override
  State<UserActivityPage> createState() => _UserActivityPageState();
}

class _UserActivityPageState extends State<UserActivityPage> {
  int _currentIndex = 0;
  int _selectedTab = 0; // 0 for Reservations, 1 for Borrowed Equipment

  List<Map<String, dynamic>> _reservations = [];
  List<Map<String, dynamic>> _borrowedEquipment = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserActivity();
  }

  Future<void> _loadUserActivity() async {
    try {
      // Load facility reservations
      final facilityString = await rootBundle.loadString('assets/files/facility_reservations.json');
      final facilityJson = json.decode(facilityString) as List;

      // Load equipment reservations
      final equipmentString = await rootBundle.loadString('assets/files/equipment_reservations.json');
      final equipmentJson = json.decode(equipmentString) as List;

      // Get user ID from the user object
      final userId = widget.user['id']?.toString() ?? '';
      
      // Filter reservations for this specific user
      final userFacilityReservations = List<Map<String, dynamic>>.from(
        facilityJson.where((reservation) => 
          reservation['userId']?.toString() == userId
        )
      );

      // Filter equipment reservations for this specific user
      final userEquipmentReservations = List<Map<String, dynamic>>.from(
        equipmentJson.where((equipment) => 
          equipment['userId']?.toString() == userId
        )
      );

      setState(() {
        _reservations = userFacilityReservations;
        _borrowedEquipment = userEquipmentReservations;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user activity: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('MM/dd/yyyy').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  String _getDateRange(String startDate, String endDate) {
    try {
      DateTime start = DateTime.parse(startDate);
      DateTime end = DateTime.parse(endDate);
      return '${DateFormat('MM/dd').format(start)} - ${DateFormat('MM/dd/yyyy').format(end)}';
    } catch (e) {
      return '$startDate - $endDate';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/images/logo.png',
          height: 50,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.fitness_center,
            color: Colors.red,
            size: 32,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Back Button at the top
                          const CustomBackButton(),
                          
                          const SizedBox(height: 10),

                          // Title
                          const Text(
                            'User Activity',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Manage Users of SpartaGo',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // User Info Card with overlapping profile picture
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Main Card
                              Container(
                                margin: const EdgeInsets.only(left: 60),
                                padding: const EdgeInsets.only(
                                  left: 70,
                                  right: 130,
                                  top: 12,
                                  bottom: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8B1E1E),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.user['name'] ?? 'Unknown User',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Profile Picture (overlapping on the left)
                              Positioned(
                                left: 0,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: widget.user['hasImage'] == true
                                      ? Center(
                                          child: Icon(
                                            Icons.person,
                                            size: 40,
                                            color: Colors.orange.shade700,
                                          ),
                                        )
                                      : const Center(
                                          child: Icon(
                                            Icons.person_outline,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Tab Selector
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildTabButton('Reservations', 0),
                                ),
                                Expanded(
                                  child: _buildTabButton('Borrowed Equipment', 1),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Content based on selected tab
                          _selectedTab == 0
                              ? _buildReservationsList()
                              : _buildBorrowedEquipmentList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReservationsList() {
    if (_reservations.isEmpty) {
      return _buildEmptyState('No pending reservations');
    }

    return Column(
      children: _reservations.map((reservation) {
        final formattedDate = _formatDate(reservation['date'] ?? '');
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      reservation['facility'] ?? 'Unknown Facility',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    reservation['timeSlot'] ?? 'N/A',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBorrowedEquipmentList() {
    if (_borrowedEquipment.isEmpty) {
      return _buildEmptyState('No pending borrowed equipment');
    }

    return Column(
      children: _borrowedEquipment.map((equipment) {
        final dateRange = _getDateRange(
          equipment['startDate'] ?? '', 
          equipment['endDate'] ?? ''
        );
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      equipment['name'] ?? 'Unknown Equipment',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dateRange,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                equipment['description'] ?? '',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Quantity: ${equipment['count'] ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.tag,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
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