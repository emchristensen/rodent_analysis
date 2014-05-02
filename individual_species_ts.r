source('portal_weather/csv_to_dataframe.r')

dat = read.csv("data/Rodents.csv", as.is = TRUE,  colClasses = c(note1='character'))
# There's a real species called NA, so make sure that the NAs are actually "NA"
dat$species[is.na(dat$species)] = "NA"

sp = c("PM")

species = dat[dat$species %in% sp,]
species_count = aggregate(species$yr,
                          by=list(yr=species$yr),
                          FUN=length)


per1 = aggregate(dat$period,by=list(yr= dat$yr,period=dat$period),
                    FUN=length)
periods = aggregate(per1$yr,
                     by=list(yr=per1$yr),
                     FUN=length)

species_count = merge(species_count,periods,by.x='yr',by.y='yr')
plot(species_count$yr,species_count$x.x/species_count$x.y,xlab = '',ylab='animals per census',main=sp)
lines(species_count$yr,species_count$x.x/species_count$x.y)
