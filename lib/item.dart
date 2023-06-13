class Item {
  String? _itemname;
  String? _variety;
  double? _capacity;
  String? _uom2;
  double? _wholesalePrice;
  double? _retailPrice;
  double? _gsttaxper;

  Item(
      {String? itemname,
      String? variety,
      double? capacity,
      String? uom2,
      double? wholesalePrice,
      double? retailPrice,
      double? gsttaxper}) {
    if (itemname != null) {
      this._itemname = itemname;
    }
    if (variety != null) {
      this._variety = variety;
    }
    if (capacity != null) {
      this._capacity = capacity;
    }
    if (uom2 != null) {
      this._uom2 = uom2;
    }
    if (wholesalePrice != null) {
      this._wholesalePrice = wholesalePrice;
    }
    if (retailPrice != null) {
      this._retailPrice = retailPrice;
    }
    if (gsttaxper != null) {
      this._gsttaxper = gsttaxper;
    }
  }

  String? get itemname => _itemname;
  set itemname(String? itemname) => _itemname = itemname;
  String? get variety => _variety;
  set variety(String? variety) => _variety = variety;
  double? get capacity => _capacity;
  set capacity(double? capacity) => _capacity = capacity;
  String? get uom2 => _uom2;
  set uom2(String? uom2) => _uom2 = uom2;
  double? get wholesalePrice => _wholesalePrice;
  set wholesalePrice(double? wholesalePrice) => _wholesalePrice = wholesalePrice;
  double? get retailPrice => _retailPrice;
  set retailPrice(double? retailPrice) => _retailPrice = retailPrice;
  double? get gsttaxper => _gsttaxper;
  set gsttaxper(double? gsttaxper) => _gsttaxper = gsttaxper;

  Item.fromJson(Map<String, dynamic> json) {
    _itemname = json['itemname'];
    _variety = json['variety'];
    _capacity = json['capacity'];
    _uom2 = json['uom2'];
    _wholesalePrice = json['wholesale_price'];
    _retailPrice = json['retail_price'];
    _gsttaxper = json['gsttaxper'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemname'] = this._itemname;
    data['variety'] = this._variety;
    data['capacity'] = this._capacity;
    data['uom2'] = this._uom2;
    data['wholesale_price'] = this._wholesalePrice;
    data['retail_price'] = this._retailPrice;
    data['gsttaxper'] = this._gsttaxper;
    return data;
  }
}
