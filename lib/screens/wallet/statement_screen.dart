import 'dart:async';
import 'dart:io';

import "package:flutter/material.dart";
import 'package:flutter/services.dart';import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/models/wallet_history_list.dart';
import 'package:wellon_partner_app/screens/wallet/payment_screen.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/flash_helper.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:pdf/pdf.dart';
import 'package:wellon_partner_app/utils/network_util.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart' as material;
import 'package:wellon_partner_app/utils/pdfviewer.dart';

class StatementScreen extends StatefulWidget {
  @override
  _StatementScreenState createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> with SingleTickerProviderStateMixin{
  BuildContext _ctx;

  SharedPreferences prefs;
  NetworkUtil _netUtil = new NetworkUtil();

  String spfullname="",provider_id="0",mobile_numbers="";
  String withdraw_id,order_id,amount,amount_type,amount_status,wallet_date_time,updated_at,created_at;
  String _amt,_addmoneyamt,_remart;
  bool _visibalpdfloading=false,_visibalpdf=true;
//
  String total_credit,total_debit,total_balance="0";

  bool isOffline = false;
  bool _isLoading = false;
  bool _isdataLoading = false;
  final formKey = new GlobalKey<FormState>();
  final formKeyaddmoney = new GlobalKey<FormState>();

  Future<List<WalletHistoryList>> WalletHistoryListdata;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 = new GlobalKey<RefreshIndicatorState>();

  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  _loadPref() async {
    setState(() {
      WalletHistoryListdata = _getWalletHistoryData();
    });
  }

  _loadWalletamt() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {

      provider_id= prefs.getString("provider_id") ?? '';
      spfullname= prefs.getString("spfullname") ?? '';

      _netUtil.post(RestDatasource.GET_WALLET_TOTAL_AMT, body: {
        "provider_id":provider_id,
      }).then((dynamic res) async {
        setState(() {
          //print(provider_id);
          total_credit=res["total_credit_ledger"].toString();
          total_debit=res["total_debit_ledger"].toString();
          total_balance=res["total_balance_ledger"].toString();
          total_balance=res["total_balance_ledger"].toString();

          _isdataLoading=false;
        });
      });

    });
  }

  Future<List<WalletHistoryList>> _getWalletHistoryData() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return _netUtil.post(RestDatasource.GET_WALLET_LEDGER,
        body:{
          "provider_id":prefs.getString("provider_id"),
        }).then((dynamic res)
    {
      final items = res.cast<Map<String, dynamic>>();
      //print(items);
      List<WalletHistoryList> listofusers = items.map<WalletHistoryList>((json) {
        return WalletHistoryList.fromJson(json);
      }).toList();
      List<WalletHistoryList> revdata = listofusers.reversed.toList();
      return revdata;
    });
  }

  //Load Data
  //On Refresh
  Future<List<WalletHistoryList>> _refresh1() async
  {
    setState(() {
      WalletHistoryListdata = _getWalletHistoryData();
    });
  }
  Future<File> copyAsset() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File tempFile = File('$tempPath/logo.png');
    ByteData bd = await rootBundle.load('images/logo.png');
    await tempFile.writeAsBytes(bd.buffer.asUint8List(), flush: true);
    return tempFile;
  }

  reportView(context) async {
    final pw.Document pdf = pw.Document();

    final SharedPreferences prefs = await SharedPreferences.getInstance();

     _netUtil.post(RestDatasource.GET_WALLET_LEDGER,
        body:{
          "provider_id":prefs.getString("provider_id"),
        }).then((dynamic res)
    async {
      final items = res.cast<Map<String, dynamic>>();
      //print(items);
      List<WalletHistoryList> listofusers = items.map<WalletHistoryList>((
          json) {
        return WalletHistoryList.fromJson(json);
      }).toList();
      List<WalletHistoryList> revdata = listofusers.toList();
      List<List<String>> mainarray = new List<List<String>>();

      List<String> item = new List<String>();
      item.add("wallet_date_time");
      item.add("wallet_remark");
      item.add("updated_at");
      item.add("created_at");
      item.add("amount_type");
      item.add("amount_status");
      item.add("amount");
      item.add("Balance");
      mainarray.add(item);
      double total=0.0;
      for(var i = 0; i < revdata.length; i++){
        List<String> item=new List<String>();
        item.add(revdata[i].wallet_date_time.toString());
        item.add(revdata[i].wallet_remark.toString());
        item.add(revdata[i].updated_at.toString());
        item.add(revdata[i].created_at.toString());
        item.add(revdata[i].amount_type.toString());
        item.add(revdata[i].amount_status.toString());
        item.add(revdata[i].amount.toString());

        total=revdata[i].amount_type.toString()=="credit"?total+double.parse(revdata[i].amount.toString()):total-double.parse(revdata[i].amount.toString());
        item.add(total.toString());
        mainarray.add(item);

      }


      File f = await copyAsset();
      final image = PdfImage.file(
          pdf.document,
          bytes: f.readAsBytesSync()
      );
      pdf.addPage(pw.MultiPage(
          pageFormat:
          PdfPageFormat.a3,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          header: (pw.Context context) {
            return null;
          },
          footer: (pw.Context context) {
            return pw.Container(
                alignment: pw.Alignment.topRight,
                margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                child: pw.Text(
                    'Page ${context.pageNumber} of ${context.pagesCount}'));
          },
          build: (pw.Context context) =>
          <pw.Widget>[

            pw.Container(
                alignment: pw.Alignment.topCenter,
                margin: const pw.EdgeInsets.only(
                    bottom: 3.0 * PdfPageFormat.mm),
                padding: const pw.EdgeInsets.only(
                    bottom: 3.0 * PdfPageFormat.mm),
                child: pw.Image(image,height: 500,width: 300)),
            pw.Container(
                alignment: pw.Alignment.topCenter,
                margin: const pw.EdgeInsets.only(
                    bottom: 0.0 * PdfPageFormat.mm),
                padding: const pw.EdgeInsets.only(
                    bottom: 0.0 * PdfPageFormat.mm),
                child: pw.Text("Wallet Statement",
                    style: pw.Theme
                        .of(context)
                        .defaultTextStyle
                        .copyWith(color: PdfColors.black, fontSize: 30))),
            pw.Container(
                alignment: pw.Alignment.topCenter,
                margin: const pw.EdgeInsets.only(
                    bottom: 3.0 * PdfPageFormat.mm),
                padding: const pw.EdgeInsets.only(
                    bottom: 3.0 * PdfPageFormat.mm),
                child: pw.Text("Total Amount : "+total_balance,
                    style: pw.Theme
                        .of(context)
                        .defaultTextStyle
                        .copyWith(color: PdfColors.black, fontSize: 20))),
            pw.Padding(padding: const pw.EdgeInsets.all(10)),
            pw.Header(
                level: 0,
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: <pw.Widget>[
                      pw.Text(
                          "",
                          textScaleFactor: 1),
                    ])),
            pw.Padding(padding: const pw.EdgeInsets.all(10)),
            pw.Table.fromTextArray(context: context, data: mainarray),
          ]));
      //save PDF
      final String dir = (await getApplicationDocumentsDirectory()).path;
      final String path = '$dir/' + spfullname + '.pdf';
      final File file = File(path);
      await file.writeAsBytes(pdf.save());
      setState(() {
        _isLoading=false;
      });
      material.Navigator.of(context).push(
        material.MaterialPageRoute(
          builder: (_) => PdfViewerPage(path: path, pdffile: file),
        ),
      );
    });
  }


  @override
  initState() {
    super.initState();
    //print("setstate called");
    ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
    _loadPref();
    _loadWalletamt();
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      ////print(isOffline);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
     appBar: AppBar(
       centerTitle: true,
       iconTheme: IconThemeData(
         color: Colors.white, //change your color here
       ),
       title: Text("Wellon Ledger",style: GoogleFonts.lato(color:Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
       actions: <Widget>[
         IconButton(
           icon: Icon(
             Icons.picture_as_pdf,
             color: Colors.white,
             size: 30,
           ),
           onPressed: () {
             if(_isLoading==false)
               {
                 setState(() {
                   _isLoading=true;
                 });
                 reportView(context);
               }
           },
         ),
       ],
       backgroundColor: Colors.green,
     ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                children: [
                  Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            alignment: Alignment.center,
                            child: new Text("Total Balance",style: GoogleFonts.lato(color:Colors.black,fontSize:18,letterSpacing: 1,fontWeight: FontWeight.w700))
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Container(
                            alignment: Alignment.center,
                            child: new Text((total_balance!=null)?" ₹"+total_balance:"₹0",style: GoogleFonts.lato(color:Colors.black,fontSize:40,letterSpacing: 1,fontWeight: FontWeight.w700))
                        ),

                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            (total_balance!="0")?Expanded(
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context,StateSetter setState) {
                                            return Dialog(
                                              backgroundColor: Colors.white,
                                              child: Container(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.fromLTRB(20, 20, 15, 5),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Container(
                                                            child: Text("Withdraw Money",
                                                              style: GoogleFonts.lato(color:Colors.black,fontSize:20,fontWeight: FontWeight.w700),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Container(
                                                            child: Text("Are you sure you want to withdraw money?",
                                                              style: GoogleFonts.lato(color:Colors.black,fontSize:14,fontWeight: FontWeight.w700),
                                                            ),
                                                          ),
                                                          Form(
                                                            key: formKey,
                                                            child: Column(
                                                              children: <Widget>[
                                                                Container(
                                                                  padding: EdgeInsets.symmetric(vertical: 10),
                                                                  child: TextFormField(
                                                                    obscureText: false,
                                                                    keyboardType: TextInputType.number,
                                                                    onSaved: (val) {
                                                                      setState(() {
                                                                        _amt = val;
                                                                      });
                                                                    },
                                                                    validator: (val){
                                                                      if(val.length == 0)
                                                                        return "Name must be greater than 3";
                                                                      else
                                                                        return null;
                                                                    },
                                                                    decoration: InputDecoration(
                                                                      labelText: 'Enter Amount',
                                                                      labelStyle: GoogleFonts.lato(color:Color(0xff33691E),letterSpacing: 1,fontWeight: FontWeight.w700),
                                                                      filled: false,
                                                                      focusedBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              width: 2, color: Color(0xff33691E)
                                                                          )
                                                                      ),
                                                                      border: OutlineInputBorder(
                                                                          borderSide: BorderSide()
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  padding: EdgeInsets.symmetric(vertical: 5),
                                                                  child: TextFormField(
                                                                    textCapitalization: TextCapitalization.sentences,
                                                                    obscureText: false,
                                                                    keyboardType: TextInputType.text,
                                                                    maxLines: 4,
                                                                    onSaved: (val) {
                                                                      setState(() {
                                                                        _remart = val;
                                                                      });
                                                                    },
                                                                    validator: (val){
                                                                      if(val.length == 0)
                                                                        return "Name must be greater than 3";
                                                                      else
                                                                        return null;
                                                                    },
                                                                    decoration: InputDecoration(
                                                                      labelText: 'Enter Remark',
                                                                      labelStyle: GoogleFonts.lato(color:Color(0xff33691E),letterSpacing: 1,fontWeight: FontWeight.w700),
                                                                      filled: false,
                                                                      focusedBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              width: 2, color: Color(0xff33691E)
                                                                          )
                                                                      ),
                                                                      border: OutlineInputBorder(
                                                                          borderSide: BorderSide()
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(
                                                      color: Colors.grey,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.pop(context,false);
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                                                              alignment: Alignment.center,
                                                              child: Text("No",
                                                                style: GoogleFonts.lato(color:Colors.black,fontSize: 15,letterSpacing: 1,fontWeight: FontWeight.w700),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                                          width: 0.5,
                                                          color: Colors.grey,
                                                        ),
                                                        Expanded(
                                                          child: InkWell(
                                                            onTap: () {
                                                              if(_isLoading==false) {
                                                                final form = formKey
                                                                    .currentState;
                                                                if (form
                                                                    .validate()) {
                                                                  form.save();
                                                                  _netUtil.post(
                                                                      RestDatasource
                                                                          .SEND_WITHDRAW_MONEY_REQ,
                                                                      body: {
                                                                        "provider_id": prefs
                                                                            .getString(
                                                                            "provider_id"),
                                                                        "withdraw_amount": _amt,
                                                                        "withdrawal_remark": _remart,
                                                                      }).then((
                                                                      dynamic res) async {
                                                                    if (res["Request"] ==
                                                                        "Your Request Successfully Send") {
                                                                      Navigator
                                                                          .pop(
                                                                          context,
                                                                          false);
                                                                      formKey
                                                                          .currentState
                                                                          .reset();
                                                                      FlashHelper
                                                                          .successBar(
                                                                          context,
                                                                          message: "Your Request Successfully Send");
                                                                    }
                                                                    else
                                                                    if (res["Balance"] ==
                                                                        "Insufficient Balance") {
                                                                      Navigator
                                                                          .pop(
                                                                          context,
                                                                          false);
                                                                      FlashHelper
                                                                          .errorBar(
                                                                          context,
                                                                          message: "Insufficient Balance");
                                                                    }
                                                                    else {
                                                                      Navigator
                                                                          .pop(
                                                                          context,
                                                                          false);
                                                                      FlashHelper
                                                                          .errorBar(
                                                                          context,
                                                                          message: "Your Previous Request Still Pending");
                                                                    }
                                                                  });
                                                                }
                                                              }
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                                                              alignment: Alignment.center,
                                                              child: Text("Yes",
                                                                style: GoogleFonts.lato(color:Colors.black,fontSize: 15,letterSpacing: 1,fontWeight: FontWeight.w700),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }

                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(
                                      color: Colors.green.shade600,

                                    ),
                                  ),
                                  child: Text("Withdraw\nMoney",textAlign: TextAlign.center ,style: GoogleFonts.lato(color:Colors.green.shade600,fontSize: 14,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                ),
                              ),
                            ):Container(),
                            Expanded(
                              child: InkWell(
                                onTap: (){
                                  if(_isLoading==false)
                                    {
                                      Navigator.of(context).pushNamed("/viewscreen");
                                    }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(
                                      color: Colors.blue.shade600,

                                    ),
                                  ),
                                  child: Text("Your\nRequest",textAlign: TextAlign.center, style: GoogleFonts.lato(color:Colors.blue.shade600,fontSize: 14,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context,StateSetter setState) {
                                            return Dialog(
                                              backgroundColor: Colors.white,
                                              child: Container(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.fromLTRB(20, 20, 15, 5),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Container(
                                                            child: Text("Add Money",
                                                              style: GoogleFonts.lato(color:Colors.black,fontSize:20,fontWeight: FontWeight.w700),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Container(
                                                            child: Text("Are you sure you want to Add money?",
                                                              style: GoogleFonts.lato(color:Colors.black,fontSize:14,fontWeight: FontWeight.w700),
                                                            ),
                                                          ),
                                                          Form(
                                                            key: formKeyaddmoney,
                                                            child: Column(
                                                              children: <Widget>[
                                                                Container(
                                                                  padding: EdgeInsets.symmetric(vertical: 10),
                                                                  child: TextFormField(
                                                                    obscureText: false,
                                                                    keyboardType: TextInputType.number,
                                                                    onSaved: (val) {
                                                                      setState(() {
                                                                        _addmoneyamt = val;
                                                                      });
                                                                    },
                                                                    validator: (val){
                                                                      if(val.length == 0)
                                                                        return "Name must be greater than 3";
                                                                      else
                                                                        return null;
                                                                    },
                                                                    decoration: InputDecoration(
                                                                      labelText: 'Enter Amount',
                                                                      labelStyle: GoogleFonts.lato(color:Color(0xff33691E),letterSpacing: 1,fontWeight: FontWeight.w700),
                                                                      filled: false,
                                                                      focusedBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              width: 2, color: Color(0xff33691E)
                                                                          )
                                                                      ),
                                                                      border: OutlineInputBorder(
                                                                          borderSide: BorderSide()
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(
                                                      color: Colors.grey,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.pop(context,false);
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                                                              alignment: Alignment.center,
                                                              child: Text("No",
                                                                style: GoogleFonts.lato(color:Colors.black,fontSize: 15,letterSpacing: 1,fontWeight: FontWeight.w700),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                                          width: 0.5,
                                                          color: Colors.grey,
                                                        ),
                                                        Expanded(
                                                          child: InkWell(
                                                            onTap: () {
                                                              if(_isLoading==false) {
                                                                if(formKeyaddmoney.currentState.validate())
                                                                  {
                                                                    formKeyaddmoney.currentState.save();
                                                                    Navigator.push(
                                                                      context,
                                                                      PageTransition(
                                                                        childCurrent: StatementScreen(),
                                                                        duration: Duration(milliseconds: 500),
                                                                        reverseDuration: Duration(milliseconds: 500),
                                                                        type: PageTransitionType.bottomToTop,
                                                                        child: AddPaymentScreen(provider_id,_addmoneyamt),
                                                                      ),
                                                                    );
                                                                  }
                                                              }
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                                                              alignment: Alignment.center,
                                                              child: Text("Yes",
                                                                style: GoogleFonts.lato(color:Colors.black,fontSize: 15,letterSpacing: 1,fontWeight: FontWeight.w700),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }

                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(
                                      color: Colors.green.shade600,

                                    ),
                                  ),
                                  child: Text("Add\nMoney",textAlign: TextAlign.center, style: GoogleFonts.lato(color:Colors.green.shade600,fontSize: 14,letterSpacing: 1,fontWeight: FontWeight.w700),),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
            RefreshIndicator(
              color: Colors.black,
              key: _refreshIndicatorKey1,
              onRefresh: _refresh1,
              child: FutureBuilder<List<WalletHistoryList>>(
                future: WalletHistoryListdata,
                builder: (context, snapshot) {
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
                      height: MediaQuery.of(context).size.height*1.0,
                      child: Center(
                        child: Text("No Data Available!"),
                      ),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                  Padding(
                    padding: const EdgeInsets.only(left: 10,top: 10),
                    child: Text("Ledger History", style: GoogleFonts.lato(color:Colors.black,fontSize: 20,letterSpacing: 1,fontWeight: FontWeight.w700),),
                  ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10,bottom: 20),
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(), ///
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 5),
                        children: snapshot.data.map((data) =>
                            Card(
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              margin: new EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 1.0),

                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Image.asset("images/launcher.png",height: 50,width: 50,),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                (data.order_id!="null")?"WELLON"+data.order_id:"WELLON",
                                                style: GoogleFonts.lato(color: Colors.grey.shade800,fontSize: 15,fontWeight: FontWeight.w700),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    width:MediaQuery.of(context).size.width*0.50,
                                                    child: Text(
                                                      (data.wallet_remark!=null)?data.wallet_remark:"",
                                                      style: GoogleFonts.lato(color: Colors.grey.shade800,fontSize: 14,fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    (data.amount_status!=null)?data.amount_status:"",
                                                    style: GoogleFonts.lato(color: Color(0xff616161),fontSize: 13,fontWeight: FontWeight.w700),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    (data.wallet_date_time!=null)?data.wallet_date_time:"",
                                                    style: GoogleFonts.lato(color: Color(0xff616161),fontSize: 13,fontWeight: FontWeight.w700),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: (data.amount_type == "credit") ? new Text((data.amount!=null)?" + ₹"+data.amount:" + "+"₹0",style: GoogleFonts.lato(color: Colors.green,fontSize: 16,fontWeight: FontWeight.w700)):new Text((data.amount!=null)?" - ₹"+data.amount:" - "+"₹0",style: GoogleFonts.lato(fontSize: 16.0,color: Colors.red,)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
            ),
            _isLoading?Center(child: CircularProgressIndicator(backgroundColor: Colors.green,)):Center()
          ],
        ),
      ),
    );
  }
}