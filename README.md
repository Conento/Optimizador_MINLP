Optimizador MINLP con R y Pyomo
========================================================
Este optimizador es un ejemplo de cómo usar **R** y **Pyomo** para realizar un optimizador fácil para el usuario final y hecho con software libre. Se puede probar la aplicación en http://jornadas-r.conento.com. 

Realizado y presentado por Jorge Ayuso analista en **Conento** www.conento.com en las V Jornadas de Usuarios de R (España).


Más información:
* Documento Metodológico disponible en http://www.conento.com/noticias.
* Contacto: [atencionalcliente@conento.com](mailto:atencionalcliente@conento.com)

Softwares principales utilizados:
* R (http://www.r-project.org).
* Optimizadores del proyecto COIN-OR (http://www.coin-or.org).
* Pyomo (http://software.sandia.gov/trac/coopr/wiki/Pyomo).
* Shiny (http://www.rstudio.com/shiny).

******
### Modo de uso
Es necesario tener instalado y configurado en el PATH del sistema: Pyomo, Bonmin, Ipopt.  
Además se necesita tener instalado en R los siguientes paquetes: Shiny, rCharts, googleVis, RJSONIO, reshape2, stringr, WriteXLS.  

Después ejecutar en R:

```{coffee eval=FALSE}
require("shiny")
runGitHub("Optimizador_MINLP","Conento")
```

