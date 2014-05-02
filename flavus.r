source('portal_weather/csv_to_dataframe.r')

dat = read.csv("data/Rodents.csv", as.is = TRUE,  colClasses = c(note1='character'))
# There's a real species called NA, so make sure that the NAs are actually "NA"
dat$species[is.na(dat$species)] = "NA"

sp = "PM"

flavus = dat[dat$species==sp,]
flavus_count = aggregate(flavus$yr,
                          by=list(yr=flavus$yr),
                          FUN=length)


per1 = aggregate(dat$period,by=list(yr= dat$yr,period=dat$period),
                    FUN=length)
periods = aggregate(per1$yr,
                     by=list(yr=per1$yr),
                     FUN=length)

flavus_count = merge(flavus_count,periods,by.x='yr',by.y='yr')
plot(flavus_count$yr,flavus_count$x.x/flavus_count$x.y,xlab = '',ylab='animals per census',main=sp)
lines(flavus_count$yr,flavus_count$x.x/flavus_count$x.y)
