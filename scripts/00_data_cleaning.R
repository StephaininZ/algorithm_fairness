#### Preamble ####
# Purpose: This script produces the cleaned data for further analysis
# author: "Yingying Zhou"
# Data: 15 April 2021
# Contact: yingying.zhou@utoronto.ca
# License: MIT
# Pre-requisites: 
# - None


#### Workspace setup ####
library(tidyverse)
library(haven)
library(dplyr)
library(here) # locate the file path
library(tibble)
library(tidyr)
library(DescTools)

# load data
oped <- haven::read_stata(here::here("inputs/data/oped-desc.dta"))

###--------------------------------------------
### data cleaning: select variables of interest
###--------------------------------------------
oped_df <- oped %>% 
  select(c(starts_with(c("lawsuitspr", "posneg","damaging","recscale","recyesno","sqseen"))), response_id, cf, fat, sqshw, sqopt, sqhid, hiringfirst, female, white, black, asian, otherethn, workdecisions, eduprepared, knowsml, hispanic, consrv_std) %>%
  select(-contains("growth")) %>%   # drop "growth" related columns
  add_column(sqseen_post_first=NA, .after="sqseen_pre_second") %>%  # add 2 NA columns for sqseen to balance the dataframe
  add_column(sqseen_post_second=NA, .after="sqseen_post_first")

###---------------------------------------------------
### data cleaning: convert dataframe from wide to long
###---------------------------------------------------
oped_df_long <- as.data.frame(oped_df) %>% 
  reshape(direction="long",
          varying=c(1:24),
          timevar="first_str",
          times=c("_pre_first","_pre_second","_post_first","_post_second"),
          v.names=c("lawsuitspr","posneg","damaging","recscale","recyesno","sqseen"),
          sep="_",
          idvar="response_id",
          new.row.names = 1:1992)

###-------------------------------------------------------------------
### data cleaning: create indicator variables "first", "pos", "hiring"
###-------------------------------------------------------------------

# first=1 if "first" is in value for first_str
library(DescTools)
oped_df_long["first"] <- ifelse(StrPos(oped_df_long$first_str,"first")>0, 1, 0)
oped_df_long$first[is.na(oped_df_long$first)] <- 0

# update variable value for "cf", "fat"
oped_df_long[oped_df_long$first==1, "cf"] <- 0
oped_df_long[oped_df_long$first==1, "fat"] <- 0

# pos=1 if "post" is in value for first_str
oped_df_long["pos"] <- ifelse(StrPos(oped_df_long$first_str, "post")>0, 1, 0)
oped_df_long$pos[is.na(oped_df_long$pos)] <- 0

# create vairable hiring
oped_df_long$hiring <- ifelse(oped_df_long$hiringfirst==1 & oped_df_long$first==1, 1, 0)
oped_df_long[oped_df_long$hiringfirst==0 & oped_df_long$first==0, "hiring"] <- 1


###----------------------------------------
### data cleaning: create interaction terms
###----------------------------------------
oped_df_long$cf_sqshw <- oped_df_long$cf * oped_df_long$sqshw
oped_df_long$cf_sqopt <- oped_df_long$cf * oped_df_long$sqopt
oped_df_long$cf_sqhid <- oped_df_long$cf * oped_df_long$sqhid
oped_df_long$cf_pos <- oped_df_long$cf * oped_df_long$pos

oped_df_long$fat_sqshw <- oped_df_long$fat * oped_df_long$sqshw
oped_df_long$fat_sqopt <- oped_df_long$fat * oped_df_long$sqopt
oped_df_long$fat_sqhid <- oped_df_long$fat * oped_df_long$sqhid
oped_df_long$fat_pos <- oped_df_long$fat * oped_df_long$pos

oped_df_long$hiring_pos <- oped_df_long$hiring * oped_df_long$pos
oped_df_long$sqshw_pos <- oped_df_long$sqshw * oped_df_long$pos
oped_df_long$sqopt_pos <- oped_df_long$sqopt * oped_df_long$pos

###-------------------------------------------------------
### data cleaning: create standardized dependent variables
###-------------------------------------------------------
oped_df_long$posneg_std <- (oped_df_long$posneg-mean(oped_df_long$posneg)) / sd(oped_df_long$posneg)
oped_df_long$lawsuitspr_std <- (oped_df_long$lawsuitspr-mean(oped_df_long$lawsuitspr)) / sd(oped_df_long$lawsuitspr)
oped_df_long$damaging_std <- (oped_df_long$damaging-mean(oped_df_long$damaging)) / sd(oped_df_long$damaging)
oped_df_long$recscale_std <- (oped_df_long$recscale-mean(oped_df_long$recscale)) / sd(oped_df_long$recscale)
oped_df_long$recyesno_std <- (oped_df_long$recyesno-mean(oped_df_long$recyesno)) / sd(oped_df_long$recyesno)
oped_df_long$sqseen_std <- (oped_df_long$sqseen-mean(oped_df_long$sqseen)) / sd(oped_df_long$sqseen)

###-------------------------------------------------------
### data cleaning: save to csv
###-------------------------------------------------------
write_csv(oped_df_long, "inputs/data/clean_df")
