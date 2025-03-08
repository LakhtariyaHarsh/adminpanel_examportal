import 'package:admin_panel/constants/constant.dart';
import 'package:admin_panel/constants/customdrawer.dart';
import 'package:admin_panel/view_models/Category_view_model.dart';
import 'package:admin_panel/view_models/Eligibility_view_model.dart';
import 'package:admin_panel/view_models/auth_view_model.dart';
import 'package:admin_panel/view_models/exam_view_model.dart';
import 'package:admin_panel/view_models/post_view_model.dart';
import 'package:flutter/material.dart';
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
    final examViewModel = Provider.of<ExamViewModel>(context);
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    final postViewModel = Provider.of<PostViewModel>(context);
    final eligibilityViewModel = Provider.of<EligibilityViewModel>(context);

    final List Exams = examViewModel.exams;
    final List Categories = categoryViewModel.categories;
    final List Posts = postViewModel.posts;
    final List Eligibilities = eligibilityViewModel.eligibilities;

    final double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    bool isTablet = screenWidth < 1140;
    bool isDesktop = screenWidth >= 1140;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        title: Center(child: Row(
          children: [
            Image.asset("assets/images/app_logo.png", height: 30),
            SizedBox(width: 10),
            Text("Dashboard Screen", style: TextStyle(color: white)),
          ],
        )),
      ),
      drawer: isDesktop
          ? null :CustomDrawer(onLogout: () => authViewModel.logout(),),
      body: Row(
        children: [
          //Drawer for desktop
          isDesktop
              ? CustomDrawer(onLogout: () => authViewModel.logout(),)  : SizedBox(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 8 : isTablet? 15: 50.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile
                      ? 2
                      : isTablet
                          ? 3
                          : 4,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  List<Map<String, dynamic>> cardData = [
                    {'title': "Total Exams", 'count': Exams.length},
                    {'title': "Total Categories", 'count': Categories.length},
                    {'title': "Total Posts", 'count': Posts.length},
                    {
                      'title': "Total Eligibilities",
                      'count': Eligibilities.length
                    },
                  ];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: bluegray50,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  cardData[index]['title'],
                                  style: TextStyle(
                                    fontSize: isMobile? 16 :isTablet? 22: 24,
                                    fontWeight: FontWeight.bold,
                                    color: black87,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              cardData[index]['count'].toString(),
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: bluegray90,
                              ),
                            ),
                          ],
                        ),
                      ),
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
