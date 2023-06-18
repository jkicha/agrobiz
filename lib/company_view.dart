import 'dart:async';

import 'package:flutter/material.dart';
import 'package:agrobiz/mysql_conn.dart';
import 'package:agrobiz/main.dart';

import 'package:flutter_web_data_table/web_data_table.dart';

class CompanyView extends StatefulWidget {
  const CompanyView({Key? key}) : super(key: key);

  @override
  State<CompanyView> createState() => _CompanyViewState();
}

class _CompanyViewState extends State<CompanyView> {
  late String _sortColumnName;
  late bool _sortAscending;
  List<String>? _filterTexts;
  bool _willSearch = true;
  Timer? _timer;
  int? _latestTick;

  List<Map<String, dynamic>> companyMapList = [];
  // Sql Connection
  late var conn;

  Future<void> getCompany() async {
    // connectToDB();
    conn = await DatabaseClient().databaseConnect();
    var results = await conn.query("SELECT companyname FROM company;");
    for (var row in results) {
      companyMapList.add({"companyName": row[0]});
    }
    setState(() {});
  }

  @override
  void initState() {
    getCompany();
    super.initState();

    _sortColumnName = 'companyName';
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
            print('filterTexts = $_filterTexts');
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
        route: '/companyview',
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: WebDataTable(
              header: Text('Company'),
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
                    name: 'companyName',
                    label: const Text('Company Name'),
                    dataCell: (value) => DataCell(Text('$value')),
                  ),
                ],
                rows: companyMapList,
                primaryKeyName: 'companyName',
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
