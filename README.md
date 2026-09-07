# Data Wrangling and Data Analysis (INFOMDWR)

Coursework from the MSc Applied Data Science programme at Utrecht University, autumn 2025. Four assignments covering relational database design, data profiling and integration, supervised learning, and unsupervised text clustering. Written in Python, R and SQL.

## Contents

| | Assignment | Topic | Stack |
|---|---|---|---|
| 01 | Database design | Relational schema design, constraints, analytical queries, string similarity matching | SQL (SQLite), Python |
| 02 | Data integration and preparation | Single column profiling, entity resolution via pairwise matching and LSH, missing value imputation | Python |
| 03 | Supervised learning | Regression trees with custom k-fold pruning, SVM, multiple linear regression | R, Quarto |
| 04 | Text clustering | TF-IDF, Latent Semantic Analysis, k-means and hierarchical clustering | R, Quarto |

## Assignment 1: Database design

An eight table schema for a European billing system, with primary and foreign keys, check constraints on country codes, phone formats and email formats, and two many-to-many relationships resolved through junction tables. The notebook connects to the database and implements Jaro and Jaccard similarity from scratch to flag near duplicate customer records above a 0.7 threshold.

The customer table seeds three deliberate near duplicates (C00021 to C00023, close variants of C00006 to C00008) so the similarity matching has something to find. All three are recovered by the Jaccard comparison in the notebook.

```bash
cd 01-database-design-sql
python build_db.py        # creates assignment.db from schema_and_queries.sql
jupyter notebook assignment1.ipynb
```

The database file is not committed, since `schema_and_queries.sql` is the authoritative source and rebuilds it exactly. The notebook was originally run in Google Colab and points at `/content/assignment.db`. Change that path to `assignment.db` to run it locally.

## Assignment 2: Data integration and preparation

Three tasks:

1. **Profiling** ten single column statistics on the UK Department for Transport road collision data for 2024, following the taxonomy in Abedjan et al., *Profiling Relational Data: A Survey* (2015). Covers completeness, distinctness, uniqueness ratio, constancy and duplicate detection.
2. **Entity resolution** matching bibliographic records between DBLP and ACM. Part one does exhaustive pairwise comparison across several similarity measures. Part two uses minhash signatures and locality sensitive hashing, then compares precision and runtime against the exhaustive approach.
3. **Data preparation** on the Pima Indians diabetes data. Identifies disguised missing values encoded as zeros, imputes them with class conditional means, and measures how the correlation structure shifts as a result.

```bash
pip install -r requirements.txt
cd 02-data-integration-preparation
python get_data.py        # fetches the datasets
jupyter notebook assignment2.ipynb
```

The datasets are not committed to this repository. `get_data.py` downloads what it can and prints instructions for the rest. `diabetes.csv` needs a Kaggle account.

## Assignment 3: Supervised learning

Predicting student exam scores from school, family and social variables. Exploratory analysis, one hot encoding of categorical predictors, then three models compared against a trivial mean baseline under 10-fold cross validation. The regression tree implementation prunes inside each fold and records the tree size selected per fold, so pruning is tuned without leaking the held out data. SVM performed best and was used for the final test set predictions.

Rendered output: `assignment3.html`

```bash
cd 03-supervised-learning
quarto render assignment3.qmd
```

R packages: tidyverse, GGally, e1071, skimr, tree, caret

## Assignment 4: Text clustering

Unsupervised clustering of 5,000 IMDB movie reviews from the `text2vec` package. Text is tokenised and cleaned, represented as a TF-IDF weighted document term matrix, then reduced with Latent Semantic Analysis. K-means on scaled Euclidean distances is compared against hierarchical clustering with complete linkage on cosine distances, at k=5 and k=10, evaluated with silhouette widths and cluster size distributions.

Rendered output: `assignment4.html`

```bash
cd 04-text-clustering
quarto render assignment4.qmd
```

R packages: text2vec, tm, tidyverse, wordcloud, magrittr, fastcluster, proxy, cluster

## Data sources

- **UK road collision data 2024**, Department for Transport, Open Government Licence. [Dataset page](https://www.data.gov.uk/dataset/cb7ae6f0-4be6-4935-9277-47e5ce24a11f/road-safety-data)
- **DBLP-ACM entity resolution benchmark**, Database Group Leipzig, CC BY 4.0. [Project page](https://dbs.uni-leipzig.de/research/projects/benchmark-datasets-for-entity-resolution). Cite Köpcke, Thor and Rahm, *Evaluation of entity resolution approaches on real-world match problems*, VLDB 2010.
- **Pima Indians Diabetes Database**, originally from the National Institute of Diabetes and Digestive and Kidney Diseases. [Kaggle mirror](https://www.kaggle.com/datasets/uciml/pima-indians-diabetes-database)
- **IMDB movie reviews**, bundled with the R `text2vec` package.
- **Student performance data** for Assignment 3 was provided by the course and is included in `03-supervised-learning/`.

## Authorship

Assignments 1 and 2 were completed individually.

Assignments 3 and 4 were group submissions by Aayush Sharma, Elli Rapti, Mansi Budamagunta, Nishant Rajamani and Petros Polychronopoulos. Individual contributions are listed at the end of each rendered document. My own contributions were the decision tree modelling in Assignment 3 and the clustering evaluation and model comparison in Assignment 4.

## Note

This is coursework, published as a record of completed work. It is not intended as reference material for anyone currently enrolled in the course.
