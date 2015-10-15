pollutantmean2 <- function(directory, pollutant, id = 1:332) {
    pathname<-paste(getwd(),directory,sep='/')
    filelist<-as.list(list.files(pathname))
    typeofpollutant<-pollutant
    idfile<-id
    nooffiles<-length(idfile)
    data=replicate(nooffiles,list())
    meanpollutant<-replicate(nooffiles,numeric())
    
    for (i in 1:nooffiles){
        data[[i]]<-read.csv(paste(pathname,filelist[[idfile[i]]],sep='/'))
        meanpollutant[i]<-mean(data[[i]][[typeofpollutant]],na.rm = T)
        
    }
    mean(as.numeric(meanpollutant))

}