#!/usr/bin/env python3
import subprocess
import sys
from pathlib import Path

sql_path = Path(sys.argv[1])
sql = sql_path.read_text(encoding="utf-8")

cmd = ["mysql", "--socket=/tmp/mysql.sock", "-uroot", "-p12345678", "ontology", "-e", sql]
result = subprocess.run(cmd, text=True, capture_output=True)
if result.stdout:
    print(result.stdout)
if result.stderr:
    print(result.stderr, file=sys.stderr)
sys.exit(result.returncode)
