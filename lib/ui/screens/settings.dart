import 'package:flutter/material.dart';
import '../../core/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _autoAnalyzeEnabled = true;
  bool _dataSharingEnabled = false;
  String _language = 'English';
  String _dateFormat = 'MM/DD/YYYY';

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                setState(() => _language = 'English');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Malayalam'),
              onTap: () {
                setState(() => _language = 'Malayalam');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDateFormatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Date Format'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('MM/DD/YYYY'),
              onTap: () {
                setState(() => _dateFormat = 'MM/DD/YYYY');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('DD/MM/YYYY'),
              onTap: () {
                setState(() => _dateFormat = 'DD/MM/YYYY');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
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
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const SizedBox(height: 20),
                    _buildSection(
                      'General',
                      [
                        _buildSettingTile(
                          icon: Icons.notifications,
                          title: 'Notifications',
                          subtitle: 'Receive alerts and updates',
                          trailing: Switch(
                            value: _notificationsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _notificationsEnabled = value;
                              });
                            },
                          ),
                        ),
                        _buildSettingTile(
                          icon: Icons.dark_mode,
                          title: 'Dark Mode',
                          subtitle: 'Toggle dark theme',
                          trailing: Switch(
                            value: _darkModeEnabled,
                            onChanged: (value) {
                              setState(() {
                                _darkModeEnabled = value;
                              });
                            },
                          ),
                        ),
                        _buildSettingTile(
                          icon: Icons.language,
                          title: 'Language',
                          subtitle: _language,
                          onTap: _showLanguageDialog,
                        ),
                        _buildSettingTile(
                          icon: Icons.calendar_today,
                          title: 'Date Format',
                          subtitle: _dateFormat,
                          onTap: _showDateFormatDialog,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSection(
                      'App Features',
                      [
                        _buildSettingTile(
                          icon: Icons.auto_awesome,
                          title: 'Auto Analysis',
                          subtitle: 'Automatically analyze new reports',
                          trailing: Switch(
                            value: _autoAnalyzeEnabled,
                            onChanged: (value) {
                              setState(() {
                                _autoAnalyzeEnabled = value;
                              });
                            },
                          ),
                        ),
                        _buildSettingTile(
                          icon: Icons.share,
                          title: 'Data Sharing',
                          subtitle: 'Share data with healthcare providers',
                          trailing: Switch(
                            value: _dataSharingEnabled,
                            onChanged: (value) {
                              setState(() {
                                _dataSharingEnabled = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSection(
                      'Privacy & Security',
                      [
                        _buildSettingTile(
                          icon: Icons.lock,
                          title: 'Privacy Settings',
                          subtitle: 'Manage data sharing & encryption',
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Privacy Settings'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SwitchListTile(
                                      title: const Text(
                                          'Share with Healthcare Providers'),
                                      value: _dataSharingEnabled,
                                      onChanged: (value) {
                                        setState(
                                            () => _dataSharingEnabled = value);
                                      },
                                    ),
                                    SwitchListTile(
                                      title: const Text('Encrypt Data'),
                                      value: true,
                                      onChanged: (value) {},
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        _buildSettingTile(
                          icon: Icons.security,
                          title: 'Security',
                          subtitle: 'Change password & 2FA settings',
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Security Settings'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: const Text('Change Password'),
                                      onTap: () {
                                        // Navigate to change password screen
                                      },
                                    ),
                                    SwitchListTile(
                                      title: const Text('Enable 2FA'),
                                      value: false,
                                      onChanged: (value) {},
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        _buildSettingTile(
                          icon: Icons.delete,
                          title: 'Data Management',
                          subtitle: 'Clear cache & manage storage',
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Data Management'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: const Text('Clear Cache'),
                                      onTap: () {
                                        // Clear cache implementation
                                      },
                                    ),
                                    ListTile(
                                      title: const Text('Manage Storage'),
                                      onTap: () {
                                        // Storage management implementation
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSection(
                      'About',
                      [
                        _buildSettingTile(
                          icon: Icons.info,
                          title: 'About App',
                          subtitle: 'Version 1.0.0',
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('About'),
                                content: const Text(
                                  'Health Report Analyzer\nVersion 1.0.0\n\nA smart tool for analyzing health reports and providing insights.',
                                ),
                              ),
                            );
                          },
                        ),
                        _buildSettingTile(
                          icon: Icons.help,
                          title: 'Help & Support',
                          subtitle: 'Get help and contact support',
                          onTap: () {
                            // Navigate to help screen
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSection(
                      'Account',
                      [
                        _buildSettingTile(
                          icon: Icons.logout,
                          title: 'Logout',
                          subtitle: 'Sign out of your account',
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Logout'),
                                content: const Text(
                                    'Are you sure you want to logout?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Close dialog
                                      Navigator.pushReplacementNamed(
                                          context, '/login');
                                    },
                                    child: const Text(
                                      'Logout',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
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
                    child: Icon(Icons.settings, color: AppTheme.primaryColor),
                  ),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Customize your app experience',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppTheme.darkTextSecondaryColor
                  : AppTheme.textSecondaryColor,
            ),
          ),
        ),
        Container(
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
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.white70 : Colors.grey[600],
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
