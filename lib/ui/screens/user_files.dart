import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme.dart';
import '../../data/models/health_file.dart';
import '../widgets/upload_dialog.dart';
import '../../services/api_service.dart';
import 'fileviewerscreen.dart';


class UserFilesScreen extends StatefulWidget {
  const UserFilesScreen({super.key});

  @override
  State<UserFilesScreen> createState() => _UserFilesScreenState();
}

class _UserFilesScreenState extends State<UserFilesScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<HealthFile> _uploadedFiles = [];
  List<HealthFile> _analyzedFiles = [];
  String _selectedFilter = 'all';
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadAnalyzedFiles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadAnalyzedFiles() async {
    try {
      final files = await ApiService.fetchAnalyzedOutputs();
      setState(() {
        _analyzedFiles = files.map((data) {
          return HealthFile(
            id: data['id'].toString(),
            name: data['name'],
            type: data['type'],
            uploadDate: DateTime.parse(data['uploadDate']),
            analysisDate: DateTime.tryParse(data['analysisDate']),
            summary: data['summary'], // can be null
          );
        }).toList();
      });
    } catch (e) {
      print("Error loading analyzed files: $e");
    }
  }

  List<HealthFile> _getFilteredFiles(List<HealthFile> files) {
    var filteredFiles = files;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filteredFiles = filteredFiles
          .where((file) =>
              file.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              file.type.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Apply type filter
    if (_selectedFilter != 'all') {
      filteredFiles = filteredFiles
          .where((file) =>
              file.type.toLowerCase() == _selectedFilter.toLowerCase())
          .toList();
    }

    // Apply date filter
    if (_selectedDate != null) {
      filteredFiles = filteredFiles
          .where((file) =>
              file.uploadDate.year == _selectedDate!.year &&
              file.uploadDate.month == _selectedDate!.month &&
              file.uploadDate.day == _selectedDate!.day)
          .toList();
    }

    return filteredFiles;
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Files'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // File Type Filter
            const Text('File Type',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildFilterChip('All', 'all'),
                _buildFilterChip('PDF', 'pdf'),
                _buildFilterChip('TXT', 'txt'),
                _buildFilterChip('Image', 'jpg'),
              ],
            ),
            const SizedBox(height: 16),
            // Date Filter
            const Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(_selectedDate == null
                  ? 'Select Date'
                  : DateFormat('MMM dd, yyyy').format(_selectedDate!)),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedFilter = 'all';
                _selectedDate = null;
              });
              Navigator.pop(context);
            },
            child: const Text('Clear Filters'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return FilterChip(
      label: Text(label),
      selected: _selectedFilter == value,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = selected ? value : 'all';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? AppTheme.darkBackgroundColor : AppTheme.backgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(context),
              if (_searchQuery.isNotEmpty ||
                  _selectedFilter != 'all' ||
                  _selectedDate != null)
                _buildActiveFilters(),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: _buildFileList(_getFilteredFiles(_analyzedFiles)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 20,
            bottom: 60,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return UploadDialog(
                        onFilesSelected: (filePaths) {
                          setState(() {
                            for (var filePath in filePaths) {
                              _uploadedFiles.add(
                                HealthFile.createDummy(
                                  id: DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                  name: filePath.split('/').last,
                                  type: filePath.split('.').last,
                                  uploadDate: DateTime.now(),
                                ),
                              );
                            }
                          });
                          Navigator.pop(context);
                        },
                        showBackButton: false,
                      );
                    },
                  );
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 23,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: AppTheme.primaryColor),
                  ),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Files',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Manage your health documents',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _showFilterDialog();
                      },

                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.filter_list,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _loadAnalyzedFiles(); // trigger fresh fetch
                      },
                    ),

                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.pushNamed(context, '/settings');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.settings_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search files...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          if (_selectedFilter != 'all')
            Chip(
              label: Text(_selectedFilter.toUpperCase()),
              onDeleted: () {
                setState(() {
                  _selectedFilter = 'all';
                });
              },
              deleteIcon: const Icon(Icons.close, size: 16),
            ),
          if (_selectedDate != null) ...[
            const SizedBox(width: 8),
            Chip(
              label: Text(DateFormat('MMM dd, yyyy').format(_selectedDate!)),
              onDeleted: () {
                setState(() {
                  _selectedDate = null;
                });
              },
              deleteIcon: const Icon(Icons.close, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  // Widget _buildTabBar() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //     decoration: BoxDecoration(
  //       color: Colors.grey.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(30),
  //     ),
  //     child: TabBar(
  //       controller: _tabController,
  //       dividerColor: Colors.transparent,
  //       indicator: BoxDecoration(
  //         color: AppTheme.primaryColor,
  //         borderRadius: BorderRadius.circular(30),
  //       ),
  //       labelColor: Colors.white,
  //       unselectedLabelColor: Colors.grey,
  //       tabs: const [
  //         Tab(text: 'Uploaded'),
  //         Tab(text: 'Analyzed'),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildFileList(List<HealthFile> files) {
    if (files.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.upload_file,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No files found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final isAnalyzed = file.analysisDate != null;
        final isPending = file.analysisDate == null &&
            file.uploadDate.isAfter(
              DateTime.now().subtract(const Duration(hours: 24)),
            );
        final isFailed = file.analysisDate == null && !isPending;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkCardColor : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            onTap: () {
              final userId = Supabase.instance.client.auth.currentUser?.id;
              final url = "<use your IP>/outputs/$userId/${file.name}";
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FileViewerScreen(
                    fileType: file.type.toLowerCase(),
                    fileUrl: url,
                  ),
                ),
              );
            },
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getFileIcon(file.type),
                color: AppTheme.primaryColor,
                size: 20,
              ),
            ),
            title: Text(
              file.name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Uploaded on ${DateFormat('MMM dd, yyyy').format(file.uploadDate)}',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        file.type.toUpperCase(),
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (isAnalyzed) ...[
                      const SizedBox(width: 8),
                      _buildStatusIndicator(isAnalyzed, isPending, isFailed),
                    ],
                  ],
                ),
                if (file.analysisDate != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Analyzed on ${DateFormat('MMM dd, yyyy').format(file.analysisDate!)}',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.more_vert,
                color: isDark ? Colors.white70 : Colors.grey[600],
                size: 20,
              ),
              onPressed: () {
                // Show file options menu
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusIndicator(bool isAnalyzed, bool isPending, bool isFailed) {
    Color color;
    IconData icon;
    String text;

    if (isAnalyzed) {
      color = Colors.green;
      icon = Icons.check_circle;
      text = 'Analyzed';
    } else if (isPending) {
      color = Colors.orange;
      icon = Icons.refresh;
      text = 'Processing';
    } else {
      color = Colors.red;
      icon = Icons.error;
      text = 'Failed';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'txt':
        return Icons.text_snippet;
      case 'png':
      case 'jpg':
      case 'jpeg':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }
}
