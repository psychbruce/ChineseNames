#' ChineseNames: Chinese Name Database 1930-2008
#'
#' A database of Chinese surnames and given names (1930-2008), originally
#' obtained from the National Citizen Identity Information Center (NCIIC)
#' of China and provided by Beijing Meiming Science and Technology Company.
#' This name database contains nationwide frequency statistics for
#' 1,806 Chinese surnames and 2,614 Chinese characters used in given names,
#' covering about 1.2 billion Han Chinese population
#' (96.8\% of the Han Chinese household-registered population
#' born from 1930 to 2008 and still alive in 2008).
#' This package also contains a function that can compute variables of
#' Chinese surnames and given names for scientific research (e.g.,
#' name uniqueness, name positivity, name warmth/competence).
#'
#' Details are described in
#' \url{https://github.com/psychbruce/ChineseNames}
#'
#' @section Citation:
#' Bao, H.-W.-S. (2021). ChineseNames: Chinese Name Database 1930-2008.
#' R package version 1.0.0.
#' \url{https://CRAN.R-project.org/package=ChineseNames}
#'
#' @docType package
#' @name ChineseNames
NULL


.onAttach=function(libname, pkgname) {
  packageStartupMessage(
    "To cite the `ChineseNames` package in publications, please use:\n",
    "Bao, H.-W.-S. (2021). ",
    "ChineseNames: Chinese Name Database 1930-2008. ",
    "R package version 1.0.0. ",
    "https://CRAN.R-project.org/package=ChineseNames")
}


#### Database ####


#' 1,806 Chinese surnames and nationwide frequency.
#'
#' @name familyname
#' @usage data(familyname)
#' @format
#' A data frame with 7 variables:
#' \describe{
#'   \item{\code{surname}}{surname (in Chinese)}
#'   \item{\code{compound}}{0 = single surname, 1 = compound surname}
#'   \item{\code{initial}}{initial letter (a-z)}
#'   \item{\code{initial.rank}}{initial order (1-26)}
#'   \item{\code{n.1930_2008}}{total counts in the database}
#'   \item{\code{ppm.1930_2008}}{proportion in population (ppm = parts per million)}
#'   \item{\code{surname.uniqueness}}{surname uniqueness}
#' }
#' @details \url{https://github.com/psychbruce/ChineseNames}
NULL


#' 2,614 Chinese characters used in given names and nationwide frequency.
#'
#' @name givenname
#' @usage data(givenname)
#' @format
#' A data frame with 25 variables:
#' \describe{
#'   \item{\code{character}}{character used in given names (in Chinese)}
#'   \item{\code{pinyin}}{pinyin (pronunciation)}
#'   \item{\code{bihua}}{number of strokes in a character}
#'   \item{\code{n.male}}{total counts in male}
#'   \item{\code{n.female}}{total counts in female}
#'   \item{\code{name.gender}}{difference in proportions of a character used by male vs. female}
#'   \item{\code{n.1930_1959}, \code{n.1960_1969}, ..., \code{n.2000_2008}}{total counts in a birth cohort}
#'   \item{\code{ppm.1930_1959}, \code{ppm.1960_1969}, ..., \code{ppm.2000_2008}}{proportion (parts per million) in a birth cohort}
#'   \item{\code{name.ppm}}{average ppm (parts per million) across all cohorts}
#'   \item{\code{name.uniqueness}}{name-character uniqueness (in naming practices)}
#'   \item{\code{corpus.ppm}}{proportion (parts per million) in contemporary Chinese corpus}
#'   \item{\code{corpus.uniqueness}}{character-corpus uniqueness (in contemporary Chinese corpus)}
#'   \item{\code{name.valence} (based on subjective ratings from 16 raters, ICC = 0.921)}{name valence (positivity of character meaning)}
#'   \item{\code{name.warmth} (based on subjective ratings from 10 raters, ICC = 0.774)}{name warmth/morality}
#'   \item{\code{name.competence} (based on subjective ratings from 10 raters, ICC = 0.712)}{name competence/assertiveness}
#' }
#' @details \url{https://github.com/psychbruce/ChineseNames}
NULL


#' Population statistics for the Chinese name database.
#' @name population
#' @usage data(population)
#' @details \url{https://github.com/psychbruce/ChineseNames}
NULL


#' Top 1,000 given names in 31 Chinese mainland provinces.
#' @name top1000name.prov
#' @usage data(top1000name.prov)
#' @details \url{https://github.com/psychbruce/ChineseNames}
NULL


#' Top 100 given names in 6 birth cohorts.
#' @name top100name.year
#' @usage data(top100name.year)
#' @details \url{https://github.com/psychbruce/ChineseNames}
NULL


#' Top 50 given-name characters in 6 birth cohorts.
#' @name top50char.year
#' @usage data(top50char.year)
#' @details \url{https://github.com/psychbruce/ChineseNames}
NULL


#### Function ####


`%>%`=dplyr::`%>%`


#' Compute indices of surnames and given names.
#'
#' Compute all available name indices based on
#' \code{\link{familyname}} and \code{\link{givenname}}.
#' You can either input \code{data} with a variable of Chinese names
#' (and a variable of birth year, if necessary)
#' or just input a vector of \code{name}
#' (and \code{birth} year, if necessary).
#'
#' @param data Data frame.
#' @param var.fullname Variable name of Chinese full names (e.g., \code{"name"}).
#' @param var.surname Variable name of Chinese surnames (e.g., \code{"surname"}).
#' @param var.givenname Variable name of Chinese given names (e.g., \code{"givenname"}).
#' @param var.birthyear Variable name of birth year (e.g., \code{"birth"}).
#' @param name \strong{If no \code{data}}, you can just input a vector of full name(s).
#' @param birth \strong{If no \code{data}}, you can just input a vector of birth year(s).
#' @param index Which indices to compute?
#'
#' By default, it computes all available name indices:
#' \itemize{
#'   \item \code{NLen}: full-name length (2~4).
#'   \item \code{SNU}: surname uniqueness (1~6).
#'   \item \code{SNI}: surname initial (1~26).
#'   \item \code{NU}: name-character uniqueness (1~6).
#'   \item \code{CCU}: character-corpus uniqueness (1~6).
#'   \item \code{NG}: name gender (-1~1).
#'   \item \code{NV}: name valence (1~5).
#'   \item \code{NW}: name warmth (1~5).
#'   \item \code{NC}: name competence (1~5).
#' }
#'
#' For details, see \url{https://github.com/psychbruce/ChineseNames}
#' @param NU.approx Whether to \emph{approximately} compute name-character uniqueness (NU)
#' using \emph{the nearest two birth cohorts with relative weights}
#' (which would be more precise than just using a single birth cohort).
#' Default is \code{TRUE}.
#' @param digits Number of decimal places. Default is \code{4}.
#' @param return.namechar Whether to return separate name characters.
#' Default is \code{TRUE}.
#' @param return.all Whether to return all temporary variables
#' in the computation of the final variables.
#' Default is \code{FALSE}.
#'
#' @return
#' A new data frame (\code{data.table}) with name indices appended.
#'
#' @examples
#' ## compute for one name
#' myname=demodata[1, "name"]
#' mybirth=1995
#' d=compute_name_index(name=myname, birth=mybirth, index="NU")
#' # use View(d) to see the results
#'
#' ## compute for a dataset with a variable of names
#' data(demodata)  # a data frame
#' data=compute_name_index(demodata,
#'                         var.fullname="name")  # not adjusted for birth year
#' data=compute_name_index(demodata,
#'                         var.fullname="name",
#'                         var.birthyear="birth")  # adjusted for birth year
#' # use View(data) to see the results
#'
#' @import data.table
#' @importFrom bruceR Print MEAN LOOKUP
#' @export
compute_name_index=function(data=NULL,
                            var.fullname=NULL,
                            var.surname=NULL,
                            var.givenname=NULL,
                            var.birthyear=NULL,
                            name=NA, birth=NA,
                            index=c("NLen",
                                    "SNU", "SNI",
                                    "NU", "CCU", "NG",
                                    "NV", "NW", "NC"),
                            NU.approx=TRUE,
                            digits=4,
                            return.namechar=TRUE,
                            return.all=FALSE) {
  if(is.na(name)==FALSE) {
    data=data.frame(name=name, birth=birth)
    var.fullname="name"
    var.birthyear="birth"
  }
  if(is.null(data))
    stop("Please input your data.")
  if(is.null(var.fullname) & is.null(var.surname) & is.null(var.givenname))
    stop("Please input variable(s) of full/family/given names.")

  data=as.data.frame(data)
  if(!is.null(var.fullname)) {
    d=data.table(name=data[[var.fullname]])
    d[,name:=as.character(name)]
    d[,NLen:=nchar(name)]
    d[,fx:=(substr(name, 1, 2) %in% fuxing) & NLen>2]
    d[,name0:=substr(name, 1, ifelse(fx, 2, 1))]
    d[,name1:=substr(name, ifelse(fx, 3, 2), ifelse(fx, 3, 2)) %>% ifelse(.=="", NA, .)]
    d[,name2:=substr(name, ifelse(fx, 4, 3), ifelse(fx, 4, 3)) %>% ifelse(.=="", NA, .)]
    d[,name3:=substr(name, ifelse(fx, 5, 4), ifelse(fx, 5, 4)) %>% ifelse(.=="", NA, .)]
  } else {
    if(!is.null(var.surname) & !is.null(var.givenname)) {
      d=data.table(sur.name=data[[var.surname]], given.name=data[[var.givenname]])
      names(d)=c("sur.name", "given.name")
    } else {
      if(!is.null(var.surname)) {
        d=data.table(sur.name=data[[var.surname]])
        d$given.name=""
      }
      if(!is.null(var.givenname)) {
        d=data.table(given.name=data[[var.givenname]])
        d$sur.name=""
      }
    }
    d[,name:=paste0(sur.name, given.name)]
    d[,NLen:=nchar(name)]
    d[,fx:=sur.name %in% fuxing]
    d[,name0:=sur.name]
    d[,name1:=substr(given.name, 1, 1) %>% ifelse(.=="", NA, .)]
    d[,name2:=substr(given.name, 2, 2) %>% ifelse(.=="", NA, .)]
    d[,name3:=substr(given.name, 3, 3) %>% ifelse(.=="", NA, .)]
    d$sur.name=NULL
    d$given.name=NULL
  }

  if(!is.null(var.birthyear)) {
    d=cbind(d, year=data[[var.birthyear]])
  } else {
    d=cbind(d, year=NA)
  }

  d=d[,.(name0, name1, name2, name3, year, NLen)]

  log=(nrow(d)>=100000)

  if("SNU" %in% index) {
    d[,SNU:=LOOKUP(d, "name0", familyname, "surname", "surname.uniqueness", return="new.value") %>% round(digits)]
    if(log) Print("SNU computed.")
  }

  if("SNI" %in% index) {
    d[,SNI:=LOOKUP(d, "name0", familyname, "surname", "initial.rank", return="new.value")]
    if(log) Print("SNI computed.")
  }

  if("NU" %in% index) {
    d[,`:=`(nu1=mapply(compute_NU_char, name1, year, NU.approx),
            nu2=mapply(compute_NU_char, name2, year, NU.approx),
            nu3=mapply(compute_NU_char, name3, year, NU.approx)
            )]
    d[,NU:=MEAN(d, "nu", 1:3) %>% round(digits)]
    if(log) Print("NU computed.")
  }

  if("CCU" %in% index) {
    d[,`:=`(ccu1=LOOKUP(d, "name1", givenname, "character", "corpus.uniqueness", return="new.value"),
            ccu2=LOOKUP(d, "name2", givenname, "character", "corpus.uniqueness", return="new.value"),
            ccu3=LOOKUP(d, "name3", givenname, "character", "corpus.uniqueness", return="new.value")
            )]
    d[,CCU:=MEAN(d, "ccu", 1:3) %>% round(digits)]
    if(log) Print("CCU computed.")
  }

  if("NG" %in% index) {
    d[,`:=`(ng1=LOOKUP(d, "name1", givenname, "character", "name.gender", return="new.value"),
            ng2=LOOKUP(d, "name2", givenname, "character", "name.gender", return="new.value"),
            ng3=LOOKUP(d, "name3", givenname, "character", "name.gender", return="new.value")
            )]
    d[,NG:=MEAN(d, "ng", 1:3) %>% round(digits)]
    if(log) Print("NG computed.")
  }

  if("NV" %in% index) {
    d[,`:=`(nv1=LOOKUP(d, "name1", givenname, "character", "name.valence", return="new.value"),
            nv2=LOOKUP(d, "name2", givenname, "character", "name.valence", return="new.value"),
            nv3=LOOKUP(d, "name3", givenname, "character", "name.valence", return="new.value")
            )]
    d[,NV:=MEAN(d, "nv", 1:3) %>% round(digits)]
    if(log) Print("NV computed.")
  }

  if("NW" %in% index) {
    d[,`:=`(nw1=LOOKUP(d, "name1", givenname, "character", "name.warmth", return="new.value"),
            nw2=LOOKUP(d, "name2", givenname, "character", "name.warmth", return="new.value"),
            nw3=LOOKUP(d, "name3", givenname, "character", "name.warmth", return="new.value")
            )]
    d[,NW:=MEAN(d, "nw", 1:3) %>% round(digits)]
    if(log) Print("NW computed.")
  }

  if("NC" %in% index) {
    d[,`:=`(nc1=LOOKUP(d, "name1", givenname, "character", "name.competence", return="new.value"),
            nc2=LOOKUP(d, "name2", givenname, "character", "name.competence", return="new.value"),
            nc3=LOOKUP(d, "name3", givenname, "character", "name.competence", return="new.value")
            )]
    d[,NC:=MEAN(d, "nc", 1:3) %>% round(digits)]
    if(log) Print("NC computed.")
  }

  if(return.namechar)
    data=cbind(data, d[,.(name0, name1, name2, name3)])
  data.new=cbind(data, as.data.frame(d)[index]) %>% as.data.table()
  if(return.all)
    return(d)
  else
    return(data.new)
}


compute_NU_char=function(char, year=NA, approx=TRUE) {
  raw=!approx
  if(is.na(char))
    ppm="NA"
  else if(is.na(year))
    ppm=ref0[char]  # overall
  else if(year<1930)
    ppm=ref1[char]  # 1930-1959
  else if(year<1960)
    ppm=ifelse(
      raw | year<1955,
      ref1[char],  # 1930-1959
      (ref1[char]*(1965-year) + ref2[char]*(year-1955))/10
    )
  else if(year<1970)
    ppm=ifelse(
      raw,
      ref2[char],  # 1960-1969
      ifelse(year<1965,
             (ref1[char]*(1965-year) + ref2[char]*(year-1955))/10,
             (ref2[char]*(1975-year) + ref3[char]*(year-1965))/10)
    )
  else if(year<1980)
    ppm=ifelse(
      raw,
      ref3[char],  # 1970-1979
      ifelse(year<1975,
             (ref2[char]*(1975-year) + ref3[char]*(year-1965))/10,
             (ref3[char]*(1985-year) + ref4[char]*(year-1975))/10)
    )
  else if(year<1990)
    ppm=ifelse(
      raw,
      ref4[char],  # 1980-1989
      ifelse(year<1985,
             (ref3[char]*(1985-year) + ref4[char]*(year-1975))/10,
             (ref4[char]*(1995-year) + ref5[char]*(year-1985))/10)
    )
  else if(year<2000)
    ppm=ifelse(
      raw,
      ref5[char],  # 1990-1999
      ifelse(year<1995,
             (ref4[char]*(1995-year) + ref5[char]*(year-1985))/10,
             (ref5[char]*(2005-year) + ref6[char]*(year-1995))/10)
    )
  else if(year<2010)
    ppm=ifelse(
      raw,
      ref6[char],  # 2000-2009 (2008)
      ifelse(year<2005,
             (ref5[char]*(2005-year) + ref6[char]*(year-1995))/10,
             (ref6[char]*(2015-year) + ref7[char]*(year-2005))/10)
    )
  else if(year<2020)
    ppm=ifelse(
      raw,
      ref7[char],  # 2010-2019 (forecast by time-series models)
      ifelse(year<2015,
             (ref6[char]*(2015-year) + ref7[char]*(year-2005))/10,
             (ref7[char]*(2025-year) + ref8[char]*(year-2015))/10)
    )
  else if(year<2030)
    ppm=ref8[char]  # 2020-2029 (forecast by time-series models)
  else
    ppm="NA"
  if(is.na(ppm)) ppm=0
  if(ppm=="NA") ppm=NA
  return(as.numeric( -log10((ppm+1)/10^6) ))
}

