import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:talkio/utils/constant.dart';

class MySearch extends StatelessWidget {
  final TextEditingController searchController;
  const MySearch({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: searchController,
      style: const TextStyle(color: apptextcolor),
      cursorColor: apptextcolor,
      decoration: const InputDecoration(
          fillColor: appbackground,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: apptextcolor, width: 0.1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: apptextcolor, width: 0.1)),
          prefixIcon: Icon(
            CupertinoIcons.search,
            color: apptextcolor,
            size: 25,
          ),
          hintText: 'Search',
          hintStyle: TextStyle(
              color: Colors.white54,
              fontSize: 15,
              fontWeight: FontWeight.w400)),
    );
  }
}
