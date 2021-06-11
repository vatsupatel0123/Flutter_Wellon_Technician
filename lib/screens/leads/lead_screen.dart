import 'dart:async';
import 'dart:ui';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellon_partner_app/data/loaddata.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/models/cancel_lead_list.dart';
import 'package:wellon_partner_app/models/complete_lead_list.dart';
import 'package:wellon_partner_app/models/new_lead_list.dart';
import 'package:wellon_partner_app/models/process_lead_list.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

import '../../sizeconfig.dart';

class LeadScreen extends StatefulWidget {
  final int currentindex;
  LeadScreen({this.currentindex});
  @override
  _LeadScreenState createState() => _LeadScreenState();
}

class _LeadScreenState extends State<LeadScreen> with SingleTickerProviderStateMixin{
  BuildContext _ctx;
  TabController _tabController;
  int _currentIndex = 0;
  int _redirectIndex = 0;
  String service_type;
  int selectedindex;
  //Search
  bool _isSearchingUser = false;
  String searchQueryUser = "Search query";
  TextEditingController _searchQueryUser;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 = new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey2 = new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey3 = new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey4 = new GlobalKey<RefreshIndicatorState>();
  //On Refresh

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQueryUser,
      autofocus: true,
      style: GoogleFonts.lato(
        color: Colors.white,
      ),
      decoration: const InputDecoration(
        filled: true,
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white),
      ),
      onChanged: updateSearchQuery,
    );
  }
  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQueryUser = newQuery;
      if(_currentIndex==0)
      {
        //print("object");
        if(_searchQueryUser.toString().length>0)
        {
          //print(searchQuery.toString().length);
          Future<List<NewLeadList>> items=LoadData.newLeadListdata;
          List<NewLeadList> filter=new List<NewLeadList>();
          items.then((result){
            for(var record in result)
            {
              if(record.order_id.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase()) || record.customer_name.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase()) || record.o_type_name.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase()) || record.o_category.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase()) || record.o_machine.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase()) || record.order_date_time.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase()))
              {
                //print(record.order_id);
                filter.add(record);
              }
            }
            LoadData.newLeadListfilterData=Future.value(filter);
          });
        }
        else
        {
          LoadData.newLeadListfilterData=LoadData.newLeadListdata;
        }
      }
      else if(_currentIndex==1)
      {
        if(_searchQueryUser.toString().length>0)
        {
          //print(searchQuery.toString().length);
          Future<List<ProcessLeadList>> items=LoadData.processLeadListdata;
          List<ProcessLeadList> filter=new List<ProcessLeadList>();
          items.then((result){
            for(var record in result)
            {
              if(record.order_id.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase()) || record.orderd_name.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase()) || record.o_type_name.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase()) || record.o_category.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase()) || record.o_machine.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase())||record.order_date_time.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase()))
              {
                //print(record.order_id);
                filter.add(record);
              }
            }
            LoadData.processLeadListfilterData=Future.value(filter);
          });
        }
        else
        {
          LoadData.processLeadListfilterData=LoadData.processLeadListdata;
        }
      }
      else if(_currentIndex==3)
      {
        if(_searchQueryUser.toString().length>0)
        {
          //print(searchQuery.toString().length);
          Future<List<CancelLeadList>> items=LoadData.cancelLeadListdata;
          List<CancelLeadList> filter=new List<CancelLeadList>();
          items.then((result){
            for(var record in result)
            {
              if(record.order_id.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase()) || record.orderd_name.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase()) || record.o_type_name.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase()) || record.o_category.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase()) || record.o_machine.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase())||record.order_date_time.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase()))
              {
                //(record.order_id);
                filter.add(record);
              }
            }
            LoadData.cancelLeadListfilterData=Future.value(filter);
          });
        }
        else
        {
          LoadData.cancelLeadListfilterData=LoadData.cancelLeadListdata;
        }
      }
      else
      {
        if(_searchQueryUser.toString().length>0)
        {
          //print(searchQuery.toString().length);
          Future<List<CompleteLeadList>> items=LoadData.completeLeadListdata;
          List<CompleteLeadList> filter=new List<CompleteLeadList>();
          items.then((result){
            for(var record in result)
            {
              if(record.order_id.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase()) || record.orderd_name.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase()) || record.o_type_name.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase()) || record.o_category.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase()) || record.o_machine.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase()) || record.order_complete_date_time.toString().toLowerCase().toString().contains(searchQueryUser.toLowerCase()))
              {
                //print(record.order_id);
                filter.add(record);
              }
            }
            LoadData.completeLeadListfilterData=Future.value(filter);
          });
        }
        else
        {
          LoadData.completeLeadListfilterData=LoadData.completeLeadListdata;
        }
      }
    });
    //print("search query " + searchQueryUser);
  }

  List<Widget> _buildActions() {
    if (_isSearchingUser) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear,color: Colors.white,),
          onPressed: () {
            if (_searchQueryUser == null || _searchQueryUser.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }
    return <Widget>[
      new IconButton(
        icon: const Icon(Icons.search,color: Colors.white,),
        onPressed: _startSearch,
      ),
    ];
  }

  void _clearSearchQuery() {
    //print("close search box");
    setState(() {
      _searchQueryUser.clear();
      if(_currentIndex==0)
        LoadData.newLeadListfilterData=LoadData.newLeadListdata;
      else if(_currentIndex==1)
        LoadData.processLeadListfilterData=LoadData.processLeadListdata;
      else
        LoadData.completeLeadListfilterData=LoadData.completeLeadListdata;
      updateSearchQuery("");
    });
  }

  void _startSearch() {
    //print("open search box");
    ModalRoute
        .of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearchingUser = true;
    });
  }
  void _stopSearching() {
    _clearSearchQuery();
    setState(() {
      _isSearchingUser = false;
    });
  }
  //Search

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool passwordVisible = true;
  String _otpcode;

  bool isOffline = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  @override
  initState() {
    super.initState();
    ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);
    _tabController = TabController(length: 4, vsync: this, initialIndex: (selectedindex!=null)?selectedindex:widget.currentindex!=null?widget.currentindex:0);
    _tabController.addListener(_handleTabIndex);
    _searchQueryUser = new TextEditingController();
    _loadpref();
  }

  void _loadpref() async
  {
    await LoadData.refreshpendinglead();
    await LoadData.refreshprocesslead();
    await LoadData.refreshcompletelead();
    await LoadData.refreshcancellead();
    setState(() {

    });
  }
  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.screenWidth = MediaQuery.of(context).size.width;
    SizeConfig.screenHeight = MediaQuery.of(context).size.height;
    SizeConfig.blockSizeHorizontal = SizeConfig.screenWidth / 100;
    SizeConfig.blockSizeVertical = SizeConfig.screenHeight / 100;
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return DefaultTabController(
        length: 4,
        child: Scaffold(
          body: new NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  centerTitle: true,
                  backgroundColor: Colors.green,
                  title: _isSearchingUser ? _buildSearchField() :
                  Text("Wellon Leads",style: GoogleFonts.lato(color:Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
                  iconTheme: IconThemeData(
                    color: Colors.white, //change your color here
                  ),
                  actions: _buildActions(),
                  pinned: true,
                  floating: false,
                  forceElevated: innerBoxIsScrolled,
                  bottom: new TabBar(
                    unselectedLabelColor: Colors.white,
                    indicatorColor: Colors.white,
                    controller: _tabController,
                    tabs: <Tab>[
                      new Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Pending",style: GoogleFonts.lato(fontSize:  SizeConfig.blockSizeHorizontal * 3.2,color: _tabController.index == 0 ? Colors.white : Colors.white70,fontWeight: FontWeight.w600),),
                        ),
                      ),
                      new Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("In Process",style: GoogleFonts.lato(fontSize: SizeConfig.blockSizeHorizontal * 3.2,color: _tabController.index == 1 ? Colors.white : Colors.white70,fontWeight: FontWeight.w600),),
                        ),
                      ),
                      new Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Completed",style: GoogleFonts.lato(fontSize: SizeConfig.blockSizeHorizontal * 3.2,color: _tabController.index == 2 ? Colors.white : Colors.white70,fontWeight: FontWeight.w600),),
                        ),
                      ),
                      new Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Cancel",style: GoogleFonts.lato(fontSize: SizeConfig.blockSizeHorizontal * 3.2,color: _tabController.index == 3 ? Colors.white : Colors.white70,fontWeight: FontWeight.w600),),
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: new TabBarView(
              controller: _tabController,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    RefreshIndicator(
                      key: _refreshIndicatorKey1,
                      color: Colors.black,
                      onRefresh: () async{
                        await LoadData.refreshpendinglead();
                        setState(() {

                        });
                      },
                      child: FutureBuilder<List<NewLeadList>>(
                        future:LoadData.newLeadListfilterData,
                        builder: (context,snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting)
                          {
                            return Center(
                              child: CircularProgressIndicator(
                                      backgroundColor: Colors.green,
                                    ),
                            );
                          }
                          else if (!snapshot.hasData) {
                            return SingleChildScrollView(
                              child: Container(
                                height: MediaQuery.of(context).size.height*0.8,
                                child: Center(
                                  child: Text("No Data Available!"),
                                ),
                              ),
                            );
                          }
                          return ListView(
                            padding: EdgeInsets.only(top: 10),
                            children: snapshot.data
                                .map((data) =>
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed("/leadnewscreen",
                                        arguments: {
                                          "serviceprovider_name" : (data.serviceprovider_name!=null)?data.serviceprovider_name:"",
                                          "order_id" : (data.order_id!=null)?data.order_id:"",
                                          "prefer_date" : (data.prefer_date!=null)?data.prefer_date:"",
                                          "prefer_time" : (data.prefer_time!=null)?data.prefer_time:"",
                                          "house_no" : (data.house_no!=null)?data.house_no:"",
                                          "house_name" : (data.house_name!=null)?data.house_name:"",
                                          "address1" : (data.address1!=null)?data.address1:"",
                                          "address2" : (data.address2!=null)?data.address2:"",
                                          "address3" : (data.address3!=null)?data.address3:"",
                                          "pincode" : (data.pincode!=null)?data.pincode:"",
                                          "order_date_time" : (data.order_date_time!=null)?data.order_date_time:"",
                                          "expire_date_time" : (data.expire_date_time!=null)?data.expire_date_time:"",
                                          "expire_time" : (data.expire_time!=null)?data.expire_time:"",
                                          "olat" : (data.olat!=null)?data.olat:"",
                                          "olong" : (data.olong!=null)?data.olong:"",
                                          "slat" : (data.slat!=null)?data.slat:"",
                                          "slong" : (data.slong!=null)?data.slong:"",
                                          "km" : (data.km!=null)?data.km:"",
                                          "service_type" : (data.service_type!=null)?data.service_type:"",
                                          "brandid" : (data.brandid!=null)?data.brandid:"",
                                          "modelid" : (data.modelid!=null)?data.modelid:"",
                                          "brandname" : (data.brandname!=null)?data.brandname:"",
                                          "otherbrand" : (data.otherbrand!=null)?data.otherbrand:"",
                                          "othermodel" : (data.othermodel!=null)?data.othermodel:"",
                                          "brandimg" : (data.brandimg!=null)?data.brandimg:"",
                                          "instance_normal":(data.instance_normal!=null)?data.instance_normal:"",
                                          "modelname" : (data.modelname!=null)?data.modelname:"",
                                          "modelimg" : (data.modelimg!=null)?data.modelimg:"",
                                          "customer_name" : (data.customer_name!=null)?data.customer_name:"",
                                          "other_customer_name" : (data.other_customer_name!=null)?data.other_customer_name:"",
                                          "other_customer_number" : (data.other_customer_number!=null)?data.other_customer_number:"",
                                          "who_order" : (data.who_order!=null)?data.who_order:"",
                                          "customer_remark" : (data.customer_remark!=null)?data.customer_remark:"",
                                          "o_type_name" : (data.o_type_name!=null)?data.o_type_name:"",
                                          "o_category" : (data.o_category!=null)?data.o_category:"",
                                          "o_machine" : (data.o_machine!=null)?data.o_machine:"",
                                          "payable_amount" : (data.payable_amount!=null)?data.payable_amount:"",
                                          "ro_capacity" : (data.ro_capacity!=null)?data.ro_capacity:"",
                                          "raw_tds" : (data.raw_tds!=null)?data.raw_tds:"",
                                          "system_old_new" : (data.system_old_new!=null)?data.system_old_new:"",
                                          "old_year" : (data.old_year!=null)?data.old_year:"",
                                          "is_ro" : (data.is_ro!=null)?data.is_ro:"",
                                          "ro_img" : (data.ro_img!=null)?data.ro_img:"",
                                        });
                                  },
                                  child:
                                  Card(
                                      semanticContainer: true,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      elevation: 5.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      margin: new EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),

                                      child: Container(
                                        child: ListTile(contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
                                            title: Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                            Row(
                                                              children: [
                                                                (data.who_order=="Self"||data.who_order==null)?Container(
                                                                  width:MediaQuery.of(context).size.width*0.60,
                                                                  child: Text(
                                                                    (data.customer_name!=null)?data.customer_name.toUpperCase():"---",
                                                                    style: GoogleFonts.lato(color: Colors.green, fontSize: 17.0,fontWeight: FontWeight.w700),
                                                                  ),
                                                                ):
                                                                Container(
                                                                  width:MediaQuery.of(context).size.width*0.60,
                                                                  child: Text(
                                                                    (data.other_customer_name!=null)?data.other_customer_name.toUpperCase():"---",
                                                                    style: GoogleFonts.lato(color: Colors.green, fontSize: 17.0,fontWeight: FontWeight.w700),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "WELLON",
                                                                  style: GoogleFonts.lato(color: Colors.green, fontSize: 18.0,fontWeight: FontWeight.w700),
                                                                ),
                                                                Text(
                                                                  (data.order_id!=null)?data.order_id:"---",
                                                                  style: GoogleFonts.lato(color: Colors.green, fontSize: 18.0,fontWeight: FontWeight.w700),
                                                                ),
                                                              ],
                                                            ),
                                                    // Container(
                                                    //   alignment: Alignment.centerLeft,
                                                    //   padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                    //   child: CountdownFormatted(
                                                    //     duration: current.difference(data.mytime),
                                                    //     builder: (BuildContext ctx, String remaining) {
                                                    //       return Text(remaining ,style: GoogleFonts.lato(fontSize: 18,color: Colors.green),); // 01:00:00
                                                    //     },
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                                new Divider(
                                                  color: Colors.black,
                                                ),
                                                SizedBox(height: 5,)
                                              ],
                                            ),
                                            subtitle: Column(
                                              children: <Widget>[
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.location_on, color: Colors.grey.shade700, size: 18.0,
                                                            ),
                                                            Container(
                                                              width:MediaQuery.of(context).size.width*0.50,
                                                              child: Text(
                                                                ((data.address2!=null)?data.address2:"---")+((data.pincode!=null)?" - "+data.pincode:"---"),
                                                                style: GoogleFonts.lato(fontSize: 15,color: Colors.grey.shade700,fontWeight: FontWeight.w700,),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 5,
                                                    ),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              'Type',
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade700,fontWeight: FontWeight.w700),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              (data.o_type_name!=null)?(data.o_type_name=="ro")?"Water Purifier".toUpperCase():"Alkaline Water Ionizer".toUpperCase():"---",
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade700),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 5,
                                                    ),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              'Category',
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade700,fontWeight: FontWeight.w700),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              (data.o_category!=null)?data.o_category.toUpperCase():"---",
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade700),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 5,
                                                    ),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              'Installation Type',
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade700,fontWeight: FontWeight.w700),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              (data.instance_normal!=null)?data.instance_normal.toUpperCase():"---",
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade700),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 5,
                                                    ),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.calendar_today, color: Colors.grey.shade700, size: 16.0,
                                                            ),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              (data.prefer_date!=null)?data.prefer_date:"Quick",
                                                              style: GoogleFonts.lato(fontSize: 16,color: Colors.grey.shade700,fontWeight: FontWeight.w700,),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.timer, color: Colors.grey.shade700, size: 16.0,
                                                            ),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              (data.prefer_time!=null)?data.prefer_time:"Quick",
                                                              style: GoogleFonts.lato(fontSize: 16,color: Colors.grey.shade700,fontWeight: FontWeight.w700,),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),

                                              ],
                                            )
                                        ),
                                      )),
                                ),
                            ).toList(),
                          );
                        },
                      ),
                    )
                  ],
                ),
                Stack(
                  children: <Widget>[
                    RefreshIndicator(
                      color: Colors.black,
                      key: _refreshIndicatorKey2,
                      onRefresh: () async{
                        await LoadData.refreshprocesslead();
                        setState(() {

                        });
                      },
                      child: FutureBuilder<List<ProcessLeadList>>(
                        future: LoadData.processLeadListfilterData,
                        builder: (context,snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting)
                          {
                            return Center(
                              child: CircularProgressIndicator(
                                      backgroundColor: Colors.green,
                                    ),
                            );
                          }
                          else if (!snapshot.hasData) {
                            return SingleChildScrollView(
                              child: Container(
                                height: MediaQuery.of(context).size.height*0.8,
                                child: Center(
                                  child: Text("No Data Available!"),
                                ),
                              ),
                            );
                          }
                          return ListView(
                            padding: EdgeInsets.only(top: 5),
                            children: snapshot.data
                                .map((data1) =>
                                InkWell(
                                  onTap: () {
                                    //print("Check Pay Mode"+data1.paymode);
                                    Navigator.of(context).pushNamed("/leadprogressscreen",
                                        arguments: {
                                          "order_id" : (data1.order_id!=null)?data1.order_id:"",
                                          "customer_id" : (data1.customer_id!=null)?data1.customer_id:"",
                                          "type_id" : (data1.type_id!=null)?data1.type_id:"",
                                          "orderd_contact_number" : (data1.orderd_contact_number!=null)?data1.orderd_contact_number:"",
                                          "orderd_name" : (data1.orderd_name!=null)?data1.orderd_name:"",
                                          "house_no" : (data1.house_no!=null)?data1.house_no:"",
                                          "house_name" : (data1.house_name!=null)?data1.house_name:"",
                                          "address1" : (data1.address1!=null)?data1.address1:"",
                                          "address2" : (data1.address2!=null)?data1.address2:"",
                                          "address3" : (data1.address3!=null)?data1.address3:"",
                                          "pincode" : (data1.pincode!=null)?data1.pincode:"",
                                          "latitude" : (data1.latitude!=null)?data1.latitude:"",
                                          "longitude" : (data1.longitude!=null)?data1.longitude:"",
                                          "olat" : (data1.olat!=null)?data1.olat:"",
                                          "olong" : (data1.olong!=null)?data1.olong:"",
                                          "ro_product_photo" : (data1.ro_product_photo!=null)?data1.ro_product_photo:"",
                                          "prefer_date" : (data1.prefer_date!=null)?data1.prefer_date:"",
                                          "prefer_time" : (data1.prefer_time!=null)?data1.prefer_time:"",
                                          "order_date_time" : (data1.order_date_time!=null)?data1.order_date_time:"",
                                          "expire_date_time" : (data1.expire_date_time!=null)?data1.expire_date_time:"",
                                          "order_status" : (data1.order_status!=null)?data1.order_status:"",
                                          "order_created_by" : (data1.order_created_by!=null)?data1.order_created_by:"",
                                          "is_complete_customer" : (data1.is_complete_customer!=null)?data1.is_complete_customer:"",
                                          "is_complete_sp" : (data1.is_complete_sp!=null)?data1.is_complete_sp:"",
                                          "order_complete_date_time" : (data1.order_complete_date_time!=null)?data1.order_complete_date_time:"",
                                          "cust_remark" : (data1.cust_remark!=null)?data1.cust_remark:"",
                                          "created_at" : (data1.created_at!=null)?data1.created_at:"",
                                          "updated_at" : (data1.updated_at!=null)?data1.updated_at:"",
                                          "log_date_time" : (data1.log_date_time!=null)?data1.log_date_time:"",
                                          "brandid" : (data1.brandid!=null)?data1.brandid:"",
                                          "modelid" : (data1.modelid!=null)?data1.modelid:"",
                                          "brandname" : (data1.brandname!=null)?data1.brandname:"",
                                          "other_brand" : (data1.other_brand!=null)?data1.other_brand:"",
                                          "other_model" : (data1.other_model!=null)?data1.other_model:"",
                                          "brandimg" : (data1.brandimg!=null)?data1.brandimg:"",
                                          "modelname" : (data1.modelname!=null)?data1.modelname:"",
                                          "modelimg" : (data1.modelimg!=null)?data1.modelimg:"",
                                          "customer_name" : (data1.customer_name!=null)?data1.customer_name:"",
                                          "who_order_for" : (data1.who_order_for!=null)?data1.who_order_for:"",
                                          "other_cust_name" : (data1.other_cust_name!=null)?data1.other_cust_name:"",
                                          "other_cust_contact" : (data1.other_cust_contact!=null)?data1.other_cust_contact:"",
                                          "o_type_name" : (data1.o_type_name!=null)?data1.o_type_name:"",
                                          "o_category" : (data1.o_category!=null)?data1.o_category:"",
                                          "o_machine" : (data1.o_machine!=null)?data1.o_machine:"",
                                          "instance_normal" : (data1.instance_normal!=null)?data1.instance_normal:"",
                                          "payable_amount" : (data1.payable_amount!=null)?data1.payable_amount:"",
                                          "cod_amount" : (data1.cod_amount!=null)?data1.cod_amount:"",
                                          "cod_pay" : (data1.cod_pay!=null)?data1.cod_pay:"",
                                          "paymode" : data1.paymode,
                                          "ro_capacity" : (data1.ro_capacity!=null)?data1.ro_capacity:"",
                                          "raw_tds" : (data1.raw_tds!=null)?data1.raw_tds:"",
                                          "system_old_new" : (data1.system_old_new!=null)?data1.system_old_new:"",
                                          "old_year" : (data1.old_year!=null)?data1.old_year:"",
                                          "is_ro" : (data1.is_ro!=null)?data1.is_ro:"",
                                          "ro_img" : (data1.ro_img!=null)?data1.ro_img:"",
                                        });
                                  },
                                  child: Card(
                                      color : (data1.order_status=="processadmin")?Colors.green.shade100:Colors.white,
                                      semanticContainer: true,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      elevation: 5.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      margin: new EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),

                                      child: Container(
                                        child: ListTile(contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
                                            title: Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                            Row(
                                                              children: [
                                                                (data1.who_order_for=="Self"||data1.who_order_for==null)?
                                                                Container(
                                                                  width:MediaQuery.of(context).size.width*0.60,
                                                                  child: Text(
                                                                    (data1.orderd_name!=null)?data1.orderd_name.toUpperCase():"---",
                                                                    style: GoogleFonts.lato(color: (data1.order_status=="process")?Colors.green:Colors.black,fontWeight: FontWeight.w600, fontSize: 17.0,),
                                                                  ),
                                                                ):
                                                                Container(
                                                                  width:MediaQuery.of(context).size.width*0.60,
                                                                  child: Text(
                                                                    (data1.other_cust_name!=null)?data1.other_cust_name.toUpperCase():"---",
                                                                    style: GoogleFonts.lato(color: (data1.order_status=="process")?Colors.green:Colors.black,fontWeight: FontWeight.w600, fontSize: 17.0,),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "WELLON",
                                                                  style: GoogleFonts.lato(color: (data1.order_status=="process")?Colors.green:Colors.black,fontWeight: FontWeight.w600, fontSize: 18.0,),
                                                                ),
                                                                Text(
                                                                  (data1.order_id!=null)?data1.order_id:"---",
                                                                  style: GoogleFonts.lato(color: (data1.order_status=="process")?Colors.green:Colors.black, fontWeight: FontWeight.w600,fontSize: 18.0,),
                                                                ),
                                                              ],
                                                            ),
                                                  ],
                                                ),
                                                new Divider(
                                                  color: Colors.black,
                                                ),
                                                SizedBox(height: 5,),
                                              ],
                                            ),
                                            subtitle: Column(
                                              children: <Widget>[
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.location_on, color: Colors.grey.shade700, size: 18.0,
                                                            ),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Container(
                                                              width:MediaQuery.of(context).size.width*0.50,
                                                              child: Text(
                                                                ((data1.address2!=null)?data1.address2:"---")+((data1.pincode!=null)?" - "+data1.pincode:"---"),
                                                                style: GoogleFonts.lato(fontSize: 13,color: Colors.grey.shade700,fontWeight: FontWeight.w700),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Icon(
                                                                  Icons.call, color: Colors.grey.shade700, size: 18.0,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Container(
                                                                  child:
                                                                  (data1.who_order_for=="Self"||data1.who_order_for==null)?Text(
                                                                    (data1.orderd_contact_number!=null)?data1.orderd_contact_number:"---",
                                                                    style: GoogleFonts.lato(color: Colors.grey.shade700, fontSize: 13.0,fontWeight: FontWeight.w700,),
                                                                  ):
                                                                  Text(
                                                                    (data1.other_cust_contact!=null)?data1.other_cust_contact:"---",
                                                                    style: GoogleFonts.lato(color: Colors.grey.shade700, fontSize: 13.0,fontWeight: FontWeight.w700,),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 5,
                                                    ),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              'Type',
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade700,fontWeight: FontWeight.w700),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              (data1.o_type_name!=null)?(data1.o_type_name=="ro")?"Water Purifier".toUpperCase():"Alkaline Water Ionizer".toUpperCase():"---",
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade700),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 5,
                                                    ),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              'Category',
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade700,fontWeight: FontWeight.w700),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              (data1.o_category!=null)?data1.o_category.toUpperCase():"---",
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade700),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 5,
                                                    ),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              'Installation Type',
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade700,fontWeight: FontWeight.w700),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              (data1.instance_normal!=null)?data1.instance_normal.toUpperCase():"---",
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade700),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.calendar_today, color: Colors.grey.shade700, size: 16.0,
                                                            ),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              (data1.prefer_date!=null)?data1.prefer_date:"Quick",
                                                              style: GoogleFonts.lato(fontSize: 16,color: Colors.grey.shade700,fontWeight: FontWeight.w700,),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.timer, color: Colors.grey.shade700, size: 16.0,
                                                            ),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              (data1.prefer_time!=null)?data1.prefer_time:"Quick",
                                                              style: GoogleFonts.lato(fontSize: 16,color: Colors.grey.shade700,fontWeight: FontWeight.w700),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
//                                                    new Divider(
//                                                      color: Colors.black,
//                                                    ),
                                                  ],
                                                ),

                                              ],
                                            )
                                        ),
                                      )),
                                ),
                            ).toList(),
                          );
                        },
                      ),
                    )
                  ],
                ),
                Stack(
                  children: <Widget>[
                    RefreshIndicator(
                      color: Colors.black,
                      key: _refreshIndicatorKey3,
                      onRefresh: () async{
                        await LoadData.refreshcompletelead();
                        setState(() {

                        });
                      },
                      child: FutureBuilder<List<CompleteLeadList>>(
                        future: LoadData.completeLeadListfilterData,
                        builder: (context,snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting)
                          {
                            return Center(
                              child: CircularProgressIndicator(
                                      backgroundColor: Colors.green,
                                    ),
                            );
                          }
                          else if (!snapshot.hasData) {
                            return SingleChildScrollView(
                              child: Container(
                                height: MediaQuery.of(context).size.height*0.8,
                                child: Center(
                                  child: Text("No Data Available!"),
                                ),
                              ),
                            );
                          }
                          return ListView(
                            padding: EdgeInsets.only(top: 5),
                            children: snapshot.data
                                .map((data) =>
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed("/leadcompletescreen",
                                        arguments: {
                                          "order_id" : (data.order_id!=null)?data.order_id:"",
                                          "customer_id" : (data.customer_id!=null)?data.customer_id:"",
                                          "type_id" : (data.type_id!=null)?data.type_id:"",
                                          "orderd_contact_number" : (data.orderd_contact_number!=null)?data.orderd_contact_number:"",
                                          "orderd_name" : (data.orderd_name!=null)?data.orderd_name:"",
                                          "house_no" : (data.house_no!=null)?data.house_no:"",
                                          "house_name" : (data.house_name!=null)?data.house_name:"",
                                          "address1" : (data.address1!=null)?data.address1:"",
                                          "address2" : (data.address2!=null)?data.address2:"",
                                          "address3" : (data.address3!=null)?data.address3:"",
                                          "pincode" : (data.pincode!=null)?data.pincode:"",
                                          "latitude" : (data.latitude!=null)?data.latitude:"",
                                          "longitude" : (data.longitude!=null)?data.longitude:"",
                                          "ro_product_photo" : (data.ro_product_photo!=null)?data.ro_product_photo:"",
                                          "prefer_date" : (data.prefer_date!=null)?data.prefer_date:"",
                                          "prefer_time" : (data.prefer_time!=null)?data.prefer_time:"",
                                          "order_date_time" : (data.order_date_time!=null)?data.order_date_time:"",
                                          "expire_date_time" : (data.expire_date_time!=null)?data.expire_date_time:"",
                                          "order_status" : (data.order_status!=null)?data.order_status:"",
                                          "order_created_by" : (data.order_created_by!=null)?data.order_created_by:"",
                                          "is_complete_customer" : (data.is_complete_customer!=null)?data.is_complete_customer:"",
                                          "is_complete_sp" : (data.is_complete_sp!=null)?data.is_complete_sp:"",
                                          "order_complete_date_time" : (data.order_complete_date_time!=null)?data.order_complete_date_time:"",
                                          "cust_remark" : (data.cust_remark!=null)?data.cust_remark:"",
                                          "created_at" : (data.created_at!=null)?data.created_at:"",
                                          "updated_at" : (data.updated_at!=null)?data.updated_at:"",
                                          "type_name" : (data.type_name!=null)?data.type_name:"",
                                          "modelid" : (data.modelid!=null)?data.modelid:"",
                                          "brandname" : (data.brandname!=null)?data.brandname:"",
                                          "other_brand" : (data.other_brand!=null)?data.other_brand:"",
                                          "other_model" : (data.other_model!=null)?data.other_model:"",
                                          "brandimg" : (data.brandimg!=null)?data.brandimg:"",
                                          "modelname" : (data.modelname!=null)?data.modelname:"",
                                          "modelimg" : (data.modelimg!=null)?data.modelimg:"",
                                          "customer_name" : (data.customer_name!=null)?data.customer_name:"",
                                          "who_order_for" : (data.who_order_for!=null)?data.who_order_for:"",
                                          "other_cust_name" : (data.other_cust_name!=null)?data.other_cust_name:"",
                                          "other_cust_contact" : (data.other_cust_contact!=null)?data.other_cust_contact:"",
                                          "o_type_name" : (data.o_type_name!=null)?data.o_type_name:"",
                                          "o_category" : (data.o_category!=null)?data.o_category:"",
                                          "o_machine" : (data.o_machine!=null)?data.o_machine:"",
                                          "instance_normal" : (data.instance_normal!=null)?data.instance_normal:"",
                                          "payable_amount" : (data.payable_amount!=null)?data.payable_amount:"",
                                          "cod_amount" : (data.cod_amount!=null)?data.cod_amount:"",
                                          "cod_pay" : (data.cod_pay!=null)?data.cod_pay:"",
                                          "paymode" : (data.paymode!=null)?data.paymode:"",
                                          "ro_capacity" : (data.ro_capacity!=null)?data.ro_capacity:"",
                                          "raw_tds" : (data.raw_tds!=null)?data.raw_tds:"",
                                          "system_old_new" : (data.system_old_new!=null)?data.system_old_new:"",
                                          "old_year" : (data.old_year!=null)?data.old_year:"",
                                          "is_ro" : (data.is_ro!=null)?data.is_ro:"",
                                          "ro_img" : (data.ro_img!=null)?data.ro_img:"",
                                        });
                                  },
                                  child: Card(
                                      semanticContainer: true,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      elevation: 2.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      margin: new EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),

                                      child: Container(
//                                        decoration: BoxDecoration(
//                                            gradient: LinearGradient(
//                                                begin: Alignment.topLeft,
//                                                end: Alignment.bottomRight,
//                                                stops: [0.3, 1],
//                                                colors: [Colors.blue.shade400, Colors.blue.shade500])
//                                        ),
                                        child: ListTile(contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                            title: Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                            Row(
                                                              children: [
                                                                (data.who_order_for=="Self" || data.who_order_for==null)?Container(
                                                                  width:MediaQuery.of(context).size.width*0.60,
                                                                  child: Text(
                                                                    (data.orderd_name!=null)?data.orderd_name.toUpperCase():"---",
                                                                    style: GoogleFonts.lato(color: Colors.green, fontSize: 17.0,fontWeight: FontWeight.w700),
                                                                  ),
                                                                ):Container(
                                                                  width:MediaQuery.of(context).size.width*0.60,
                                                                  child: Text(
                                                                    (data.other_cust_name!=null)?data.other_cust_name.toUpperCase():"---",
                                                                    style: GoogleFonts.lato(color: Colors.green, fontSize: 17.0,fontWeight: FontWeight.w700),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "WELLON",
                                                                  style: GoogleFonts.lato(color: Colors.green, fontSize: 18.0,fontWeight: FontWeight.w700),
                                                                ),
                                                                Text(
                                                                  (data.order_id!=null)?data.order_id:"---",
                                                                  style: GoogleFonts.lato(color: Colors.green, fontSize: 18.0,fontWeight: FontWeight.w700),
                                                                ),
                                                              ],
                                                            ),
                                                  ],
                                                ),
                                                new Divider(
                                                  color: Colors.black,
                                                ),
                                              ],
                                            ),
                                            subtitle: Column(
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
//                                                            Text(
//                                                              '5 KM',
//                                                              style: GoogleFonts.lato(fontSize: 14,fontWeight: FontWeight.w700, color: Colors.grey.shade600),
//                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.location_on, color: Colors.grey.shade600, size: 18.0,
                                                            ),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Container(
                                                              width:MediaQuery.of(context).size.width*0.50,
                                                              child: Text(
                                                                ((data.address2!=null)?data.address2:"---")+((data.pincode!=null)?" - "+data.pincode:"---"),
                                                                style: GoogleFonts.lato(fontSize: 14,color: Colors.grey.shade600,fontWeight: FontWeight.w700),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 4,
                                                    ),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              'Type',
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade600,fontWeight: FontWeight.w700),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              (data.o_type_name!=null)?(data.o_type_name=="ro")?"Water Purifier".toUpperCase():"Alkaline Water Ionizer".toUpperCase():"---",
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade600,fontWeight: FontWeight.w500),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 4,
                                                    ),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              'Category',
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade600,fontWeight: FontWeight.w700),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              (data.o_category!=null)?data.o_category.toUpperCase():"---",
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade600,fontWeight: FontWeight.w500),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 4,
                                                    ),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              'Installation Type',
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade600,fontWeight: FontWeight.w700),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              (data.instance_normal!=null)?data.instance_normal.toUpperCase():"---",
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade600,fontWeight: FontWeight.w500),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 4,
                                                    ),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.calendar_today, color: Colors.grey.shade600, size: 18.0,
                                                            ),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              (data.order_complete_date_time!=null)?data.order_complete_date_time:"---",
                                                              style: GoogleFonts.lato(fontSize: 14,color: Colors.grey.shade600,fontWeight: FontWeight.w700),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),

                                              ],
                                            )
                                        ),
                                      )),
                                ),
                            ).toList(),
                          );
                        },
                      ),
                    )
                  ],
                ),
                Stack(
                  children: <Widget>[
                    RefreshIndicator(
                      color: Colors.black,
                      key: _refreshIndicatorKey4,
                      onRefresh: () async{
                        await LoadData.refreshcancellead();
                        setState(() {

                        });
                      },
                      child: FutureBuilder<List<CancelLeadList>>(
                        future: LoadData.cancelLeadListfilterData,
                        builder: (context,snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting)
                          {
                            return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                          else if (!snapshot.hasData) {
                            return SingleChildScrollView(
                              child: Container(
                                height: MediaQuery.of(context).size.height*0.8,
                                child: Center(
                                  child: Text("No Data Available!"),
                                ),
                              ),
                            );
                          }
                          return ListView(
                            padding: EdgeInsets.only(top: 5),
                            children: snapshot.data
                                .map((data) =>
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed("/leadcancelscreen",
                                        arguments: {
                                          "order_id" : (data.order_id!=null)?data.order_id:"",
                                          "customer_id" : (data.customer_id!=null)?data.customer_id:"",
                                          "type_id" : (data.type_id!=null)?data.type_id:"",
                                          "orderd_contact_number" : (data.orderd_contact_number!=null)?data.orderd_contact_number:"",
                                          "orderd_name" : (data.orderd_name!=null)?data.orderd_name:"",
                                          "house_no" : (data.house_no!=null)?data.house_no:"",
                                          "house_name" : (data.house_name!=null)?data.house_name:"",
                                          "address1" : (data.address1!=null)?data.address1:"",
                                          "address2" : (data.address2!=null)?data.address2:"",
                                          "address3" : (data.address3!=null)?data.address3:"",
                                          "pincode" : (data.pincode!=null)?data.pincode:"",
                                          "latitude" : (data.latitude!=null)?data.latitude:"",
                                          "longitude" : (data.longitude!=null)?data.longitude:"",
                                          "ro_product_photo" : (data.ro_product_photo!=null)?data.ro_product_photo:"",
                                          "prefer_date" : (data.prefer_date!=null)?data.prefer_date:"",
                                          "prefer_time" : (data.prefer_time!=null)?data.prefer_time:"",
                                          "order_date_time" : (data.order_date_time!=null)?data.order_date_time:"",
                                          "expire_date_time" : (data.expire_date_time!=null)?data.expire_date_time:"",
                                          "order_status" : (data.order_status!=null)?data.order_status:"",
                                          "order_created_by" : (data.order_created_by!=null)?data.order_created_by:"",
                                          "is_complete_customer" : (data.is_complete_customer!=null)?data.is_complete_customer:"",
                                          "is_complete_sp" : (data.is_complete_sp!=null)?data.is_complete_sp:"",
                                          "order_complete_date_time" : (data.order_complete_date_time!=null)?data.order_complete_date_time:"",
                                          "cust_remark" : (data.cust_remark!=null)?data.cust_remark:"",
                                          "created_at" : (data.created_at!=null)?data.created_at:"",
                                          "updated_at" : (data.updated_at!=null)?data.updated_at:"",
                                          "modelid" : (data.modelid!=null)?data.modelid:"",
                                          "brandname" : (data.brandname!=null)?data.brandname:"",
                                          "other_brand" : (data.other_brand!=null)?data.other_brand:"",
                                          "other_model" : (data.other_model!=null)?data.other_model:"",
                                          "brandimg" : (data.brandimg!=null)?data.brandimg:"",
                                          "modelname" : (data.modelname!=null)?data.modelname:"",
                                          "modelimg" : (data.modelimg!=null)?data.modelimg:"",
                                          "customer_name" : (data.customer_name!=null)?data.customer_name:"",
                                          "who_order_for" : (data.who_order_for!=null)?data.who_order_for:"",
                                          "other_cust_name" : (data.other_cust_name!=null)?data.other_cust_name:"",
                                          "other_cust_contact" : (data.other_cust_contact!=null)?data.other_cust_contact:"",
                                          "o_type_name" : (data.o_type_name!=null)?data.o_type_name:"",
                                          "o_category" : (data.o_category!=null)?data.o_category:"",
                                          "o_machine" : (data.o_machine!=null)?data.o_machine:"",
                                          "instance_normal" : (data.instance_normal!=null)?data.instance_normal:"",
                                          "payable_amount" : (data.payable_amount!=null)?data.payable_amount:"",
                                          "cod_amount" : (data.cod_amount!=null)?data.cod_amount:"",
                                          "cod_pay" : (data.cod_pay!=null)?data.cod_pay:"",
                                          "paymode" : (data.paymode!=null)?data.paymode:"",
                                          "ro_capacity" : (data.ro_capacity!=null)?data.ro_capacity:"",
                                          "raw_tds" : (data.raw_tds!=null)?data.raw_tds:"",
                                          "system_old_new" : (data.system_old_new!=null)?data.system_old_new:"",
                                          "old_year" : (data.old_year!=null)?data.old_year:"",
                                          "is_ro" : (data.is_ro!=null)?data.is_ro:"",
                                          "ro_img" : (data.ro_img!=null)?data.ro_img:"",
                                        });
                                  },
                                  child: Card(
                                      color : (data.order_status!="processspcancel")?Colors.green.shade100:Colors.white,
                                      semanticContainer: true,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      elevation: 2.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      margin: new EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),

                                      child: Container(
//                                        decoration: BoxDecoration(
//                                            gradient: LinearGradient(
//                                                begin: Alignment.topLeft,
//                                                end: Alignment.bottomRight,
//                                                stops: [0.3, 1],
//                                                colors: [Colors.blue.shade400, Colors.blue.shade500])
//                                        ),
                                        child: ListTile(contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                            title: Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Row(
                                                      children: [
                                                        (data.who_order_for=="Self" || data.who_order_for==null)?Container(
                                                          width:MediaQuery.of(context).size.width*0.60,
                                                          child: Text(
                                                            (data.orderd_name!=null)?data.orderd_name.toUpperCase():"---",
                                                            style: GoogleFonts.lato(color: Colors.green, fontSize: 17.0,fontWeight: FontWeight.w700),
                                                          ),
                                                        ):Container(
                                                          width:MediaQuery.of(context).size.width*0.60,
                                                          child: Text(
                                                            (data.other_cust_name!=null)?data.other_cust_name.toUpperCase():"---",
                                                            style: GoogleFonts.lato(color: Colors.green, fontSize: 17.0,fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "WELLON",
                                                          style: GoogleFonts.lato(color: Colors.green, fontSize: 18.0,fontWeight: FontWeight.w700),
                                                        ),
                                                        Text(
                                                          (data.order_id!=null)?data.order_id:"---",
                                                          style: GoogleFonts.lato(color: Colors.green, fontSize: 18.0,fontWeight: FontWeight.w700),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                new Divider(
                                                  color: Colors.black,
                                                ),
                                              ],
                                            ),
                                            subtitle: Column(
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
//                                                            Text(
//                                                              '5 KM',
//                                                              style: GoogleFonts.lato(fontSize: 14,fontWeight: FontWeight.w700, color: Colors.grey.shade600),
//                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.location_on, color: Colors.grey.shade600, size: 18.0,
                                                            ),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Container(
                                                              width:MediaQuery.of(context).size.width*0.50,
                                                              child: Text(
                                                                ((data.address2!=null)?data.address2:"---")+((data.pincode!=null)?" - "+data.pincode:"---"),
                                                                style: GoogleFonts.lato(fontSize: 14,color: Colors.grey.shade600,fontWeight: FontWeight.w700),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 4,
                                                    ),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              'Type',
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade600,fontWeight: FontWeight.w700),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              (data.o_type_name!=null)?(data.o_type_name=="ro")?"Water Purifier".toUpperCase():"Alkaline Water Ionizer".toUpperCase():"---",
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade600,fontWeight: FontWeight.w500),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 4,
                                                    ),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              'Category',
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade600,fontWeight: FontWeight.w700),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              (data.o_category!=null)?data.o_category.toUpperCase():"---",
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade600,fontWeight: FontWeight.w500),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 4,
                                                    ),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              'Installation Type',
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade600,fontWeight: FontWeight.w700),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              (data.instance_normal!=null)?data.instance_normal.toUpperCase():"---",
                                                              style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade600,fontWeight: FontWeight.w500),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 4,
                                                    ),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.calendar_today, color: Colors.grey.shade600, size: 18.0,
                                                            ),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              (data.order_complete_date_time!=null)?data.order_complete_date_time:"---",
                                                              style: GoogleFonts.lato(fontSize: 14,color: Colors.grey.shade600,fontWeight: FontWeight.w700),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),

                                              ],
                                            )
                                        ),
                                      )),
                                ),
                            ).toList(),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
