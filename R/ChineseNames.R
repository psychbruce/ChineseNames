#' ChineseNames: Chinese Names Database 1930-2008
#'
#' A database of Han Chinese names provided by \href{https://www.qimingtong.com/}{Beijing Meiming Technology Company}.
#' @references
#' To cite this package if you use the data in your research:
#'
#' Bao, H.-W.-S. (2020). ChineseNames: Chinese Names Database 1930-2008 (R package). Retrieved from \link{https://github.com/psychbruce/ChineseNames}
#' @docType package
#' @name ChineseNames-package
NULL


.onAttach=function(libname, pkgname) {
  if(require(bruceR)==FALSE) devtools::install_github("psychbruce/bruceR")
  Print("
  <<bold <<blue
  \n\n\n<<magenta {rep_char('=', 56)}>>
  Loaded package:
  <<green \u2714 ChineseNames>>
  Citation:
  <<silver
  Bao, H.-W.-S. (2020). ChineseNames: Chinese Names Database 1930-2008 (R package). Retrieved from <<underline https://github.com/psychbruce/ChineseNames>>
  >>>>>>
  ")
}


#### Databases ####

#' Chinese surname database
#' @name familyname
NULL


#' Chinese given-name database (character level)
#' @name givenname
NULL


#' Population for name databases
#' @name population
NULL


#' Top 1000 given names across 31 Chinese mainland provinces
#' @name top1000name.prov
NULL


#' Top 100 given names across 6 birth cohorts (pre-1960 to 2008)
#' @name top100name.year
NULL


#### Functions ####

#' Compute indexes of given names and surnames
#' @import data.table
#' @import stringr
#' @param data \code{data.frame} or \code{data.table}.
#' @param var.fullname A variable (name) of full Chinese names.
#' @param var.birthyear [Optional] A variable (name) of birth year.
#' @param index [Optional] Which indexes to compute?
#'
#' By default, it will compute all available variables.
#' \itemize{
#'   \item NLen: full-name length (2~4).
#'   \item NU: given-name uniqueness (1~6).
#'   \item CCU: character uniqueness in corpus (1~6).
#'   \item NV: given-name valence (1~5).
#'   \item NG: given-name gender (-1~1).
#'   \item SNU: surname uniqueness (1~6).
#'   \item SNI: surname initial (alphabetical order; 1~26).
#' }
#' @param return.namechar Whether to return name characters. Default is \code{FALSE}.
#' @return A \code{data.frame} or \code{data.table} with a series of name indexes appended.
#' @examples
#' demodata
#' compute_name_index(demodata, "name", "birth")  # adjust for birth cohort
#' compute_name_index(demodata, "name")  # no controlling for birth cohort
#' compute_name_index(demodata, "name", return.namechar=T)  # return name chars
#' @export
compute_name_index=function(data=NULL, var.fullname=NULL, var.birthyear=NULL,
                            index=c("NLen",
                                    "NU", "CCU", "NV", "NG",
                                    "SNU", "SNI"),
                            return.namechar=FALSE) {
  if(is.null(data)) stop("Please input your data.")
  if(is.null(var.fullname)) stop("Please input a variable of full names.")

  d=data.table(name=as.data.frame(data)[[var.fullname]])
  d$name=as.character(d$name)
  if(!is.null(var.birthyear)) {
    d=cbind(d, year=as.data.frame(data)[[var.birthyear]])
  } else {
    d=cbind(d, year=NA)
  }

  d[,NLen:=nchar(name)]
  d[,fx:=(str_sub(name, 1, 2) %in% fuxing) & NLen>2]
  d[,name0:=str_sub(name, 1, ifelse(fx, 2, 1))]
  d[,name1:=str_sub(name, ifelse(fx, 3, 2), ifelse(fx, 3, 2))]
  d[,name2:=str_sub(name, ifelse(fx, 4, 3), ifelse(fx, 4, 3))]
  d[,name3:=str_sub(name, ifelse(fx, 5, 4), ifelse(fx, 5, 4))]
  d[,name1:=ifelse(name1=="", NA, name1)]
  d[,name2:=ifelse(name2=="", NA, name2)]
  d[,name3:=ifelse(name3=="", NA, name3)]

  if("NU" %in% index) {
    d[,":="(nu1=mapply(compute_NU, name1, year),
            nu2=mapply(compute_NU, name2, year),
            nu3=mapply(compute_NU, name3, year)
            )]
    d[,NU:=MEAN(d, "nu", 1:3)]
  }

  if("CCU" %in% index) {
    d[,":="(ccu1=LOOKUP(d, "name1", givenname, "character", "corpus.uniqueness", return="new.value"),
            ccu2=LOOKUP(d, "name2", givenname, "character", "corpus.uniqueness", return="new.value"),
            ccu3=LOOKUP(d, "name3", givenname, "character", "corpus.uniqueness", return="new.value")
            )]
    d[,CCU:=MEAN(d, "ccu", 1:3)]
  }

  if("NV" %in% index) {
    d[,":="(nv1=LOOKUP(d, "name1", givenname, "character", "meaning.positivity", return="new.value"),
            nv2=LOOKUP(d, "name2", givenname, "character", "meaning.positivity", return="new.value"),
            nv3=LOOKUP(d, "name3", givenname, "character", "meaning.positivity", return="new.value")
            )]
    d[,NV:=MEAN(d, "nv", 1:3)]
  }

  if("NG" %in% index) {
    d[,":="(ng1=LOOKUP(d, "name1", givenname, "character", "name.gender", return="new.value"),
            ng2=LOOKUP(d, "name2", givenname, "character", "name.gender", return="new.value"),
            ng3=LOOKUP(d, "name3", givenname, "character", "name.gender", return="new.value")
            )]
    d[,NG:=MEAN(d, "ng", 1:3)]
  }

  if("SNU" %in% index) {
    d[,SNU:=LOOKUP(d, "name0", familyname, "surname", "surname.uniqueness", return="new.value")]
  }

  if("SNI" %in% index) {
    d[,SNI:=LOOKUP(d, "name0", familyname, "surname", "initial.rank", return="new.value")]
  }

  if(return.namechar) data=cbind(data, as.data.frame(d)[c("name0", "name1", "name2", "name3")])
  data.new=cbind(data, as.data.frame(d)[index])
  if(is.data.table(data)) data.new=as.data.table(data.new)
  return(data.new)
}


compute_NU=function(char, year=NA) {
  if(is.na(char))
    ppm="NA"
  else if(is.na(year) | year<1930)
    ppm=ref0[char]
  else if(year<1960)
    ppm=ref1[char]  # 1930-1959
  else if(year<1970)
    ppm=ref2[char]  # 1960-1969
  else if(year<1980)
    ppm=ref3[char]  # 1970-1979
  else if(year<1990)
    ppm=ref4[char]  # 1980-1989
  else if(year<2000)
    ppm=ref5[char]  # 1990-1999
  else if(year<2010)
    ppm=ref6[char]  # 2000-2009 (2008)
  else if(year<2020)
    ppm=ref7[char]  # 2010-2019 (forecast by time-series models)
  else if(year<2030)
    ppm=ref8[char]  # 2020-2029 (forecast by time-series models)
  else
    ppm="NA"
  if(is.na(ppm)) ppm=0
  if(ppm=="NA") ppm=NA
  return(as.numeric( -log10((ppm+1)/10^6) ))
}
