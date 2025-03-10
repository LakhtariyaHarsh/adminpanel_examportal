import 'package:admin_panel/constants/button.dart';
import 'package:admin_panel/constants/constant.dart';
import 'package:admin_panel/constants/customdrawer.dart';
import 'package:admin_panel/view_models/Eligibility_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';

class EligibilityScreen extends StatefulWidget {
  @override
  State<EligibilityScreen> createState() => _EligibilityState();
}

class _EligibilityState extends State<EligibilityScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EligibilityViewModel>(context, listen: false)
          .fetchEligibilities();
    });
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Scroll listener to load more eligibilities when near bottom.
  void _scrollListener() {
    final eligibilityViewModel =
        Provider.of<EligibilityViewModel>(context, listen: false);

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!eligibilityViewModel.isLoading &&
          eligibilityViewModel.page < eligibilityViewModel.totalPages) {
        eligibilityViewModel.fetchEligibilities(isLoadMore: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final eligibilityViewModel =
        Provider.of<EligibilityViewModel>(context, listen: false);

    final double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600;
    bool isDesktop = screenWidth >= 1100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        title: Center(
          child: Row(
            children: [
              Image.asset("assets/images/app_logo.png", height: 30),
              SizedBox(width: 10),
              Text("Eligibility Screen", style: TextStyle(color: white)),
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
            child: Container(
              color: bluegray50,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          "All Eligibilities",
                          style: TextStyle(fontSize: 30),
                        ),
                        Divider(),
                        SizedBox(height: 20),
                        // Search Bar
                        isDesktop || isTablet
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 300,
                                    child: TextField(
                                      controller: _searchController,
                                      onChanged: (value) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          setState(() {
                                            _searchQuery = value;
                                          });

                                          if (value.isEmpty) {
                                            eligibilityViewModel.clearSearch();
                                          } else {
                                            eligibilityViewModel
                                                .searchEligibilities(value);
                                          }
                                        });
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Search eligibilities",
                                        prefixIcon: Icon(Icons.search),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        filled: true,
                                        fillColor: white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    height: 50,
                                    child: CustomButton(
                                      text: "Add Eligibilities",
                                      route: "/eligibilities/add",
                                      backgroundColor: Colors.blue,
                                      textColor: Colors.white,
                                      borderRadius: 8.0,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextField(
                                    controller: _searchController,
                                    onChanged: (value) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          setState(() {
                                            _searchQuery = value;
                                          });

                                          if (value.isEmpty) {
                                            eligibilityViewModel.clearSearch();
                                          } else {
                                            eligibilityViewModel
                                                .searchEligibilities(value);
                                          }
                                        });
                                      },
                                    decoration: InputDecoration(
                                      labelText: "Search eligibilities",
                                      prefixIcon: Icon(Icons.search),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      filled: true,
                                      fillColor: white,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  SizedBox(
                                      width:
                                          200, // Set fixed width for the button
                                      height: 50, // Optional: Set fixed height
                                      child: CustomButton(
                                        text: "Add Eligiblities",
                                        route: "/eligibilities/add",
                                        backgroundColor: Colors.blue,
                                        textColor: Colors.white,
                                        borderRadius: 8.0,
                                      )),
                                ],
                              ),
                        SizedBox(height: 20),
                        // Eligibility List
                        Expanded(
                          child: Consumer<EligibilityViewModel>(
                            builder: (context, eligibilityViewModel, child) {
                              final bool isSearching = _searchQuery.isNotEmpty;
                              final List displayedEligibilities = isSearching
                                  ? eligibilityViewModel.searchResults
                                  : eligibilityViewModel.eligibilities;

                              if (eligibilityViewModel.isLoading &&
                                  displayedEligibilities.isEmpty) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }

                              return ListView.builder(
                                controller: _scrollController,
                                itemCount: displayedEligibilities.length,
                                itemBuilder: (context, index) {
                                  final eligibility =
                                      displayedEligibilities[index];
                                  return Card(
                                    color: bluegray50,
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ListTile(
                                      title: Text(
                                        eligibility["name"] ??
                                            eligibility[
                                                "eligibilityCriteria"] ??
                                            "",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      trailing: SizedBox(
                                        width: 100,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.edit,
                                                  color: Colors.blue),
                                              onPressed: () {
                                                context.push(
                                                    '/eligibilities/update/${eligibility["id"]}');
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete,
                                                  color: red),
                                              onPressed: () async {
                                                final id =
                                                    eligibility["id"] ?? "";
                                                await eligibilityViewModel
                                                    .deleteEligibility(id);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          "Eligibility deleted successfully")),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
