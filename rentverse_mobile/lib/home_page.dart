import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'enums/user_role.dart';
import 'services/user_provider.dart';
import 'shared/widgets/secure_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _where = '';
  String _selectedType = 'All Types';
  String _selectedPrice = 'Any Price';

  final Color primaryColor = const Color(0xFF1976D2);
  final List<String> _propertyTypes = [
    'All Types',
    'Apartment',
    'House',
    'Studio',
    'Villa'
  ];
  final List<String> _priceRanges = [
    'Any Price',
    '< RM 1000',
    'RM 1000 - 2500',
    'RM 2500+'
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Digital Rental',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(Icons.logout), onPressed: userProvider.logout),
        ],
      ),
      drawer: _buildAppDrawer(context, userProvider),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Hero Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hello, ${userProvider.currentUser.name}!',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Find your dream home today',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8), fontSize: 16)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Search Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 8,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.location_on, color: primaryColor),
                          hintText: 'City, Area or Zip...',
                          labelText: 'Location',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                        ),
                        onChanged: (val) => setState(() => _where = val),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedType,
                              decoration: InputDecoration(
                                labelText: 'Type',
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none),
                              ),
                              items: _propertyTypes
                                  .map((t) => DropdownMenuItem(
                                      value: t, child: Text(t)))
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedType = val!),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedPrice,
                              decoration: InputDecoration(
                                labelText: 'Budget',
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none),
                              ),
                              items: _priceRanges
                                  .map((p) => DropdownMenuItem(
                                      value: p, child: Text(p)))
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedPrice = val!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(55),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/properties', arguments: {
                            'location': _where,
                            'type': _selectedType == 'All Types'
                                ? ''
                                : _selectedType,
                            'priceRange': _selectedPrice,
                          });
                        },
                        child: const Text('SEARCH PROPERTIES',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SecureButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed('/upload-property'),
                label: 'List Your Property',
                requiredRoles: const [UserRole.Owner, UserRole.Admin],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppDrawer(BuildContext context, UserProvider userProvider) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userProvider.currentUser.name),
            accountEmail: Text('Role: ${userProvider.currentRole.name}'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(userProvider.currentRole.name[0]),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.apartment),
            title: const Text('View Properties'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/properties');
            },
          ),
          if (userProvider.currentRole == UserRole.Admin)
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Activity Log Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/activity-log');
              },
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              userProvider.logout();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}