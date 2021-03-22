class ProductCartList {
  int TableId;
  String category_id;
  String cproduct_id;
  String productname;
  String productprice;
  String image1;
  int qty;
  int minmum_qua;

  ProductCartList({
    this.TableId,
    this.category_id,
    this.cproduct_id,
    this.productname,
    this.productprice,
    this.image1,
    this.qty,
    this.minmum_qua,
  });

  factory ProductCartList.fromMap(Map<String, dynamic> json) => new ProductCartList(
    TableId : json["TableId"],
    category_id : json["category_id"],
    cproduct_id : json["cproduct_id"],
    productname : json["productname"],
    productprice : json["productprice"],
    image1 : json["image1"],
    qty : json["qty"],
    minmum_qua : json["minmum_qua"],
  );

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["TableId"] = TableId;
    map["category_id"] = category_id;
    map["cproduct_id"] = cproduct_id;
    map["productname"] = productname;
    map["productprice"] = productprice;
    map["image1"] = image1;
    map["qty"] = qty;
    map["minmum_qua"] = minmum_qua;
    return map;
  }
}