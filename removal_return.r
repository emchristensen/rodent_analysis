# This script is to look at the rate of return of animals removed from the site




dat = read.csv('data/Rodents.csv',as.is=T)

# There's a real species called NA, so make sure that the NAs are actually "NA"
dat$species[is.na(dat$species)] = "NA"

# ===================================================================================

sw = read.csv('data/newdat_neg_436.csv',as.is=T)
sw$species[is.na(sw$species)] = "NA"

p437 = read.csv('data/newdat437.csv',as.is=T)

removed = sw[sw$note5=='R',]

rem_tag = removed$tag[removed$tag!= ""]

new_tag = p437$tag[p437$tag!=""]

returns = intersect(rem_tag,new_tag)
