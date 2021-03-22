import 'dart:async';
import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/utils/common_helper.dart';
import 'package:wellon_partner_app/utils/connectionStatusSingleton.dart';
import 'package:wellon_partner_app/utils/internetconnection.dart';
import 'package:flutter/material.dart';

class TermsAndConditionScreen extends StatefulWidget {
  @override
  _TermsAndConditionScreenState createState() => _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {

  BuildContext _ctx;

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
            title: Text("Term & Conditions",style: GoogleFonts.lato(color:Colors.white,letterSpacing: 1,fontWeight: FontWeight.w700),),
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            centerTitle: true,
            backgroundColor: Colors.green,
          ),
        key: scaffoldKey,
        body: SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
//              Align(
//                alignment: Alignment.centerLeft,
//                child:InkWell(
//                  onTap: () {
//                    Navigator.of(context).pop();
//                  },
//                  child: Padding(
//                    padding: const EdgeInsets.fromLTRB(10,10,10,10),
//                    child: Icon(Icons.arrow_back_ios,size: 25,color: Colors.black,),
//                  ),
//                ),
//              ),
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
                child: Text("Wellon Terms & Conditions",style: GoogleFonts.lato(color:Color(0xff33691E),fontSize: 22,fontWeight: FontWeight.w700),
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
                      Text("1. Terms & Conditions",style: GoogleFonts.lato(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text(" Welcome to “http://wellonwater.com”/the Wellon Mobile Application Wellon technician. This Website/App is owned and operated by (“Wellon”), whose registered office is at (Postal Address). The Website/App is an online platform which enables Users to book the services of persons providing Technical services (“Providers”).For the purpose of these terms of use (“Terms of Use”), “We”, “Us” and “Our” means the Company and “You”, “Your” and “User” means any person who accesses or uses the Website/App or the Services. “Services” includes access to our mobile application Wellon technician, any upgrades of the App, Our call and SMS based services, databases, Interactive Voice Response services and all other services and functionalities that we provide through the Website/App or your mobile phone.By accessing or using this Website/App or the Services, You agree to be bound by these Terms of Use, the services agreement between you and our website http://wellonwater.com/agreement and our other policies made available on the website, including but not limited to the Privacy Policy available at http://wellonwater.com/privacy (“Policies”). If you do not agree to these Terms of Use or any of our Policies, please do not use the Services or access the Website/App.",
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
                      Text("2. Changes to the Terms of Use",style: GoogleFonts.lato(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text("We may modify these Terms of Use and Our Policies from time to time, by updating this document. Your continuing to use the Website/App or Services following the posting of changes will mean that you accept such changes.",
                          style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                      ),
                    ],
                  )
              ),
              // Container(
              //     margin: EdgeInsets.fromLTRB(10, 2, 10, 0),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text("- modify or copy the materials",
              //           style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
              //         Text("- use the materials for any commercial purpose, or for any public display(commercial or non-commercial);",
              //           style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
              //         Text("- attempt to decompile or reverse engineer any software contained on Jobify’s web site;",
              //           style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
              //         Text("- remove any copyright or other proprietary notations from the materials; or transfer the materials to another person or “mirror” the materials on any other server.",
              //           style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
              //         Text("- This license shall automatically terminate if you violate any of these restrictions and may be terminated by Thedir at any time. Upon terminating your viewing of these materials or upon the termination of this license, you must destroy any downloaded materials in your possession whether in electronic or printed format.",
              //           style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
              //       ],
              //     )
              // ),
              Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("3. Access to the Website/App and Services",style: GoogleFonts.lato(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text("You may access the Website/App and the Services only if you are 18 years of age or older and are legally capable of entering into a binding contract as per applicable law, including, in particular, the Indian Contract Act, 1872.",
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
                      Text("4. Your Information",style: GoogleFonts.lato(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("You may use the Services through Our App. Upon downloading the App, You are required to provide us with your details including your name, address, contact number and email address and then, choose the service you need, including a suitable time for such service (“User Information”).",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("After obtaining this information, we will provide you with a list of available Providers and an estimated cost of the services offered. You may confirm a booking, upon which the relevant Provider will contact you, arrive at your residence, inspect the scope of services required and quote a final fee for the same (“Transaction Fee”). You may then proceed to accept and avail of the services the Provider offers (“Transaction”).",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("Alternatively, you may provide us with your mobile phone number on the Website. We will then contact you, collect your user information and follow the procedure described in Clause 4.2 above.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("By providing us with your user information, you confirm that:",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("The user information provided by you is accurate and genuine;",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("The mobile phone number provided by you belongs to you, has been validly acquired under applicable law, and you may be contacted on the number by way of calls or SMS messages by us or our Providers; and",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("You shall immediately notify us of any un-authorized use of your user information or any other breach of these terms of use or security known to you.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("Further, you authorize us to:",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("Collect, process and store User Information and access information including the IP address, IMEI number and MAC address of the computer/device from where the Website/App were accessed;",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("Either directly, or through third parties, verifies and confirms your user information;",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("Contact you using your user information, including for marketing and promotional calls; and",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("Share your user information with providers who may use the same to contact you, including on your mobile phone.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),SizedBox(height: 10,),
                            Text("Subject to the above, and your compliance with these Terms of Use, We grant you a non-exclusive, revocable, limited privilege to access and use this Website/App and the Services.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                          ],
                        ),
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
                      Text("5. Fees and Payment",style: GoogleFonts.lato(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("The use of the Website/App is free of cost. However, this no charge policy can be amended at our discretion and we reserve the right to charge for any of the Services.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("You can either pay the Transaction Fee directly to the Provider upon completion of his/her services or through the Website/App, in Indian Rupees.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),SizedBox(height: 10,),
                            Text("If you choose to pay the Transaction Fee through the Website/App, Your credit/debit card or other payment instruments will be processed using a third party payment gateway (“Payment Facility”) which will also be governed by the terms and conditions agreed to between you and your issuing bank.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("We will not be responsible for any loss or damage to you due to your use of the Payment Facility on the Website/App.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),SizedBox(height: 10,),
                            Text("We can impose limits on the number of Transactions or the Transaction Fee which we receive from you and can refuse to process any Transaction Fee, at our sole discretion.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                          ],
                        ),

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
                      Text("6. Use of the Website/App and Services",style: GoogleFonts.lato(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("You agree to make use of the Website/App and Services for their intended purpose in a bona fide manner. In particular you agree not to:",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("Print, distribute, share, download, duplicate or otherwise copy, delete, vary or amend or use any data or User Information of any User other than You; infringe on any intellectual property rights of any person and/or retain information in any computer system or otherwise with an intention to do so; attempt to gain unauthorized access to any portion or feature of the Website/App, or any other systems or networks connected to the Website/App or to any server, computer, network, or to any of the Services by hacking, password “mining” or any other illegitimate means; probe, scan or test the vulnerability of the Website/App or Services or any network connected to the Website/App or Services or breach the security or authentication measures on the Website/App or any network connected to the Website/App or Services; use any automated systems to extract data from the Website/App; make any inaccurate, false, unfair or defamatory statement(s) or comment(s) about Us or the brand name or domain name used by Us, any Provider or any User on the Website/App; take any action that imposes an unreasonable or disproportionately large load on the infrastructure of the Website/App or Our systems or networks, or any systems or networks connected to Us; or circumvent or manipulate the Website/App, Services, registration process, Transaction Fees, billing system, or attempt to do so.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),SizedBox(height: 10,),
                            Text("You further agree not to host, display, upload, modify, publish, transmit, update, share or otherwise make available on the Website/App any information, that: contains content or other material protected by intellectual property laws unless You own or control the rights thereto or have received all necessary consents; defames, abuses, harasses, stalks, hurts religious or ethnic sentiments of, threatens or otherwise violates the legal rights of others; is grossly harmful, harassing, blasphemous defamatory, obscene, pornographic, pedophilic, libelous, invasive of another’s privacy, hateful, or racially, ethnically objectionable, disparaging, relating or encouraging money laundering or gambling, or otherwise unlawful in any manner whatever; harms minors in any way; infringes any patent, trademark, copyright or other proprietary rights; violates any law for the time being in force; deceives or misleads the addressee about the origin of such messages or communicates any information which is grossly offensive or menacing in nature; abets or assists with impersonating another person; contains software viruses or any other computer code, files or programs designed to interrupt, destroy or limit the functionality of any computer resource; threatens the unity, integrity, defense, security or sovereignty of India, friendly relations with foreign states, or public order or causes incitement to the commission of any cognizable offence or prevents investigation of any offence or is insulting any other nation; conducts or forwards surveys, contests, pyramid schemes or chain letters; creates profiles or provides content that promotes escort services or prostitution; uses any other internet service to send or post spam to drive visitors to any other site hosted on or through the Company’s systems, whether or not the messages were originated by You, under Your direction, or by or under the direction of a related or unrelated third party; or contains any content which is non-compliant with the Information Technology Act, 2000, Rules and regulations, guidelines made thereunder, including Rule 3 of The Information Technology (Intermediaries Guidelines) Rules, 2011, Terms of Use or Privacy Policy, as amended/re-enacted from time to time.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                          ],
                        ),
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
                      Text("7. Intellectual Property",style: GoogleFonts.lato(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("The intellectual property in the Website/App and in the material, content and information made available on the Website/App including graphics, images, photographs, logos, trademarks, the appearance, organization and layout of the Website/App and the underlying software code belong to us or our licensors.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("You must not copy, modify, alter, publish, broadcast, distribute, sell or transfer (whether in whole or in part) any such material. The information provided on the Website/App and through the Services is for your personal use only.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                          ],
                        ),
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
                      Text("8. Intellectual Property",style: GoogleFonts.lato(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text("You agree to indemnify us, our owners, licensees, affiliates, group companies and their respective officers, directors, agents, and employees, on demand, against any claim, action, damage, loss, liability, cost, charge, expense or payment which We may pay, suffer, incur or are liable for, in relation to any act You do or cause to be done, in breach of the Terms of Use or your violation of any law, rules or regulations.",
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
                      Text("9. Feedback, Reputation and Reviews",style: GoogleFonts.lato(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text("You agree to be fair, accurate and non-disparaging while leaving comments, feedback, testimonials and reviews (“Feedback”) on or about the Website/App or the Services, You acknowledge that you transfer all rights in such Feedback to us and that we will be free to use the same as we may find appropriate.",
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
                      Text("10. Breach of these Terms of Use",style: GoogleFonts.lato(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text("If you have, or we have reasonable grounds to believe that you have, violated these Terms of Use in any way, We can indefinitely suspend or terminate your access to the Website/App or Services at any time, forfeit any amounts paid by you and report such action to relevant authorities. We reserve the right to take recourse to all available remedies under applicable law in furtherance of the above.",
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
                      Text("11. Transactions",style: GoogleFonts.lato(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("The Website/App is a platform which enables Users to interact with Providers and any transactions between you and any Provider are strictly bi-partite. We are not and cannot be a party to, or control in any manner, any Transaction between you and any Provider. We shall not and are not required to mediate or resolve any disputes or disagreements between the you and any Provider.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("Accordingly, we will not be liable for any loss or damage incurred as the result of any such transaction. While interacting with any Provider found through the Website/App or through the Services, We strongly encourage you to exercise reasonable diligence as you would in traditional off line channels and practice judgment and common sense before committing to any Transaction or exchange of information.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),SizedBox(height: 10,),
                            Text("You understand that there is no guarantee of a satisfactory response or any response at all to your request for services of Providers.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("All screening procedures, verification services and background checks, whether undertaken by us or through third party consultants are performed on an “as is” and “as available” basis. By opting to avail of them you acknowledge that we will not be responsible for the quality or accuracy of the results of these procedures.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("Providers may obtain personal information about you due to your use of the Website/App or Services, and such Providers may use this information to harass or injure You. We do not approve of such acts, but by using the Services, you acknowledge that we are not responsible for the use of any personal information that you disclose or share with others through the use of the Services.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                          ],
                        ),
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
                      Text("12. Third Party Sites",style: GoogleFonts.lato(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text("All third party advertisements, hyperlinks or other redirection tools on the Website/App which take You to content operated by third parties are not controlled by us and do not form part of the Website/App. We are not liable for any loss or harm that occurs to you as a result of such sites.",
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
                      Text("13. Disclaimer and Limitation of Liability",style: GoogleFonts.lato(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("THE WEBSITE/APP AND SERVICES ARE PROVIDED ON AN “AS IS” AND “AS AVAILABLE” BASIS WITHOUT ANY REPRESENTATION OR WARRANTY, EXPRESS OR IMPLIED. WE DO NOT WARRANT THAT",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("The Website/App or the Services will be constantly available or available at all. We shall have no liability to you for any interruption or delay in access to the Website/App or Services availed through it, irrespective of the cause;",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("The information on the Website/App or given through Services is complete, true, accurate or non-misleading;",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),SizedBox(height: 10,),
                            Text("Any errors or defects in the Website/App or Services will be corrected;",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("That the Website/App is secure or free of viruses, Trojans or other malware; or",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("The contents of the Website/App or the Services do not infringe any intellectual property rights.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),SizedBox(height: 10,),
                            Text("IN NO EVENT SHALL WE BE LIABLE FOR ANY DIRECT, SPECIAL, PUNITIVE, INCIDENTAL, INDIRECT OR CONSEQUENTIAL DAMAGES INCLUDING BUT NOT LIMITED TO ANY LOSS OF PROFITS, REVENUE, BUSINESS OR DATA OF ANY KIND IN CONNECTION WITH THESE TERMS OF USE, EVEN IF YOU HAVE BEEN INFORMED IN ADVANCE OF THE POSSIBILITY OF SUCH DAMAGES.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                          ],
                        ),
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
                      Text("14. Privacy Policy",style: GoogleFonts.lato(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text("Any personal information you supply to us when you use this Website/App or the Services will be used in accordance with Our Privacy Policy.",
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
                      Text("15. Miscellaneous",style: GoogleFonts.lato(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Severability and Waiver , If any provisions of these Terms of Use are found to be invalid by any court having competent jurisdiction, the invalidity of such provision shall not affect the validity of the remaining provisions of these Terms of Use, which shall remain in full force and effect. No waiver of any term of these Terms of Use shall be deemed a further or continuing waiver of such term or any other term.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("Relationship between the Company and its Users , Use of the Website/App does not create any association, partnership, venture or relationship of principal and agent, master and servant or employer and employee between the user and the Company. Further, there is no relationship of principal and agent, master and servant or employer and employee between the Providers and the Company or the Contractor and the Company.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),SizedBox(height: 10,),
                            Text("Applicable Law and Dispute Resolution , These Terms of Use shall be governed by and interpreted and construed in accordance with the laws of India. Any disputes pertaining to the Website/App shall be subject to the exclusive jurisdiction of the appropriate courts in India.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                          ],
                        ),
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
                      Text("16. Grievance officer",style: GoogleFonts.lato(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("In accordance with the Information Technology Act, 2000 and rules made there under, the name and contact details of the Grievance Officer are provided below:",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("(Name of The Grievance Officer)",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("You may write to him at the following address:",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("HEAD OFFICE",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            Text("A-34/2,Ichhapore GIDC, HAZIRA ROAD, SURAT-394510",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            Text("+91 - 937 788 7251",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),SizedBox(height: 5,),
                            Text("OR",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),SizedBox(height: 5,),
                            Text("Email him at support@wellonwater.com",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                          ],
                        ),
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
                      Text("17. Contact Us",style: GoogleFonts.lato(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Please contact us for any questions or comments (including all inquiries related to copyright infringement) regarding this Website/App.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Text("This document is an electronic record under the Information Technology Act, 2000 and rules thereunder. This electronic record is generated by a computer system and does not require any physical or digital signatures.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),SizedBox(height: 10,),
                            Text("This document is published in accordance with the provisions of Rule 3 (1) of the Information Technology (Intermediaries Guidelines) Rules, 2011 that require publishing the rules and regulations, Privacy Policy and Terms of Use for access to or usage of this Website/App.",
                              style: GoogleFonts.lato(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w500),),
                          ],
                        ),
                      ),
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
              SizedBox(           height: 20,
              ),
            ],
          ),
        )
      );
    }
  }
}
