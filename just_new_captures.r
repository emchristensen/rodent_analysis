

just_new_captures = function(dat) {
  # this function separates new captures from recaps in rodent data
  newrt = dat[dat$note2 =='*',]
  newboth = newrt[newrt$note3=='*',]
  noleft = newrt[newrt$ltag =='',]
  
  newrats = rbind(newboth,noleft)
  newrats = newrats[order(newrats$yr,newrats$mo,newrats$dy),]
  return(newrats)
}