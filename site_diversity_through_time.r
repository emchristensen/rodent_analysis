# This script plots species diversity over time -- control plots

library(vegan)
setwd('C:/Users/EC/Desktop/git')
# =============================================================================
# read in rodent data
totA = read.csv("data/monthly_A_controls.csv")
totA = totA[,names(totA) != 'period']

#dat = read.csv("PortalData/Rodents/Portal_rodent.csv", as.is = TRUE,  colClasses = c(note1='character'),na.strings = '')


#dat = dat[dat$period>0,]

# only rodent species, no unknowns
#allspecies = c('DM','DS','NA','PE','PF','PP','DO','OL','OT','RM','PM','SH','PH','RF','SF','BA','SO','PI','PB','PL','RO')
#dat = dat[dat$species %in% allspecies,]

periodinfo = read.csv('data/Period_dates_single.csv')
periodinfo$date = as.Date(paste(periodinfo$yr,periodinfo$mo,periodinfo$dy,sep='-'))

# =============================================================================
# find  number of species per period

species_count = apply(totA,1,function(c)length(c[c>0]))
#species_count = aggregate(dat$yr,
#                          by=list(period=dat$period,species=dat$species),                          
#                          FUN=length)

#sp_per_period = aggregate(species_count$species,
#                          by=list(period=species_count$period),
#                          FUN=length)

# ===========================================================================
# find number of plots trapped per period

#trapped = dat[!dat$note1 %in% c(4,8),]
#count_per_plot = aggregate(trapped$plot,
#                           by=list(period=trapped$period,plot=trapped$plot),
#                           FUN=length)

#plot_per_period = aggregate(count_per_plot$plot,
#                            by=list(period=count_per_plot$period),
#                            FUN=length)

# ==============================================================================
# normalize species diversity per period by number of plots trapped each period

#sp_diversity = merge(sp_per_period,plot_per_period,by='period')
#names(sp_diversity) = c('period','species','plots')
#sp_diversity$sp_plot = sp_diversity$species/sp_diversity$plots
#sp_diversity = merge(sp_diversity,periodinfo,by='period')

# ============================================================================
# plot richness

plot(periodinfo$date[1:length(species_count)],species_count,ylab='# species',xlab='',main='Species richness through time')

# ==============================================================================
# Shannon index

H = diversity(totA)
plot(sp_diversity$date[1:length(H)],H,xlab='',ylab='Shannon diversity',main='Shannon diversity')

# =============================================================================
# evenness
J = H/log(specnumber(totA))
plot(sp_diversity$date[1:length(H)],J,xlab='',ylab='Evenness',main='Species evenness')
