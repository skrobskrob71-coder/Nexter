"""طبقة الوصول إلى SQLite مع مخطط قابل للتوسع واستعلامات آمنة."""
import sqlite3
from contextlib import contextmanager
from datetime import date
from pathlib import Path

class Database:
    def __init__(self, path: str):
        self.path = Path(path)
        self.path.parent.mkdir(parents=True, exist_ok=True)
        self.conn = sqlite3.connect(str(self.path), check_same_thread=False)
        self.conn.row_factory = sqlite3.Row
        self.conn.execute("PRAGMA foreign_keys = ON")
        self.conn.execute("PRAGMA journal_mode = WAL")

    @contextmanager
    def transaction(self):
        try:
            yield self.conn
            self.conn.commit()
        except Exception:
            self.conn.rollback()
            raise

    def initialize(self):
        schema = """
        CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, name TEXT NOT NULL, pin_hash TEXT, created_at TEXT DEFAULT CURRENT_TIMESTAMP);
        CREATE TABLE IF NOT EXISTS products (id INTEGER PRIMARY KEY, name TEXT NOT NULL, sku TEXT UNIQUE, barcode TEXT, unit TEXT DEFAULT 'قطعة', purchase_price REAL DEFAULT 0, sale_price REAL DEFAULT 0, quantity REAL DEFAULT 0, min_quantity REAL DEFAULT 0, tax_rate REAL DEFAULT 15, active INTEGER DEFAULT 1, created_at TEXT DEFAULT CURRENT_TIMESTAMP);
        CREATE TABLE IF NOT EXISTS customers (id INTEGER PRIMARY KEY, name TEXT NOT NULL, phone TEXT, email TEXT, address TEXT, tax_number TEXT, opening_balance REAL DEFAULT 0, kind TEXT DEFAULT 'customer', created_at TEXT DEFAULT CURRENT_TIMESTAMP);
        CREATE TABLE IF NOT EXISTS invoices (id INTEGER PRIMARY KEY, number TEXT UNIQUE NOT NULL, partner_id INTEGER, kind TEXT DEFAULT 'sale', status TEXT DEFAULT 'paid', subtotal REAL DEFAULT 0, tax REAL DEFAULT 0, discount REAL DEFAULT 0, total REAL DEFAULT 0, paid REAL DEFAULT 0, notes TEXT, issued_at TEXT NOT NULL, FOREIGN KEY(partner_id) REFERENCES customers(id));
        CREATE TABLE IF NOT EXISTS invoice_items (id INTEGER PRIMARY KEY, invoice_id INTEGER NOT NULL, product_id INTEGER, description TEXT NOT NULL, quantity REAL NOT NULL, unit_price REAL NOT NULL, tax_rate REAL DEFAULT 15, line_total REAL NOT NULL, FOREIGN KEY(invoice_id) REFERENCES invoices(id) ON DELETE CASCADE, FOREIGN KEY(product_id) REFERENCES products(id));
        CREATE TABLE IF NOT EXISTS expenses (id INTEGER PRIMARY KEY, category TEXT NOT NULL, description TEXT, amount REAL NOT NULL, tax REAL DEFAULT 0, spent_at TEXT NOT NULL, created_at TEXT DEFAULT CURRENT_TIMESTAMP);
        CREATE INDEX IF NOT EXISTS idx_invoices_date ON invoices(issued_at); CREATE INDEX IF NOT EXISTS idx_items_invoice ON invoice_items(invoice_id); CREATE INDEX IF NOT EXISTS idx_products_barcode ON products(barcode);
        """
        with self.transaction() as c:
            c.executescript(schema)
            c.execute("INSERT OR IGNORE INTO users(id,name) VALUES(1,?)", ("المستخدم الرئيسي",))

    def query(self, sql, params=()):
        return self.conn.execute(sql, params).fetchall()

    def one(self, sql, params=()):
        return self.conn.execute(sql, params).fetchone()

    def execute(self, sql, params=()):
        with self.transaction() as c:
            cur = c.execute(sql, params)
            return cur.lastrowid

    def dashboard(self, day=None):
        day = day or date.today().isoformat()
        sales = self.one("SELECT COALESCE(SUM(total),0) v FROM invoices WHERE kind='sale' AND substr(issued_at,1,10)=?", (day,))["v"]
        expenses = self.one("SELECT COALESCE(SUM(amount),0) v FROM expenses WHERE substr(spent_at,1,10)=?", (day,))["v"]
        count = self.one("SELECT COUNT(*) v FROM invoices WHERE kind='sale' AND substr(issued_at,1,10)=?", (day,))["v"]
        best = self.query("SELECT COALESCE(c.name,'نقدي') name, SUM(i.total) total FROM invoices i LEFT JOIN customers c ON c.id=i.partner_id WHERE i.kind='sale' GROUP BY i.partner_id ORDER BY total DESC LIMIT 5")
        return {"sales": sales, "expenses": expenses, "profit": sales-expenses, "count": count, "best": best}

    def close(self):
        self.conn.close()
