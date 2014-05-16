source('rodent_analysis/just_new_captures.r')
source('portal_weather/period_to_monthly_ts.r')

dat = read.csv("data/Rodents.csv", as.is = TRUE,  colClasses = c(note1='character'))
# There's a real species called NA, so make sure that the NAs are actually "NA"
dat$species[is.na(dat$species)] = "NA"

sp = c("DM")

species = dat[dat$species %in% sp,]
newsp = just_new_captures(species)


newsp_period = aggregate(newsp$yr,
                         by=list(period=newsp$period),
                         FUN=length)
newsp_ts = periods_to_ts(newsp)
