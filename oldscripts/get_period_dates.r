# This script uses the rodent database to extract a date for each trapping period.
# The data frame is then saved as a csv in the data folder for future reference.

get_period_dates = function(dat) {
  
  # This function extracts the dates of each trapping period (for periods > 0)
  
  periods = dat[dat$period > 0,]              # remove non-census trapping events (period < 0)
  periods = periods[,c('mo','dy','yr','period')] #extract only date/period information
  periods = unique(periods)                   # reduce to unique mo/dy/yr/period lines
  pframe = data.frame()
  for (p in unique(periods$period)) {
    pframe = rbind(pframe,periods[which.max(periods$period==p),]) # finds a single date of each period
  }
  pframe$date = as.Date(paste(pframe$yr,pframe$mo,pframe$dy,sep='-'))
  return(pframe)
}

dat = read.csv('data/Rodents.csv')
pframe = get_period_dates(dat)

# ===========================================================================
# find number of plots trapped per period

trapped = dat[!dat$note1 %in% c(4,8),]
count_per_plot = aggregate(trapped$plot,
                           by=list(period=trapped$period,plot=trapped$plot),
                           FUN=length)

plot_per_period = aggregate(count_per_plot$plot,
                            by=list(period=count_per_plot$period),
                            FUN=length)
# ===========================================================================

pframe = merge(pframe,plot_per_period,by='period')
names(pframe) = c('period','mo','dy','yr','date','plots')

write.csv(pframe,file='data/Period_dates_single.csv',row.names=F)

#rm(list=ls(all=TRUE))