import 'dart:convert';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class OfflineDataPage extends StatefulWidget {
  const OfflineDataPage({Key? key}) : super(key: key);

  @override
  State<OfflineDataPage> createState() => _OfflineDataPageState();
}

class _OfflineDataPageState extends State<OfflineDataPage> {
  bool hasData = false;
  List _displayData=[];

  loadJson()async{
    var isCacheExist = await APICacheManager().isAPICacheKeyExist("KEY");
    if(!isCacheExist){
      setState(() {
        hasData = false;
      });
    }else{
      setState(() {
        hasData=true;
      });
      var cacheData = await APICacheManager().getCacheData("KEY");
      var jsonData = json.decode(cacheData.syncData);
      print(jsonData);
      setState((){
        _displayData = jsonData["entries"];
      });
    }
  }
  @override
  void initState() {
    loadJson();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: hasData?
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: _displayData.isEmpty ? Center(child: CircularProgressIndicator()) :
          ListView.builder(
              itemCount: _displayData.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                  child: GestureDetector(
                    onTap: ()async{
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(_displayData[index]["API"],
                                            style: GoogleFonts.roboto(
                                              textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold ,letterSpacing: .5),
                                            ),
                                          ),
                                          Spacer(),
                                          Text(_displayData[index]["Category"]),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      RichText(
                                        overflow: TextOverflow.ellipsis,
                                        strutStyle: StrutStyle(fontSize: 12.0),
                                        text: TextSpan(
                                            style: GoogleFonts.roboto(
                                              textStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal ),
                                            ),
                                            text: _displayData[index]["Description"]),
                                      ),

                                    ],
                                  ),
                                ),

                              ],
                            ),
                          )
                      ),),
                  ),
                );
              }
          )
      )
          :Center(
        child: Text("NO Data"),
      ) ,



    );
  }
}
