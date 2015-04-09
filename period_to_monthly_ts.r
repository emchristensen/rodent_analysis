# This function takes rodent data taken at irregular "periods" and puts it in timeseries form
# with regular spacing between time steps


source('rodent_analysis/get_period_dates.r')

library(sqldf)

period_to_ts = function(dat) {

  pframe = get_period_dates(dat)
  #pframe$date = as.Date(paste(pframe$yr,pframe$mo,pframe$dy,sep='-'))
  start = head(pframe,1)
  end = tail(pframe,1)
  desired_dates = data.frame(date=seq.Date(from=as.Date('1977-07-15'),
                      to=as.Date(paste(end$yr,end$mo,end$dy,sep='-')),
                      by='month'))
  
  # create frame with period, month, year
  p = vector()
  for (ind in seq(length(desired_dates$date))) {
    d = desired_dates$date[ind]
    p[ind] = max(0,pframe$period[which(pframe$date<=d+15 & pframe$date>=d-14)])
  }
  desired_dates$period = p
  
  count_period = aggregate(dat$yr,
                           by=list(period=dat$period),
                           FUN=length)
  
  count_ts = sqldf("SELECT * 
                      FROM desired_dates
                      LEFT JOIN count_period USING(period)")
  countts = ts(count_ts$x,start=c(1977,7),end=c(end$yr,end$mo),freq=12)
  return(countts)
}
