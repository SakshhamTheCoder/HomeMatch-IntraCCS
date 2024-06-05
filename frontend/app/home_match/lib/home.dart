import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_match/views/listings.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<ListingModel> listings = [];

  void _getInitialListings() {
    listings = ListingModel.getListings();
  }

  @override
  Widget build(BuildContext context) {
    _getInitialListings();
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeMatch'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          const searchBar(),
          // const SizedBox(height: 40),
          GestureDetector(
            onTap: () {
              if (kDebugMode) {
                print('Hello');
              }
            },
            child: Container(
                height: 50,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
                // padding: const EdgeInsets.only(left: 20, top: 15),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(129, 164, 236, 254),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    const Text(
                      "Find price of your home",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                        height: 25,
                        width: 30,
                        child: SvgPicture.asset('./icons/right_arrow.svg')),
                  ],
                )),
          ),
          const SizedBox(height: 40),
          recommendationList(listings: listings),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class recommendationList extends StatelessWidget {
  const recommendationList({
    super.key,
    required this.listings,
  });

  final List<ListingModel> listings;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Recommended for you',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(
            height: 25,
          ),
          itemCount: listings.length,
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 20, right: 20),
          itemBuilder: (context, index) {
            return Container(
              height: 150,
              decoration: BoxDecoration(
                color: const Color.fromARGB(54, 245, 38, 38),
                borderRadius: BorderRadius.circular(10),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.5),
                //     spreadRadius: 10,
                //     blurRadius: 10,
                //     offset: const Offset(0, 3),
                //   ),
                // ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    width: 150,
                    height: 120,
                    child:
                        Image.asset(listings[index].image, fit: BoxFit.cover),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            listings[index].name,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '   ${listings[index].bhk} BHK · ${listings[index].area} sqft',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '   ₹${listings[index].price}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '   ${listings[index].location}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}

// ignore: camel_case_types
class searchBar extends StatelessWidget {
  const searchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search for a home',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
          prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset('./icons/search.svg')),
          suffixIcon: SizedBox(
            width: 64,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const VerticalDivider(
                    color: Colors.black,
                    indent: 10,
                    endIndent: 10,
                    thickness: 0.1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset('./icons/filter.svg'),
                  ),
                ],
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
