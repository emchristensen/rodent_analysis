# This script is intended to plot species abundance through time for a single species


source('rodent_analysis/get_rodent_data.r')

dat = get_rodent_data('controls',seq(1977,2014))

dat = dat[dat$period>0,]

period_dates = read.csv('data/Period_dates_single.csv')

#========================================================================================
# aggregate by period

sp = c("DM")

species = dat[dat$species %in% sp,]
species_count = aggregate(species$yr,
                          by=list(period=species$period),
                          FUN=length)

species_count = merge(species_count,period_dates,by='period')
species_count$date = as.Date(paste(species_count$yr,species_count$mo,species_count$dy,sep='-'))

plot(species_count$date,species_count$x,xlab = '',ylab='animals per census',main=sp)
lines(species_count$date,species_count$x)
