

shinyServer(function(input, output) {

    
  # Cargamos la tabla del óptico
  output$ui_optico<-renderUI({
    
    if(is.null(data)) return()
    
    df<-data.frame(matrix(rep("X",length(unique(data$MEDIO)) ),nrow=1))
    colnames(df)<- sort(unique(data$MEDIO))
    df<-cbind("Invertir:",df)
    colnames(df)[1]<-"\t\t"
    matrixInput2('optico', '', df )
  })
  
  
  # Definimos el óptico que ha introducido el usuario
  optico<-reactive({
    
    if(is.null(input$optico) ) return()
    if(ncol(input$optico)<1 ) return()
        
    df<-input$optico
    df<-toupper(gsub("\\W","",df)) ## Elimina cualquier caracter no alfanumerico
    df<-data.frame(df)
  
    colnames(df)<- sort(unique(data$MEDIO))  
    df    
  })


  ###########################################################################################
  #### EMPIEZA LA OPTIMIZACION
  
  proceso<-reactive({
    
    if(input$ejecutar==0) return()
    
    meta<-data
    mix<-isolate(optico())  
    presu<-isolate(input$presupuesto)

    # Comprobaciones de los datos
    if( is.na(presu)  ) return( list("El presupuesto introducido no tiene el formato correcto.\nIntroduce un número sin comas ni puntos.",NULL,NULL) )
    if( presu<=0  ) return( list("El presupuesto tiene que ser positivo.",NULL,NULL) )
    if(length(which(!(mix=="X" | mix=="")))>0) return (list("En el óptico hay algún carácter inválido.",NULL,NULL))
    if(sum(mix=="X")==0) return( list(paste("No se ha seleccionado ningún medio.\nAl menos debde de haber un medio seleccionado."),NULL,NULL) )
      
    # Comprobar solucion factible
    if( isolate(input$permitir)){  
       presu_min<-min(meta[meta$MEDIO %in% colnames(mix)[mix=="X"],"MIN"])
       if( presu < presu_min) return(list(paste("Presupuesto introducido insuficiente según los modelos cargados, se necesita al menos:",ceiling(presu_min),"€\nAumenta el presupuesto o cambie el mix de medios."), NULL,NULL))
     }else{
       presu_min<-sum(meta[meta$MEDIO %in% colnames(mix)[mix=="X"],"MIN"])
       if( presu < presu_min) return(list(paste("Presupuesto introducido insuficiente según los modelos cargados, se necesita al menos:",ceiling(presu_min),"€\nAumenta el presupuesto o cambie el mix de medios."), NULL,NULL))
    } 

    cuales<-colnames(mix)[mix=="X"]    
    zoom<- meta[meta$MEDIO %in% cuales,]
    #rownames(zoom)<-iconv(zoom$MEDIO, to="ASCII//TRANSLIT")
    rownames(zoom)<-zoom$MEDIO
    zoom$MEDIO<-NULL
    
    aux<-c(data_ampl(zoom,name="datos"),
            data_ampl(presu,name="Presupuesto",tipo="param"))
    file<- as.numeric(Sys.time())
    write(aux,paste(file,".dat",sep=""))
    

    if( isolate(input$permitir)){    
      log<-system(paste("pyomo bonmin.py ",file,".dat --solver bonmin --save-results ",file,".json",sep=""))
    }else{
      log<-system(paste("pyomo ipopt.py ",file,".dat --solver ipopt --save-results ",file,".json",sep=""))
    }
    
    salida<-fromJSON(content=paste(file,".json",sep=""))
    unlink(paste(file,"*",sep="") )
    

    if(isolate(input$permitir)){
      
      resultados<-as.data.frame(do.call(rbind,salida$Solution[[2]]$Variable))
      resultados$Id<-iconv(rownames(resultados),from="latin1",to="UTF8")
      rownames(resultados)<-NULL
      resultados$tipo<-str_extract(resultados$Id,"^[w|x]")
      resultados$MEDIO<-gsub("^.\\[|\\]","",resultados$Id)
      resultados$Id<-NULL
      resultados<-Reduce(function(x, y) merge(x, y, all=T,by.x="MEDIO", by.y="MEDIO"), split(resultados,resultados$tipo), accumulate=F)
      resultados[is.na(resultados)]<-0
      resultados<-resultados[,c(1,2,4)]
      resultados$Inversión<-apply(resultados[,-1],1,prod)
      resultados<-resultados[,c("MEDIO","Inversión")]  
    
    }else{
      
      resultados<-as.data.frame(do.call(rbind,salida$Solution[[2]]$Variable))
      resultados$Id<-iconv(rownames(resultados),from="latin1",to="UTF8")
      rownames(resultados)<-NULL
      resultados$MEDIO<-gsub("^.\\[|\\]","",resultados$Id)
      resultados$Id<-NULL
      resultados$Inversión<-resultados$Value
      resultados<-resultados[,c("MEDIO","Inversión")]  
      
    }
     
    
    # Cálculo de Aportes
    resultados$APORTES<-apply(resultados,1,function(x){
      aux<-data[data$MEDIO==x[1],c("A","B")]
      as.numeric(exp(aux[1]-aux[2]/as.numeric(x[2])))
    })
    
    log<-"Optimización terminada correctamente."
    
    return(list(log,resultados) )
   
  })
  
  #######################################################################################
  
  output$optimizar<-renderText({
    proceso()[[1]]
  })
  
  output$ui_guardar<-renderUI({  
    tabla<-proceso()[[2]]
    if(is.null(tabla)) return(p("Nada que descargar todavía") )
    downloadButton("guardar","Descargar resultados de optimización")
    })
  
  # Guardar los datos a Excel
  output$guardar<-downloadHandler(
    filename = function() {
      paste('Optimización-', Sys.Date(), '.xls', sep='')
    },
    content = function(file) {
      Aportes<-proceso()[[2]]
            
      rownames(Aportes)<-Aportes$MEDIO
      Aportes$MEDIO<-NULL
      Aportes<-data.frame(t(Aportes))
      
      WriteXLS(c("Aportes"), file,
               AdjWidth = TRUE,BoldHeaderRow = TRUE,row.names=TRUE)
    }
  )
  
  
  # Mostramos la tabla de aportes
  output$tabla_medios <- renderGvis({
    
    data<-proceso()[[2]]
    if(is.null(data)) return()
    
    colnames(data)[2]<-"Inversión (€)"
    nombres<-data$MEDIO 
    data<-t(data[,-1])
    colnames(data)<- nombres
    data<-as.data.frame(data)
    data$'Total Medios'<-rowSums(data)
    data<-cbind( paste("<b>",simpleCap(tolower(rownames(data))),"</b>",sep=""),data)
    colnames(data)[1]<-"\t"
    colnames(data)[-c(1,ncol(data))]<-sapply(colnames(data)[-c(1,ncol(data))],function(x) 
                  paste("<p>",x,"</p><br /><img src=\"imagenes/",iconv(x, to="ASCII//TRANSLIT") ,".png\">",sep=""))
    
    aux<-lapply(colnames(data)[-1],function(x) return("##,###"))
    names(aux)<-colnames(data)[-1]    
    gvisTable(data,options=list(sort="disable",width=800),formats=aux,chartid="tabla_aportes")
    
  })
  

  ### GRAFICO DE PIE
   
  output$tarta<-renderChart({

    data<-proceso()[[2]]
    
    if(is.null(data)) return()
    
    data$APORTES<-NULL
    data<- melt(data,id.vars="MEDIO")
    data<-data[data$value!=0,] 
    
    colnames(data)[c(1,3)]<-c("name","y")
    data$y<-paste("#!",data$y,"!#",sep="") #Me truncaba los datos
    
    p2<-rCharts::Highcharts$new()
    p2$series(data = toJSONArray2(data[,-2], json = F, names = T),
              type = "pie",name =as.character(data$variable[1]))
      
    p2$plotOptions(
        pie =list(
          allowPointSelect="true",
          cursor='pointer'        
        )
      )
    
    p2$tooltip(useHTML = T,
               pointFormat="<b>{point.y:,.0f}€ ({point.percentage:.2f}%)</b><br/>"               
    )
   
    p2$addParams(dom = 'tarta')
    p2$title(text="Reparto óptimo de inversiones")
    p2$chart(width=420)
    
    return(p2)
    
  })
  
    
  output$ui_salida2<-renderUI({ 
    data<-proceso()[[2]]
    if(is.null(data)) return()
    
      h3(HTML("<center>Tabla de Resultados</center>"))
  })
  

})