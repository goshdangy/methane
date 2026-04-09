This package contains a Quarto-first analysis project.

Files:
- analysis.qmd: paper-facing Quarto analysis
- data/site_df.csv
- data/survey_df.csv
- data/site_naive_df.csv
- _quarto.yml

How to use:
1. Open the folder as an RStudio project or set the working directory to this folder.
2. Render analysis.qmd.
3. The Quarto document reads the static data files from the data/ folder and writes compact outputs to outputs/.

Notes:
- The benchmark data files are pre-generated and included with the project.
- Accepted benchmark dataset seed used for construction: 306
