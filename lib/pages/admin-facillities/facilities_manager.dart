import 'package:flutter/material.dart';
import 'package:sparta_go/pages/admin-equipment/equipment_manager.dart';
import 'package:sparta_go/pages/admin-facillities/facilities_manager.dart';
import 'package:sparta_go/pages/admin-reservation/reservation_manager.dart';
import 'dart:convert';
import 'package:sparta_go/pages/admin-user_manager/user_manager.dart';
import 'package:http/http.dart' as http;
import 'package:sparta_go/constant/constant.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

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

class FacilityManagerPage extends StatefulWidget {
  const FacilityManagerPage({Key? key}) : super(key: key);

  @override
  State<FacilityManagerPage> createState() => _FacilityManagerPageState();
}

class _FacilityManagerPageState extends State<FacilityManagerPage> {
  int _currentIndex = 2; // Facilities tab selected
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  Uint8List? _selectedImageBytes; // Store the image bytes
  String? _selectedImageName; // Store the image filename

  List<Map<String, dynamic>> _facilities = [];
  bool _isLoading = true;
  String? _expandedFacilityId; // Track which Facility is expanded

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController equipmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFacilitiesData();
  }

  // HTTP GET request to fetch all Facilities
  Future<void> _loadFacilitiesData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      print('🔄 Fetching Facilities from: $API_URL/facilities/');

      final response = await http.get(
        Uri.parse('$API_URL/facilities/'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<Map<String, dynamic>> facilitiesList = 
            jsonData.map((item) => item as Map<String, dynamic>).toList();

        print('✅ Successfully fetched ${facilitiesList.length} Facilities items');

        setState(() {
          _facilities = facilitiesList;
          _isLoading = false;
        });
      } else {
        print('❌ Error: Status code ${response.statusCode}');
        
        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load Facilities: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Error loading Facilities data: $e');
      
      setState(() {
        _isLoading = false;
      });

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

  // HTTP DELETE request to delete Facility
  Future<void> _deleteFacility(int facilityId) async {
    try {
      print('🔄 Deleting Facility ID: $facilityId');

      final response = await http.delete(
        Uri.parse('$API_URL/facilities/$facilityId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ Facility deleted successfully');

        // Reload Facilities list
        await _loadFacilitiesData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Facility deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        print('❌ Error: Status code ${response.statusCode}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete Facility: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Error deleting Facility: $e');

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

    // HTTP POST add facility
    Future<void> _addFacility() async {
    try {
      // Convert image bytes to base64 if image is selected
      String? base64Image;
      if (_selectedImageBytes != null) {
        base64Image = base64Encode(_selectedImageBytes!);
        print('📷 Image encoded to base64, length: ${base64Image.length}');
      }

      final facilityData = {
        "name": nameController.text,
        "description": descController.text,
        "image": base64Image, // Send base64 string instead of filename
        "building": buildingController.text,
        "capacity": capacityController.text,
        "equipment": equipmentController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        "type": typeController.text
      };

      print('🔄 Adding new facility: ${facilityData.keys}');

      final response = await http.post(
        Uri.parse('$API_URL/facilities/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(facilityData),
      );

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('✅ Facility added successfully');
        
        // Clear controllers and image
        nameController.clear();
        descController.clear();
        imageController.clear();
        buildingController.clear();
        capacityController.clear();
        equipmentController.clear();
        typeController.clear();
        setState(() {
          _selectedImageBytes = null;
          _selectedImageName = null;
        });

        // Reload facilities list
        await _loadFacilitiesData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Facility added successfully"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } else {
        print('❌ Error: ${response.body}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${response.statusCode}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print("❌ Error adding facility: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

// Image for add facility
Future<void> _pickImage() async {
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
        _selectedImageName = image.name;
      });
      
      print('✅ Image selected: ${image.name}, Size: ${bytes.length} bytes');
    }
  } catch (e) {
    print('❌ Error picking image: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}


  @override
  void dispose() {
    _searchController.dispose();
    nameController.dispose();
    descController.dispose();
    imageController.dispose();
    buildingController.dispose();
    capacityController.dispose();
    typeController.dispose();
    equipmentController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredFacilities {
    List<Map<String, dynamic>> filtered = _facilities;

    // Filter by type
    if (_selectedFilter != 'All') {
      filtered = filtered.where((facility) {
        return facility['type'] == _selectedFilter;
      }).toList();
    }

    // Filter by search query
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((facility) {
        final name = facility['name'].toString().toLowerCase();
        return name.contains(query);
      }).toList();
    }

    return filtered;
  }

  void _toggleFacilityExpansion(Map<String, dynamic> facility) {
    setState(() {
      final facilityId = facility['id']?.toString() ?? facility['name'];
      if (_expandedFacilityId == facilityId) {
        _expandedFacilityId = null; // Collapse if already expanded
      } else {
        _expandedFacilityId = facilityId; // Expand
      }
    });
  }

  void _showDeleteConfirmation(Map<String, dynamic> facility) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Facility'),
        content: Text('Are you sure you want to delete ${facility['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              
              // Call HTTP DELETE
              final facilityId = facility['id'] as int?;
              if (facilityId != null) {
                _deleteFacility(facilityId);
                setState(() {
                  _expandedFacilityId = null; // Collapse after delete
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Invalid Facility ID'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
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

    void _showAddFacilityDialog() {
      String selectedType = 'Court'; // Default type

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
              // Clear controllers and image
              nameController.clear();
              descController.clear();
              imageController.clear();
              buildingController.clear();
              capacityController.clear();
              equipmentController.clear();
              typeController.clear();
              setState(() {
                _selectedImageBytes = null;
                _selectedImageName = null;
              });
              Navigator.pop(context);
            },
              ),
              title: const Text(
                'Add Facility',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: StatefulBuilder(
              builder: (context, setDialogState) => SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Placeholder
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300, width: 2),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade50,
                          ),
                          child: _selectedImageBytes != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.memory(
                                    _selectedImageBytes!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate,
                                      size: 40,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Add Facility Photo',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Facility Name
                    const Text(
                      'Add Facility Name',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description
                    const Text(
                      'Add Description',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Description',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Building
                    const Text(
                      'Add Building',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: buildingController,
                      decoration: InputDecoration(
                        hintText: 'Building',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Capacity
                    const Text(
                      'Add Capacity',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: capacityController,
                      decoration: InputDecoration(
                        hintText: 'Capacity',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Equipment
                    const Text(
                      'Add Facility Equipment',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: equipmentController,
                      decoration: InputDecoration(
                        hintText: 'Equipment (comma-separated)',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Facility Type
                    const Text(
                      'Select Facility Type',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        hintText: 'Type',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Court', child: Text('Court')),
                        DropdownMenuItem(value: 'Gym', child: Text('Gym')),
                        DropdownMenuItem(value: 'Studio', child: Text('Studio')),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          selectedType = value!;
                          typeController.text = value;
                        });
                      },
                    ),
                    const SizedBox(height: 32),

                    // Add Facility Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Validation
                          if (nameController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Facility name is required'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          if (buildingController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Building location is required'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // Set the selected type
                          typeController.text = selectedType;

                          // Call the add facility function
                          _addFacility();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B1E1E),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Add Facility',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
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
                    'Facilities Manager',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage Facilities in SpartaGo',
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
                      hintText: 'Search facilities...',
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
                    filters: const ['All', 'Court', 'Gym', 'Studio'],
                    selectedFilter: _selectedFilter,
                    onFilterSelected: (filter) {
                      setState(() {
                        _selectedFilter = filter;
                        _expandedFacilityId = null; // Collapse when filter changes
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // Facilities List
                  Expanded(
                    child: _filteredFacilities.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.home_work_outlined,
                                  size: 64,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No Facilities found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _filteredFacilities.length,
                            itemBuilder: (context, index) {
                              final facility = _filteredFacilities[index];
                              final facilityId = facility['id']?.toString() ?? facility['name'];
                              final isExpanded = _expandedFacilityId == facilityId;
                              return _buildFacilityCard(facility, isExpanded);
                            },
                          ),
                  ),

                  // Add Facility Button
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _showAddFacilityDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B1E1E),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Add Facility',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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

  Widget _buildFacilityCard(Map<String, dynamic> facility, bool isExpanded) {
    return GestureDetector(
      onTap: () => _toggleFacilityExpansion(facility),
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
            ? _buildExpandedCard(facility)
            : _buildCollapsedCard(facility),
      ),
    );
  }

  Widget _buildCollapsedCard(Map<String, dynamic> facility) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Facility Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: facility['image'] != null && facility['image'].toString().isNotEmpty
                    ? Image.memory(
                        base64Decode(facility['image']),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.home_work_outlined,
                          size: 40,
                          color: Colors.grey.shade400,
                        ),
                      )
                    : Icon(
                        Icons.home_work_outlined,
                        size: 40,
                        color: Colors.grey.shade400,
                      )
            ),
          ),
          const SizedBox(width: 12),
          // Facility Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  facility['name'] ?? 'Unknown Facility',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  facility['description'] ?? '',
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
                      Icons.location_on,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        facility['building'] ?? 'N/A',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    facility['type'] ?? 'N/A',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
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

  Widget _buildExpandedCard(Map<String, dynamic> facility) {
    final equipment = facility['equipment'] as List<dynamic>?;
    final equipmentList = equipment?.map((e) => e.toString()).toList() ?? [];
    
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
              child: facility['image'] != null && facility['image'].toString().isNotEmpty
              ? _buildImage(
                  facility['image'],
                  Icons.home_work_outlined,
                )
              : Container(
                  color: Colors.grey.shade300,
                  child: Icon(
                    Icons.home_work_outlined,
                    size: 50,
                    color: Colors.grey.shade400,
                  ),
                ),
            ),
          ),
          const SizedBox(height: 16),

          // Facility Name
          Text(
            facility['name'] ?? 'Unknown Facility',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            facility['description'] ?? '',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // Building
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  facility['building'] ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Capacity
          Row(
            children: [
              const Icon(
                Icons.people,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                'Capacity: ${facility['capacity'] ?? 'N/A'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Equipment List
          if (equipmentList.isNotEmpty) ...[
            const Row(
              children: [
                Icon(
                  Icons.inventory_2,
                  size: 16,
                  color: Colors.white,
                ),
                SizedBox(width: 6),
                Text(
                  'Equipment:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: equipmentList.map((eq) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    eq,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],

          // Type Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Type: ${facility['type'] ?? 'N/A'}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8B1E1E),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Delete Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showDeleteConfirmation(facility);
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
                'Delete Facility',
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
              onPressed: () => _toggleFacilityExpansion(facility),
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

  Widget _buildImage(String imageData, IconData fallbackIcon) {
  // Check if it's base64 (base64 strings are typically very long and don't have file extensions)
  if (imageData.length > 100 && !imageData.contains('.')) {
    // It's base64
    try {
      return Image.memory(
        base64Decode(imageData),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey.shade300,
          child: Icon(
            fallbackIcon,
            size: 50,
            color: Colors.grey.shade400,
          ),
        ),
      );
    } catch (e) {
      print('Error decoding base64 image: $e');
      return Container(
        color: Colors.grey.shade300,
        child: Icon(
          fallbackIcon,
          size: 50,
          color: Colors.grey.shade400,
        ),
      );
    }
  } else {
    // It's a filename, load from assets
    return Image.asset(
      "assets/images/$imageData",
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey.shade300,
        child: Icon(
          fallbackIcon,
          size: 50,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
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