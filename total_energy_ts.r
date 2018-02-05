# This script plots total rodent energy over time
# This script will no longer work -- data folder has been removed



library(dplyr)

dat = read.csv('data/monthly_E_controls.csv')

dat = dat[,names(dat) != 'period']

totals = rowSums(dat)
totalE = data.frame(total = totals,period = rownames(dat))

periodinfo = read.csv('data/Period_dates_single.csv')
periodinfo$date = as.Date(periodinfo$date,format='%m/%d/%Y')
totalE = merge(totalE,periodinfo,by='period')
totalE = filter(totalE,plots>22)

totalE = totalE[order(totalE$date),]

# =================================================
# plot

plot(totalE$date,totalE$total,xlab='',ylab='Total energy',main='Total energy through time')
abline(h=mean(totalE$total))


plot(totalE$date,log(totalE$total),xlab='',ylab='Total energy',main='Total energy through time')
lines(totalE$date,log(totalE$total))
abline(h=mean(log(totalE$total)))
abline(h=mean(log(totalE$total))-2*sd(log(totalE$total)),lty=3)
abline(h=mean(log(totalE$total))+2*sd(log(totalE$total)),lty=3)

# extreme low events
extreme = totalE[log(totalE$total)<(mean(log(totalE$total))-2*sd(log(totalE$total))),]
points(extreme$date,log(extreme$total),col='red',pch=20)
