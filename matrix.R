#' @import shiny
NULL

#' Matrix input
#' 
#' Creates an adjustable-length matrix input.
#' 
#' @param inputId Input variable to assign the control's value to.
#' @param label Display label for the control.
#' @param data The initial values to use for the matrix.
#' 
#' @export
matrixInput2 <- function(inputId, label, data) {
  addResourcePath(
    prefix='tableinput', 
    directoryPath=system.file('tableinput', 
                              package='shinyIncubator'))
  
  tagList(
    singleton(
      tags$head(
        tags$link(rel = 'stylesheet',
                  type = 'text/css',
                  href = 'tableinput/tableinput.css'),
        tags$script(src = 'tableinput/tableinput.js')
      )
    ),
    
    tags$div(
      class = 'control-group tableinput-container',
     
      tags$table(
        id = inputId,
        class = 'tableinput data table table-bordered table-condensed',
        #style='.td{text-align:center;}',
        tags$colgroup(
          lapply(names(data), function(name) {
            tags$col('data-name' = name,
                     'data-field' = name,
                     'data-type' = 'text')
          })
        ),
        tags$thead(
          #class = 'hide',
          #style=".tr.th{text-align: center;}",
          tags$tr(
            lapply(names(data), function(name) {
              tags$th(
                div(name,class="text-center")
                )
            })
          )
        ),
        tags$tbody(
          lapply(1:nrow(data), function(i) {
            tags$tr(
              lapply(names(data), function(name) {
                
                if(name!="\t\t"){
                  
                  tags$td(
                    div(tabindex=0, as.character(data[i,name]),class="text-center")
                  )
                  
                }else{
                  
                  tags$th(
                    div(tabindex=0, as.character(data[i,name]),class="text-center")
                  )   
                  
                }
                
              })
            )
          })
        )
      )
      )
    )
}