rankall <- function(outcome, num = "best") {
    ## Read outcome data

    dataoutcome<-read.csv("C:/Users/jaimi/Documents/R/rprog-data-ProgAssignment3-data/outcome-of-care-measures.csv",colClasses = "character")
    
    
    outname<-c("heart attack", "heart failure", "pneumonia")
    outnamelogic<-outname==outcome
    if (sum(outnamelogic,na.rm=TRUE)==0)
        {
        #print("Error in Best: Invalid outcome")
        stop("Error in Best: Invalid outcome")
        }

    outstate<-levels(as.factor(dataoutcome$State))


## Function capitalizes first letter of each word and concates with a "."
    simpleCap <- function(x) {
        s <- strsplit(x, " ")[[1]]
        paste(toupper(substring(s, 1,1)), substring(s, 2),
              sep="", collapse=".")
    }
    
    outnamereal<-simpleCap(outcome)
    outnamereal<-paste("Hospital.30.Day.Death..Mortality..Rates.from",outnamereal,sep=".")
    newdata<-split(dataoutcome,dataoutcome$State)
    
    ordereddata<-lapply(newdata, function(x) x[order(as.numeric(x[[outnamereal]]),x$Hospital.Name),])
    noofhospitals<-lapply(ordereddata, function (x) sum(!is.na(as.numeric(x[[outnamereal]]))))

    if (num=="best")
        {
           listofhosp<- as.character(lapply(ordereddata, function (x) x$Hospital.Name[1]))
           data.frame (hospital=listofhosp,state=outstate,stringsAsFactors = FALSE)
        }
    
    else if (num=="worst")
        {
            listofhosp<-as.character(mapply(function(x,y) x$Hospital.Name[y],ordereddata,noofhospitals))
            data.frame (hospital=listofhosp,state=outstate,stringsAsFactors = FALSE)
        }
    
    
    else
        {
            listofhosp<-as.character(mapply(function(x,y,z) if(z<y) {x$Hospital.Name[z]} else {NA},ordereddata,noofhospitals,num))
            data.frame (hospital=listofhosp,state=outstate,stringsAsFactors = FALSE)
        }

}