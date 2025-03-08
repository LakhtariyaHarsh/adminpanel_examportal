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
    return const Divider(color: white24, thickness: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.zero, // Force removal of default border radius
      ),
      child: Container(
        color: const Color(0xFF2C2F3F), // Dark sidebar background
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/login.png"),
                    radius: 30,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Hi, Admin 👋",
                    style: TextStyle(
                        color: white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            _buildDivider(),
            Expanded(
              child: ListView.separated(
                itemCount: menuItems.keys.length,
                itemBuilder: (context, index) {
                  String sectionTitle = menuItems.keys.elementAt(index);
                  List<Map<String, String>> sectionItems =
                      menuItems[sectionTitle]!;
                  return _buildExpandableMenu(
                      context, sectionTitle, sectionItems);
                },
                separatorBuilder: (context, index) => _buildDivider(),
              ),
            ),
            _buildDivider(),
            _buildDrawerItem(context, Icons.logout, "Logout", "/login",
                isLogout: true),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableMenu(
      BuildContext context, String title, List<Map<String, String>> items) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: transparent),
      child: ExpansionTile(
        iconColor: white,
        collapsedIconColor: white70,
        leading: _getIcon(title),
        title: Text(
          title,
          style: const TextStyle(color: white, fontWeight: FontWeight.bold),
        ),
        children: items.map((item) {
          return _buildDrawerItem(
              context, Icons.circle, item["title"]!, item["route"]!);
        }).toList(),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, IconData icon, String title, String route,
      {bool isLogout = false}) {
    bool isSelected =
        GoRouter.of(context).routerDelegate.currentConfiguration.fullPath ==
            route;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: MouseRegion(
        onEnter: (_) => {},
        onExit: (_) => {},
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            if (isLogout) {
              onLogout();
            }
            context.go(route);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: isSelected ? blue.withOpacity(0.9) : transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? white : white70,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? white : white70,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Icon _getIcon(String title) {
    switch (title) {
      case "Exams":
        return Icon(Icons.school, color: white);
      case "Category":
        return Icon(Icons.category, color: white);
      case "Eligibility":
        return Icon(Icons.verified_user, color: white);
      case "Post":
        return Icon(Icons.article, color: white);
      default:
        return Icon(Icons.dashboard, color: white);
    }
  }
}
