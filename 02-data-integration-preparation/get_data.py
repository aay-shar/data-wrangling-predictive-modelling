"""
Download the datasets used in Assignment 2.

The notebook reads these CSVs from its own directory, so they are written here
rather than into a shared data folder. They are excluded from version control
via .gitignore.

Two of the five files need manual steps and are reported at the end:

  diabetes.csv
      Pima Indians Diabetes Database. Requires a Kaggle account.
      https://www.kaggle.com/datasets/uciml/pima-indians-diabetes-database
      Download, unzip, and place diabetes.csv in this directory.

  ACM.csv / DBLP2.csv / DBLP-ACM_perfectMapping.csv
      DBLP-ACM entity resolution benchmark from the Leipzig DB group,
      released under CC BY 4.0. Fetched automatically below. Source page:
      https://dbs.uni-leipzig.de/research/projects/benchmark-datasets-for-entity-resolution

Usage:
    python get_data.py
"""

import io
import sys
import zipfile
from pathlib import Path
from urllib.request import urlopen, Request

HERE = Path(__file__).parent

DIRECT_DOWNLOADS = {
    "dft-road-casualty-statistics-collision-2024.csv":
        "https://data.dft.gov.uk/road-accidents-safety-data/"
        "dft-road-casualty-statistics-collision-2024.csv",
}

ZIP_DOWNLOADS = {
    "https://dbs.uni-leipzig.de/files/datasets/DBLP-ACM.zip":
        ["ACM.csv", "DBLP2.csv", "DBLP-ACM_perfectMapping.csv"],
}

MANUAL = {
    "diabetes.csv":
        "https://www.kaggle.com/datasets/uciml/pima-indians-diabetes-database",
}


def fetch(url: str, timeout: int = 120) -> bytes:
    req = Request(url, headers={"User-Agent": "Mozilla/5.0"})
    with urlopen(req, timeout=timeout) as resp:
        return resp.read()


def main() -> None:
    missing = []

    for name, url in DIRECT_DOWNLOADS.items():
        target = HERE / name
        if target.exists():
            print(f"skip   {name} (already present)")
            continue
        print(f"get    {name} ...", flush=True)
        try:
            target.write_bytes(fetch(url))
            size_mb = target.stat().st_size / 1e6
            print(f"       done, {size_mb:.1f} MB")
        except Exception as exc:
            print(f"       failed: {exc}")
            missing.append((name, url))

    for url, members in ZIP_DOWNLOADS.items():
        if all((HERE / m).exists() for m in members):
            print(f"skip   {', '.join(members)} (already present)")
            continue
        print(f"get    {', '.join(members)} ...", flush=True)
        try:
            with zipfile.ZipFile(io.BytesIO(fetch(url))) as zf:
                for member in zf.namelist():
                    base = Path(member).name
                    if base in members:
                        (HERE / base).write_bytes(zf.read(member))
                        print(f"       extracted {base}")
        except Exception as exc:
            print(f"       failed: {exc}")
            for m in members:
                missing.append((m, url))

    for name, url in MANUAL.items():
        if (HERE / name).exists():
            print(f"skip   {name} (already present)")
        else:
            missing.append((name, url))

    if missing:
        print("\nStill needed (download manually):")
        for name, url in missing:
            print(f"  {name}\n    {url}")
        sys.exit(1)

    print("\nAll datasets present.")


if __name__ == "__main__":
    main()
