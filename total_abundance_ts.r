# This script just looks at total abundance on long term control plots per plot per sampling period through time

# =========================================================================
# Rodent data
dat = read.csv('data/Rodents.csv',as.is=TRUE,colClasses=c(note1='character',
                                                                         tag='character'))

# There's a real species called NA, so make sure that the NAs are actually "NA"
dat$species[is.na(dat$species)] = "NA"

dat1 = dat[dat$period>0,]
datc = dat1[dat1$plot %in% c(2,4,8,11,12,14,17,22),]

periodinfo = read.csv('data/Period_dates_single.csv')

# ====================================================================
# number of plots actually trapped in each period

periods = aggregate(datc$species,by=list(period=datc$period),FUN=length)
nonemptyplots = datc[!datc$note1 %in% c(4,8),]
periodplots = aggregate(nonemptyplots$yr,by=list(period=nonemptyplots$period,plot=nonemptyplots$plot),FUN=length)
plotsperperiod = aggregate(periodplots$plot,by=list(period=periodplots$period),FUN=length)

# =====================================================================
# total abundance through time

periods = merge(periods,plotsperperiod,by='period')
periods$abundperplot = periods$x.x/periods$x.y

periodabund = merge(periods,periodinfo,by='period')
periodabund$date = as.Date(paste(periodabund$yr,periodabund$mo,periodabund$dy,sep='-'))

plot(periodabund$date,periodabund$abundperplot,xlab='',ylab='# rodents per plot',main='Rodent abundance through time')
