pollutantmean <- function(directory, pollutant, id = 1:332) {
    ## 'directory' is a character vector of length 1 indicating
    ## the location of the CSV files
    
    ## 'pollutant' is a character vector of length 1 indicating
    ## the name of the pollutant for which we will calculate the
    ## mean; either "sulfate" or "nitrate".
    
    ## 'id' is an integer vector indicating the monitor ID numbers
    ## to be used
    
    ## Return the mean of the pollutant across all monitors list
    ## in the 'id' vector (ignoring NA values)
    ## NOTE: Do not round the result!
    pathname<-paste(getwd(),directory,sep='/')
    filelist<-as.list(list.files(pathname))
    typeofpollutant<-pollutant
    idfile<-id
    nooffiles<-length(idfile)
    data<-replicate(nooffiles,list())
    meanpollutant<-replicate(nooffiles,numeric())
    
    for (i in 1:nooffiles){
        data[[i]]<-read.csv(paste(pathname,filelist[[idfile[i]]],sep='/'))
        meanpollutant[i]<-mean(data[[i]][[typeofpollutant]],na.rm = T)
        
    }
    mean(as.numeric(meanpollutant))
    
    
}
