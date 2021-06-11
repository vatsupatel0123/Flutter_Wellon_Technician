import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellon_partner_app/data/rest_ds.dart';
import 'package:wellon_partner_app/models/cancel_lead_list.dart';
import 'package:wellon_partner_app/models/category_list.dart';
import 'package:wellon_partner_app/models/categoryproduct_list.dart';
import 'package:wellon_partner_app/models/complete_lead_list.dart';
import 'package:wellon_partner_app/models/new_lead_list.dart';
import 'package:wellon_partner_app/models/process_lead_list.dart';
import 'package:wellon_partner_app/utils/network_util.dart';

class LoadData with ChangeNotifier {
  static NetworkUtil _netUtil = new NetworkUtil();

  static Future<List<CategoryList>> categoryListdata;
  static Future<List<CategoryList>> categoryListdata1;

  static String total_credit_ledger, total_debit_ledger, total_balance_ledger,
      total_credit_normal,total_cart_items,
      total_debit_normal, total_balance_normal, total_pending, total_process,
      total_complete, total_cancel;
  static SharedPreferences prefs;

  static Future<List<NewLeadList>> newLeadListdata;
  static Future<List<NewLeadList>> newLeadListfilterData;

  static Future<List<ProcessLeadList>> processLeadListdata;
  static Future<List<ProcessLeadList>> processLeadListfilterData;

  static Future<List<CompleteLeadList>> completeLeadListdata;
  static Future<List<CompleteLeadList>> completeLeadListfilterData;

  static Future<List<CancelLeadList>> cancelLeadListdata;
  static Future<List<CancelLeadList>> cancelLeadListfilterData;

  static loadpref() async
  {
    prefs = await SharedPreferences.getInstance();
    //Load Category
    categoryListdata = _getCategoryData();
    //Load Category

    //Load PendingLeads
    newLeadListdata = _getNewLeadData();
    newLeadListfilterData = newLeadListdata;
    //Load PendingLeads

    // Load ProcessLeads
    processLeadListdata = _getProcessLeadData();
    processLeadListfilterData = processLeadListdata;
    //Load ProcessLeads

    //Load CompleteLeads
    completeLeadListdata = _getCompleteLeadData();
    completeLeadListfilterData = completeLeadListdata;
    //Load CompleteLeads

    // Load CancelLeads
    cancelLeadListdata = _getCencelLeadData();
    cancelLeadListfilterData = cancelLeadListdata;
    //Load CancelLeads

    //Load HomeScreen
    loadWalletamt();
    totalcartitems();
    //Load HomeScreen
  }

  static refreshcategory() async
  {
    categoryListdata = _getCategoryData();
  }

  static refreshpendinglead() async
  {
    newLeadListdata = _getNewLeadData();
    newLeadListfilterData = newLeadListdata;
  }

  static refreshprocesslead() async
  {
    processLeadListdata = _getProcessLeadData();
    processLeadListfilterData = processLeadListdata;
  }

  static refreshcompletelead() async
  {
    completeLeadListdata = _getCompleteLeadData();
    completeLeadListfilterData = completeLeadListdata;
  }

  static refreshcancellead() async
  {
    cancelLeadListdata = _getCencelLeadData();
    cancelLeadListfilterData = cancelLeadListdata;
  }

  static Future<List<CategoryList>> _getCategoryData() async
  {
    return _netUtil.post(RestDatasource.GET_CATEGORY).then((dynamic res) {
      if (res.toString() == "[]") {
        return null;
      }
      final items = res.cast<Map<String, dynamic>>();
      //print(items);
      List<CategoryList> listofusers = items.map<CategoryList>((json) {
        return CategoryList.fromJson(json);
      }).toList();
      List<CategoryList> revdata = listofusers.reversed.toList();
      return revdata;
    });
  }

  static Future<List<NewLeadList>> _getNewLeadData() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return _netUtil.post(RestDatasource.GET_NEW_ORDER,
        body: {
          "provider_id": prefs.getString("provider_id"),
        }).then((dynamic res) {
      final items = res.cast<Map<String, dynamic>>();
      List<NewLeadList> listofusers = items.map<NewLeadList>((json) {
        return NewLeadList.fromJson(json);
      }).toList();
      List<NewLeadList> revdata = listofusers.reversed.toList();
      return revdata;
    });
  }

  static Future<List<ProcessLeadList>> _getProcessLeadData() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return _netUtil.post(RestDatasource.GET_PROCCESS_ORDER,
        body: {
          "provider_id": prefs.getString("provider_id"),
        }).then((dynamic res) {
      if (res.toString() == "[]") {
        return null;
      }
      final items = res.cast<Map<String, dynamic>>();
      //print(items);
      List<ProcessLeadList> listofusers = items.map<ProcessLeadList>((json) {
        return ProcessLeadList.fromJson(json);
      }).toList();
      List<ProcessLeadList> revdata = listofusers.reversed.toList();
      return revdata;
    });
  }

  static Future<List<CompleteLeadList>> _getCompleteLeadData() async
  {
    prefs = await SharedPreferences.getInstance();
    return _netUtil.post(RestDatasource.GET_COMPLETE_ORDER,
        body: {
          "provider_id": prefs.getString("provider_id"),
        }).then((dynamic res) {
      if (res.toString() == "[]") {
        return null;
      }
      final items = res.cast<Map<String, dynamic>>();
      List<CompleteLeadList> listofusers = items.map<CompleteLeadList>((json) {
        return CompleteLeadList.fromJson(json);
      }).toList();
      List<CompleteLeadList> revdata = listofusers.reversed.toList();
      return revdata;
    });
  }

  static Future<List<CancelLeadList>> _getCencelLeadData() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return _netUtil.post(RestDatasource.GET_CANCEL_ORDER,
        body: {
          "provider_id": prefs.getString("provider_id"),
        }).then((dynamic res) {
      if (res.toString() == "[]") {
        return null;
      }
      final items = res.cast<Map<String, dynamic>>();
      List<CancelLeadList> listofusers = items.map<CancelLeadList>((json) {
        return CancelLeadList.fromJson(json);
      }).toList();
      List<CancelLeadList> revdata = listofusers.reversed.toList();
      return revdata;
    });
  }

  static loadWalletamt() async {
    prefs = await SharedPreferences.getInstance();
    return _netUtil.post(RestDatasource.HOME_COUNT_ORDER, body: {
      "provider_id": prefs.getString("provider_id"),
    }).then((dynamic res) async {
      //print(res);
      total_credit_ledger = res["total_credit_ledger"].toString();
      total_debit_ledger = res["total_debit_ledger"].toString();
      total_balance_ledger = res["total_balance_ledger"].toString();
      total_credit_normal = res["total_credit_normal"].toString();
      total_debit_normal = res["total_debit_normal"].toString();
      total_balance_normal = res["total_balance_normal"].toString();
      total_pending = res["total_pending"].toString();
      total_process = res["total_process"].toString();
      total_complete = res["total_complete"].toString();
      total_cancel = res["total_cancel"].toString();
    });
  }
  static totalcartitems() async {
    prefs = await SharedPreferences.getInstance();
    _netUtil.post(RestDatasource.GET_CART_LIST, body: {
      "provider_id": prefs.getString("provider_id")
    }).then((dynamic res) {
      total_cart_items=res["totalcartitem"].toString();
    });
  }
}