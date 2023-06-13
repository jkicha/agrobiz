import 'package:flutter/material.dart';
import 'package:agrobiz/item.dart';
import 'package:agrobiz/mysql_conn.dart';

class PricelistView extends StatefulWidget {
  const PricelistView({Key? key}) : super(key: key);

  @override
  State<PricelistView> createState() => _PricelistViewState();
}

class _PricelistViewState extends State<PricelistView> {
  // Books
  List<Item> priceList = [];

  // Sql Connection
  late var conn;

  // Db connect
  Future<void> connectToDB() async {
    conn = await DatabaseClient().databaseConnect();
    conn.connect();
  }

  Future<List<Item>> getPricelist() async {
    var results = await conn.query(
        "SELECT itemname, variety, capacity, uom2, sellprice1, sellprice2, gsttaxper FROM item;");

    for (var row in results) {
      setState(() {
        Item item = Item();
        item.itemname = row[0];
        item.variety = row[1];
        item.capacity = row[2];
        item.uom2 = row[3];
        item.wholesalePrice = row[4];
        item.retailPrice = row[5];
        item.gsttaxper = row[6];
        priceList.add(item);
      });
    }
      return priceList;
  }

  @override
  void initState() {
    connectToDB();
    getPricelist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {
            getPricelist();
          },
          // controller: searchController,
          // decoration: const InputDecoration(
          //   hintText: 'Search...',
          //   border: OutlineInputBorder(),
          // ),
          // onChanged: _onSearchTextChanged,
        ),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text('Name'),
            ),
            DataColumn(
              label: Text('Age'),
              numeric: true,
            ),
            DataColumn(
              label: Text('Role'),
            ),
          ],
          rows: List.generate(priceList.length, (index) {
            Item? item = priceList[index];
              return DataRow(
                cells: [
                  DataCell(Text(item.itemname!)),
                  DataCell(Text(item.variety!)),
                  DataCell(Text(item.retailPrice.toString()) ),
                ],
              );
            }
          ),
        ),
      ),
    ]);
  }
}

// return Column(children: [
//     child: FloatingActionButton(
//       onPressed: () {
//         getPricelist();
//       },
//     ),
//     SizedBox(child: ,)
//   ],
// );

// body: ListView.builder(
//     itemCount: PricelistList.length,
//     itemBuilder: (context, index) {
//       return ListTile(
//         title: Text('${PricelistList[index].itemname}'),
//       );}),
