import 'package:admin_panel/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatefulWidget {
  final Function onLogout;

  const CustomDrawer({Key? key, required this.onLogout}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? hoveredMenu;
  String? hoveredItem;

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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Container(
        color: const Color(0xFF2C2F3F), // Dark sidebar background
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildDivider(),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
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
            ),
            _buildDivider(),
            _buildDrawerItem(context, Icons.logout, "Logout", "/login",
                isLogout: true),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
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
              color: white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(color: white24, thickness: 1);
  }

  Widget _buildExpandableMenu(
      BuildContext context, String title, List<Map<String, String>> items) {
    bool isHovered = hoveredMenu == title;

    // Check if any of the child items' routes match the current route
    bool isSelected = items.any((item) =>
        GoRouter.of(context).routerDelegate.currentConfiguration.fullPath ==
        item["route"]);

    return MouseRegion(
      onEnter: (_) => setState(() => hoveredMenu = title),
      onExit: (_) => setState(() => hoveredMenu = null),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? Color(0xff494e53) // Selected menu item background color
                : isHovered
                    ? Color(0xff494e53) // Hover effect
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ExpansionTile(
            iconColor: white70,
            collapsedIconColor: white70,
            leading: _getIcon(title),
            title: Text(
              title,
              style: const TextStyle(color: white70),
            ),
            children: items.map((item) {
              return _buildDrawerItem(context, Icons.circle_outlined,
                  item["title"]!, item["route"]!);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, IconData icon, String title, String route,
      {bool isLogout = false}) {
    bool isHovered = hoveredItem == title;
    bool isSelected =
        GoRouter.of(context).routerDelegate.currentConfiguration.fullPath ==
            route;

    return MouseRegion(
      onEnter: (_) => setState(() => hoveredItem = title),
      onExit: (_) => setState(() => hoveredItem = null),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            if (isLogout) widget.onLogout();
            context.go(route);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: isHovered
                  ? Color(0xff6d7175)
                  : isSelected
                      ? blue.withOpacity(0.9)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            child: Row(
              children: [
                Icon(icon, color: isSelected ? white : white70, size: 20),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? white : white70,
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
        return Icon(Icons.school, color: white70);
      case "Category":
        return Icon(Icons.category, color: white70);
      case "Eligibility":
        return Icon(Icons.verified_user, color: white70);
      case "Post":
        return Icon(Icons.article, color: white70);
      default:
        return Icon(Icons.dashboard, color: white70);
    }
  }
}
