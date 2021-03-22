import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonHelper {

  static CommonHelper _instance = new CommonHelper.internal();
  CommonHelper.internal();
  factory CommonHelper() => _instance;

  String checkStringNullOrBlank(String value,String dispdata)
  {
    return (value == null || value  == "") ? dispdata : value;
  }

  String checkTwoValueBlank(String valueone,String valuetwo)
  {
    String value = "-";
    if(valueone != null && valueone != "") {
      value = valueone;
    }
    if(valuetwo != null && valuetwo != ""){
      if(valueone != null && valueone != "") {
        value += ", " + valuetwo;

      }else{
        value = valuetwo;
      }
    }
    return value;
  }

  void launchMapsUrl(double lat, double lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void launchCaller(String contact) async {
    var url = "tel:"+contact;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  void launchEmail(String email) async {
    var url = "mailto:"+email+"?subject=Inquiry&body=Hi,";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String convertDesimalFormat(var value,String pattern)
  {
    var format = new NumberFormat(pattern, "en_US");
    return format.format(value);
  }

  String getCurrentDate()
  {
    String _currYear = new DateFormat.y().format(new DateTime.now());
    return _currYear;
  }

  void getWebSiteUrl(String url) async
  {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

}