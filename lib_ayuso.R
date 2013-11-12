simpleCap <- function(x) {
    gsub("(^|[[:space:]])([[:alpha:]])", "\\1\\U\\2", x, perl=TRUE)
}
  
iconv.data.frame<-function(df,...){
    df.names<-iconv(names(df),...)
    df.rownames<-iconv(rownames(df),...)
    names(df)<-df.names
    rownames(df)<-df.rownames
    df.list<-lapply(df,function(x){
      if(class(x)=="factor"){x<-factor(iconv(as.character(x),...))}else
        if(class(x)=="character"){x<-iconv(x,...)}else{x}
    })
    df.new<-do.call("data.frame",df.list)
    return(df.new)
}
  
punto_mil<- function(x, ...) { 
  format(x, ..., big.mark = ".", scientific = FALSE, trim = TRUE)
}

trim <- function (x) gsub("^\\s+|\\s+$", "", x)
  
