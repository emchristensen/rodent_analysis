# This script plots total rodent energy over time


dat = read.csv('data/monthly_E_controls.csv')

dat = dat[,names(dat) != 'period']

totals = rowSums(dat)
totalE = data.frame(total = totals,period = rownames(dat))

periodinfo = read.csv('data/Period_dates_single.csv')
totalE = merge(totalE,periodinfo,by='period')

# =================================================
# plot

plot(as.Date(totalE$date),totalE$total,xlab='',ylab='Total energy',main='Total energy through time')
