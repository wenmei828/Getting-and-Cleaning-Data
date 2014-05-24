#read all needed data
library(data.table)
testdata<-read.table("./test/X_test.txt")
traindata<-read.table("./train/X_train.txt")
feature<-read.table("features.txt")
testlabel<-read.table("./test/y_test.txt",colClasses="numeric")
trainlabel<-read.table("./train/y_train.txt",colClasses="numeric")
testsubject<-read.table("./test/subject_test.txt")
trainsubject<-read.table("./train/subject_train.txt")

#merge into one data set
data<-rbind(traindata,testdata)
names(data)<-feature[,2]
datalabel<-rbind(trainlabel,testlabel)
names(datalabel)<-c("activity")
datasubject<-rbind(trainsubject,testsubject)
names(datasubject)<-c("subject")
datawanted<-cbind(datasubject,datalabel,data[,grep("mean|std",names(data))])


#Creates a second, independent tidy data set with the average of each variable for each activity and each subject
require(plyr)
results<-ddply(datawanted, .(subject,activity), function(x) {unlist(lapply(x, mean, na.rm = T))})
results$activity<-sapply(results$activity,switch,'1'="WALKING",'2'="WALKING_UPSTAIRS",'3'="WALKING_DOWNSTAIRS",'4'="SITTING",'5'="STANDING",'6'="LAYING")
write.table(results, "data_set_with_the_averages.txt")


