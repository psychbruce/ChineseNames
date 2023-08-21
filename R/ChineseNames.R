#' ChineseNames: Chinese Name Database 1930-2008
#'
#' @description
#' A database of Chinese surnames and Chinese given names (1930-2008).
#' This database contains nationwide frequency statistics of
#' 1,806 Chinese surnames and 2,614 Chinese characters used in given names,
#' covering about 1.2 billion Han Chinese population
#' (96.8\% of the Han Chinese household-registered population
#' born from 1930 to 2008 and still alive in 2008).
#' This package also contains a function for computing multiple features of
#' Chinese surnames and Chinese given names for scientific research (e.g.,
#' name uniqueness, name gender, name valence, and name warmth/competence).
#'
#' @details
#' Details are described in
#' \url{https://psychbruce.github.io/ChineseNames/}
#'
#' @note
#' This database does not contain any individual-level information
#' (so it does not leak personal privacy).
#' All data are at the name level or character level.
#' Extremely rare characters are not included.
#'
#' @source
#' This database was provided by Beijing Meiming Science and Technology Company (in collaboration) and
#' originally obtained from the National Citizen Identity Information Center (NCIIC) of China in 2008.
#'
"_PACKAGE"


.onAttach = function(libname, pkgname) {
  inst.ver = as.character(utils::packageVersion("ChineseNames"))
  pkg.date = substr(utils::packageDate("ChineseNames"), 1, 4)
  packageStartupMessage(glue::glue_col("

  {magenta ChineseNames (v{inst.ver})}
  {blue Chinese Name Database 1930-2008}

  {magenta Online documentation:}
  {underline https://psychbruce.github.io/ChineseNames}

  {magenta To use this package in publications, please cite:}
  Bao, H.-W.-S. ({pkg.date}). "),
  glue::glue_col("{italic ChineseNames: Chinese Name Database 1930-2008}"),
  glue::glue_col(" (Version {inst.ver}) [Computer software]. "),
  glue::glue_col("{underline https://CRAN.R-project.org/package=ChineseNames}"),
  "\n")
}


#### Database ####


#' 1,806 Chinese surnames and nationwide frequency.
#'
#' @name familyname
#' @usage data(familyname)
#' @format A data frame with 7 variables:
#' \describe{
#'   \item{\code{surname}}{surname (in Chinese)}
#'   \item{\code{compound}}{0 = single surname, 1 = compound surname}
#'   \item{\code{initial}}{initial letter (a-z)}
#'   \item{\code{initial.rank}}{initial order (1-26)}
#'   \item{\code{n.1930_2008}}{total counts in the database}
#'   \item{\code{ppm.1930_2008}}{proportion in population (ppm = parts per million)}
#'   \item{\code{surname.uniqueness}}{surname uniqueness}
#' }
#' @details \url{https://psychbruce.github.io/ChineseNames/}
NULL


#' 2,614 Chinese characters used in given names and nationwide frequency.
#'
#' @name givenname
#' @usage data(givenname)
#' @format A data frame with 25 variables:
#' \describe{
#'   \item{\code{character}}{character used in given names (in Chinese)}
#'   \item{\code{pinyin}}{pinyin (pronunciation)}
#'   \item{\code{bihua}}{number of strokes in a character}
#'   \item{\code{n.male}}{total counts in male}
#'   \item{\code{n.female}}{total counts in female}
#'   \item{\code{name.gender}}{difference in proportions of a character used by male vs. female}
#'   \item{\code{n.1930_1959}, \code{n.1960_1969}, \code{n.1970_1979}, \code{n.1980_1989}, \code{n.1990_1999}, \code{n.2000_2008}}{total counts in a birth cohort}
#'   \item{\code{ppm.1930_1959}, \code{ppm.1960_1969}, \code{ppm.1970_1979}, \code{ppm.1980_1989}, \code{ppm.1990_1999}, \code{ppm.2000_2008}}{proportion (parts per million) in a birth cohort}
#'   \item{\code{name.ppm}}{average ppm (parts per million) across all cohorts}
#'   \item{\code{name.uniqueness}}{name-character uniqueness (in naming practices)}
#'   \item{\code{corpus.ppm}}{proportion (parts per million) in contemporary Chinese corpus}
#'   \item{\code{corpus.uniqueness}}{character-corpus uniqueness (in contemporary Chinese corpus)}
#'   \item{\code{name.valence}}{name valence (positivity of character meaning) (based on subjective ratings from 16 raters, ICC = 0.921)}
#'   \item{\code{name.warmth}}{name warmth/morality (based on subjective ratings from 10 raters, ICC = 0.774)}
#'   \item{\code{name.competence}}{name competence/assertiveness (based on subjective ratings from 10 raters, ICC = 0.712)}
#' }
#' @details \url{https://psychbruce.github.io/ChineseNames/}
NULL


#' Population statistics for the Chinese name database.
#' @name population
#' @usage data(population)
#' @details \url{https://psychbruce.github.io/ChineseNames/}
NULL


#' Top 1,000 given names in 31 Chinese mainland provinces.
#' @name top1000name.prov
#' @usage data(top1000name.prov)
#' @details \url{https://psychbruce.github.io/ChineseNames/}
NULL


#' Top 100 given names in 6 birth cohorts.
#' @name top100name.year
#' @usage data(top100name.year)
#' @details \url{https://psychbruce.github.io/ChineseNames/}
NULL


#' Top 50 given-name characters in 6 birth cohorts.
#' @name top50char.year
#' @usage data(top50char.year)
#' @details \url{https://psychbruce.github.io/ChineseNames/}
NULL


#### Functions ####


`%>%` = dplyr::`%>%`


#' Compute multiple features of surnames and given names.
#'
#' @description
#' Compute all available name features (indices) based on
#' \code{\link{familyname}} and \code{\link{givenname}}.
#' You can either input a data frame
#' with a variable of Chinese full names
#' (and a variable of birth years, if necessary)
#' or just input a vector of full names
#' (and a vector of birth years, if necessary).
#'
#' \itemize{
#'   \item Usage 1: Input a single value or a vector of \code{name} [and \code{birth}, if necessary].
#'   \item Usage 2: Input a data frame of \code{data}
#'   and the variable name of
#'   \code{var.fullname} (or \code{var.surname} and/or \code{var.givenname})
#'   [and \code{var.birthyear}, if necessary].
#' }
#'
#' \emph{Caution.} Name-character uniqueness (NU) for birth year >= 2010
#' is estimated by forecasting and thereby may not be accurate.
#'
#' @param data Data frame.
#' @param var.fullname Variable name of Chinese full names (e.g., \code{"name"}).
#' @param var.surname Variable name of Chinese surnames (e.g., \code{"surname"}).
#' @param var.givenname Variable name of Chinese given names (e.g., \code{"givenname"}).
#' @param var.birthyear Variable name of birth year (e.g., \code{"birth"}).
#' @param name If no \code{data}, you can just input a vector of full name(s).
#' @param birth If no \code{data}, you can just input a vector of birth year(s).
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
#' For details, see \url{https://psychbruce.github.io/ChineseNames/}
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
#' A new data frame (of class \code{data.table}) with name indices appended.
#' Full names are split into \code{name0} (surnames, with compound surnames automatically detected),
#' \code{name1}, \code{name2}, and \code{name3} (given-name characters).
#'
#' @note
#' For details and examples, see \url{https://psychbruce.github.io/ChineseNames/}
#'
#' @examples
#' ## Prepare ##
#' sn = familyname$surname[1:12]
#' gn = c(top100name.year$name.all.1960[1:6],
#'        top100name.year$name.all.2000[1:6],
#'        top100name.year$name.all.1960[95:100],
#'        top100name.year$name.all.2000[95:100])
#' demodata = data.frame(name=paste0(sn, gn),
#'                       birth=c(1960:1965, 2000:2005,
#'                               1960:1965, 2000:2005))
#' demodata
#'
#' ## Compute ##
#' newdata = compute_name_index(demodata,
#'                              var.fullname="name",
#'                              var.birthyear="birth")
#' newdata
#'
#' @import data.table
#' @importFrom bruceR dtime Print MEAN LOOKUP
#' @export
compute_name_index = function(
    data=NULL,
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
    return.all=FALSE
) {
  ## Prepare ##

  if(!is.null(data)) log = (nrow(data)>=1000) else log = FALSE
  t0 = Sys.time()

  familyname = ChineseNames::familyname
  givenname = ChineseNames::givenname

  fuxing = familyname[familyname$compound==1, "surname"]
  ref0 = data.table(char=givenname$character, code=0, ppm=givenname$name.ppm)
  ref1 = data.table(char=givenname$character, code=1, ppm=givenname$ppm.1930_1959)
  ref2 = data.table(char=givenname$character, code=2, ppm=givenname$ppm.1960_1969)
  ref3 = data.table(char=givenname$character, code=3, ppm=givenname$ppm.1970_1979)
  ref4 = data.table(char=givenname$character, code=4, ppm=givenname$ppm.1980_1989)
  ref5 = data.table(char=givenname$character, code=5, ppm=givenname$ppm.1990_1999)
  ref6 = data.table(char=givenname$character, code=6, ppm=givenname$ppm.2000_2008)
  ref.long = rbind(ref0, ref1, ref2, ref3, ref4, ref5, ref6)

  ## Initialize ##

  `.` = NULL
  NLen = SNU = SNI = NU = CCU = NG = NV = NW = NC = NULL
  fx = sur.name = given.name = full.name = name0 = name1 = name2 = name3 = NULL

  ## Main ##

  if(is.na(name)==FALSE) {
    data = data.frame(name=name, birth=birth)
    var.fullname = "name"
    var.birthyear = "birth"
  }
  if(is.null(data))
    stop("Please input your data.")
  if(is.null(var.fullname) & is.null(var.surname) & is.null(var.givenname))
    stop("Please input variable(s) of full/family/given names.")

  data = as.data.frame(data)
  if(!is.null(var.fullname)) {
    d = data.table(full.name=data[[var.fullname]])
    d[, NLen := nchar(full.name)]
    d[, sur.name := substr(full.name, 1,
                           ifelse((substr(full.name, 1, 2) %in% fuxing) & NLen>2,
                                  2, 1))]
    d[, given.name := substr(full.name, nchar(sur.name)+1, NLen)]
  } else {
    if(!is.null(var.surname) & !is.null(var.givenname)) {
      d = data.table(sur.name=data[[var.surname]], given.name=data[[var.givenname]])
    } else {
      if(!is.null(var.surname))
        d = data.table(sur.name=data[[var.surname]], given.name="")
      if(!is.null(var.givenname))
        d = data.table(sur.name="", given.name=data[[var.givenname]])
    }
    d[, full.name := paste0(sur.name, given.name)]
    d[, NLen := nchar(full.name)]
  }
  d[, name0 := sur.name]
  d[, name1 := substr(given.name, 1, 1)]
  d[, name2 := substr(given.name, 2, 2)]
  d[, name3 := substr(given.name, 3, 3)]

  if(!is.null(var.birthyear))
    d = cbind(d, year=data[[var.birthyear]])
  else
    d = cbind(d, year=NA)

  d = d[,.(name0, name1, name2, name3, year, NLen)]

  if(log) Print("Data preprocessed ({dtime(t0)}).")

  if("SNU" %in% index) {
    t0 = Sys.time()
    d[, SNU := LOOKUP(d, "name0", familyname, "surname", "surname.uniqueness", return="new.value") %>% round(digits)]
    if(log) Print("SNU computed ({dtime(t0)}).")
  }

  if("SNI" %in% index) {
    t0 = Sys.time()
    d[, SNI := LOOKUP(d, "name0", familyname, "surname", "initial.rank", return="new.value")]
    if(log) Print("SNI computed ({dtime(t0)}).")
  }

  if("NU" %in% index) {
    t0 = Sys.time()
    d[, `:=`(
      nu1 = compute_NU_char(d, ref.long, "name1", "year", NU.approx),
      nu2 = compute_NU_char(d, ref.long, "name2", "year", NU.approx),
      nu3 = compute_NU_char(d, ref.long, "name3", "year", NU.approx)
    )]
    d[, NU := MEAN(d, "nu", 1:3) %>% round(digits)]
    if(log) Print("NU computed ({dtime(t0)}).")
  }

  if("CCU" %in% index) {
    t0 = Sys.time()
    d[, `:=`(
      ccu1 = LOOKUP(d, "name1", givenname, "character", "corpus.uniqueness", return="new.value"),
      ccu2 = LOOKUP(d, "name2", givenname, "character", "corpus.uniqueness", return="new.value"),
      ccu3 = LOOKUP(d, "name3", givenname, "character", "corpus.uniqueness", return="new.value")
    )]
    d[, CCU := MEAN(d, "ccu", 1:3) %>% round(digits)]
    if(log) Print("CCU computed ({dtime(t0)}).")
  }

  if("NG" %in% index) {
    t0 = Sys.time()
    d[, `:=`(
      ng1 = LOOKUP(d, "name1", givenname, "character", "name.gender", return="new.value"),
      ng2 = LOOKUP(d, "name2", givenname, "character", "name.gender", return="new.value"),
      ng3 = LOOKUP(d, "name3", givenname, "character", "name.gender", return="new.value")
    )]
    d[, NG := MEAN(d, "ng", 1:3) %>% round(digits)]
    if(log) Print("NG computed ({dtime(t0)}).")
  }

  if("NV" %in% index) {
    t0 = Sys.time()
    d[, `:=`(
      nv1 = LOOKUP(d, "name1", givenname, "character", "name.valence", return="new.value"),
      nv2 = LOOKUP(d, "name2", givenname, "character", "name.valence", return="new.value"),
      nv3 = LOOKUP(d, "name3", givenname, "character", "name.valence", return="new.value")
    )]
    d[, NV := MEAN(d, "nv", 1:3) %>% round(digits)]
    if(log) Print("NV computed ({dtime(t0)}).")
  }

  if("NW" %in% index) {
    t0 = Sys.time()
    d[, `:=`(
      nw1 = LOOKUP(d, "name1", givenname, "character", "name.warmth", return="new.value"),
      nw2 = LOOKUP(d, "name2", givenname, "character", "name.warmth", return="new.value"),
      nw3 = LOOKUP(d, "name3", givenname, "character", "name.warmth", return="new.value")
    )]
    d[, NW := MEAN(d, "nw", 1:3) %>% round(digits)]
    if(log) Print("NW computed ({dtime(t0)}).")
  }

  if("NC" %in% index) {
    t0 = Sys.time()
    d[, `:=`(
      nc1 = LOOKUP(d, "name1", givenname, "character", "name.competence", return="new.value"),
      nc2 = LOOKUP(d, "name2", givenname, "character", "name.competence", return="new.value"),
      nc3 = LOOKUP(d, "name3", givenname, "character", "name.competence", return="new.value")
    )]
    d[, NC := MEAN(d, "nc", 1:3) %>% round(digits)]
    if(log) Print("NC computed ({dtime(t0)}).")
  }

  if(return.namechar)
    data = cbind(data, d[,.(name0, name1, name2, name3)])
  data.new = cbind(data, as.data.frame(d)[index]) %>% as.data.table()
  if(return.all)
    return(d)
  else
    return(data.new)
}


#' @importFrom bruceR LOOKUP
compute_NU_char = function(data, ref.long, var.char, var.year=NULL, approx=TRUE) {
  ppm1 = ppm2 = weight1 = weight2 = NULL
  if(is.null(var.year)) {
    ppm = LOOKUP(data, var.char,
                 ChineseNames::givenname, "character", "name.ppm",
                 return="new.value")
  } else {
    d = as.data.frame(data)[c(var.char, var.year)]
    names(d) = c("char", "year")
    d$code = car::recode(
      d$year, "lo:1929=1; 1930:1959=1; 1960:1969=2; 1970:1979=3; 1980:1989=4; 1990:1999=5; 2000:2009=6; else=0")
    d$code1 = car::recode(
      d$year, "lo:1954=1; 1955:1964=1; 1965:1974=2; 1975:1984=3; 1985:1994=4; 1995:2004=5; 2005:2009=6; else=0")
    d$code2 = car::recode(
      d$year, "lo:1954=1; 1955:1964=2; 1965:1974=3; 1975:1984=4; 1985:1994=5; 1995:2004=6; 2005:2009=6; else=0")
    d$weight1 = 5 - (d$year %% 10)
    d$weight1 = ifelse(d$weight1 > 0, d$weight1, 10 + d$weight1)
    d$weight1 = ifelse(is.na(d$weight1), 5, d$weight1)
    d$weight2 = 10 - d$weight1
    if(approx==FALSE) {
      d$ppm = LOOKUP(d, c("char", "code"), ref.long, c("char", "code"), "ppm", return="new.value")
    } else {
      d$ppm1 = LOOKUP(d, c("char", "code1"), ref.long, c("char", "code"), "ppm", return="new.value")
      d$ppm2 = LOOKUP(d, c("char", "code2"), ref.long, c("char", "code"), "ppm", return="new.value")
      d = dplyr::mutate(d, ppm=(ppm1*weight1+ppm2*weight2)/10)
    }
  }
  d$ppm = ifelse(is.na(d$ppm) & !is.na(d$char) & d$char != "", 0, d$ppm)
  return(as.numeric( -log10((d$ppm+1) / 10^6) ))
}
