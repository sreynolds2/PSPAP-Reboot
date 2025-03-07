figures<- function(n){

if(n==1){
    # ENTIRE STUDY AREA
	plot(manunits,col="black",lwd=1)
	plot(bends,col="black",lwd=2,add=TRUE)	
	plot(reservoirs,add=TRUE,col="grey",border="grey",lwd=2.5)		
	points(-104.54,47.28,pch=19,cex=1)          # INTAKE
	points(-106.422049, 48.001600,pch=19, cex=1)# FORT PECK DAM	
	points(-101.411601,47.498528,pch=19,cex=1)  # GARRISON DAM		
	points(-100.402227, 44.451274,pch=19,cex=1) # OAHE DAM	
	points(-99.448768,44.049215,pch=19,cex=1)   # BIG BEND DAM	
	points(-98.562062,43.059483,pch=19,cex=1)   # FORT RANDALL DAM
	points(-97.485244,42.860696,pch=19,cex=1)   # GAVINS POINT DAM
	map.scale(y=42,ratio=FALSE)
	arrows(-109.5,43,-109.5,45,lwd=3,length=0.15)
	text(-109.5,42.5,"N",cex=1.2)
	par(xpd=TRUE)	
	segments(-90.120752, 38.813236, -90.120752, 50,lwd=2)
	segments(-97.485244,42.860696,-97.485244,50,lwd=2) # GAVINS POINT DAM
	segments(-103.5,48.001600,-103.5,50,lwd=2)	
	segments(-106.422049,48.001600,-106.422049,50,lwd=2)

	text(mean(c(-90.120752,-97.485244)),50,"Lower Missouri \n River \n",
		col="black",cex=0.8)
	text(mean(c(-103.5,-97.485244)),50,"Segmented \n reach \n",
		col="black",cex=0.8)	
	text(mean(c(-103.5,-106.422049)),50,"Upper \n Missouri \n River",
		col="black",cex=0.8)
	text(-86.5,35, "Mississippi River \n and Atchafalaya \n Basin")
		
	par(srt=-45)
	text(-96.5,40, "Missouri River")
	par(srt=0)		
		
	# insert US 
	par(new=TRUE,oma=c(0,6,12,6))
	plot(us)	
	plot(missouri,col="lightgrey", border="lightgrey",add=TRUE)
	plot(manunits,col="black",lwd=2,add=TRUE)
	plot(us,add=TRUE)	
	}	
	
if(n==2)
	{# US LEVEL STUDY AREA
	plot(us)	
	plot(watershed,col="lightgrey", border="lightgrey",add=TRUE)
	plot(manunits,col="black",lwd=2,add=TRUE)
	plot(us,add=TRUE)	
	}	

if(n==3)
	{
	plot(manunits[manunits$Name!= "Coastal Plains",],col="black",lwd=1)
	plot(bends[bends$B_SEGME==1,],col="black",lwd=6,add=TRUE)	
	plot(bends[bends$B_SEGME==2,],col="grey",lwd=6,add=TRUE)	
	plot(bends[bends$B_SEGME==3,],col="black",lwd=6,add=TRUE)	
	plot(bends[bends$B_SEGME==4,],col="grey",lwd=6,add=TRUE)	
	#plot(bends[bends$B_SEGME==5,],col="black",lwd=6,add=TRUE)	
	#plot(bends[bends$B_SEGME==6,],col="grey",lwd=6,add=TRUE)	
	plot(bends[bends$B_SEGME==7,],col="black",lwd=6,add=TRUE)	
	plot(bends[bends$B_SEGME==8,],col="grey",lwd=6,add=TRUE)	
	plot(bends[bends$B_SEGME==9,],col="black",lwd=6,add=TRUE)	
	plot(bends[bends$B_SEGME==10,],col="grey",lwd=6,add=TRUE)	
	#plot(bends[bends$B_SEGME==11,],col="black",lwd=6,add=TRUE) Kansas River	
	#plot(bends[bends$B_SEGME==12,],col="red",lwd=6,add=TRUE)	
	plot(bends[bends$B_SEGME==13,],col="black",lwd=6,add=TRUE)	
	plot(bends[bends$B_SEGME==14,],col="grey",lwd=6,add=TRUE)	
    
    
    
    
    
	plot(reservoirs,add=TRUE,col="lightblue",border="lightblue",lwd=2.5)		
	points(-104.54,47.28,pch=19,cex=1,col="red")          # INTAKE
	points(-106.422049, 48.001600,pch=19,cex=1,col="red")# FORT PECK DAM	
	points(-101.411601,47.498528,pch=19,cex=1,col="red")  # GARRISON DAM		
	points(-100.402227, 44.451274,pch=19,cex=1,col="red") # OAHE DAM	
	points(-99.448768,44.049215,pch=19,cex=1,col="red")   # BIG BEND DAM	
	points(-98.562062,43.059483,pch=19,cex=1,col="red")   # FORT RANDALL DAM
	points(-97.485244,42.860696,pch=19,cex=1,col="red")   # GAVINS POINT DAM
	text(-95,33, "Mississippi River \n and Atchafalaya \n Basin")
		
	par(srt=-45)
	text(-98.5,41.5, "Missouri River")
	par(srt=0)	

    # PLOT HATCHERIES
	points(y~x,hatcheries,pch=15,cex=1.3, subset=Hatchery!="Gavins Point National Fish Hatchery")
    
    labs<-c("Blind Pony \n Hatchery",
        "Gavins Point\n National Fish Hatchery",
        "Garrison Dam\n National Fish Hatchery",
        "Neosho National\n Fish Hatchery", 
        "Miles City State \nFish Hatchery",
        "Bozeman Fish \nTechnology Center" )    

   
	#text(hatcheries$x, hatcheries$y, 
	#	labs,cex=0.4,pos=c(1,1,3,4,1,4))
    
  
	}

if(n==4)
    {

    }
	
	}

