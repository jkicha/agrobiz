import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:agrobiz/item.dart';
import 'package:agrobiz/mysql_conn.dart';
import 'package:agrobiz/main.dart';

import 'package:flutter_web_data_table/web_data_table.dart';

class PricelistView extends StatefulWidget {
  const PricelistView({Key? key}) : super(key: key);

  @override
  State<PricelistView> createState() => _PricelistViewState();
}

class _PricelistViewState extends State<PricelistView> {
  late String _sortColumnName;
  late bool _sortAscending;
  List<String>? _filterTexts;
  bool _willSearch = true;
  Timer? _timer;
  int? _latestTick;

  // Books
  List<Map<String, dynamic>> priceMapList = [];

  // Sql Connection
  late var conn;

  Future<void> getPricelist() async {
    conn = await DatabaseClient().databaseConnect();
    var results = await conn.query(
        "SELECT itemname, variety, capacity, uom2, sellprice1, sellprice2, gsttaxper FROM item;");

    for (var row in results) {
      var retailPrice = row[5] * (1 + row[6] / 100);
      var wholesalePrice = row[4] * (1 + row[6] / 100);
      var uom = row[2].toString() + ' ' + row[3];

      priceMapList.add({
        "itemname": row[0],
        "variety": row[1],
        "packing": uom,
        "sellprice1": wholesalePrice,
        "sellprice2": retailPrice,
        "gsttaxper": row[6]
      });
      // Item item = Item();
      // item.itemname = row[0];
      // item.variety = row[1];
      // item.capacity = row[2];
      // item.uom2 = row[3];
      // item.wholesalePrice = row[4];
      // item.retailPrice = row[5];
      // item.gsttaxper = row[6];
      // priceList.add(item);
    }
    setState(() {});
  }

  @override
  void initState() {
    getPricelist();
    super.initState();

    _sortColumnName = 'itemname';
    _sortAscending = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_willSearch) {
        if (_latestTick != null && timer.tick > _latestTick!) {
          _willSearch = true;
        }
      }
      if (_willSearch) {
        _willSearch = false;
        _latestTick = null;
        setState(() {
          if (_filterTexts != null && _filterTexts!.isNotEmpty) {
            _filterTexts = _filterTexts;
            // print('filterTexts = $_filterTexts');
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        route: '/pricelistview',
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: WebDataTable(
              header: Text('Price List'),
              actions: [
                Container(
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'increment search...',
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFCCCCCC),
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFCCCCCC),
                        ),
                      ),
                    ),
                    onChanged: (text) {
                      _filterTexts = text.trim().split(' ');
                      _willSearch = false;
                      _latestTick = _timer?.tick;
                    },
                  ),
                ),
              ],
              source: WebDataTableSource(
                sortColumnName: _sortColumnName,
                sortAscending: _sortAscending,
                filterTexts: _filterTexts,
                columns: [
                  WebDataColumn(
                    name: 'itemname',
                    label: const Text('Prodcut Name'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                  WebDataColumn(
                    name: 'variety',
                    label: const Text('Variety'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                  WebDataColumn(
                    name: 'packing',
                    sortable: false,
                    label: const Text('Packing'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                  WebDataColumn(
                    name: 'sellprice1',
                    sortable: false,
                    label: const Text('Wholesale Price'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                  WebDataColumn(
                    name: 'sellprice2',
                    sortable: false,
                    label: const Text('Retail Price'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                ],
                rows: priceMapList,
                primaryKeyName: 'itemname',
              ),
              horizontalMargin: 100,
              onSort: (columnName, ascending) {
                setState(() {
                  _sortColumnName = columnName;
                  _sortAscending = ascending;
                });
              },
            ),
          ),
        ));
  }
}
