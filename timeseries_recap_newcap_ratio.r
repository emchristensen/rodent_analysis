# This script looks at the ratio of recaptures to new captures
#
#
# Script dependencies:
#     just_new_captures.r       function that creates data frame containing only new captures
#     period_to_monthly_ts.r    ??
#     get_period_dates.r        function that extracts a date (one of the two days if two-day trapping period)
#                                   from the rodent database


source('rodent_analysis/just_new_captures.r')
source('portal_weather/period_to_monthly_ts.r')

dat = read.csv("data/Rodents.csv", as.is = TRUE,  colClasses = c(note1='character'))
# There's a real species called NA, so make sure that the NAs are actually "NA"
dat$species[is.na(dat$species)] = "NA"

dat = dat[dat$period > 0,]

sp = c("PP")

species = dat[dat$species %in% sp,]
newsp = just_new_captures(species)


newsp_period = aggregate(newsp$yr,
                         by=list(period=newsp$period),
                         FUN=length)
newsp_ts = period_to_ts(newsp)
plot(newsp_ts)

# ======================================================================
# ratio of new caputures to total captures
newsp_ts[is.na(newsp_ts)]=0

allsp_ts = period_to_ts(species)
allsp_ts[is.na(allsp_ts)]=0

sp_ratio = newsp_ts/allsp_ts

sp_ratio.w = window(sp_ratio,start=c(2005,1),end=c(2014,4))
sp_ratio.w[is.na(sp_ratio.w)]=0
plot(sp_ratio.w)

sp_ratio.smooth = SMA(sp_ratio.w,12)
lines(sp_ratio.smooth,col='red')
