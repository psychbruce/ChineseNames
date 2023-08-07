# ChineseNames <img src="man/figures/logo.png" align="right" width="160"/>

**Chinese Name Database 1930-2008**

A database of Chinese surnames and Chinese given names (1930-2008). This database contains nationwide frequency statistics of 1,806 Chinese surnames and 2,614 Chinese characters used in given names, covering about 1.2 billion Han Chinese population (96.8% of the Han Chinese household-registered population born from 1930 to 2008 and still alive in 2008). This package also contains a function for computing multiple features of Chinese surnames and Chinese given names for scientific research (e.g., name uniqueness, name gender, name valence, and name warmth/competence).

<!-- badges: start -->

[![CRAN-Version](https://www.r-pkg.org/badges/version/ChineseNames?color=red)](https://CRAN.R-project.org/package=ChineseNames) [![GitHub-Version](https://img.shields.io/github/r-package/v/psychbruce/ChineseNames?label=GitHub&color=orange)](https://github.com/psychbruce/ChineseNames) [![R-CMD-check](https://github.com/psychbruce/ChineseNames/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/psychbruce/ChineseNames/actions/workflows/R-CMD-check.yaml) [![CRAN-Downloads](https://cranlogs.r-pkg.org/badges/grand-total/ChineseNames)](https://CRAN.R-project.org/package=ChineseNames) [![Logo-Designer](https://img.shields.io/badge/Logo%20Designer-Meijia%20Li-blueviolet?logo=github-sponsors)](https://github.com/Stellapros) [![GitHub-Stars](https://img.shields.io/github/stars/psychbruce/ChineseNames?style=social)](https://github.com/psychbruce/ChineseNames/stargazers)

<!-- badges: end -->

<img src="https://s1.ax1x.com/2020/07/28/aAjUJg.jpg" width="120px" height="42px"/>

## Author

Han-Wu-Shuang (Bruce) Bao 包寒吴霜

Email: [baohws\@foxmail.com](mailto:baohws@foxmail.com)

Homepage: [psychbruce.github.io](https://psychbruce.github.io)

## Citation

-   Bao, H.-W.-S. (2021). ChineseNames: Chinese Name Database 1930-2008. R package version 2021.12. <https://CRAN.R-project.org/package=ChineseNames>
-   Bao, H.-W.-S., Cai, H., Jing, Y., & Wang, J. (2021). Novel evidence for the increasing prevalence of unique names in China: A reply to Ogihara. *Frontiers in Psychology, 12*, 731244. <https://www.frontiersin.org/articles/10.3389/fpsyg.2021.731244/full>

## Install

``` r
## Method 1: Install from CRAN
install.packages("ChineseNames")

## Method 2: Install from GitHub
install.packages("devtools")
devtools::install_github("psychbruce/ChineseNames")
```

## User Guide

### Data Source

This Chinese name database was provided by Beijing Meiming Science and Technology Company (in collaboration) and originally obtained from the National Citizen Identity Information Center (NCIIC) of China in 2008.

It contains nationwide frequency statistics of almost all Chinese surnames and given-name characters, which have covered about **1.2 billion Han Chinese population** (96.8% of the Han Chinese population born from 1930 to 2008 and still alive in 2008, i.e., the *living household-registered population*). It also contains subjective rating indices of given-name characters. To our knowledge, this is the most comprehensive and accurate Chinese name database up to now.

Note that this database does not contain any individual-level information (so it does not leak personal privacy). All data are at the name level or character level. Extremely rare characters are not included.

### Datasets

This package includes five datasets (`data.frame` in R). You can access them using the `data()` function in R. The use of these datasets should follow the GNU GPL-3 License and the Creative Commons License CC BY-NC-SA, **with a proper citation of this package and only for non-commercial purposes**.

-   **`familyname`**: 1,806 Chinese surnames with their frequencies in the Han Chinese population.

    -   overall frequencies and proportions, regardless of gender and birth cohort

-   **`givenname`**: 2,614 Chinese characters in given names with their frequencies in the Han Chinese population.

    -   separate frequencies and proportions for each gender and each of 6 birth cohorts (pre-1960s, 1960-1969, 1970-1979, 1980-1989, 1990-1999, and 2000-2008)
    -   including usage in all single-character and multi-character given names (e.g., the character "伟" in all "张伟", "张伟\_\_", "张\_\_伟", "王伟", "王伟\_\_", "王\_\_伟", ...)

-   **`top1000name.prov`**: Top 1,000 given names in 31 Chinese mainland provinces.

-   **`top100name.year`**: Top 100 given names in 6 birth cohorts.

-   **`top50char.year`**: Top 50 given-name characters for 6 birth cohorts.

*Note*. The "ppm" in the variable names of these datasets means "parts per million (百万分率)" (e.g., 1 ppm = a proportion of 1/10<sup>6</sup>).

### Compute Name Features

**Use the `compute_name_index()` function.** This function computes multiple indices of Chinese surnames and given names for scientific research. Just input a data frame with full names (and birth years, if necessary), then it returns a new data frame with all name indices appended.

**Examples:**

``` r
library(ChineseNames)
?compute_name_index  # see detailed usage in help page

## Usage 1
compute_name_index(name="包寒吴霜", birth=1995)

## Usage 2
demodata=data.frame(
  name=c("包寒吴霜", "陈俊霖", "张伟", "张炜", "欧阳修", "欧阳", "易烊千玺", "张艺谋", "王的"),
  birth=c(1995, 1995, 1985, 1988, 1968, 2009, 2000, 1950, 2005))

newdata=compute_name_index(
  demodata,
  var.fullname="name",  # full name
  var.birthyear="birth")  # adjusted for birth year
View(newdata)
```

```         
#        name birth name0 name1 name2 name3 NLen    SNU SNI     NU    CCU      NG     NV     NW     NC
# 1: 包寒吴霜  1995    包    寒    吴    霜    4 3.0595   2 3.6042 4.1178 -0.2187 3.3542 2.6667 3.2333
# 2:   陈俊霖  1995    陈    俊    霖          3 1.3415   3 2.4619 4.7688  0.4081 4.3125 3.6500 3.6500
# 3:     张伟  1985    张    伟                2 1.1529  26 1.6611 3.8865  0.6859 4.2500 3.5000 3.4000
# 4:     张炜  1988    张    炜                2 1.1529  26 3.0547 5.8583  0.6025 3.9375 3.4000 3.5000
# 5:   欧阳修  1968  欧阳    修                3 3.1645  15 2.9816 3.5510  0.5047 3.0625 3.5000 3.3000
# 6:     欧阳  2009    欧    阳                2 2.9694  15 2.0389 3.4574  0.5103 4.3750 4.1000 3.7000
# 7: 易烊千玺  2000    易    烊    千    玺    4 2.8689  25 3.8743 4.8944  0.4619 3.1875 3.2000 3.1667
# 8:   张艺谋  1950    张    艺    谋          3 1.1529  26 3.8808 3.6611  0.3183 3.5938 3.5500 3.3500
# 9:     王的  2005    王    的                2 1.1257  23 5.1893 1.3110 -0.5325 2.1250 2.5000 2.2000
```

-   **NLen: full-name length**

    -   2\~4

        -   A Chinese surname usually consists of one character (i.e., single surname, 单姓) and sometimes consists of two characters (i.e., compound surname, 复姓).

        -   A Chinese given name can be any single character or any combination of two characters (rarely of three characters, like the author's given name "Han-Wu-Shuang").

-   **SNU: surname uniqueness**

    -   1\~6

    -   SNU = --log<sub>10</sub>(P<sub>surname</sub> + 10<sup>--6</sup>)

        -   P<sub>surname</sub> = the percentage of a surname held by people in the Han Chinese population.
        -   A small constant (10<sup>--6</sup>) is added to adjust for skewness and limit the maximum of SNU to 6.00.
        -   SNU = 2 and 3 mean that 1/100 and 1/1000 of people had this surname, respectively.
        -   The diversity of surnames is limited in China: the top 25 most common Chinese surnames have covered about 60% (0.7 billion) of the Han Chinese population (1.2 billion).

-   **SNI: surname initial (alphabetical order)**

    -   1\~26

        -   Chinese names are usually sorted by surname initials. This index is the alphabetical order of *Pinyin* initial of a surname.

-   **NU: name-character uniqueness (in naming practices)**

    -   1\~6

    -   NU = --log<sub>10</sub>(P<sub>character</sub> + 10<sup>--6</sup>)

        -   P<sub>character</sub> = the percentage of a character used in all single-character and multi-character given names in the Han Chinese population *within a specific birth year* (an approximate estimate using the nearest two birth cohorts with relative weights, which would be more precise than just using a single birth cohort).
        -   A small constant (10<sup>--6</sup>) is added to adjust for skewness and limit the maximum of NU to 6.00.
        -   NU = 2 and 3 mean that 1/100 and 1/1000 of people used this character in given name (in their birth year), respectively.
        -   For data without birth-year information, the `compute_name_index()` function returns NU based on the average percentage across all six birth cohorts.

-   **CCU: character-corpus uniqueness (in contemporary Chinese corpus)**

    -   1\~6

    -   CCU = --log<sub>10</sub>(P<sub>character</sub> + 10<sup>--6</sup>)

        -   P<sub>character</sub> = the percentage of a character in a contemporary Chinese corpus.
        -   CCU should be distinguished from NU because daily language usage is distinct from naming practices. Some characters rarely used in personal names may instead be frequently used in daily language (and vice versa).

-   **NG: name gender (difference in proportions of a character used by male vs. female)**

    -   --1\~1

    -   NG = (*N*<sub>male</sub> -- *N*<sub>female</sub>) / (*N*<sub>male</sub> + *N*<sub>female</sub>)

        -   NG ranges from --1 (completely feminine; 100% used by female) through 0 (gender-neutral; half by female and half by male) to 1 (completely masculine; 100% used by male).

-   **NV: name valence (positivity of character meaning)**

    -   1\~5
    -   Subjective ratings from 16 Chinese raters (9 males and 7 females; interrater reliability ICC = 0.921) on the positivity of all 2,614 given-name characters according to the meaning of each character (1 = *strongly negative*, 3 = *neutral*, 5 = *strongly positive*).

-   **NW: name warmth/morality**

    -   1\~5
    -   Subjective ratings from 10 Chinese raters (5 males and 5 females; interrater reliability ICC = 0.774) on how a person whose name contains each of the 2,614 given-name characters is likely to have warmth-related traits (1 = *strongly unlikely to have*, 3 = *medium likelihood*, 5 = *strongly likely to have*).

-   **NC: name competence/assertiveness**

    -   1\~5
    -   Subjective ratings from 10 Chinese raters (5 males and 5 females; interrater reliability ICC = 0.712) on how a person whose name contains each of the 2,614 given-name characters is likely to have competence-related traits (1 = *strongly unlikely to have*, 3 = *medium likelihood*, 5 = *strongly likely to have*).

\* Instruction for the rating task of NW and NC (adapted from [Newman et al., 2018](https://doi.org/10.1177/0146167218769858)):

> According to psychological research, when people form impressions of others, they usually evaluate them in two aspects: warmth and competence.
>
> -   "Warmth" (温暖) includes traits such as warm (热情), friendly (友好), righteous (正直), honest (诚实), kind (和善), fair (公平), sincere (真诚), reliable (可靠), and moral (有道德).
> -   "Competence" (能力) includes traits such as competent (能干), clever (聪明), careful (细心), efficient (高效), creative (创新), ingenious (灵巧), knowledgeable (博学), persistent (坚韧), and intelligent (有智慧).
>
> Imagine that you are about to meet a person whose given name contains each of the following characters. Please judge how likely he/she is to have traits related to "warmth" ("competence"). If you feel uncertain, please use your intuition and make your best guess.

### A Note on Multi-Character Given Names

For a Chinese given name with multiple characters, name indices are averaged across characters. In other words, name indices are computed based on ***characters*** rather than ***character combinations***. Here are main reasons.

1.  Computing name variables at the character level is more practical in research. Indeed, character combinations are countless, whereas single characters are a finite set and easy to handle. Moreover, for name indices other than NU, this is the only feasible approach, especially in a large sample. It is impractical to ask participants to rate millions or billions of character combinations.
2.  As evidenced by our research, NU computed by averaging across characters (objective NU) was positively correlated with people's perception of the uniqueness of their given names (subjective NU): *r* = 0.32, *p* \< 0.001, *N* = 672.
3.  As evidenced by our research, among four measures of name uniqueness (two at the character level and two at the character-combination level), only name-character uniqueness (i.e., NU) was positively associated with cultural-level individualism.
4.  In linguistics, a *name* (word) is to English what a *name character* (single character) is to Chinese.
