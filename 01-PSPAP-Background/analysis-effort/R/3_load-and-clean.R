

## CODE TO COMMUNICATE WITH LOCAL PSPAP DATABASE 
#com3<- odbcConnectAccess2007("C:/Users/mcolvin/Google Drive/Pallid-Sturgeon/analysis-effort/pallids.accdb")
com3<- odbcConnectAccess2007("C:/Users/sreynolds/Google Drive/Pallid-Sturgeon/analysis-effort/pallids.accdb")
dat<-sqlFetch(com3, "Gear-Specific-Effort")
## CONVERT TO CHARACTER
dat$STARTTIME<- as.character(dat$STARTTIME)
dat$STOPTIME<- as.character(dat$STOPTIME)
## FILL NON TIME FORMATS WITH NA
dat[-(grep(":",dat$STARTTIME)),]$STARTTIME<- NA
dat[-(grep(":",dat$STOPTIME)),]$STOPTIME<- NA   
## DROP NAs
dat<- subset(dat, !(is.na(STARTTIME)));dim(dat)
dat<- subset(dat, !(is.na(STOPTIME)));dim(dat)
dat<- subset(dat, !(is.na(SETDATE)))   ;dim(dat)
## MAKE SURE ALL IS UPPER CASE
dat$STARTTIME<- toupper(dat$STARTTIME)
dat$STOPTIME<-toupper(dat$STOPTIME)

## LOAD GEAR DATA
gear_dat<-sqlFetch(com3, "Gear-Meta-Data")
names(gear_dat)[2]<-"gear_type"
## SUBSET OUT DUPLICATE GEARS 
# POT02, HN, SHN,TN11, MOT02, OT04, OT02
gear_dat<- gear_dat[-which(duplicated(gear_dat$gear_code)==TRUE),]
## MERGE GEAR TYPE WITH EFFORT DATA   
dat<- merge(dat,gear_dat[,c(2,3,4,5,7,10)],by.x="GEAR",
            by.y="gear_code",all.x=TRUE)


### UPDATE STOP DATE FOR OVERNIGHTS
dat$STOPDATE<- dat$SETDATE+60*60*24*dat$overnight

## CONVERT ALL TO HOUR FRACTION TIME
## START TIME
dat$start_time<-unlist(lapply(1:nrow(dat),function(x)
{
  pp<- NA
  xx<-unlist(
    strsplit(
      dat[x,]$STARTTIME,":"
    ))
  if(length(grep("PM",xx))==0|{length(grep("PM",xx))>0 & xx[1]==12}) # HANDLE AM, NON PM, AND 12PM FORMATS
  {
    pp<-paste(as.character(dat[x,]$SETDATE)," ",as.numeric(xx[1]),":", 
              as.numeric(xx[2]),":00",sep="") 
    pp<-strptime(pp, "%Y-%m-%d %H:%M:%S")  
  }
  if(length(grep("PM",xx))>0 & xx[1]!=12) # HANDLE REMAINING PM FORMATS
  {
    pp<-paste(as.character(dat[x,]$SETDATE)," ",as.numeric(xx[1])+12,":", 
              as.numeric(xx[2]),":00",sep="") 
    pp<-strptime(pp, "%Y-%m-%d %H:%M:%S")  
  }
  return(as.character(pp))
}))

## STOP TIME
# xx<-strsplit(dat$STOPTIME,":")
# hr<- unlist(lapply(xx, `[[`, 1))
# mins<- unlist(lapply(xx, `[[`, 2))
# apply(cbind(hr,mins),1,paste,collapse=":")
dat$stop_time<-unlist(lapply(1:nrow(dat),function(x)
{
  pp<- NA
  xx<-unlist(
    strsplit(
      dat[x,]$STOPTIME,":"
    ))
  if(length(grep("PM",xx))==0|{length(grep("PM",xx))>0 & xx[1]==12}) # HANDLE AM, NON PM FORMATS, AND 12PM
  {
    pp<-paste(as.character(dat[x,]$STOPDATE)," ",as.numeric(xx[1]),":", 
              as.numeric(xx[2]),":00",sep="") 
    pp<-strptime(pp, "%Y-%m-%d %H:%M:%S")  
  }
  if(length(grep("PM",xx))>0 & xx[1]!=12) # HANDLE REMAINING PM FORMATS
  {
    pp<-paste(as.character(dat[x,]$STOPDATE)," ",as.numeric(xx[1])+12,":", 
              as.numeric(xx[2]),":00",sep="") 
    pp<-strptime(pp, "%Y-%m-%d %H:%M:%S")  
  }
  return(as.character(pp))
})) 
dat$stop_time<- strptime(dat$stop_time,"%Y-%m-%d %H:%M:%S")
dat$start_time<- strptime(dat$start_time,"%Y-%m-%d %H:%M:%S")

## CALCULATE EFFORT
dat$effort<-as.numeric(dat$stop_time-dat$start_time)/60 # EFFORT IN MINUTES
dat<-subset(dat,effort>0)
names(dat)<-tolower(names(dat))

##FIX TYPO IN COLUMN NAME
colnames(dat)[14]<-"standard_gear"
