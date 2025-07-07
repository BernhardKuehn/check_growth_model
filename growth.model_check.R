# -------------------- #
# growth model example
# -------------------- #

# create a custom libpath to allow for different versions of TMB and glmmTMB
library("withr")
library("devtools")
dir.create("./dev_lib",showWarnings = F)
dir.create("./dev_lib_update",showWarnings = F)

# install old package versions
with_libpaths(new = "./dev_lib",
              code = devtools::install_version("TMB", version = "1.9.11", repos = "http://cran.us.r-project.org"))
with_libpaths(new = "./dev_lib",
              code = devtools::install_version("glmmTMB", version = "1.1.9", repos = "http://cran.us.r-project.org"))
# install new package versions
with_libpaths(new = "./dev_lib_update",
              code = devtools::install_version("TMB", version = "1.9.17", repos = "http://cran.us.r-project.org"))
with_libpaths(new = "./dev_lib_update",
              code = devtools::install_version("glmmTMB", version = "1.1.11", repos = "http://cran.us.r-project.org"))

# calculate residuals from the 'old' model with the'old' libraries
res1 = with_libpaths(new = "./dev_lib/",
                   code =  {
                     library(TMB)
                     library(glmmTMB)
                     nm.obj = load("./cod.growth_oldTMB.RData")
                     res = residuals(get(nm.obj))
                     detach("package:glmmTMB", unload = TRUE)
                     detach("package:TMB", unload = TRUE)
                     res
                   })
plot(res1)

# calculate residuals from the 'old' model with the 'new' libraries with 'up2date'
res2 = with_libpaths(new = "./dev_lib_update/",
                    code =  {
                      library(TMB)
                      library(glmmTMB)
                      nm.obj = load("./cod.growth_oldTMB.RData")
                      update.mod = up2date(get(nm.obj))
                      res = residuals(update.mod)
                      detach("package:glmmTMB", unload = TRUE)
                      detach("package:TMB", unload = TRUE)
                      res
                    })
plot(res2)

# compare together
par(mfrow = c(1,2),mar = c(4,4,2,2),oma = c(0,0,1,0))
plot(res2,col = "orange2",pch = 16,ylab = "residuals")
abline(h = 0,lty = 2)
points(res1,col = "lightblue4",pch = 16)
legend("topleft",legend = c("up2date","original"),col = c("orange2","lightblue4"),
       pch = 16,bty = "n")
plot(res2,res1,pch = 16,col = "lightblue3")
abline(0,1,lty = 2)
mtext("Comparison residuals",side = 3,outer = T,font = 2,line = -1,cex = 1.5)
