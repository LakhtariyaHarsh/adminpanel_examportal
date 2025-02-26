import 'package:admin_panel/view_models/Category_view_model.dart';
import 'package:admin_panel/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final categoryViewModel = Provider.of<CategoryViewModel>(context);

    final double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    bool isTablet = screenWidth < 1100;
    bool isDesktop = screenWidth >= 1100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 146, 156, 160),
        title: Text("Dashboard Screen", style: TextStyle(color: Colors.white)),
        actions: screenWidth >= 720
            ? [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        context.go('/');
                      },
                      child:
                          Text("Home", style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () {
                        context.go('/exams');
                      },
                      child:
                          Text("Exams", style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () {
                        context.go('/posts');
                      },
                      child:
                          Text("Posts", style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () {
                        context.go('/eligibilities');
                      },
                      child: Text("Eligibility",
                          style: TextStyle(color: Colors.white)),
                    ),
                    IconButton(
                      icon: Icon(Icons.logout, color: Colors.white),
                      onPressed: () {
                        authViewModel.logout();
                        context.go('/login');
                      },
                    ),
                  ],
                ),
              ]
            : null,
      ),
      drawer: isMobile
          ? Drawer(
              child: Container(
                color: const Color(0xffe3e4e6),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: DrawerHeader(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 244, 245, 246),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.dashboard,
                              size: 40,
                              color: Colors.blueGrey,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "ADMIN DASHBOARD",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.school,
                                color: Colors.blueGrey),
                            title: const Text("Dashboard"),
                            onTap: () {
                              context.go('/');
                            },
                          ),
                          Divider(),
                          ListTile(
                            leading: const Icon(Icons.send_and_archive_outlined,
                                color: Colors.blueGrey),
                            title: const Text("Exams"),
                            onTap: () {
                              context.go('/exams');
                            },
                          ),
                          Divider(),
                          ListTile(
                            leading: const Icon(Icons.category,
                                color: Colors.blueGrey),
                            title: const Text("Category"),
                            onTap: () {
                              context.go('/categories');
                            },
                          ),
                          Divider(),
                          ListTile(
                            leading: const Icon(Icons.article,
                                color: Colors.blueGrey),
                            title: const Text("Posts"),
                            onTap: () {
                              context.go('/posts');
                            },
                          ),
                          Divider(),
                          ListTile(
                            leading: const Icon(Icons.verified_user,
                                color: Colors.blueGrey),
                            title: const Text("Eligibility"),
                            onTap: () {
                              context.go('/eligibilities');
                            },
                          ),
                          Divider(),
                          ListTile(
                            leading: const Icon(Icons.logout,
                                color: Colors.blueGrey),
                            title: const Text("Logout"),
                            onTap: () {
                              authViewModel.logout();
                              context.go('/login');
                            },
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: Row(
        children: [
          //Drawer for desktop
          isDesktop
              ? Drawer(
                  child: Container(
                    color: const Color(0xffe3e4e6),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: DrawerHeader(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 244, 245, 246),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.dashboard,
                                  size: 40,
                                  color: Colors.blueGrey,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "ADMIN DASHBOARD",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.school,
                                    color: Colors.blueGrey),
                                title: const Text("Dashboard"),
                                onTap: () {
                                  context.go('/');
                                },
                              ),
                              Divider(),
                              ListTile(
                                leading: const Icon(
                                    Icons.send_and_archive_outlined,
                                    color: Colors.blueGrey),
                                title: const Text("Exams"),
                                onTap: () {
                                  context.go('/exams');
                                },
                              ),
                              Divider(),
                              ListTile(
                                leading: const Icon(Icons.category,
                                    color: Colors.blueGrey),
                                title: const Text("Category"),
                                onTap: () {
                                  context.go('/categories');
                                },
                              ),
                              Divider(),
                              ListTile(
                                leading: const Icon(Icons.article,
                                    color: Colors.blueGrey),
                                title: const Text("Posts"),
                                onTap: () {
                                  context.go('/posts');
                                },
                              ),
                              Divider(),
                              ListTile(
                                leading: const Icon(Icons.verified_user,
                                    color: Colors.blueGrey),
                                title: const Text("Eligibility"),
                                onTap: () {
                                  context.go('/eligibilities');
                                },
                              ),
                              Divider(),
                              ListTile(
                                leading: const Icon(Icons.logout,
                                    color: Colors.blueGrey),
                                title: const Text("Logout"),
                                onTap: () {
                                  authViewModel.logout();
                                  context.go('/login');
                                },
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 2 : isTablet ? 3 : 4,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.blueGrey.shade100,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
