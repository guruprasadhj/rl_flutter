import 'dart:convert';
import 'dart:io';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hive/hive.dart';

// ////////////////////////// Fetch DATA Page ////////////////////////////

class DataLoaderPage extends StatefulWidget {
  const DataLoaderPage({Key? key}) : super(key: key);

  @override
  State<DataLoaderPage> createState() => _DataLoaderPageState();
}

class _DataLoaderPageState extends State<DataLoaderPage> {
  List _displayData = [];

  loadJson() async {
    setState(() {
      isClicked=true;
    });
    var response =
        await http.get(Uri.parse("https://api.publicapis.org/entries"));
    var jsonData = jsonDecode(response.body);

    print(jsonData);
    setState(() {
      _displayData = jsonData["entries"];
    });
    print("Data Saving");
    APICacheDBModel cacheDBModel =
        new APICacheDBModel(key: "KEY", syncData: response.body);
    await APICacheManager().addCacheData(cacheDBModel);
    print("Data Save");
  }



  bool hasData = false;
  bool isClicked = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Task - 1",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: "Satisfy",
            fontWeight: FontWeight.w600,
            fontSize: 35,
            letterSpacing: 0.27,
            //color: DesignCourseAppTheme.darkerText,
          ),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: _displayData.isEmpty
              ? !isClicked?SizedBox():Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _displayData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: GestureDetector(
                        onTap: () async {
                          String url = (_displayData[index]["Link"]);
                          Uri _url = Uri.parse(url);
                          if (!await launchUrl(_url)) {
                            throw 'Could not launch $_url';
                          }
                        },
                        child: Card(
                          elevation: 50,
                          shadowColor: Colors.grey,
                          color: Colors.white,
                          child: Container(
                              margin: EdgeInsets.only(bottom: 5),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                _displayData[index]["API"],
                                                style: GoogleFonts.roboto(
                                                  textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: .5),
                                                ),
                                              ),
                                              Spacer(),
                                              Text(_displayData[index]
                                                  ["Category"]),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          RichText(
                                            overflow: TextOverflow.ellipsis,
                                            strutStyle:
                                                StrutStyle(fontSize: 12.0),
                                            text: TextSpan(
                                                style: GoogleFonts.roboto(
                                                  textStyle: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                                text: _displayData[index]
                                                    ["Description"]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    );
                  })),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.get_app),
        label: Text("Fetch Data"),
        backgroundColor: Color(0xff2196F3),
        foregroundColor: Color(0xffFFFFFF),
        onPressed: () {
          loadJson();
        },
      ),
    );
  }
}

class Entry {
  late final String api;
  late final String description;
  late final String link;
  late final String category;
  Entry(this.api, this.description, this.link, this.category);
}
