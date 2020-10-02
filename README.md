# ChineseNames

Chinese Name Database 1930-2008

![](https://img.shields.io/badge/R-package-success)
![](https://img.shields.io/badge/Version-0.6.0-success)
![](https://img.shields.io/github/license/psychbruce/ChineseNames?label=License&color=success)
[![](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![](https://img.shields.io/github/stars/psychbruce/ChineseNames?style=social)](https://github.com/psychbruce/ChineseNames/stargazers)

<a href="https://en.wikipedia.org/wiki/Creative_Commons_license"><img src="https://s1.ax1x.com/2020/07/28/aAjUJg.jpg" width="120px" height="42px"></a>

- 复制、修改、使用、分享本代码库，必须遵守<b>「创作共用许可协议 CC BY-NC-SA」（原作者署名-非商业用途使用-相同方式共享）</b>


## Author

[包寒吴霜 \| Bao H.-W.-S.](https://psychbruce.github.io)

E-mail: [baohws@foxmail.com](mailto:baohws@foxmail.com)

Website: [psychbruce.github.io](https://psychbruce.github.io)

[ResearchGate](https://www.researchgate.net/profile/Han_Wu_Shuang_Bao) |
[GitHub](https://github.com/psychbruce) |
[知乎](https://www.zhihu.com/people/psychbruce)


## Citation

Please cite the following three references if you use this database:

- Bao, H.-W.-S. (2020). ChineseNames: Chinese Name Database 1930-2008 [R package]. https://github.com/psychbruce/ChineseNames

- Bao, H.-W.-S., Cai, H., DeWall, C. N., Gu, R., Chen, J., & Luo, Y. L. L. (2020). Name uniqueness predicts career choice and career achievement. Preprint at *PsyArXiv* https://doi.org/10.31234/osf.io/53j86

- Bao, H.-W.-S., Wang, J., & Cai, H. (2020). Blame crime on name? People with bad names are more likely to commit crime. Preprint at *PsyArXiv* https://doi.org/10.31234/osf.io/txhqg

## Install

```r
install.packages("devtools")
# devtools::install_github("psychbruce/bruceR")
devtools::install_github("psychbruce/ChineseNames")
```
*Note*. To use the function `compute_name_index()` in `ChineseNames`, you should also install the package `bruceR`. For an installation guide of `bruceR`, please see: https://github.com/psychbruce/bruceR


## Description

### Data Source

This Chinese name database was provided by *Beijing Meiming Science and Technology Company* and originally obtained from the National Citizen Identity Information Center (NCIIC) of China in 2008.

It consists of nationwide statistics for almost all surnames and given-name characters and covers **1.2 billion Han Chinese population** (96.8% of the Han Chinese population born from 1930 to 2008 and still alive in 2008, i.e., the *living household-registered population*). To our knowledge, this is the most comprehensive and accurate Chinese name database up to now.

The `ChineseNames` package includes five datasets (`data.frame` in R):
- **`familyname`**: 1,806 Chinese surnames with their usage in the Han Chinese population
  + overall frequencies and proportions regardless of gender and birth cohort
- **`givenname`**: 2,614 characters used in Chinese given names with their usage in the Han Chinese population
  + separate frequencies and proportions for each gender and each birth cohort (i.e., pre-1960s, 1960-1969, 1970-1979, 1980-1989, 1990-1999, and 2000-2008)
  + involving all situations of their usage in either single-character or multi-character given names (e.g., the character “伟” in “张伟”, “张伟\*”, “张\*伟”, “王伟”, “王伟\*”, “王\*伟”, …)
- **`top1000name.prov`**: Top 1,000 given names (character combinations) for 31 Chinese mainland provinces
- **`top100name.year`**: Top 100 given names (character combinations) for 6 birth cohorts
- **`top50char.year`**: Top 50 given-name characters for 6 birth cohorts

*Note*. The “ppm” in variable names of these datasets means “parts per million (百万分率)” (e.g., ppm = 1 means a proportion of 1/10<sup>6</sup>).


### Name Variables

- **NLen: full-name length**
  + 2~4
  + A Chinese given name can be any Chinese character or any combination of two characters (rarely three characters).
  + A Chinese surname usually consists of one character (rarely two characters [“compound surname”, 复姓]).

- **SNU: surname uniqueness**
  + 1~6
  + SNU = –log<sub>10</sub>(P<sub>surname</sub> + 10<sup>–6</sup>)
    + SNU ranges from 1.13 to 6.00. Likewise, SNU = 2 and 3 mean that 1% and 1‰ of people possess this surname, respectively.
    + Note that the diversity of surnames is rather limited in China: the top 25 popular Chinese surnames have covered about 60% (0.7 billion) of the Han Chinese population (1.2 billion).

- **SNI: surname initial (alphabetical order)**
  + 1~26
  + As Chinese names are always sorted by surname initials, we include such an index according to the alphabetical order of *Pinyin* initial of each surname.

- **NU: given-name uniqueness (character level)**
  + 1~6
  + NU = –log<sub>10</sub>(P<sub>given-name</sub> + 10<sup>–6</sup>)
    + P<sub>given-name</sub> = percentage of a character used in either single-character or multi-character given names among the Han Chinese population within a specific *birth cohort* (or within a specific *birth year*, please see and use the parameter `NU.approx` of the function `compute_name_index()` to obtain **an approximate estimate of NU within a birth year** rather than a birth cohort)
    + The distribution of P<sub>given-name</sub> is highly skewed, so we log-transform and reverse it to get an index of uniqueness easy to be interpreted.
    + As the Chinese given-name database does not include some extremely rare characters, a small constant (10<sup>–6</sup>) is added to adjust for zero percentage (P<sub>given-name</sub> = 0) and limit the maximum of NU to 6.00.
    + NU ranges from 1.18 to 6.00, with a higher value indicating a more unique character. This index can be directly interpreted. For instance, NU = 2 means that 1% of people use this character in given names within their birth cohort; and NU = 3 means that 1‰ of people use this character in given names within their birth cohort.
    + For data without birth-year information, you can just use the averaged percentage across all six birth cohorts to estimate NU (see the help page of the function `compute_name_index()`).

- **CCU: character uniqueness in contemporary Chinese corpus**
  + 1~6
  + CCU = –log<sub>10</sub>(P<sub>character</sub> + 10<sup>–6</sup>)
    + P<sub>character</sub> = percentage of a character appearing in contemporary Chinese corpus (http://www.cncorpus.org)
    + CCU should be distinguished from NU because daily language usage is quite different from naming practices. For instance, some characters rarely used in personal names may instead be frequently used in daily language (and vice versa).
    + CCU ranges from 1.31 to 6.00. For example, CCU = 2 and 3 mean that the frequency of a character used in written and/or spoken Chinese texts equals to 1% and 1‰, respectively.

- **NG: given-name gender (difference in proportions of a character used by males vs. females)**
  + –1~1
  + NG = (*N*<sub>male</sub> – *N*<sub>female</sub>) / (*N*<sub>male</sub> + *N*<sub>female</sub>)
    + NG ranges from –1 (completely feminine; 100% used by females) through 0 (gender-neutral; half by females and half by males) to 1 (completely masculine; 100% used by males).

- **NV: given-name valence (positivity of character meaning)**
  + 1~5
  + Sixteen Chinese raters (9 males and 7 females) evaluated the valence of all 2,614 given-name characters according to the meaning of each character (1 = *strongly negative*, 3 = *neutral*, 5 = *strongly positive*) (interrater reliability ICC = 0.921).

- **NW: given-name warmth/morality**
  + 1~5
  + Ten Chinese raters (5 males and 5 females) evaluated how likely a person whose name contains each of the 2,614 given-name characters is to have warmth-related traits (1 = *strongly unlikely to have*, 3 = *medium likelihood*, 5 = *strongly likely to have*) (interrater reliability ICC = 0.774).

- **NC: given-name competence/assertiveness**
  + 1~5
  + Ten Chinese raters (5 males and 5 females) evaluated how likely a person whose name contains each of the 2,614 given-name characters is to have competence-related traits (1 = *strongly unlikely to have*, 3 = *medium likelihood*, 5 = *strongly likely to have*) (interrater reliability ICC = 0.712).

\* Instructions for the rating tasks of NW and NC (adapted from [Newman et al., 2018](https://doi.org/10.1177/0146167218769858)):
> According to psychological research, when people form impressions of others, they usually evaluate them in two aspects: warmth and competence.
> - “Warmth” (温暖) includes traits such as warm (热情), friendly (友好), righteous (正直), honest (诚实), kind (和善), fair (公平), sincere (真诚), reliable (可靠), and moral (有道德).
> - “Competence” (能力) includes traits such as competent (能干), clever (聪明), careful (细心), efficient (高效), creative (创新), ingenious (灵巧), knowledgeable (博学), persistent (坚韧), and intelligent (有智慧).
>
> Imagine that you are about to meet a person whose given name contains each of the following characters. Please judge how likely he/she is to have traits related to “warmth” (“competence”). If you feel uncertain, please use your intuition and make your best guess.


### Functions in `ChineseNames`
- **`compute_name_index()`**
  + With this function, users can easily compute variables of given names and surnames ready for scientific research. Just input a data frame and it will output a new data frame with all name variables appended.
  + It can handle millions of cases in seconds.
  + We strongly recommend using this function given its convenience and optimized computation efficiency. Otherwise, users have to spend much time on basic work such as transforming and merging different datasets.
  + Example:
```r
library(ChineseNames)  # "bruceR" package should also be installed
?compute_name_index  # see the help page to learn how to use it

demodata  # a data frame with two variables "name" and "birth"
newdata=compute_name_index(demodata,
                           var.fullname="name",  # full name
                           var.birthyear="birth",  # adjust for birth cohort)
newdata
```
```
       name birth name0 name1 name2 name3 NLen    SNU SNI     NU    CCU      NG     NV     NW     NC
1: 包寒吴霜  1995    包    寒    吴    霜    4 3.0595   2 3.6042 4.1178 -0.2187 3.3542 2.6667 3.2333
2:   陈俊霖  1995    陈    俊    霖  <NA>    3 1.3415   3 2.4619 4.7688  0.4081 4.3125 3.6500 3.6500
3:     张伟  1985    张    伟  <NA>  <NA>    2 1.1529  26 1.6611 3.8865  0.6859 4.2500 3.5000 3.4000
4:     张炜  1988    张    炜  <NA>  <NA>    2 1.1529  26 3.1665 5.8583  0.6025 3.9375 3.4000 3.5000
5:   欧阳修  1968  欧阳    修  <NA>  <NA>    3 3.1645  15 2.9462 3.5510  0.5047 3.0625 3.5000 3.3000
6:     欧阳  2010    欧    阳  <NA>  <NA>    2 2.9694  15 1.9509 3.4574  0.5103 4.3750 4.1000 3.7000
7: 易烊千玺  2000    易    烊    千    玺    4 2.8689  25 3.7449 4.8944  0.4619 3.1875 3.2000 3.1667
8:   张艺谋  1950    张    艺    谋  <NA>    3 1.1529  26 3.8808 3.6611  0.3183 3.5938 3.5500 3.3500
9:     王的  2005    王    的  <NA>  <NA>    2 1.1257  23 5.1893 1.3110 -0.5325 2.1250 2.5000 2.2000
```


### A Note on Multi-Character Given Names
For a Chinese given name with multiple characters, name variables (NU, CCU, NV, and NG) are averaged across characters. In other words, we target (and recommend targeting) ***characters*** rather than ***character combinations*** in Chinese given names. Here we summarize the reasons for doing so.
1. This practice has been accepted by academic community of psychology (for related previous research, see [Cai et al., 2018](https://doi.org/10.3389/fpsyg.2018.00554)).
2. Analyses based on characters are more practical and allow for more specific examination targeting characters used at different locations in a given name.
3. In computing the percentage of a character used among the Han Chinese population, the Chinese name database has added up all kinds of its usage in either single-character or multi-character given names. Therefore, the percentages of characters indeed reflect their all possible usage in naming practices.
4. Our research has shown that the NU computed by averaging NU across multiple characters (objective NU) is positively correlated with people’s perception (subjective NU) (*r*<sub>obj–subj</sub> = 0.32, *p* < 0.001, *N* = 672, [Study 1](https://doi.org/10.31234/osf.io/53j86)), suggesting an objective–subjective correspondence.
5. For name variables other than NU, it is the only feasible approach to compute them in a large sample.

For details, see *Supplementary Information* (`Bao_2020_Preprint_SI_Name uniqueness predicts career choice and career achievement.pdf`) posted on our OSF Project (https://osf.io/8syrc/).

We recommend future researchers to follow this practice when handling multi-character given names.
