class User {
  String _first_name;
  String _mobile_numbers;


  User(this._first_name, this._mobile_numbers);


  User.map(dynamic obj) {
    this._first_name = obj["first_name"];
    this._mobile_numbers = obj["mobile_numbers"];
  }



  String get first_name => _first_name;
  String get mobile_numbers => _mobile_numbers;


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["first_name"] = _first_name;
    map["mobile_numbers"] = _mobile_numbers;
    return map;
  }
}