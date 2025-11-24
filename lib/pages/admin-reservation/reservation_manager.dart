import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sparta_go/pages/admin-equipment/equipment_manager.dart';
import 'package:sparta_go/pages/admin-facillities/facilities_manager.dart';
import 'package:sparta_go/pages/admin-user_manager/user_manager.dart';
import 'dart:convert';

class ReservationManagerPage extends StatefulWidget {
  const ReservationManagerPage({Key? key}) : super(key: key);

  @override
  State<ReservationManagerPage> createState() => _ReservationManagerPageState();
}

class _ReservationManagerPageState extends State<ReservationManagerPage> {
  int _currentIndex = 1; // Reservations tab selected
  int _selectedTab = 0; // 0 for Facilities, 1 for Equipment
  DateTime _selectedMonth = DateTime.now();
  DateTime? _selectedDate;
  
  List<Map<String, dynamic>> _facilityReservations = [];
  List<Map<String, dynamic>> _equipmentReservations = [];
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Load all data from JSON files
  Future<void> _loadData() async {
    try {
      // Load facility reservations
      final facilityString = await rootBundle.loadString('assets/files/facility_reservations.json');
      final facilityJson = json.decode(facilityString) as List;

      // Load equipment reservations
      final equipmentString = await rootBundle.loadString('assets/files/equipment_reservations.json');
      final equipmentJson = json.decode(equipmentString) as List;

      // Load users
      final usersString = await rootBundle.loadString('assets/files/user_manager.json');
      final usersJson = json.decode(usersString) as List;

      setState(() {
        _facilityReservations = List<Map<String, dynamic>>.from(facilityJson);
        _equipmentReservations = List<Map<String, dynamic>>.from(equipmentJson);
        _users = List<Map<String, dynamic>>.from(usersJson);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Get user name by userId
  String _getUserName(String userId) {
    try {
      final user = _users.firstWhere(
        (u) => u['id']?.toString() == userId,
        orElse: () => {},
      );
      return user['name'] ?? 'Unknown User';
    } catch (e) {
      return 'Unknown User';
    }
  }

  // Get reserved dates for the current month
  Set<int> _getReservedDates() {
    Set<int> dates = {};
    for (var reservation in _facilityReservations) {
      try {
        // Parse date format: "2025-10-01"
        DateTime reservationDate = DateTime.parse(reservation['date']);
        if (reservationDate.year == _selectedMonth.year &&
            reservationDate.month == _selectedMonth.month) {
          dates.add(reservationDate.day);
        }
      } catch (e) {
        print('Error parsing date: $e');
      }
    }
    return dates;
  }

  // Get reservations for a specific date
  List<Map<String, dynamic>> _getReservationsForDate(DateTime date) {
    String dateStr = DateFormat('yyyy-MM-dd').format(date);
    return _facilityReservations.where((reservation) {
      return reservation['date'] == dateStr;
    }).toList();
  }

  // Check if equipment is overdue
  String _getEquipmentStatus(String endDate) {
    try {
      DateTime returnDate = DateTime.parse(endDate);
      DateTime today = DateTime.now();
      
      if (returnDate.isBefore(DateTime(today.year, today.month, today.day))) {
        return 'Overdue';
      } else {
        return 'To Return';
      }
    } catch (e) {
      return 'To Return';
    }
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + 1,
      );
    });
  }

  List<DateTime?> _getDaysInMonth() {
    final firstDay = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final lastDay = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    
    final firstWeekday = firstDay.weekday % 7;
    
    List<DateTime?> days = [];
    
    for (int i = 0; i < firstWeekday; i++) {
      days.add(null);
    }
    
    for (int day = 1; day <= lastDay.day; day++) {
      days.add(DateTime(_selectedMonth.year, _selectedMonth.month, day));
    }
    
    return days;
  }

  void _showReservationsForDate(DateTime date) {
    final reservations = _getReservationsForDate(date);
    final dateStr = DateFormat('MMMM d, yyyy').format(date);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Reservation on',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          dateStr,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Reservations List
            Expanded(
              child: reservations.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 64,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No facility reservation in this date',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: reservations.length,
                      itemBuilder: (context, index) {
                        final reservation = reservations[index];
                        return _buildFacilityReservationCard(reservation);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilityReservationCard(Map<String, dynamic> reservation) {
    final userName = _getUserName(reservation['userId']?.toString() ?? '');
    final formattedDate = reservation['date'] != null 
        ? DateFormat('MM/dd/yyyy').format(DateTime.parse(reservation['date']))
        : 'Unknown Date';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reservation['facility'] ?? 'Unknown Facility',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.person,
                size: 14,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 6),
              Text(
                'Reserved by: $userName',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 6),
              Text(
                'Date: $formattedDate',
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
                Icons.access_time,
                size: 14,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 6),
              Text(
                reservation['timeSlot'] ?? 'Unknown Time',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reservedDates = _getReservedDates();

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
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'Reservation Manager',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage Reservations in SpartaGo',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tab Selector
                    Row(
                      children: [
                        Expanded(
                          child: _buildTabButton('Facilities', 0),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTabButton('Equipment', 1),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Content based on selected tab
                    _selectedTab == 0
                        ? _buildFacilitiesContent(reservedDates)
                        : _buildEquipmentContent(),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const UserManagerPage(),
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
          } else if (index == 3) {
            // Navigate to Equipment
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const EquipmentManagerPage(),
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
            icon: Icon(Icons.home_outlined),
            label: 'Facilities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
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

  Widget _buildTabButton(String label, int tab) {
    final isSelected = _selectedTab == tab;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = tab;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF8B1E1E) : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFacilitiesContent(Set<int> reservedDates) {
    return Column(
      children: [
        // Calendar Title (Centered)
        Center(
          child: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'SPARTA',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: 'GO',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF8B1E1E),
                  ),
                ),
                TextSpan(
                  text: ' CALENDAR',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Calendar Container
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Month Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _previousMonth,
                    icon: const Icon(Icons.chevron_left),
                    color: Colors.black,
                  ),
                  Text(
                    DateFormat('MMMM yyyy').format(_selectedMonth),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: _nextMonth,
                    icon: const Icon(Icons.chevron_right),
                    color: Colors.black,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Weekday Headers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                    .map((day) => SizedBox(
                          width: 35,
                          child: Center(
                            child: Text(
                              day,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: day == 'Su' || day == 'Sa'
                                    ? Colors.red.shade400
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),

              const SizedBox(height: 8),

              // Calendar Grid
              _buildCalendarGrid(reservedDates),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEquipmentContent() {
    return Column(
      children: [
        _equipmentReservations.isEmpty
            ? Center(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 64,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No equipment reservations',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _equipmentReservations.length,
                itemBuilder: (context, index) {
                  final equipment = _equipmentReservations[index];
                  return _buildEquipmentCard(equipment);
                },
              ),
      ],
    );
  }

  Widget _buildEquipmentCard(Map<String, dynamic> equipment) {
    final status = _getEquipmentStatus(equipment['endDate'] ?? '');
    final isOverdue = status == 'Overdue';
    final userName = _getUserName(equipment['userId']?.toString() ?? '');
    final formattedStartDate = equipment['startDate'] != null 
        ? DateFormat('MM/dd/yyyy').format(DateTime.parse(equipment['startDate']))
        : 'Unknown';
    final formattedEndDate = equipment['endDate'] != null 
        ? DateFormat('MM/dd/yyyy').format(DateTime.parse(equipment['endDate']))
        : 'Unknown';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // Equipment Image
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: equipment['image'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      equipment['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.fitness_center,
                        size: 35,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  )
                : Icon(
                    Icons.fitness_center,
                    size: 35,
                    color: Colors.grey.shade400,
                  ),
          ),
          const SizedBox(width: 12),
          // Equipment Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        equipment['name'] ?? 'Unknown Equipment',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isOverdue ? Colors.red.shade50 : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isOverdue ? Colors.red.shade700 : Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
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
                const SizedBox(height: 4),
                Text(
                  'Count: ${equipment['count'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Borrowed by: $userName',
                  style: TextStyle(
                    fontSize: 12,
                    color: isOverdue ? Colors.red.shade600 : Colors.green.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Start: $formattedStartDate | Return: $formattedEndDate',
                  style: TextStyle(
                    fontSize: 11,
                    color: isOverdue ? Colors.red.shade600 : Colors.green.shade900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Delete Icon
          IconButton(
            onPressed: () {
              // TODO: Implement delete functionality
            },
            icon: Icon(
              Icons.delete_outline,
              color: Colors.red.shade400,
              size: 22,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(Set<int> reservedDates) {
    final days = _getDaysInMonth();
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        
        if (day == null) {
          return const SizedBox.shrink();
        }

        final isReserved = reservedDates.contains(day.day);
        final isSelected = _selectedDate != null &&
            day.day == _selectedDate!.day &&
            day.month == _selectedDate!.month &&
            day.year == _selectedDate!.year;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = day;
            });
            _showReservationsForDate(day);
          },
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isReserved
                  ? const Color(0xFF8B1E1E)
                  : isSelected
                      ? Colors.grey.shade300
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isReserved
                      ? Colors.white
                      : isSelected
                          ? Colors.black
                          : Colors.black87,
                ),
              ),
            ),
          ),
        );
      },
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