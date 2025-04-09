import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'dashboard.dart';
import 'user_files.dart';
import 'ai_chat.dart';
import 'patch.dart';
import '../widgets/upload_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const UserFilesScreen(),
    const AIChatScreen(),
    const AIChatScreen(),
    const PatchScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // Show file upload dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return UploadDialog(
            onFilesSelected: (filePaths) {
              Navigator.pop(context);
              // After file upload, switch to the files tab
              setState(() {
                _selectedIndex = 1;
              });
            },
            showBackButton: false,
          );
        },
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? AppTheme.darkBackgroundColor : AppTheme.backgroundColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 8),
          height: 60,
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkSurfaceColor : Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              backgroundColor:
                  isDark ? AppTheme.darkSurfaceColor : Colors.white,
              selectedItemColor: AppTheme.primaryColor,
              unselectedItemColor:
                  isDark ? AppTheme.darkTextSecondaryColor : Colors.grey,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.folder_outlined),
                  activeIcon: Icon(Icons.folder),
                  label: 'Files',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline),
                  activeIcon: Icon(Icons.add_circle),
                  label: 'Upload',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.smart_toy_outlined),
                  activeIcon: Icon(Icons.smart_toy),
                  label: 'AI',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.medical_services_outlined),
                  activeIcon: Icon(Icons.medical_services),
                  label: 'Patch',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
