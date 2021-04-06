## ChineseNames (CSV Data Files)

### Description

**`ChineseNames`** (v1.0.0) is an R package published on CRAN (<https://CRAN.R-project.org/package=ChineseNames>). To use the datasets in this package, it is highly recommended to use [R software](https://www.r-project.org/), normally within its IDE [RStudio](https://www.rstudio.com/products/rstudio/download/preview/), and install this package.

``` {.r}
## Install from CRAN
install.packages("ChineseNames")

## Load to environment
library(ChineseNames)

## See R documentation
?ChineseNames
?compute_name_index
```

In the [data-csv](https://github.com/psychbruce/ChineseNames/tree/master/data-csv) subfolder of its [GitHub repository](https://github.com/psychbruce/ChineseNames), I also provide CSV-format data files for people who do not use R. These datasets are identical to the R datasets embedded in the `ChineseNames` package with the same names (i.e., `familyname`, `givenname`, `population`, `top1000name.prov`, `top100name.year`, `top50char.year`).

For detailed description, see [README.md](https://github.com/psychbruce/ChineseNames) (and the R documentation of each dataset).

**If you are about to use or share these datasets, please strictly follow the GPL-3 License and the CC BY-NC-SA License.**

-   **BY: Cite this R package (see below).**
-   **NC: Use ONLY for non-commercial purposes.**
-   **SA: Share in an identical way.**

### Citation

-   Bao, H.-W.-S. (2021). ChineseNames: Chinese Name Database 1930-2008. R package version 1.0.0. <https://CRAN.R-project.org/package=ChineseNames> or <https://github.com/psychbruce/ChineseNames>

### Supplementary Information

Example usage and application based on this name database can be found in:

-   [What can we tell from the evolution of Han Chinese names? - by Isabella Chua (March 12, 2021)](https://kontinentalist.com/stories/a-cultural-history-of-han-chinese-names-for-girls-and-boys-in-china)
