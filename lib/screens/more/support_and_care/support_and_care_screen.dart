import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/utils/common_helper.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';

class SupportAndCareScreen extends StatefulWidget {
  @override
  _SupportAndCareScreenState createState() => _SupportAndCareScreenState();
}

class _SupportAndCareScreenState extends State<SupportAndCareScreen> {
  BuildContext _ctx;

  bool isOffline = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  @override
  initState() {
    super.initState();
    print("setstate called");
    ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      //print(isOffline);
    });
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Support/Customer Care",style: GoogleFonts.lato(color:Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
          body: SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.center,
                  child: new Image.asset(
                    'images/launcher.png', width: 100, height: 100,),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text("Wellon Support & Care",style: GoogleFonts.lato(color:Color(0xff33691E),fontSize: 22,fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("1. How to contact with providers on Thedir?",style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w700),),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text("          No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know is blend mol how to pursue pleasure ration ignitation.Lorem ipsum dolor sit amet..",
                            style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                        ),
                      ],
                    )
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("2. How to write review on Thedir?",style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w700),),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text("         Nulla venenatis. In pede mi, aliquet sit amet, euismod in,auctor ut, ligula. Aliquam dapibus tincidunt metu. Praesent justo dolor, lobortisquis, lobortis dignissim, pulvinar ac, lorem. Vestibulum sed ante.Donec sagittis euismod purus. Sed ut perspiciatis unde omnis iste natuserror sit voluptatem accusantium doloremque laudantium, totam remaperiam, eaque ipsa quae ab illo inventore",
                            style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                        ),
                      ],
                    )
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("3. How to become a provider on Thedir?",
                          style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w700),),
                        Text("          Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute,non cupidatat skateboard dolor brunch. Food truck quinoanesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliquaput a bird on it squid single-origin coffee nulla assumendashoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.",
                          style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),

                      ],
                    )
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("3. Disclaimer",style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w700),),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text("         Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute,non cupidatat skateboard dolor brunch. Food truck quinoanesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliquaput a bird on it squid single-origin coffee nulla assumendashoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.",
                            style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                        ),
                      ],
                    )
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("4. Limitations",style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w700),),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text("         Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute,non cupidatat skateboard dolor brunch. Food truck quinoanesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliquaput a bird on it squid single-origin coffee nulla assumendashoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.",
                            style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                        ),
                      ],
                    )
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("5. Revisions and Errata",style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w700),),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text("         Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute,non cupidatat skateboard dolor brunch. Food truck quinoanesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliquaput a bird on it squid single-origin coffee nulla assumendashoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.",
                            style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                        ),
                      ],
                    )
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("6. Links",style: GoogleFonts.lato(color: Colors.black,fontSize: 19,fontWeight: FontWeight.w700),),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text("         Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute,non cupidatat skateboard dolor brunch. Food truck quinoanesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliquaput a bird on it squid single-origin coffee nulla assumendashoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.",
                            style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                        ),
                      ],
                    )
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("7. Site Terms of Use Modifications",style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w700),),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text("         Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute,non cupidatat skateboard dolor brunch. Food truck quinoanesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliquaput a bird on it squid single-origin coffee nulla assumendashoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.",
                            style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                        ),
                      ],
                    )
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("8. Governing Law",style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w700),),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text("         Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute,non cupidatat skateboard dolor brunch. Food truck quinoanesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliquaput a bird on it squid single-origin coffee nulla assumendashoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.",
                            style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                        ),
                      ],
                    )
                ),Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Have any problem and need support?",style: GoogleFonts.lato(color:Colors.black,fontSize: 19,fontWeight: FontWeight.w700),),
                        Text("Call Us directly (+91) 9377887251 Or chat with us",
                          style: GoogleFonts.lato(color:Colors.black,fontSize: 18,fontWeight: FontWeight.w700),),
                      ],
                    )
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("© " +CommonHelper().getCurrentDate(), style: GoogleFonts.lato(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w600)),
                      InkWell(
                        onTap: () async {
                          CommonHelper().getWebSiteUrl(RestDatasource.BASE_URL);
                        },
                        child: Text(", wellonwater.com ", style: GoogleFonts.lato(color: Colors.blue,fontSize: 13,fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(", Inc.", style: GoogleFonts.lato(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w600)),
                      // Text(" Design by", style: GoogleFonts.lato(color: Colors.black,fontSize: 13,fontWeight: FontWeight.w600)),
                      // InkWell(
                      //   onTap: () async {
                      //     CommonHelper().getWebSiteUrl(RestDatasource.KARON);
                      //   },
                      //   child: Text(" Karon Infotech", style: GoogleFonts.lato(color: Colors.blue,fontSize: 13,fontWeight: FontWeight.w600),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
      );

    }
  }
}
