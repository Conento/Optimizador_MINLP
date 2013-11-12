Optimizador MINLP con R y Pyomo
========================================================
Este optimizador es un ejemplo de cómo usar **R** y **Pyomo** para realizar un optimizador fácil para el usuario final y hecho con software libre.  
Realizado y presentado por Jorge Ayuso analista en **Conento** www.conento.com en las V Jornadas de Usuarios de R (España).

Más información:
* Documento Metodológico: LINK
* Contacto: [atencionalcliente@conento.com](mailto:atencionalcliente@conento.com)

Softwares principales utilizados:
* R (http://www.r-project.org).
* Optimizadores del proyecto COIN-OR (http://www.coin-or.org).
* Pyomo (http://software.sandia.gov/trac/coopr/wiki/Pyomo).
* Shiny (http://www.rstudio.com/shiny).

### Modo de uso
Es necesario tener instalado y configurado en el PATH del sistema: Pyomo, Bonmin, Ipopt.  
Después ejecutar en R:


```r
require(shiny)
runGitHub("Optimizador_MINLP", "Conento")
```


