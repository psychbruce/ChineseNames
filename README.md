# ChineseNames

Chinese Names Database 1930-2008

![](https://img.shields.io/badge/R-package-success)
![](https://img.shields.io/badge/Version-0.2.0-success)
![](https://img.shields.io/github/license/psychbruce/ChineseNames?label=License&color=success)
[![](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![](https://img.shields.io/github/stars/psychbruce/ChineseNames?style=social)](https://github.com/psychbruce/ChineseNames/stargazers)

[![](https://img.shields.io/badge/Follow%20me%20on-Zhihu-blue)](https://www.zhihu.com/people/psychbruce/ "Personal profile on Zhihu.com")


## Citation
Bao, H.-W.-S. (2020). ChineseNames: Chinese Names Database 1930-2008 (R package). Retrieved from https://github.com/psychbruce/ChineseNames


## Install
NOTE: To use the function `compute_name_index()` in `ChineseNames`, you should also install the package `bruceR`. For an installation guide of `bruceR`, please see: https://github.com/psychbruce/bruceR
```r
install.packages("devtools")
# devtools::install_github("psychbruce/bruceR")
devtools::install_github("psychbruce/ChineseNames")
```


## Description
### Data Source
This Chinese name database was provided by *Beijing Meiming Science and Technology Company* and originally obtained from the National Citizen Identity Information Center (NCIIC) of China.

It consists of nationwide statistics for almost all surnames and given-name characters and covers **1.2 billion Han Chinese population**. To our knowledge, this is the most comprehensive and accurate Chinese name database up to now.

The given-name and surname lists cover 96.8% of Han Chinese population born from 1930 to 2008 and still alive in 2008 (i.e., the living household-registered population). The given-name list documents the proportions of given-name characters separately for each gender and each birth cohort (i.e., pre-1960s, 1960-1969, 1970-1979, 1980-1989, 1990-1999, and 2000-2008). The surname list records the overall proportions of surnames across gender and birth cohorts.

The `ChineseNames` package includes six datasets (`data.frame` in R):
1.	`familyname`: 1,806 Chinese surnames with their proportions in the Han Chinese population
2.	`givenname`: 2,614 characters used in Chinese given names with their proportions in the Han Chinese population
3. `population`: Population for name databases
4. `top1000name.prov`: Top 1000 given names across 31 Chinese mainland provinces
5. `top100name.year`: Top 100 given names across 6 birth cohorts (pre-1960s to 2008)
6. `top50char.year`: Top 50 given-name characters across 6 birth cohorts (pre-1960s to 2008)

Note: "ppm" in the variable names of these datasets means "parts per million" (百万分率; 1/10<sup>6</sup>).


### Name Variables
- NLen: full-name length
  + 2~4
- NU: given-name uniqueness
  + 1~6
  + NU = –log<sub>10</sub>(P<sub>given-name</sub> + 10<sup>–6</sup>)
    + P<sub>given-name</sub> = percentage of a character used among the Han Chinese population specific to a person's birth cohort (all kinds of usage in either single-character or multi-character given names; e.g., the character “伟” in “张伟”, “张伟\*”, “张\*伟”, “王伟”, “王伟\*”, “王\*伟”, …)
    + As the Chinese given-name database does not include some extremely rare characters, a small constant (10<sup>–6</sup>) is added to adjust for zero frequency (P<sub>given-name</sub> = 0) and limit the maximum of NU to 6.00.
    + NU ranges from 1.18 to 6.00, with a higher value indicating a more unique character. This index can be directly interpreted. For instance, NU = 2 means that 1% of people use this character in given names within their birth cohort; and NU = 3 means that 1‰ of people use this character in given names within their birth cohort.
- CCU: character uniqueness in daily corpus
  + 1~6
  + CCU = –log<sub>10</sub>(P<sub>character</sub> + 10<sup>–6</sup>)
    + P<sub>character</sub> = percentage of a character appearing in Chinese corpus (http://www.cncorpus.org)
    + CCU should be distinguished from NU because daily language usage is quite different from naming practices.
    + CCU ranges from 1.31 to 6.00. For example, CCU = 2 and 3 mean that the frequency of a character used in written and/or spoken Chinese texts equals to 1% and 1‰, respectively.
- NV: given-name valence (i.e., positivity of character meaning)
  + 1~5
  + Six raters evaluated the valence (1 = *strongly negative*, 5 = *strongly positive*) of all the 2,614 characters in the Chinese given-name list (interrater reliability ICC = 0.884).
- NG: given-name gender (i.e., difference in proportions of a character used by males vs. females)
  + -1~1
  + NG = P<sub>male</sub> – P<sub>female</sub>
  + NG ranges from –1 (completely feminine; 100% used by females) through 0 (gender-neutral; half by females and half by males) to 1 (completely masculine; 100% used by males).
- SNU: surname uniqueness
  + 1~6
  + SNU = –log<sub>10</sub>(P<sub>surname</sub> + 10<sup>–6</sup>)
    + SNU ranges from 1.13 to 6.00. Likewise, SNU = 2 and 3 mean that 1% and 1‰ of people possess this surname, respectively.
    + Note that the diversity of surnames is rather limited in China: the top 25 popular Chinese surnames have covered about 60% (0.7 billion) of the Han Chinese population (1.2 billion).
- SNI: surname initial (i.e., alphabetical order)
  + 1~26
  + As Chinese names are always sorted by surname initials, we obtained such an index according to the alphabetical order of *Pinyin* initial of each surname.


### Functions in `ChineseNames`
- `compute_name_index()`
  + Easily compute variables of given names and surnames for scientific research


## Author
[Han-Wu-Shuang (Bruce) Bao - 包寒吴霜](https://www.zhihu.com/people/psychbruce/ "Personal profile on Zhihu.com")

E-mail: baohws@psych.ac.cn or psychbruce@qq.com
