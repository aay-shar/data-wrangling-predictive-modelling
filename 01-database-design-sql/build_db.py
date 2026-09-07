"""
Rebuild assignment.db from schema_and_queries.sql.

The notebook expects a populated SQLite database. The database file itself is not
committed, since it is fully reproducible from the SQL script.

Usage:
    python build_db.py
"""

import re
import sqlite3
from pathlib import Path

HERE = Path(__file__).parent
SQL_FILE = HERE / "schema_and_queries.sql"
DB_FILE = HERE / "assignment.db"


def strip_comments(sql_text: str) -> str:
    sql_text = re.sub(r"/\*.*?\*/", "", sql_text, flags=re.DOTALL)
    sql_text = re.sub(r"--[^\n]*", "", sql_text)
    return sql_text


def ddl_and_inserts(sql_text: str) -> str:
    """Keep CREATE TABLE and INSERT statements, drop the reporting SELECT queries."""
    statements = [s.strip() for s in strip_comments(sql_text).split(";")]
    keep = [s for s in statements if re.match(r"^(CREATE|INSERT)\b", s, re.IGNORECASE)]
    return ";\n".join(keep) + ";"


def main() -> None:
    if DB_FILE.exists():
        DB_FILE.unlink()

    script = ddl_and_inserts(SQL_FILE.read_text(encoding="utf-8-sig"))

    conn = sqlite3.connect(DB_FILE)
    conn.execute("PRAGMA foreign_keys = ON;")
    conn.executescript(script)
    conn.commit()

    tables = conn.execute(
        "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
    ).fetchall()

    print(f"Created {DB_FILE.name}")
    for (name,) in tables:
        count = conn.execute(f"SELECT COUNT(*) FROM {name}").fetchone()[0]
        print(f"  {name:<24} {count:>4} rows")

    conn.close()


if __name__ == "__main__":
    main()
