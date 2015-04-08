# This function is meant to streamline extracting rodent data from the database for a given
# treatment type and selection of years.

# get_rodent_data(treatment,years)
#     treatment = 'conrols', 'exclosures', or leave blank for all
#     years = list of years when data is desired


get_rodent_data = function(treatment,years) {
  # function to load rodent data with limited flexibility in subsetting the data
  
  # load complete raw database
  dat = read.csv("data/Rodents.csv", as.is = TRUE,  colClasses = c(note1='character'))
  # There's a real species called NA, so make sure that the NAs are actually "NA"
  dat$species[is.na(dat$species)] = "NA"
  
  if (treatment == 'controls') {
    # restrict plots to controls only
    dat = dat[dat$plot %in% c(1,2,4,8,9,11,12,14,17,22),]
  }
  else {
    if (treatment == 'exclosures') {
      #krat exclosures only
      dat = dat[dat$plot %in% c(3,6,13,15,18,19,20,21),]
    }
  }
  
  # restrict to selected years
  dat = dat[dat$yr %in% years,]
  
  return(dat)
}
