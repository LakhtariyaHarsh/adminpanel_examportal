import 'package:admin_panel/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  final Function onLogout;

  CustomDrawer({Key? key, required this.onLogout}) : super(key: key);

  final Map<String, List<Map<String, String>>> menuItems = {
    "Dashboard": [
      {"title": "Home", "route": "/"},
    ],
    "Exams": [
      {"title": "View Exams", "route": "/exams"},
      {"title": "Add Exams", "route": "/exams/add"},
    ],
    "Category": [
      {"title": "View Categories", "route": "/categories"},
      {"title": "Add Categories", "route": "/categories/add"},
    ],
    "Eligibility": [
      {"title": "View Eligibilities", "route": "/eligibilities"},
      {"title": "Add Eligibilities", "route": "/eligibilities/add"},
    ],
    "Post": [
      {"title": "View Posts", "route": "/posts"},
      {"title": "Add Posts", "route": "/posts/add"},
    ],
  };

  void navigateTo(BuildContext context, String route) {
    context.push(route);
  }

  Widget _buildDivider() {
    return const Divider();
  }

  @override
  Widget build(BuildContext context) {
    // Create a list of drawer items by combining expandable menus and the logout item.
    final List<Widget> drawerItems = [
      ...menuItems.entries.map((entry) {
        return _buildExpandableMenu(context, entry.key, entry.value);
      }).toList(),
      _buildDrawerItem(context, Icons.logout, "Logout", "/login",
          isLogout: true),
    ];

    return Drawer(
      child: Container(
        color: white, // Change drawer body color to white
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: DrawerHeader(
                decoration: const BoxDecoration(color: white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.dashboard, size: 40, color: bluegrey),
                    SizedBox(height: 10),
                    Text("ADMIN DASHBOARD",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: black87)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: drawerItems.length,
                separatorBuilder: (context, index) => _buildDivider(),
                itemBuilder: (context, index) => drawerItems[index],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableMenu(
      BuildContext context, String title, List<Map<String, String>> items) {
    return ExpansionTile(
      leading: _getIcon(title),
      title: Text(title),
      children: items.map((item) {
        return _buildDrawerItem(
            context, Icons.circle, item["title"]!, item["route"]!);
      }).toList(),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, IconData icon, String title, String route,
      {bool isLogout = false}) {
    bool isSelected =
        GoRouter.of(context).routerDelegate.currentConfiguration.fullPath ==
            route;
    return Container(
      color: isSelected ? bluegray : Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.white : bluegrey),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {
          if (isLogout) {
            onLogout();
          }
          context.push(route);
        },
      ),
    );
  }

  Icon _getIcon(String title) {
    switch (title) {
      case "Exams":
        return Icon(Icons.school, color: bluegrey);
      case "Category":
        return Icon(Icons.category, color: bluegrey);
      case "Eligibility":
        return Icon(Icons.verified_user, color: bluegrey);
      case "Post":
        return Icon(Icons.article, color: bluegrey);
      default:
        return Icon(Icons.dashboard, color: bluegrey);
    }
  }
}
