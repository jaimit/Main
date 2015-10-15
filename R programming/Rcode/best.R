best<-function(state,outcome){
    ## Read outcome data
    dataoutcome<-read.csv("C:/Users/jaimi/Documents/R/rprog-data-ProgAssignment3-data/outcome-of-care-measures.csv",colClasses = "character")
    
    ## Check the input arguement 
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
      
    newdata<-split(dataoutcome,dataoutcome$State)
    #Return hospital name in that state with lowest 30-day death
    ## rate
    realname<-paste("Hospital.30.Day.Death..Mortality..Rates.from",outnamereal,sep=".")
    values<-as.numeric(newdata[[state]][[realname]])
    minimumindex<-which(values==min(values,na.rm=TRUE))
    nameofhospital<-newdata[[state]][["Hospital.Name"]][minimumindex]
    finalnames<-sort(nameofhospital,decreasing = TRUE)
    finalnames[1]
    
    
}