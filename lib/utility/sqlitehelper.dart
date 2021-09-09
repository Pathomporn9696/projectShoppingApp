import 'package:shoppingproject/models/order_sqlite_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHelper {
  final String namedatabase = 'shopping.db';
  final int version = 1;
  final String tabledatabase = 'orderTABLE';
  final String colId = 'id';
  final String colUidShop = 'uidshop';
  final String colNameShop = 'nameshop';
  final String colNameProduct = 'nameproduct';
  final String colPrice = 'price';
  final String colAmount = 'amount';
  final String colSum = 'sum';

  SQLiteHelper() {
    initDatabase();
  }

  Future<Null> initDatabase() async {
    await openDatabase(join(await getDatabasesPath(), namedatabase),
        onCreate: (db, version) => db.execute(
            'CREATE TABLE $tabledatabase ($colId INTEGER PRIMARY KEY, $colUidShop TEXT, $colNameShop TEXT, $colNameProduct TEXT, $colPrice TEXT, $colAmount TEXT, $colSum TEXT)'),
        version: version);
  }

  Future<Database> connectedDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), namedatabase));
  }

  Future<Null> insertData(OrderSQLiteModel model) async {
    Database database = await connectedDatabase();
    try {
      database
          .insert(tabledatabase, model.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace)
          .then((value) =>
              print('success add Sqlite at nameproduct= ${model.nameproduct}'));
    } catch (e) {}
  }

  Future<List<OrderSQLiteModel>> readData()async{
    Database database = await connectedDatabase();
    List<OrderSQLiteModel> models = [];
    List<Map<String, dynamic>> maps = await database.query(tabledatabase);
    for (var item in maps) {
      OrderSQLiteModel model = OrderSQLiteModel.fromMap(item);
      models.add(model);
    }
    return models;
  }

  Future<Null> deleteDataWhereId(int? id)async{
    Database database = await connectedDatabase();
    try {
      await database.delete(tabledatabase, where: '$colId = $id');
    } catch (e) {
    }
  }

}
