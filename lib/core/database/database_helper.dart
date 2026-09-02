import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final instance = DatabaseHelper._();
  Database? _database;
  Future<Database> get database async => _database ??= await _init();
  Future<Database> _init() async => openDatabase(join(await getDatabasesPath(), 'naxter.db'), version: 1, onCreate: (db, _) async {
    await db.execute('CREATE TABLE customers(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT NOT NULL,phone TEXT,address TEXT,balance REAL NOT NULL DEFAULT 0,created_at TEXT NOT NULL)');
    await db.execute('CREATE TABLE products(id INTEGER PRIMARY KEY AUTOINCREMENT,barcode TEXT,name TEXT NOT NULL,quantity REAL NOT NULL DEFAULT 0,purchase_price REAL NOT NULL DEFAULT 0,sale_price REAL NOT NULL DEFAULT 0,created_at TEXT NOT NULL)');
    await db.execute('CREATE TABLE invoices(id INTEGER PRIMARY KEY AUTOINCREMENT,number TEXT NOT NULL,customer_id INTEGER,customer_name TEXT,subtotal REAL NOT NULL,tax REAL NOT NULL,total REAL NOT NULL,created_at TEXT NOT NULL)');
    await db.execute('CREATE TABLE invoice_items(id INTEGER PRIMARY KEY AUTOINCREMENT,invoice_id INTEGER NOT NULL,product_id INTEGER,product_name TEXT NOT NULL,quantity REAL NOT NULL,price REAL NOT NULL,total REAL NOT NULL)');
  });
  Future<List<Map<String,dynamic>>> all(String table,{String? where,List<Object?>? args}) async => (await database).query(table,where:where,whereArgs:args,orderBy:'id DESC');
  Future<int> insert(String table,Map<String,dynamic> values) async => (await database).insert(table,values);
  Future<int> update(String table,Map<String,dynamic> values,int id) async => (await database).update(table,values,where:'id=?',whereArgs:[id]);
  Future<int> delete(String table,int id) async => (await database).delete(table,where:'id=?',whereArgs:[id]);
  Future<Map<String,num>> summary() async { final db=await database; final sales=((await db.rawQuery('SELECT COALESCE(SUM(total),0) v FROM invoices')).first['v'] as num); final customers=((await db.rawQuery('SELECT COUNT(*) v FROM customers')).first['v'] as num); final purchases=((await db.rawQuery('SELECT COALESCE(SUM(total),0) v FROM invoices WHERE customer_name LIKE "مورد%"')).first['v'] as num); return {'sales':sales,'customers':customers,'purchases':purchases,'profit':sales-purchases}; }
  Future<List<double>> monthlySales() async { final db=await database; final now=DateTime.now(); final result=<double>[]; for(int i=5;i>=0;i--){ final start=DateTime(now.year,now.month-i,1); final end=DateTime(start.year,start.month+1,1); final rows=await db.rawQuery('SELECT COALESCE(SUM(total),0) v FROM invoices WHERE created_at >= ? AND created_at < ?', [start.toIso8601String(),end.toIso8601String()]); result.add((rows.first['v'] as num).toDouble()); } return result; }
}
