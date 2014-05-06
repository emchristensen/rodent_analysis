source('portal_weather/csv_to_dataframe.r')

dat = read.csv("data/Rodents.csv", as.is = TRUE,  colClasses = c(note1='character'))
# There's a real species called NA, so make sure that the NAs are actually "NA"
dat$species[is.na(dat$species)] = "NA"

sp = c("PP")

species = dat[dat$species %in% sp,]
species_count = aggregate(species$yr,
                          by=list(period=species$period),
                          FUN=length)
perioddates = csv_to_dataframe('data/Period_dates.csv')


species_count = merge(species_count,perioddates,by.x='period',by.y='period')

species_count$datetime = as.POSIXct(paste(species_count$yr,species_count$mo,species_count$dy),
                                    format='%Y%m%d')

plot(species_count$datetime,species_count$x,xlab = '',ylab='animals per census',main=sp)
lines(species_count$datetime,species_count$x)
