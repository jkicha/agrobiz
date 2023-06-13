import 'package:mysql1/mysql1.dart';
import 'dart:async';


class DatabaseClient  {
  Future databaseConnect() async {
    // Open a connection (testdb should already exist)
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
        db: 'jsl2',
        password: 'Password1!'));
    return conn;
  }
}

