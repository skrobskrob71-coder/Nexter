import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final instance = DatabaseHelper._();
  Database? _database;

  Future<Database> get database async => _database ??= await _init();

  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'naxter.db');
    return openDatabase(path, version: 2, onCreate: (db, version) async {
      await _createTables(db);
    }, onUpgrade: (db, oldVersion, newVersion) async {
      await _createTables(db);
    });
  }

  Future<void> _createTables(Database db) async {
    await db.execute('CREATE TABLE IF NOT EXISTS customers(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT NOT NULL,phone TEXT DEFAULT \'\',address TEXT DEFAULT \'\',balance REAL NOT NULL DEFAULT 0,created_at TEXT NOT NULL)');
    await db.execute('CREATE TABLE IF NOT EXISTS products(id INTEGER PRIMARY KEY AUTOINCREMENT,barcode TEXT DEFAULT \'\',name TEXT NOT NULL,quantity REAL NOT NULL DEFAULT 0,purchase_price REAL NOT NULL DEFAULT 0,sale_price REAL NOT NULL DEFAULT 0,created_at TEXT NOT NULL)');
    await db.execute('CREATE TABLE IF NOT EXISTS invoices(id INTEGER PRIMARY KEY AUTOINCREMENT,number TEXT NOT NULL,customer_id INTEGER,customer_name TEXT DEFAULT \'نقدي\',subtotal REAL NOT NULL DEFAULT 0,tax REAL NOT NULL DEFAULT 0,total REAL NOT NULL DEFAULT 0,created_at TEXT NOT NULL)');
    await db.execute('CREATE TABLE IF NOT EXISTS invoice_items(id INTEGER PRIMARY KEY AUTOINCREMENT,invoice_id INTEGER NOT NULL,product_id INTEGER,product_name TEXT NOT NULL,quantity REAL NOT NULL,price REAL NOT NULL,total REAL NOT NULL)');
  }

  Future<List<Map<String, dynamic>>> all(String table, {String? where, List<Object?>? args}) async => (await database).query(table, where: where, whereArgs: args, orderBy: 'id DESC');
  Future<int> insert(String table, Map<String, dynamic> values) async => (await database).insert(table, values);
  Future<int> update(String table, Map<String, dynamic> values, int id) async => (await database).update(table, values, where: 'id = ?', whereArgs: [id]);
  Future<int> delete(String table, int id) async => (await database).delete(table, where: 'id = ?', whereArgs: [id]);

  Future<Map<String, num>> summary() async {
    final db = await database;
    final sales = await _scalar(db, 'SELECT COALESCE(SUM(total),0) FROM invoices');
    final customers = await _scalar(db, 'SELECT COUNT(*) FROM customers');
    final products = await _scalar(db, 'SELECT COUNT(*) FROM products');
    final profit = await _scalar(db, 'SELECT COALESCE(SUM(i.total - COALESCE((SELECT SUM(ii.quantity * p.purchase_price) FROM invoice_items ii LEFT JOIN products p ON p.id = ii.product_id WHERE ii.invoice_id = i.id),0)),0) FROM invoices i');
    return {'sales': sales, 'customers': customers, 'products': products, 'profit': profit};
  }

  Future<num> _scalar(Database db, String sql) async {
    final rows = await db.rawQuery(sql);
    return (rows.first.values.first as num?) ?? 0;
  }

  Future<List<double>> monthlySales() async {
    final db = await database;
    final now = DateTime.now();
    final values = <double>[];
    for (var i = 5; i >= 0; i--) {
      final start = DateTime(now.year, now.month - i, 1);
      final end = DateTime(start.year, start.month + 1, 1);
      final rows = await db.rawQuery('SELECT COALESCE(SUM(total),0) AS value FROM invoices WHERE created_at >= ? AND created_at < ?', [start.toIso8601String(), end.toIso8601String()]);
      values.add(((rows.first['value'] as num?) ?? 0).toDouble());
    }
    return values;
  }
}
