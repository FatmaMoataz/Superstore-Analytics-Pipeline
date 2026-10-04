# Superstore Analytics Pipeline

An end-to-end data pipeline that orchestrates a dbt warehouse build with Apache Airflow using the Astro CLI. It loads the Superstore Excel dataset into DuckDB, transforms it with dbt, and validates the resulting models.

## Pipeline

1. Airflow loads `Superstore.xlsx` into the DuckDB `ods.raw_superstore` table.
2. dbt runs its debug check.
3. dbt builds the staging views and analytics marts, then runs the configured data tests.

The DAG is named `superstore_dbt_pipeline` and is manually triggered. The dbt models create customer, product, date, and ship mode dimensions, plus a sales fact table.

## Project layout

```text
.
├── airflow/
│   ├── dags/superstore_pipeline.py   # Airflow orchestration DAG
│   ├── docker-compose.override.yml  # Mounts dbt and data into Astro containers
│   ├── Dockerfile
│   ├── requirements.txt
│   └── packages.txt
├── dbt/
│   ├── models/
│   │   ├── staging/                 # Cleaned source models
│   │   └── marts/                   # Dimensions and fact table
│   ├── profiles.yml                 # Local DuckDB profile
│   └── scripts_data/                # Source workbook and ODS loader
└── data/                            # Additional project data
```

## Requirements

- Docker Desktop with the Linux container engine running
- [Astro CLI](https://www.astronomer.io/docs/astro/cli/install-cli)
- Git

## Run locally

Open PowerShell at the repository root, then initialize the Astro project once and start Airflow:

```powershell
cd airflow
astro dev init
astro dev start
```

Astro starts the local Airflow services and opens the UI at <http://localhost:8080/>. In the Airflow UI, trigger `superstore_dbt_pipeline`.

To check DAG import errors or run the DAG from the command line:

```powershell
astro dev run dags list-import-errors
astro dev run dags test superstore_dbt_pipeline 2025-01-01
```

Astro manages the Docker Compose environment for this project. Run Astro commands from the `airflow/` directory; do not run `docker compose up` directly.

## Run dbt directly

The Airflow image installs the dependencies listed in `airflow/requirements.txt`. To run the loader and dbt from a local Python environment, install those requirements first, then:

```powershell
cd dbt
python scripts_data/scripts/load_to_ods.py
dbt build --profiles-dir .
```

The dbt profile reads the `DUCKDB_PATH` environment variable. If it is unset, dbt uses `dev.duckdb` in the current directory. The ODS loader defaults to `/tmp/dev.duckdb`, so set `DUCKDB_PATH` to the same database file before running both commands together.

## Data and outputs

The input workbook is `dbt/scripts_data/data/raw/Superstore.xlsx`. The pipeline stores the ODS source and dbt relations in DuckDB. The `dbt/models/staging/` models clean and type the source columns; `dbt/models/marts/` contains the dimensional model and schema tests.

## Troubleshooting

- If Astro reports that it cannot connect to Docker, start Docker Desktop and wait for its Linux engine to become ready, then retry the Astro command.
- If dbt cannot find `ods.raw_superstore`, check that the workbook path is correct and that the loader and dbt use the same `DUCKDB_PATH`.
- Run `astro dev logs` from `airflow/` to inspect local Airflow service logs.
