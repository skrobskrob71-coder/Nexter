import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final instance = DatabaseHelper._();
  Database? _db;
  Future<Database> get database async => _db ??= await _open();

  Future<Database> _open() async {
    final file = join(await getDatabasesPath(), 'nakster_pro_v2.db');
    return openDatabase(file, version: 1, onCreate: (db, version) async {
      await db.execute('CREATE TABLE products(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT NOT NULL,barcode TEXT DEFAULT \'\',price REAL DEFAULT 0,cost REAL DEFAULT 0,quantity REAL DEFAULT 0,type TEXT DEFAULT \'عادي\',unit TEXT DEFAULT \'قطعة\',serial TEXT DEFAULT \'\',expiry TEXT DEFAULT \'\',image TEXT DEFAULT \'\',purchase_price REAL DEFAULT 0,sale_price REAL DEFAULT 0,created_at TEXT DEFAULT \'\')');
      await db.execute('CREATE TABLE customers(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT NOT NULL,phone TEXT DEFAULT \'\',balance REAL DEFAULT 0,address TEXT DEFAULT \'\',created_at TEXT DEFAULT \'\')');
      await db.execute('CREATE TABLE invoices(id INTEGER PRIMARY KEY AUTOINCREMENT,inv_no TEXT,number TEXT,date TEXT NOT NULL,customer_id INTEGER,customer_name TEXT,total REAL DEFAULT 0,subtotal REAL DEFAULT 0,discount REAL DEFAULT 0,tax REAL DEFAULT 0,paid REAL DEFAULT 0,due REAL DEFAULT 0,payment_method TEXT DEFAULT \'كاش\',notes TEXT DEFAULT \'\')');
      await db.execute('CREATE TABLE invoice_items(id INTEGER PRIMARY KEY AUTOINCREMENT,invoice_id INTEGER NOT NULL,product_id INTEGER,qty REAL DEFAULT 1,quantity REAL DEFAULT 1,price REAL DEFAULT 0,discount REAL DEFAULT 0,total REAL DEFAULT 0,product_name TEXT DEFAULT \'\')');
      await db.execute('CREATE TABLE payments(id INTEGER PRIMARY KEY AUTOINCREMENT,invoice_id INTEGER,amount REAL DEFAULT 0,method TEXT,date TEXT)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_invoices_date ON invoices(date)');
      await db.execute('CREATE TABLE expenses(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,amount REAL DEFAULT 0,date TEXT,category TEXT)');
      await db.execute('CREATE TABLE journal(id INTEGER PRIMARY KEY AUTOINCREMENT,date TEXT,account_debit TEXT,account_credit TEXT,amount REAL DEFAULT 0,description TEXT,ref_id INTEGER)');
      await db.execute('CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,role TEXT,username TEXT UNIQUE,password TEXT)');
      await db.insert('users', {'name':'مدير النظام','role':'مدير','username':'admin','password':'1234'});
    });
  }
  Future<List<Map<String,dynamic>>> query(String table,{String? where,List<Object?>? args}) async => (await database).query(table,where:where,whereArgs:args,orderBy:'id DESC');
  Future<int> insert(String table,Map<String,dynamic> data) async => (await database).insert(table,data);
  Future<int> update(String table,Map<String,dynamic> data,int id) async => (await database).update(table,data,where:'id=?',whereArgs:[id]);
  Future<int> delete(String table,int id) async => (await database).delete(table,where:'id=?',whereArgs:[id]);
  Future<num> scalar(String sql,[List<Object?> args=const[]]) async { final rows=await (await database).rawQuery(sql,args); return (rows.first.values.first as num?)??0; }
  Future<Map<String,num>> dashboard() async => {'sales':await scalar('SELECT COALESCE(SUM(total),0) FROM invoices WHERE date >= date(\'now\',\'start of day\')'),'profit':await scalar('SELECT COALESCE(SUM(total),0) FROM invoices')-await scalar('SELECT COALESCE(SUM(amount),0) FROM expenses'),'products':await scalar('SELECT COUNT(*) FROM products'),'customers':await scalar('SELECT COUNT(*) FROM customers'),'invoices':await scalar('SELECT COUNT(*) FROM invoices')};
  Future<Map<String,num>> summary() => dashboard();
  Future<List<double>> monthlySales() => chart();
  Future<List<double>> chart() async { final result=<double>[]; final now=DateTime.now(); for(var i=5;i>=0;i--){final start=DateTime(now.year,now.month-i,1).toIso8601String();final end=DateTime(now.year,now.month-i+1,1).toIso8601String();result.add((await scalar('SELECT COALESCE(SUM(total),0) FROM invoices WHERE date>=? AND date<?',[start,end])).toDouble());}return result; }
  Future<void> seedDemo() async { final db=await database; for(var i=1;i<=20;i++){await db.insert('products',{'name':'منتج تجريبي $i','barcode':'628000000${i.toString().padLeft(2,'0')}','price':i*12.5,'cost':i*8.0,'quantity':i*3,'type':i%4==0?'وزن': 'عادي','unit':i%4==0?'كجم':'قطعة'});} for(var i=1;i<=5;i++){await db.insert('customers',{'name':'عميل تجريبي $i','phone':'050000000$i','balance':0,'address':'الرياض'});} for(var i=1;i<=10;i++){final total=i*125.0;final id=await db.insert('invoices',{'inv_no':'DEMO-$i','date':DateTime.now().subtract(Duration(days:i)).toIso8601String(),'customer_id':i%5+1,'total':total,'discount':0,'tax':total*.15,'paid':total,'due':0,'payment_method':'كاش','notes':'بيانات تجريبية'});await db.insert('invoice_items',{'invoice_id':id,'product_id':i,'qty':1,'price':total,'discount':0,'total':total});} }
}
