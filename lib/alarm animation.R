##  ANIMATED BARPLOT TRANSITION(alarm source)
# libraries:
devtools::install_github("dgrtwo/gganimate")
library(gganimate)
library(ggplot2)
library(tidyverse)
library(tweenr)
library(magick)
library(tibble)
library(animation)
#theme_set(theme_bw())

fireincident<-read.csv(choose.files())
#saveRDS(fireincident, "fireincident.rds")
#fireincident<-read_rds("fireincident.rds")
head(fireincident)
boroughs <- factor(unique(fireincident[,2]))
alarm    <- factor(unique(fireincident[,3]))

summary(fireincident$ALARM_SOURCE_DESCRIPTION_TX[1:11079])
summary(fireincident$ALARM_SOURCE_DESCRIPTION_TX[1:24999])

summary(fireincident$ALARM_SOURCE_DESCRIPTION_TX)

# from UCT/911 to Default record
c(dim(fireincident[fireincident$ALARM_SOURCE_DESCRIPTION_TX == "UCT/911", ])[1]
,dim(fireincident[fireincident$ALARM_SOURCE_DESCRIPTION_TX == "Verbal", ])[1]
,dim(fireincident[fireincident$ALARM_SOURCE_DESCRIPTION_TX == "Phone", ])[1]
,dim(fireincident[fireincident$ALARM_SOURCE_DESCRIPTION_TX == "Private Fire Alarm", ])[1]
,dim(fireincident[fireincident$ALARM_SOURCE_DESCRIPTION_TX == "ERS", ])[1]
,dim(fireincident[fireincident$ALARM_SOURCE_DESCRIPTION_TX == "EMS Link/Medical", ])[1]
,dim(fireincident[fireincident$ALARM_SOURCE_DESCRIPTION_TX == "BARS", ])[1]
,dim(fireincident[fireincident$ALARM_SOURCE_DESCRIPTION_TX == "PD Link/Medical", ])[1]
,dim(fireincident[fireincident$ALARM_SOURCE_DESCRIPTION_TX == "ERS No Contact", ])[1]
,dim(fireincident[fireincident$ALARM_SOURCE_DESCRIPTION_TX == "DEFAULT RECORD", ])[1])


# Make 2 basic barplots
b=data.frame(group=c("UCT/911", "Verbal", "Phone", "Private", "ERS", "EMS Link/Medical", "BARS", "PD Link/Medical", "ERS No Contact", "DEFAULT"), values= c(13360, 327, 1437, 10961, 76, 5, 8, 18, 11, 3), frame=rep('b',10), time = 2015)
a=data.frame(group=c("UCT/911", "Verbal", "Phone", "Private", "ERS", "EMS Link/Medical", "BARS", "PD Link/Medical", "ERS No Contact", "DEFAULT"), values= rep(1, 10), frame=rep('b',10), time = 0)
c = data.frame(group=c("UCT/911", "Verbal", "Phone", "Private", "ERS", "EMS Link/Medical", "BARS", "PD Link/Medical", "ERS No Contact", "DEFAULT"), values= c(6090, 166, 745, 4020, 41, 1, 5, 8, 3, 1), frame=rep('b',10), time = 2013)
d = data.frame(group=c("UCT/911", "Verbal", "Phone", "Private", "ERS", "EMS Link/Medical", "BARS", "PD Link/Medical", "ERS No Contact", "DEFAULT"), values= c(12759, 323, 1382, 10422, 73, 4, 8, 15,10,3), frame=rep('b',10), time = 2014)
ggplot(b, aes(x=group, y=log(values), fill=group)) + 
  geom_bar(stat='identity')

# Interpolate data with tweenr
ts <- list(a, c, d, b, a)
tf <- tween_states(ts, tweenlength = 0.2, statelength = 0.05, ease = c('quintic-in-out'), nframes = 20)
tf

# Make a barplot with frame
library(RColorBrewer)
p=ggplot(tf, aes(x=group, y=log(values), fill=group, frame= .frame)) + 
  geom_bar(stat='identity', position = "identity")+
  labs(title = "Changes of Alarm Sources by Types")+
  scale_color_brewer(palette="Set3")+
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())
    
Sys.setenv(PATH = paste("C:/Pprogra~1/ImageMagick-7.0.7-Q16",
                        Sys.getenv("PATH"), sep = ";"))
ani.options(convert = 'C:/progra~1/ImageMagick-7.0.7-Q16/convert.exe')

gganimate(p)
image_write(p, path = "p.gif", format = "gif")


data <- data.frame(
  x = rnorm(100),
  y = rnorm(100),
  time = sample(50, 100, replace = TRUE)
)
data.x <- tween_appear(data, 'time', nframes = 200)
data.x
