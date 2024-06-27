import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_commute/components/savelocation/savedlocations.dart';
import 'package:smart_commute/components/man_route.dart';
import 'package:smart_commute/components/suggestions.dart';
import 'package:smart_commute/components/forum/forumupdates.dart';
import 'package:smart_commute/providers/location_provider.dart';
import 'package:smart_commute/screens/chat.dart';
import 'package:smart_commute/screens/report.dart';
import 'package:share_plus/share_plus.dart';

class HomeBottomSheet extends StatefulWidget {
  const HomeBottomSheet({super.key});

  @override
  State<HomeBottomSheet> createState() => _HomeBottomSheetState();
}

class _HomeBottomSheetState extends State<HomeBottomSheet> {
  @override
  Widget build(BuildContext context) {
    double sheetPosition = MediaQuery.of(context).size.height * 0.00018;

    return DraggableScrollableSheet(
      initialChildSize: sheetPosition,
      minChildSize: sheetPosition,
      maxChildSize: MediaQuery.of(context).size.height * 0.001,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                ),
              ]),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: ClampingScrollPhysics(),
            ),
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 17),
              child: Column(
                children: [
                  Container(
                    width: 36,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.74,
                        height: 36,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const ChatScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = const Offset(0.0, 1.0);
                                var end = Offset.zero;
                                var curve = Curves.ease;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ),
                          ),
                          child: Hero(
                            tag: "searchBar",
                            child: TextField(
                              readOnly: true,
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                fillColor: const Color(0xffE9E9E9),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                hintText: 'Hi! Where do you want to go?',
                                hintStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChatScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Ionicons.mic,
                            size: 30,
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const ManualRoutes(),
                  const SizedBox(
                    height: 20,
                  ),
                  const SavedLocations(),
                  const SizedBox(
                    height: 20,
                  ),
                  const SuggestionsAi(),
                  const SizedBox(
                    height: 20,
                  ),
                  const RecentUpdates(),
                  const SizedBox(
                    height: 20,
                  ),
                  const ShareLocationButton(),
                  const SizedBox(
                    height: 8,
                  ),
                  const ReportButton(),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ShareLocationButton extends StatefulWidget {
  const ShareLocationButton({super.key});

  @override
  State<ShareLocationButton> createState() => _ShareLocationButtonState();
}

class _ShareLocationButtonState extends State<ShareLocationButton> {
  @override
  Widget build(BuildContext context) {
    final currentLocationProvider = Provider.of<LocationProvider>(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 48,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            Colors.grey[200],
          ),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          elevation: const MaterialStatePropertyAll(0),
        ),
        onPressed: currentLocationProvider.currentLocation == null
            ? null
            : () {
                final latitude =
                    currentLocationProvider.currentLocation!.latitude;
                final longitude =
                    currentLocationProvider.currentLocation!.longitude;
                shareMyLocation(lat: latitude, long: longitude);
              },
        child: const Text(
          'Share My Location',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }
}

void shareMyLocation({required lat, required long}) async {
  final prefs = await SharedPreferences.getInstance();
  final gender = prefs.getString('gender') == 'male' ? 'his' : 'her';
  final name = prefs.getString('fullName');
  final url = "https://www.google.com/maps/place/$lat,$long";
  await Share.share(
    "Hey, $name wants to share $gender current location. You can track them through this link: $url",
  );
}

class ReportButton extends StatefulWidget {
  const ReportButton({super.key});

  @override
  State<ReportButton> createState() => _ReportButtonState();
}

class _ReportButtonState extends State<ReportButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 48,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            Colors.grey[200],
          ),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          elevation: const MaterialStatePropertyAll(0),
        ),
        onPressed: () => Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ReportScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(0.0, 1.0);
              var end = Offset.zero;
              var curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        ),
        child: const Text(
          'Report an issue',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }
}
