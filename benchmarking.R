library(ggplot2)
library(doBy)
library(rgl)
library(scatterplot3d)
library(minpack.lm)
library(akima)

data = read.csv("stats.csv")
data = subset(data,error=="")
filtered.data = data[complete.cases(data),]
filtered.data$memoryGB = filtered.data$memory / 2^20
filtered.data$timeHR = filtered.data$time / 3600
#filtered.data$fixed = as.factor(filtered.data$fixed)

summary <- summaryBy(memoryGB + timeHR~ fixed + moving, data=filtered.data, FUN=mean)

qplot(moving,memoryGB.mean,data=summary,color=as.factor(fixed)) + geom_hline(yintercept=c(8,16,24,32)) +
  scale_y_continuous(name="Peak Memory Usage (GB)", limits=c(0, 32), breaks=seq(0,36,4)) + scale_x_reverse(name="Moving Resolution (mm)", limits=c(2, 0.25), breaks=seq(0.25,2,0.25),
  minor_breaks=seq(0.25,2,0.125)) + geom_line()

qplot(fixed,memoryGB.mean,data=summary,color=as.factor(moving)) + geom_hline(yintercept=c(8,16,24,32)) +
  scale_y_continuous(name="Peak Memory Usage (GB)", limits=c(0, 32), breaks=seq(0,36,4)) +  scale_x_reverse(name="Fixed Resolution (mm)", limits=c(2, 0.25), breaks=seq(0.25,2,0.25),
  minor_breaks=seq(0.25,2,0.125)) + geom_line()

qplot(fixed,timeHR.mean,data=summary,color=as.factor(moving)) + geom_line() + scale_y_continuous(name="Time (hours)") + scale_x_reverse(name="Fixed Resolution (mm)", limits=c(2, 0.25), breaks=seq(0.25,2,0.25),
  minor_breaks=seq(0.25,2,0.125))
qplot(moving,timeHR.mean,data=summary,color=as.factor(fixed)) + geom_line() + scale_y_continuous(name="Time (hours)") + scale_x_reverse(name="Moving Resolution (mm)", limits=c(2, 0.25), breaks=seq(0.25,2,0.25),
  minor_breaks=seq(0.25,2,0.125))

#qplot(fixed,memoryGB.mean,data=subset(summary, moving==1 | moving==0.3),color=as.factor(moving)) + scale_x_reverse() + geom_hline(yintercept=c(8,16,24,32)) +
#  scale_y_continuous(name="Peak Memory Usage (GB)", limits=c(0, 32), breaks=seq(0,36,4)) + geom_line()



m = nlsLM(memoryGB ~ a*exp(b/fixed) + d*exp(e/moving) + f, data=filtered.data, control = list(maxiter=200, warnOnly=TRUE))
mygrid = expand.grid(seq(0.5,2.1,0.1), seq(0.25,2.1,0.1))
names(mygrid) = c("fixed","moving")
mygrid$prediction = predict(m, mygrid)
mygrid2 = interp(mygrid$fixed,mygrid$moving,mygrid$prediction)
plot3d(summary$fixed,summary$moving,summary$memoryGB.mean, type = 's', size = 1, box = FALSE, xlab = "Fixed Resolution (mm)", ylab = "Moving Resolution (mm)", zlab = "Memory (GB)")
surface3d(mygrid2$x, mygrid2$y, mygrid2$z, color = "steelblue",
          alpha = 0.5, lit=FALSE)

m2 = nlsLM(time ~ a*exp(b/fixed) + d, data=filtered.data, control = list(maxiter=200, warnOnly=TRUE))
summary(m2)
