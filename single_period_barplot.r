# This script contains snippits for looking closely at individual sampling periods



# =============================================================================================
# load data
period1 = '355'

dat = read.csv('data/Rodents.csv',as.is=TRUE,colClasses=c(note1='character',tag='character'))

# There's a real species called NA, so make sure that the NAs are actually "NA"
dat$species[is.na(dat$species)] = "NA"

dat1 = dat[dat$period==period1,]
datc = dat1[dat1$plot %in% c(2,4,8,11,12,14,17,22),]

rodentinfo = read.csv('data/rodent_avg_meas.csv',as.is=T)
rodentinfo$species_id[is.na(rodentinfo$species)] = 'NA'

#==================================================================================
# plot

sp1 = aggregate(datc$species,by=list(datc$species),FUN=length)

n = merge(sp1,rodentinfo,by.x='Group.1',by.y='species_id')
M = n[order(n$avg_wgt),]
M = M[!is.na(M$avg_wgt),]

barplot(M$x,names=M$Group.1,main='Dec 2007')
