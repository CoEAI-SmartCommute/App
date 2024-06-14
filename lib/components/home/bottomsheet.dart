import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeBottomSheet extends StatefulWidget {
  const HomeBottomSheet({super.key});

  @override
  State<HomeBottomSheet> createState() => _HomeBottomSheetState();
}

class _HomeBottomSheetState extends State<HomeBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Container(
      height: 100,
      decoration: const BoxDecoration(color: Colors.white),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 17),
        child: Column(children: [
          Container(
            width: 36,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: const Color(0xffBEBFC0),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                height: 36,
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 8),
                      fillColor: const Color(0xffE9E9E9),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      hintText: 'Hi! Where do you want to go ?'),
                ),
              ),
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: user!.photoURL!,
                  fit: BoxFit.cover,
                  height: 42,
                  width: 42,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}
