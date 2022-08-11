import 'dart:convert';

import 'package:api_cache_manager/api_cache_manager.dart';
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
  var catagories = <String>{};
  TextEditingController _controller = TextEditingController();

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
      print(_displayData);
      int totalCount = jsonData["count"];
      print(totalCount);
      for (int i =0; i<=totalCount;i++){
        catagories.add(jsonData["entries"][i]["Category"]);
        //print(catagories);
       // print(jsonData["entries"][i]["Category"]);
      }

    }
  }
  void searchCat(String query){
    final suggestion ;
  }
  changeData(){
    if(_controller.text.isEmpty){
      setState(() {
        hasData = true;
      });
    }
    else{
      setState(() {
        hasData = false;
      });
    }
  }
  rowChips(){
    return Row(
      children: [
        for (String i in catagories) chipsForRow(i)
      ],
    );
  }
  Widget chipsForRow(String label){
    return GestureDetector(
      onTap: (){
        _controller.clear();
        _controller.text = label.toLowerCase();
        setState(() {
          hasData=false;
        });

        },
      child: Padding(
        padding: EdgeInsets.only(right: 5),
        child:        Chip(
            labelPadding: EdgeInsets.all(5),
            label: Text(label,style: TextStyle(color: Colors.black),
            ),
          backgroundColor: Colors.black12,
          shadowColor: Colors.grey,
          padding: EdgeInsets.all(6),
        ),
      ),
    );
  }
  @override
  void initState() {
    loadJson();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:
          SafeArea(child:
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: TextField(
              onChanged:(v){
                if(v.isEmpty){
                  setState(() {
                    hasData = true;
                  });
                }else{
                  setState(() {
                    hasData=false;
                  });
                }
              } ,
              controller: _controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Catagories",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.indigoAccent)

                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: rowChips(),
          ),
          Expanded(
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: _displayData.isEmpty ? Center(child: CircularProgressIndicator()) :
                ListView.builder(
                    itemCount: _displayData.length,
                    itemBuilder: (context, index){
                      return _controller.text.isEmpty?
                        Padding(
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
                      )
                          :
                      _displayData[index]["Category"].toLowerCase().contains(_controller.text.toString())?
                      Padding(
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
                      ):
                      Container() ;
                    }
                )
            ),
          ),
        ],
      ),),

      ) ;

  }
}
