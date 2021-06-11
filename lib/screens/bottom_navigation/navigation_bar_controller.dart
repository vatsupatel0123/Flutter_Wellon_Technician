
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wellon_partner_app/screens/home/home_screen.dart';
import 'package:wellon_partner_app/screens/leads/lead_screen.dart';
import 'package:wellon_partner_app/screens/more/more_screen.dart';
import 'package:wellon_partner_app/screens/shop/shop_screen.dart';
import 'package:wellon_partner_app/screens/wallet/statement_screen.dart';
import 'package:wellon_partner_app/screens/wallet/walllet_screen.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';

class BottomNavigationBarController extends StatefulWidget {
  final int selectedindex;
  BottomNavigationBarController({this.selectedindex});
  @override
  _BottomNavigationBarControllerState createState() =>
      _BottomNavigationBarControllerState();
}

class _BottomNavigationBarControllerState
    extends State<BottomNavigationBarController> {
  BuildContext _ctx;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;
  bool isOffline = false;
  int _selectedIndex;

  @override
  initState() {
    super.initState();
    //print("setstate called");
    ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
    _selectedIndex=widget.selectedindex!=null?widget.selectedindex:0;
    //loadpref();
//    startTime();
  }
  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      //print(isOffline);
    });
  }
  List<Widget> pages = [
    HomeScreen(),
    ShopScreen(),
    LeadScreen(),
    StatementScreen(),
    WallletScreen(),
    MoreScreen(),
  ];
  //Bottom Navigation
  @override
  Widget build(BuildContext context) {
    _ctx=context;

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green.shade600,
        elevation: 10,
        currentIndex: _selectedIndex,
        onTap: (int index){
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Dashboard",style: GoogleFonts.lato(fontSize: 12,color:(_selectedIndex==0)?Colors.green:Colors.black,letterSpacing: (_selectedIndex==0)?1:0,fontWeight: FontWeight.w600),),),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_basket), title: Text("Shop",style: GoogleFonts.lato(fontSize: 12,color:(_selectedIndex==1)?Colors.green:Colors.black,letterSpacing: (_selectedIndex==1)?1:0,fontWeight: FontWeight.w600),),),
          BottomNavigationBarItem(icon: Icon(Icons.people), title: Text("Leads",style: GoogleFonts.lato(fontSize: 12,color:(_selectedIndex==2)?Colors.green:Colors.black,letterSpacing: (_selectedIndex==2)?1:0,fontWeight: FontWeight.w600),),),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), title: Text("Ledger",style: GoogleFonts.lato(fontSize: 12,color:(_selectedIndex==3)?Colors.green:Colors.black,letterSpacing: (_selectedIndex==3)?1:0,fontWeight: FontWeight.w600),),),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), title: Text("Wallet",style: GoogleFonts.lato(fontSize: 12,color:(_selectedIndex==4)?Colors.green:Colors.black,letterSpacing: (_selectedIndex==4)?1:0,fontWeight: FontWeight.w600),),),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), title: Text("More",style: GoogleFonts.lato(fontSize: 12,color:(_selectedIndex==5)?Colors.green:Colors.black,letterSpacing: (_selectedIndex==5)?1:0,fontWeight: FontWeight.w600),),)
        ],
      ),
    );
  }

}
