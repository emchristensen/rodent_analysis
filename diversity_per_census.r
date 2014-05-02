source('portal_weather/csv_to_dataframe.r')

dat = read.csv("data/Rodents.csv", as.is = TRUE,  colClasses = c(note1='character'))
# There's a real species called NA, so make sure that the NAs are actually "NA"
dat$species[is.na(dat$species)] = "NA"

dat = dat[dat$period>0,]

species_count = aggregate(dat$yr,
                          by=list(yr = dat$yr,period=dat$period,species=dat$species),                          
                          FUN=length)

sp_per_period = aggregate(species_count$x,
                          by=list(period=species_count$period,yr=species_count$yr),
                          FUN=length)

sp_per_year = aggregate(species_count$x,
                        by=list(yr=species_count$yr),
                        FUN=length)


per1 = aggregate(dat$period,by=list(yr= dat$yr,period=dat$period),
                 FUN=length)
periods = aggregate(per1$yr,
                    by=list(yr=per1$yr),
                    FUN=length)

species_count = merge(species_count,periods,by.x='yr',by.y='yr')
plot(species_count$yr,species_count$x.x/species_count$x.y,xlab = '',ylab='animals per census',main=sp)
lines(species_count$yr,species_count$x.x/species_count$x.y)
