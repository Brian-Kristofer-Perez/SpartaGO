import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sparta_go/pages/admin-user_manager/user_manager.dart';

class ReservationManagerPage extends StatefulWidget {
  const ReservationManagerPage({Key? key}) : super(key: key);

  @override
  State<ReservationManagerPage> createState() => _ReservationManagerPageState();
}

class _ReservationManagerPageState extends State<ReservationManagerPage> {
  int _currentIndex = 1; // Reservations tab selected
  DateTime _selectedMonth = DateTime.now();
  DateTime? _selectedDate;
  int _selectedFilter = 1; // 0 for Archived, 1 for Active

  // Sample reserved dates (day of month)
  final Set<int> _reservedDates = {24, 30};

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
    
    // Get the day of week for the first day (0 = Sunday, 6 = Saturday)
    final firstWeekday = firstDay.weekday % 7;
    
    List<DateTime?> days = [];
    
    // Add empty cells for days before the first day
    for (int i = 0; i < firstWeekday; i++) {
      days.add(null);
    }
    
    // Add all days in the month
    for (int day = 1; day <= lastDay.day; day++) {
      days.add(DateTime(_selectedMonth.year, _selectedMonth.month, day));
    }
    
    return days;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'Reservation Manager',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Manage Reservations in SpartaGo',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),

              // Calendar Title (Centered)
              Center(
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'SPARTA',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: 'GO',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B1E1E),
                        ),
                      ),
                      TextSpan(
                        text: ' CALENDAR',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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
                    _buildCalendarGrid(),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Filter Buttons
              Row(
                children: [
                  Expanded(
                    child: _buildFilterButton('Archived Reservations', 0),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFilterButton('Active Reservations', 1),
                  ),
                ],
              ),

              const SizedBox(height: 20),
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
          } else if (index == 2) {
            // Navigate to Facilities
          } else if (index == 3) {
            // Navigate to Equipment
          } else if (index == 4) {
            _showLogoutDialog();
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF8B1E1E),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
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

  Widget _buildCalendarGrid() {
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

        final isReserved = _reservedDates.contains(day.day);
        final isSelected = _selectedDate != null &&
            day.day == _selectedDate!.day &&
            day.month == _selectedDate!.month &&
            day.year == _selectedDate!.year;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = day;
            });
            // TODO: Show reservations for this date
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

  Widget _buildFilterButton(String label, int index) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = index;
        });
        // TODO: Filter reservations
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF8B1E1E) : Colors.grey.shade300,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFF8B1E1E) : Colors.black87,
            ),
          ),
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