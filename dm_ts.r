source('portal_weather/csv_to_dataframe.r')
source('portal_weather/period_to_monthly_ts.r')

library(TTR)

dat = read.csv("data/Rodents.csv", as.is = TRUE,  colClasses = c(note1='character'))
# There's a real species called NA, so make sure that the NAs are actually "NA"
dat$species[is.na(dat$species)] = "NA"

# restrict plots to controls only
#dat = dat[dat$plot %in% c(1,2,4,8,9,11,12,14,17,22),]
#krat exclosures only
#dat = dat[dat$plot %in% c(3,6,13,15,18,19,20,21),]

sp = c("DM")

species = dat[dat$species %in% sp,]
species_count_period = aggregate(species$yr,
                                 by=list(period=species$period),
                                 FUN=length)

perioddates = get_period_dates(species)

species_count_period = merge(species_count_period,perioddates,by.x='period',by.y='period')

species_count_period$datetime = as.POSIXct(paste(species_count_period$yr,
                                                 species_count_period$mo,
                                                 species_count_period$dy),
                                           format='%Y%m%d')

species_count_yr = aggregate(species$yr,
                             by=list(yr=species$yr),
                             FUN=length)

per1 = aggregate(dat$period,by=list(yr= dat$yr,period=dat$period),
                 FUN=length)
periods = aggregate(per1$yr,
                    by=list(yr=per1$yr),
                    FUN=length)
species_count_yr = merge(species_count_yr,periods,by.x='yr',by.y='yr')

plot(species_count_period$datetime,species_count_period$x,xlab = '',ylab='animals per census',main=sp)
lines(species_count_period$datetime,species_count_period$x)

plot(species_count_yr$yr,species_count_yr$x.x/species_count_yr$x.y)
lines(species_count_yr$yr,species_count_yr$x.x/species_count_yr$x.y)

# convert to regular timeseries -------------------------------------------------------------------
species_count_ts = periods_to_ts(species)
dm_ts = ts(species_count_ts$x,
           start=c(as.integer(format(head(species_count_ts$date,1),'%Y')),
                   as.integer(format(head(species_count_ts$date,1),'%m'))),
           end=c(as.integer(format(tail(species_count_ts$date,1),'%Y')),
                 as.integer(format(tail(species_count_ts$date,1),'%m'))),
           freq=12)

dm_approx = na.approx(dm_ts)

# extracting trends-----------------------------------------------------------------------------
time_lm = lm(species_count_ts$x~species_count_ts$date)
summary(time_lm)
abline(time_lm)

# smoothing -----------------------------------------------------------------------------------
dm_smooth = SMA(dm_approx,12)
plot(dm_smooth)

#decompose ---------------------------------------------------------------------------
dm_decom = decompose(dm_approx)
plot(dm_decom)
