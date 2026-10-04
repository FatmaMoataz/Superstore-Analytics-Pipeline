"""Load the Superstore source into DuckDB, then build and test dbt models."""

from datetime import datetime

from airflow.sdk import DAG
from airflow.providers.standard.operators.bash import BashOperator


PROJECT_DIR = "/opt/airflow/project"

with DAG(
    dag_id="superstore_dbt_pipeline",
    description="Load Superstore.xlsx into DuckDB and build the dbt warehouse",
    start_date=datetime(2025, 1, 1),
    schedule=None,
    catchup=False,
    tags=["superstore", "duckdb", "dbt"],
) as dag:
    load_superstore_to_ods = BashOperator(
    task_id="load_superstore_to_ods",
    bash_command="python /opt/airflow/project/dbt/scripts_data/scripts/load_to_ods.py",
    )

    dbt_debug = BashOperator(
    task_id="dbt_debug",
    bash_command=(
        "cd /opt/airflow/project/dbt && "
        "dbt debug --profiles-dir . --log-path /tmp/dbt_logs"
    ),
  )

    dbt_build = BashOperator(
    task_id="dbt_build",
    bash_command=(
        "cd /opt/airflow/project/dbt && "
        "dbt build --profiles-dir . "
        "--target-path /tmp/dbt_target --log-path /tmp/dbt_logs"
    ),
   )

    load_superstore_to_ods >> dbt_debug >> dbt_build
