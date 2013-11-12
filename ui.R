
shinyUI(pageWithSidebar(
  headerPanel("Optimizador de Campañas"),
  
  
  sidebarPanel(
    tags$head(tags$link(rel="shortcut icon", href="favicon.ico")),
    tags$style(list("
                    .pasos{color:#3578ff}
                    .carga{display: block;margin-left: auto;margin-right: auto;}
                    .logos{margin-left: auto;margin-right: auto;width: 200px;}
                    .table{margin-left: auto;margin-right: auto;width: 150px;}    
                    .highcharts-container{margin-left: auto;margin-right: auto;}
                    .shiny-output-error{visibility:hidden}
                    label.radio { display: inline-block; margin: 0px 35px 0px;}
                    .text-center{ text-align:center; }
                    *{font-family: 'Ubuntu','Droid Sans',sans-serif;}
                    ")),#*{font-family: sans-serif;}
    
    tags$head(HTML("<link href='http://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel='stylesheet' type='text/css'>")),
    tags$head(HTML("<link href='http://fonts.googleapis.com/css?family=Ubuntu:400,500,700,400italic,500italic,700italic' rel='stylesheet' type='text/css'>")),
    
    tags$script(type='text/javascript', src='lang.js'),
  
    HTML('<center><a href="http://www.conento.com" target="_blank">
           <img class="logos" src="conento.png"/></a>
         </center>'),
    
    conditionalPanel(
			condition = "input.panel == 'def'",
      h2("Paso 1",class="pasos"),
			p("Introducir los datos de la camapaña a optimizar:"),
      
			wellPanel(
			  numericInput("presupuesto",label="Presupuesto a repartir:",value=570000,min=0),strong("€",style="font-size:25px;")),
      wellPanel(
        HTML("Permitir no invertir en Medios:<center>"),
			  radioButtons(inputId="permitir",label="",
			               choices=c("Si"=TRUE,"No"=FALSE),selected="Si"),HTML("</center>"),
        p(strong("Nota:"),"\"Si\" corresponde al problema 2 (MINLP),",br(),"\"No\" corresponde al problema 1 (NLP).")
			)
    ),
    
    conditionalPanel(
      condition = "input.panel == 'resultados'",
      
      wellPanel(
        h2("Paso 3",class="pasos"),
        actionButton(inputId="ejecutar",label="Ejecutar Optimización")
      ),
      
      wellPanel(
        h2("Paso 4",class="pasos"),
        p(strong("Exportar resultado de la optimización a excel:")),
        uiOutput("ui_guardar") 
        )
      
      )
    
  ), 
  
###########################################################################################
## MAIN
###########################################################################################
  
  
  mainPanel(
	
    tabsetPanel(id="panel",
    tabPanel("Definir parámetros", 
                         
             conditionalPanel(condition="$('html').hasClass('shiny-busy')", img(src="load.gif",width="128px",class="carga",id="12")),
                         
             h2("Paso 2",class="pasos"),
             p("Elimine la 'X' de la semana donde no desee invertir en el Medio:") ,          
             uiOutput("ui_optico")
               
      ,value="def"),
                
    tabPanel("Optimización",
             
             conditionalPanel(condition="$('html').hasClass('shiny-busy')", img(src="load.gif",width="128px",class="carga",id="12")),
             
             p(strong("Salida del optimizador:")),
             verbatimTextOutput("optimizar"),
             showOutput("tarta","highcharts"),
             uiOutput("ui_salida2"),
             HTML("<center>"),
             htmlOutput("tabla_medios"),
             HTML("</center>")
                      
      ,value="resultados"),
                
    tabPanel("Acerca de...",includeMarkdown("README.md"))                
    )
  )
))
