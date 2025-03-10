import 'package:admin_panel/constants/constant.dart';
import 'package:admin_panel/constants/customdrawer.dart';
import 'package:admin_panel/view_models/Category_view_model.dart';
import 'package:admin_panel/view_models/Eligibility_view_model.dart';
import 'package:admin_panel/view_models/auth_view_model.dart';
import 'package:admin_panel/view_models/exam_view_model.dart';
import 'package:admin_panel/view_models/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    bool isTablet = screenWidth < 1100;
    bool isDesktop = screenWidth >= 1100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        title: Center(
          child: Row(
            children: [
              Image.asset("assets/images/app_logo.png", height: 30),
              SizedBox(width: 10),
              Text("Dashboard Screen", style: TextStyle(color: white)),
            ],
          ),
        ),
      ),
      drawer: isDesktop
          ? null
          : CustomDrawer(
              onLogout: () => authViewModel.logout(),
            ),
      body: Row(
        children: [
          isDesktop
              ? CustomDrawer(
                  onLogout: () => authViewModel.logout(),
                )
              : SizedBox(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 8 : 15.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile
                      ? 2
                      : isTablet
                          ? 3
                          : 4,
                  childAspectRatio: 2.0,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 10,
                ),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  List<Map<String, dynamic>> cardData = [
                    {
                      'title': "Total Exams",
                      'count': Exams.length,
                      'color': Colors.teal,
                      'icon': FontAwesomeIcons.bookOpenReader
                    },
                    {
                      'title': "Total Eligibilities",
                      'count': Eligibilities.length,
                      'color': Colors.green,
                      'icon': FontAwesomeIcons.chartLine
                    },
                    {
                      'title': "Total Categories",
                      'count': Categories.length,
                      'color': Colors.amber,
                      'icon': FontAwesomeIcons.list
                    },
                    {
                      'title': "Total Posts",
                      'count': Posts.length,
                      'color': Colors.red,
                      'icon': FontAwesomeIcons.newspaper
                    },
                  ];

                  return Card(
                    color: cardData[index]['color'],
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 15,
                          right: 15,
                          child: Icon(
                            cardData[index]['icon'],
                            size: 55,
                            color: black12,
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                cardData[index]['count'].toString(),
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              // SizedBox(height: 5),
                              Flexible(
                                child: Text(
                                  cardData[index]['title'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
