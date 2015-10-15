corr <- function(directory, threshold = 0) {
    ## 'directory' is a character vector of length 1 indicating
    ## the location of the CSV files
    
    ## 'threshold' is a numeric vector of length 1 indicating the
    ## number of completely observed observations (on all
    ## variables) required to compute the correlation between
    ## nitrate and sulfate; the default is 0
    pathname<-paste(getwd(),directory,sep='/')
    filelist<-as.list(list.files(pathname))
    
    ## Finding the dataframe for the number of observations with complete cases
    nd<-complete(directory)
    totalmonitor <- length(nd$nobs[nd$nobs>threshold])
    correlation<- vector("numeric",length=totalmonitor)
    j<-1
    
    for (i in 1:length(filelist)){
        if (nd$nobs[i]>threshold){
            data<-read.csv(paste(pathname,filelist[[i]],sep='/'))
            compdata<-data[complete.cases(data),]
            correlation[j]<-cor(compdata$sulfate,compdata$nitrate)
            j<-j+1
        }
        
        
    }
    
    ## Return a numeric vector of correlations
    ## NOTE: Do not round the result!
    correlation
}