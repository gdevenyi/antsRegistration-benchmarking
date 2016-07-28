library(ggplot2)
library(doBy)
library(rgl)
library(scatterplot3d)
library(minpack.lm)
library(akima)

data = read.csv("voxel-stats.csv")
data = subset(data,error=="")
filtered.data = data[complete.cases(data),]
filtered.data$memoryGB = filtered.data$memory / 2^20
filtered.data$timeHR = filtered.data$time
#filtered.data$fixed = as.factor(filtered.data$fixed)

summary <- summaryBy(memoryGB + timeHR~ fixed + moving, data=filtered.data, FUN=mean)


m = nlsLM(memoryGB ~ a*fixed + b*moving, data=filtered.data, control = list(maxiter=200, warnOnly=TRUE))
summary(m)
mygrid = expand.grid(seq(624264,43791300,500000), seq(624264,202217000,500000))
names(mygrid) = c("fixed","moving")
mygrid$prediction = predict(m, mygrid)
mygrid2 = interp(mygrid$fixed,mygrid$moving,mygrid$prediction)
plot3d(summary$fixed,summary$moving,summary$memoryGB.mean, type = 's', size = 1, box = FALSE, xlab = "Fixed Resolution (mm)", ylab = "Moving Resolution (mm)", zlab = "Memory (GB)")
surface3d(mygrid2$x, mygrid2$y, mygrid2$z, color = "steelblue",
          alpha = 0.5, lit=FALSE)

m2 = nlsLM(time ~ a*fixed + b*moving + d, data=filtered.data, control = list(maxiter=200, warnOnly=TRUE))
summary(m2)
