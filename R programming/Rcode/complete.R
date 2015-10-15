complete <- function(directory, id = 1:332) {
    ## 'directory' is a character vector of length 1 indicating
    ## the location of the CSV files
    
    ## 'id' is an integer vector indicating the monitor ID numbers
    ## to be used
    
    ## Return a data frame of the form:
    ## id nobs
    ## 1  117
    ## 2  1041
    ## ...
    ## where 'id' is the monitor ID number and 'nobs' is the
    ## number of complete cases
    pathname<-paste(getwd(),directory,sep='/')
    filelist<-as.list(list.files(pathname))
    idfile<-id
    nooffiles<-length(idfile)
    
    nd<-data.frame(id=numeric(nooffiles), nobs=numeric(nooffiles))
    for (i in 1:nooffiles){
        data<-read.csv(paste(pathname,filelist[[idfile[i]]],sep='/'))
        nd[["nobs"]][i]<-nrow(data[complete.cases(data),])
        nd[["id"]][i]<-idfile[i]
        
    }
    nd
    
}