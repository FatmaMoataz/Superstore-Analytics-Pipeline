import os
from pathlib import Path

import duckdb
import pandas as pd

PROJECT_ROOT = Path(__file__).resolve().parents[2]

DB_PATH = Path(os.getenv("DUCKDB_PATH", "/tmp/dev.duckdb"))
DB_PATH.parent.mkdir(parents=True, exist_ok=True)

RAW_PATH = PROJECT_ROOT / "scripts_data" / "data" / "raw"

tables = {
    "raw_superstore": RAW_PATH / "Superstore.xlsx",
}

con = duckdb.connect(str(DB_PATH))

con.execute("CREATE SCHEMA IF NOT EXISTS ods")

for table_name, xlsx_path in tables.items():
    frame = pd.read_excel(xlsx_path)
    con.register("source_frame", frame)
    con.execute(f"CREATE OR REPLACE TABLE ods.{table_name} AS SELECT * FROM source_frame")
    con.unregister("source_frame")

    count = con.execute(f"SELECT COUNT(*) FROM ods.{table_name}").fetchone()[0]
    print(f"Loaded ods.{table_name}: {count} rows")

con.close()

print("ODS load complete")