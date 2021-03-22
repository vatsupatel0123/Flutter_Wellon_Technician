import 'dart:async';
import 'dart:io' as io;
import 'package:sqflite/sqlite_api.dart';
import 'package:wellon_partner_app/models/product_cart_list.dart';
import 'package:wellon_partner_app/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }


  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY, first_name TEXT, mobile_numbers TEXT)");
    print("Created tables");
    final String CREATE_CART_TABLE = "CREATE TABLE AddToCart("
        "TableId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "category_id TEXT, "
        "cproduct_id TEXT, "
        "productname TEXT, "
        "productprice TEXT,"
        "qty INTEGER,"
        "minmum_qua INTEGER,"
        "image1 TEXT)";
    await db.execute(CREATE_CART_TABLE);

  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toMap());
    return res;
  }

  Future<int> saveCart(ProductCartList cartList) async {
    var dbClient = await db;
    int res = await dbClient.insert("AddToCart", cartList.toMap());
    return res;
  }

  Future<int> deleteCartSingle(int id) async {
    var dbData = await db;
    var res = await dbData.delete("AddToCart", where: 'TableId = ?', whereArgs: [id]);
    return res;
  }
  Future<int> deleteCart() async {
    var dbData = await db;
    var res = await dbData.delete("AddToCart");
    return res;
  }
  Future<List<ProductCartList>> getcart() async {
    var dbData = await db;
    var res = await dbData.query("AddToCart");
    List<ProductCartList> list = res.isNotEmpty ? res.map((c) => ProductCartList.fromMap(c)).toList() : null;
    return list;
  }
  Future<bool> CheckProductInCart(String id) async {
    var dbData = await db;
    var res = await dbData.query('AddToCart',where: 'cproduct_id = ?',whereArgs: [id]);
    return res.length > 0? true: false;
  }
  Future<int> getCountCart() async {
    var dbData = await db;
    var x = await dbData.query('AddToCart');
    int count = x.length;
    return count;
  }

  Future<int> deleteUsers() async {
    var dbClient = await db;
    int res = await dbClient.delete("User");
    return res;
  }

  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var res = await dbClient.query("User");
    return res.length > 0? true: false;
  }

}