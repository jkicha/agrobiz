import 'package:flutter/material.dart';
import 'package:agrobiz/mysql_conn.dart';


class PricelistView extends StatefulWidget {
  const PricelistView({Key? key}) : super(key: key);

  @override
  State<PricelistView> createState() => _PricelistViewState();
}

class _PricelistViewState extends State<PricelistView> {
  // Books
  List PricelistList = [];

  // Sql Connection
  late var conn;

  // Db connect
  Future<void> connectToDB() async {
    conn = await DatabaseClient().databaseConnect();
    conn.connect();
  }

  Future<void> getPricelist() async {
    var results = await conn.query("SELECT itemname, variety, capacity, uom2, sellprice1, sellprice2, gsttaxper FROM item;");

    for (var row in results) {
      setState(() {
        PricelistList.add(row[0]);
      });
    }
  }

  @override
  void initState() {
    connectToDB();
    // getPricelist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
              floatingActionButton: FloatingActionButton(
          onPressed: () {
            getPricelist();
          },
        ),
      body: ListView.builder(  
          itemCount: PricelistList.length,  
          itemBuilder: (context, index) {  
            return ListTile(  
              title: Text('${PricelistList[index]}'),  
            );}),  
    );
  }
}