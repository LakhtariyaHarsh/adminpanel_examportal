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
    final eligibilityViewModel =
        Provider.of<EligibilityViewModel>(context, listen: false);
    // Fetch initial categories.
    eligibilityViewModel.fetchEligibilities();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Scroll listener that triggers load-more when near bottom.
  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final eligibilityViewModel =
          Provider.of<EligibilityViewModel>(context, listen: false);
      // If not loading and more pages exist, fetch more.
      if (!eligibilityViewModel.isLoading &&
          eligibilityViewModel.page < eligibilityViewModel.totalPages) {
        eligibilityViewModel.fetchEligibilities(isLoadMore: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    final eligibilityViewModel = Provider.of<EligibilityViewModel>(context);
    // If a search query is active, use the search results; otherwise, show the full list.
    final bool isSearching = _searchQuery.isNotEmpty;
    final List displaydEligibilities = isSearching
        ? eligibilityViewModel.searchResults
        : eligibilityViewModel.eligibilities;

    final double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 720;
    bool isDesktop = screenWidth >= 1100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bluegray,
        title: Center(child: Text("ALL ELIGIBILITIES", style: TextStyle(color: white))),
      ),
      drawer: isDesktop
          ? null :CustomDrawer(onLogout: () => authViewModel.logout(),),
      body: Row(
        children: [
          //Drawer for desktop
          isDesktop
              ? CustomDrawer(
                  onLogout: () => authViewModel.logout(),
                )
              : SizedBox(),
          eligibilityViewModel.isLoading &&
                  eligibilityViewModel.eligibilities.isEmpty
              ? Expanded(child: Center(child: CircularProgressIndicator()))
              : Expanded(
                  child: Container(
                    color: bluegray50,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // Search Bar
                          TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                              if (value.isEmpty) {
                                eligibilityViewModel.clearSearch();
                              } else {
                                eligibilityViewModel.searchCategories(value);
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "Search eligibilities",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              filled: true,
                              fillColor: white,
                            ),
                          ),
                          SizedBox(height: 20),
                          // eligibility List
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: displaydEligibilities.length,
                              itemBuilder: (context, index) {
                                final eligibility =
                                    displaydEligibilities[index];
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    title: Text(
                                      eligibility["name"] ??
                                          eligibility["eligiblityCriteria"] ??
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
                                                color: blue),
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
                                                        "eligibility deleted successfully")),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          // Optional: A loader at the bottom when loading more data.
                          if (eligibilityViewModel.isLoading &&
                              eligibilityViewModel.eligibilities.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
