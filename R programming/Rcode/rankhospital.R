rankhospital <- function(state, outcome, num = "best") {
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
    outstatelogic<-outstate==state
    if (sum(outstatelogic,na.rm=TRUE)==0)
    {
        #print("Error in Best: Invalid State")
        stop("Error in Best: Invalid State")
    }
    

    
    ## Function capitalizes first letter of each word and concates with a "."
    simpleCap <- function(x) {
        s <- strsplit(x, " ")[[1]]
        paste(toupper(substring(s, 1,1)), substring(s, 2),
              sep="", collapse=".")
    }
    
    outnamereal<-simpleCap(outcome)
    outnamereal<-paste("Hospital.30.Day.Death..Mortality..Rates.from",outnamereal,sep=".")
    newdata<-split(dataoutcome,dataoutcome$State)
    newdatastate<-newdata[[state]]
    
    ## Check that state and outcome are valid
    ## Return hospital name in that state with the given rank
    ## 30-day death rate
    
    ordereddata<-newdatastate[order(as.numeric(newdatastate[[outnamereal]]),newdatastate$Hospital.Name),]
    
    noofhospitals<-sum(!is.na(as.numeric(ordereddata[[outnamereal]])))
    
    if (num=="best")
        {
        ordereddata$Hospital.Name[1]    
        }
    
    else if (num=="worst")
        {
        ordereddata$Hospital.Name[noofhospitals]
        }
    
    else if (num>noofhospitals)
        {
        return(NA)
        }
    else
        {
        ordereddata$Hospital.Name[num]
        }
    
    
}