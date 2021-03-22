import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends StatefulWidget {

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _counter = 1;
  var sum_amt = 10000;
  var res = 0;

  void _decrementCounter() => setState(() => _counter--);

  void _incrementCounter() => setState(() => _counter++);


  @override
  Widget build(BuildContext context) {
    res = _counter*sum_amt;
    return new Scaffold(
      body: Stack(
        children: <Widget>[
      NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              centerTitle: true,
              title: new Text("My Cart"),
              pinned: false,
              floating: true,
              forceElevated: innerBoxIsScrolled,
            ),
          ];
        },
        body:Stack(
            children: <Widget>[
              ListView(
                  padding: EdgeInsets.only(top: 5),
                  children: <Widget>[
                    Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      margin: new EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5.0),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Deliver  to',
                                      style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade800),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Tejas Patel, 395005',
                                      style: GoogleFonts.lato(fontSize: 14,fontWeight: FontWeight.w700, color: Colors.grey.shade800),
                                    ),
                                    Align(
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(12)),
                                          color: Colors.black12,),
                                        child: Text(
                                          "Home",
                                          style: GoogleFonts.lato(color: Colors.black26, fontSize: 12.0,),
                                        ),
                                      ),
                                    ),

                                    Align(
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(12)),
                                          color: Colors.white,),
                                        child: Text(
                                          "Change",
                                          style: GoogleFonts.lato(color: Colors.blue, fontSize: 15.0,),
                                        ),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'C-703 Sagar Sankul Apt. Jangirabad Surat - 395005',
                                    style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade800),
                                  ),
                                ]
                            ),
                          ],
                        ),

                      ),

                    ),
                    Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      margin: new EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 5, 10, 5),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Self RO Water Purifier',
                                    style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade800),
                                  ),
                                  Container(
                                      alignment: Alignment.topLeft,
                                      child: new Image.asset("images/img.png", width: 70, height: 70,)
                                  ),
                                ]
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 5, 20, 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              'Rs.',
                                              style: GoogleFonts.lato(fontSize: 20,fontWeight: FontWeight.w700, color: Colors.grey.shade800),
                                            ),
                                            Text(
                                              '$res',
                                              style: GoogleFonts.lato(fontSize: 20,fontWeight: FontWeight.w700, color: Colors.grey.shade800),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(Icons.remove_circle),
                                              iconSize: 25,
                                              onPressed: _counter > 1 ? () => setState(() => _decrementCounter()) : null,
                                            ),
                                            Text('$_counter', style: GoogleFonts.lato(fontSize: 16.0)),
                                            IconButton(
                                              icon: Icon(Icons.add_circle),
                                              color: Colors.blue,
                                              iconSize: 25,
                                              onPressed: () => setState(() => _incrementCounter()),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 10, 10),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '10 offer available',
                                        style: GoogleFonts.lato(fontSize: 12, color: Colors.green.shade300),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 10, 10),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Delivery in 3 - 4 days',
                                        style: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade800),
                                      ),
                                    ),
                                  ),
                                ]
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                        alignment: Alignment.center,
                                        child: InkWell(
                                          onTap: (){

                                          },
                                          child: Text("Save for later",
                                            style: GoogleFonts.lato(color:Color(0xff33691E),fontSize: 15),),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        color: Colors.deepOrange,
                                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                        alignment: Alignment.center,
                                        child: InkWell(
                                          onTap: (){

                                          },
                                          child: Text("Remove",
                                            style: GoogleFonts.lato(color:Colors.white,fontSize: 15),),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      margin: new EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 5, 10, 5),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'PRICE DETAILS',
                                style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade800),
                              ),
                            ),
                          ),
                          new Divider(
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 5, 20, 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Price(1 item)',
                                            style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade800),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                'Rs.',
                                                style: GoogleFonts.lato(fontSize: 16,color: Colors.grey.shade800),
                                              ),
                                              Text(
                                                '$res',
                                                style: GoogleFonts.lato(fontSize: 16,color: Colors.grey.shade800),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Delivery Fee',
                                            style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade800),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            'FREE',
                                            style: GoogleFonts.lato(fontSize: 16,color: Colors.green.shade300),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  new Divider(
                                    color: Colors.grey,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Total Amount',
                                            style: GoogleFonts.lato(fontSize: 16, color: Colors.grey.shade800),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                'Rs.',
                                                style: GoogleFonts.lato(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.grey.shade800),
                                              ),
                                              Text(
                                                '$res',
                                                style: GoogleFonts.lato(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.grey.shade800),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
              ),
            ]
        ),
      ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Card(
                elevation: 20,
                margin: EdgeInsets.all(0),
                shape : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: (){

                            },
                            child: Row(
                              children: <Widget>[
                                Text('Rs.',
                                  style: GoogleFonts.lato(color: Colors.grey.shade800,fontSize: 18),),
                                Text('$res',
                                  style: GoogleFonts.lato(color: Colors.grey.shade800,fontSize: 18),),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.deepOrange,
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: (){

                            },
                            child: Text("Place Order",
                              style: GoogleFonts.lato(color:Colors.white,fontSize: 15),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
  ],
    ),
    );
  }
}
