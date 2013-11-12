
require(rCharts)
require(googleVis)
require(RJSONIO)
require(reshape2)
require(stringr)
require(WriteXLS)

source("lib_ayuso.R")
source("matrix.R")
load("datos.Rdata")

data_ampl<-function(x,name=NULL,tipo=NULL){
  if( is.null(name) )  stop("Introduza un nombre para el conjunto de datos")
  prueba<- capture.output(write.table(x))
  if(is.null(tipo)){ # Por defecto se construyen parámetros con un índice
    prueba[1]<-paste("param:",name,":",prueba[1],":=")  
  }else{
    if(tipo=="matriz"){
      prueba[1]<-paste("param ",name,"(tr) :",prueba[1],":=")
    }else{
      if(tipo=="set"){
        prueba[1]<-paste("set",name,":=",prueba[1])  
      }else{
        if(tipo=="param"){
          prueba<-paste("param",name,":=",x)  
        }else{
          stop("Tipo introducido no definido")
        }
      }
    }
  }
  prueba[length(prueba)]<-paste(prueba[length(prueba)],";",sep="")
  prueba
}

