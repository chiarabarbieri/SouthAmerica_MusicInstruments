### 
## review Izikowitz matrix analysis
## Chiara Barbieri 6 april 2021
˙
library(ggplot2)

urlfile<-'https://raw.githubusercontent.com/chiarabarbieri/SouthAmerica_MusicInstruments/main/Table_S2_Izikowitz.csv'
izi<-read.csv(urlfile,skip = 4)

izi<-as.data.frame(izi)

rownames(izi)<-izi$Ethnic_group
iziwork<-izi[,-c(2:5)] #exclude the column with the language fam attributes, geo coord, and number of instruments


languagegroup<-table(izi$Language_Family)
listlangName<-unlist(labels(which(languagegroup>1)))

verolist<-izi$Language_Family
verolist[-which(verolist%in%listlangName)]<-"Other"  # group less represented language families in the category "other"
nlang<-length(table(verolist))

# generate a random color palette
library("RColorBrewer")
qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
colorchoice<-sample(col_vector, nlang)
pie(rep(1,nlang), col=colorchoice)  # display the random color combination and decide if you are happy with it, otherwise repeat the sample command above

izi$Language_Family<-verolist

  library(ape)
 iziwork<-iziwork[,-1] #exclude the column with the ethnic group fam attributes
 iziwork<-as.matrix(iziwork)
 
 
 ### distance matrix
 dd<-dist(iziwork, method = "binary")
 
 # trees from distance matrix
 treeNJ  <- nj(dd)

 #_+++++++++++++++++++++++++++++++++++++++++++++++
 ## bootstrap NJ tree and plot unrooted, Figure 5
 #_+++++++++++++++++++++++++++++++++++++++++++++++
 
 bstrp<- boot.phylo( treeNJ, B=1000, iziwork,function(xx) nj(dist(xx)))
  # only the bootstrap values above 0.2
 bstrp2<-bstrp/1000
 bstrp2[which(bstrp2<0.2)]<-0
 bstrp2[which(bstrp2==0)]<-NA
 bstrp2[2]<-0  # the root node
 
 library(nodiv) # for graphic display of the bootstrap values on the nodes
 
 pdf("NJbootstrap_allclass_noOutgroupMore02_3.pdf", useDingbats = F, height = 5, width = 5)
 plot_nodes_phylo((bstrp2), treeNJ, cex = 0.7, show.tip.label = T,type = "f")
 dev.off()
 
 pdf("NJbootstrap_skeleton.pdf", useDingbats = F, height = 5, width = 5)   
 plot(treeNJ,main="NJ",show.tip.label = T,type = "f", cex = 0.3)
 dev.off()
 
 
 
 

 #_+++++++++++++++++++++++++++++++++++++++++++++++
 ### geographic distances
#_+++++++++++++++++++++++++++++++++++++++++++++++
 library('maps')
 library('geosphere')
 library('fields')	
 
 lista<-cbind(as.numeric(izi$lon),as.numeric(izi$lat))
 GEOdistances<-round(rdist.earth(lista, miles=FALSE))
 rownames(GEOdistances)<-izi$Ethnic_group
 colnames(GEOdistances)<-izi$Ethnic_group
 
 distmatrix<-as.matrix(dd)  # check manually if the conversion worked well
 
 distmatrix[lower.tri(distmatrix)]<-"delete"
 library(reshape)
 meltdist<-melt(distmatrix)
 colnames(meltdist)<-c("pop1","pop2","MusicDistance")
 
 meltdist$GeoDistance<-melt(GEOdistances)$value
 
 minimuminfoPOP<-izi[,c("Ethnic_group","Language_Family")]
 
 colnames(minimuminfoPOP)<-c("pop2","Language_Family2")
 meltdist<-merge(meltdist,minimuminfoPOP)
 colnames(minimuminfoPOP)<-c("pop1","Language_Family1")
 meltdist<-merge(meltdist,minimuminfoPOP)
 
 minimuminfoPOP<-izi[,c("Ethnic_group","lat", "lon")]
 
 colnames(minimuminfoPOP)<-c("pop1","lat1", "lon1")
 meltdist<-merge(meltdist,minimuminfoPOP)
 colnames(minimuminfoPOP)<-c("pop2","lat2", "lon2")
 meltdist<-merge(meltdist,minimuminfoPOP)
 
 
 withinfam<-c()
 for (i in 1:nrow(meltdist)){
    if (meltdist$Language_Family1[i]==meltdist$Language_Family2[i]){
       withinfam[i]<-meltdist$Language_Family1[i]
    }
    else {
       withinfam[i]<-"DIVERSE"
    }
 }
 
 meltdist$LanguageFamily<-withinfam
 
 meltdist$SameFamily<-"YES"
 meltdist$SameFamily[which(meltdist$LanguageFamily=="DIVERSE")]<-"NO"
 

  meltdist<-meltdist[-which(meltdist$pop1==meltdist$pop2),]
 meltdist$LanguageFamily[which(meltdist$LanguageFamily=="DIVERSE")]<-NA
 meltdist<-meltdist[-which(meltdist$MusicDistance=="delete"),]   # remove duplicated pairs
 meltdist$MusicDistance<-as.numeric(meltdist$MusicDistance)
 meltdist$popslistemp<-paste0(meltdist$pop1,meltdist$pop2,sep="")
 
 meltdistRED<- meltdist[!is.na(meltdist$LanguageFamily),]
 meltdistRED<- meltdistRED[-which(meltdistRED$LanguageFamily=="Other"),]
 
 #*******************************************
 ### supplementary figure S3
 #*******************************************
 #*
 ggg<-ggplot()
 ggg+geom_point(data=meltdist,aes(x=GeoDistance,y=MusicDistance),
               color="gray80", alpha=0.3, size=0.5)+
    geom_point(data=meltdistRED,aes(x=GeoDistance,y=MusicDistance,
                   color=LanguageFamily))+
    scale_color_manual(values=colorchoice[-11])+
    geom_text(data=meltdistRED,aes(x=GeoDistance,y=MusicDistance,
                                   label=popslistemp), size=0.2, angle = 45)+
   scale_x_log10() + 
    annotation_logticks()+ theme(legend.position="bottom")+
 xlab("Geographic Distance")+ylab("Instrument Distance")
 
 ggsave("correlationGeoDistMusicDist_LFamily_logaritmicX_3.pdf", useDingbats=FALSE, width = 8, height = 7)

 
 #_+++++++++++++++++++++++++++++++++++++++++++++++
 ### simple map
 # map with the colors for language family
 # Suppl Figure S1
 #_+++++++++++++++++++++++++++++++++++++++++++++++
 
 colnames(izi)[5]<-"number.of.instruments"
 
 Limitscoordinates<-c(-48,12,-81,-39)  ## to frame the map of South America
 map.world <- map_data(map="world")
 library(ggrepel)
 
 gg <- ggplot()
 gg <- gg + theme()
 gg <- gg + geom_map(data=map.world, map=map.world, aes(map_id=region), fill="white", colour="black", size=0.15)
 gg<- gg+coord_quickmap(ylim=Limitscoordinates[1:2], xlim=Limitscoordinates[3:4])
 
 
 gg + 
   geom_point(data=izi, aes(x=lon, y=lat, 
              size=number.of.instruments, color=Language_Family) ) +
     theme(text = element_text(size=9))+
   scale_color_manual(values=colorchoice)+
   
   scale_size(range = c(0.4,5))+
   geom_text_repel(data=izi,aes(x=lon, y=lat,label=Ethnic_group),
             #      point.padding = 0.2,
              #     nudge_x = .15,
               #    nudge_y = .5,
                   segment.size  = 0.2,
                   segment.color = "grey50",
                                 size=0.7)+
   theme(axis.title = element_blank(),
         axis.text = element_blank(),
         axis.ticks = element_blank())
 ggsave("MapstotalIziColorLanguage_2.pdf", useDingbats=FALSE)
 
 #_+++++++++++++++++++++++++++++++++++++++++++++++
 ### megamaps
 # one map for each instrument, color by language family
 # Suppl Figure S2
 #_+++++++++++++++++++++++++++++++++++++++++++++++
 
 library(reshape)
 
 izimelt<-melt(iziwork)
 colnames(izimelt)<-c("Ethnic_group","variable","value")
 
 izimelt<-izimelt[-which(izimelt$value==0),]
 izimeltcoord<-merge(izimelt,izi[,1:5])
 izimeltcoord$number.of.instruments<-as.numeric( izimeltcoord$number.of.instruments)
 
 Limitscoordinates<-c(-48,12,-81,-39)  ## to frame the map of South America
 map.world <- map_data(map="world")
 library(ggrepel)
 
 gg <- ggplot()
 gg <- gg + theme()
 gg <- gg + geom_map(data=map.world, map=map.world, aes(map_id=region), fill="white", colour="black", size=0.15)
 gg<- gg+coord_quickmap(ylim=Limitscoordinates[1:2], xlim=Limitscoordinates[3:4])
 
 gg + 
   geom_point(data=izi, aes(x=lon, y=lat), size=0.3, shape=3, color="Gray70" ) +
   #geom_label_repel(data=izimeltcoord, aes(x=lon, y=lat,label=Ethnic_group, color=Language_Family), size=0.5, label.padding=0.1)+
   geom_point(data=izimeltcoord, aes(x=lon, y=lat, color=Language_Family, size=number.of.instruments) ) +
     theme(text = element_text(size=5))+
   scale_color_manual(values=colorchoice)+
   theme(axis.title = element_blank(),
         axis.text = element_blank(),
         axis.ticks = element_blank())+
   scale_size(range = c(0.4,3))+
   facet_wrap(~variable,ncol=10) + theme(legend.position="bottom")

 
 ggsave("MapsEachInstrument4.pdf", useDingbats=FALSE, width = 8, height = 9)
 
 #_+++++++++++++++++++++++++++++++++++++++++++++++
 ## selection of 10 maps
 # Figure 4
 #_+++++++++++++++++++++++++++++++++++++++++++++++
 
 selectioninst<-c("panpipe","jingle_rattle", "gourd_rattle" ,"plug_flute","kena", 
                 "simple_end_flute", "timbira_flute", "aztec_flute", "chaco_clarinet", "flat_roots_as_signal_instruments" )

 izimeltcoordRED<-izimeltcoord[which(izimeltcoord$variable%in%selectioninst),]

 gg + 
   geom_point(data=izimeltcoordRED, aes(x=lon, y=lat), size=0.3, shape=3, color="Gray70" ) +
 #  geom_label_repel(data=izimeltcoordRED, aes(x=lon, y=lat,label=Ethnic_group, color=Language_Family), size=0.5, label.padding=0.1)+
   geom_point(data=izimeltcoordRED, aes(x=lon, y=lat, color=Language_Family, size=number.of.instruments) ) +
     theme(text = element_text(size=8))+
   scale_color_manual(values=colorchoice)+
   theme(axis.title = element_blank(),
         axis.text = element_blank(),
         axis.ticks = element_blank())+
   scale_size(range = c(0.4,3))+
   facet_wrap(~variable,ncol=5)
 
 ggsave("Maps10Instrument_mainFigure.pdf", useDingbats=FALSE, width = 10, height = 6)
 
 #_+++++++++++++++++++++++++++++++++++++++++++++++
 ### connection map
 # map connecting the closer music distances
  # Supplementary Figure S4
 #_+++++++++++++++++++++++++++++++++++++++++++++++
 
 
 meltdistgeoplottabile1<-meltdist
 meltdistgeoplottabile1$index<-c(1:nrow(meltdist))
 meltdistgeoplottabile1<-meltdistgeoplottabile1[,-which(colnames(meltdistgeoplottabile1)%in%c("lat2","lon2"))]
 
 meltdistgeoplottabile2<-meltdist
 meltdistgeoplottabile2$index<-c(1:nrow(meltdist))
 meltdistgeoplottabile2<-meltdistgeoplottabile2[,-which(colnames(meltdistgeoplottabile2)%in%c("lat1","lon1"))]
 
 betweenfamilSMALLgeoplottabile<-rbind(meltdistgeoplottabile1,setNames(meltdistgeoplottabile2,names(meltdistgeoplottabile1)))
 betweenfamilSMALLgeoplottabile$lat=as.numeric(as.character(betweenfamilSMALLgeoplottabile$lat1))
 betweenfamilSMALLgeoplottabile$lon=as.numeric(as.character(betweenfamilSMALLgeoplottabile$lon1))
 betweenfamilSMALLgeoplottabile$index=as.numeric(as.character(betweenfamilSMALLgeoplottabile$index))
 
 betweenfamilSMALLgeoplottabile<-betweenfamilSMALLgeoplottabile[!is.na(betweenfamilSMALLgeoplottabile$lat),]
 betweenfamilSMALLgeoplottabile<-betweenfamilSMALLgeoplottabile[which(betweenfamilSMALLgeoplottabile$MusicDistance<0.5),]
 betweenfamilSMALLgeoplottabile<-betweenfamilSMALLgeoplottabile[which(betweenfamilSMALLgeoplottabile$GeoDistance>0),]
 betweenfamilSMALLgeoplottabile<-as.data.frame(betweenfamilSMALLgeoplottabile)
 library(RColorBrewer)
 
 gg +   
   geom_point(data=izi, aes(x=lon, y=lat), size=0.3, shape=3, color="Gray70" ) +

   geom_path(data=betweenfamilSMALLgeoplottabile, aes(x = lon1, y = lat1, 
        group=index, alpha=MusicDistance, size=MusicDistance, color=MusicDistance))+
   scale_alpha(range = c(0.5,0.3))+
   scale_size(range = c(1.5,1.2))+
  # scale_color_brewer(palette = "YlGnBu", type = "continuous")+
   scale_colour_gradient( low="darkred", 
                         high="pink", name="distance between instrument repertoire")+
   theme(axis.title = element_blank(),
         axis.text = element_blank(),
         axis.ticks = element_blank())+
   guides(alpha=FALSE, size=FALSE)

 ggsave("MapPairMusicDistance2.pdf", useDingbats=FALSE, height = 7)
 
 
 
 
 