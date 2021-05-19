import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ombre/services/searchService.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';

class SearchConcerts extends StatefulWidget {
  @override
  _SearchConcertsState createState() => _SearchConcertsState();
}

class _SearchConcertsState extends State<SearchConcerts> {
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) async {
    if (value.length == 0) {
      //when user types something and backspaces everything

      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    var capitalizedValue = value.substring(0, 1).toString().toUpperCase() +
        value.substring(1).toString();


    if (queryResultSet.length == 0 && value.length == 1) {
      //the user has typed in only single character

      await SearchService()
          .searchByName(capitalizedValue)
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
          setState(() {
            queryResultSet.add({
              'name': doc["name"],
              'category': doc["category"],
              'downloadUrl': doc["downloadUrl"],
            });
            tempSearchStore.add({
              'name': doc["name"],
              'category': doc["category"],
              'downloadUrl': doc["downloadUrl"],
            });
          });
        });
      });

    } else {
      setState(() {
        tempSearchStore = [];
      });

      queryResultSet.forEach((element) {
        if (element['name'].toLowerCase().contains(value.toLowerCase()) == true) {
          if (element['name'].toLowerCase().indexOf(value.toLowerCase()) == 0) {
            setState(() {
              tempSearchStore.add(element);
            });
          }
        }
      });
    }

    if (tempSearchStore.length == 0 && value.length > 1) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return FocusWatcher(
      child: Scaffold(
        body: Container(
          color: Color(0xFF0D111A),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      width: width * 0.8,
                      child: TextField(
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        cursorColor: Color(0xFFFB4C76),
                        onChanged: (val) {
                          initiateSearch(val);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF263240),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFFB4C76),
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          hintText: "Search by name",
                          hintStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.search_rounded,
                      size: 40,
                      color: Color(0xFF263240),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: tempSearchStore.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        leading: CachedNetworkImage(
                          placeholder: (context , url) => Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Color(0xFFFB4C76),
                              ),
                          ),
                          imageUrl: tempSearchStore[index]['downloadUrl'],
                          height: 100,
                          width: 100,
                        ),
                        title: Text(
                          tempSearchStore[index]['category'],
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Color(0xFFFB4C76),
                              fontSize: 20,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          tempSearchStore[index]['name'],
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
