#Read Data
Sys.setenv(JAVA_HOME="C:\\Program Files\\Java\\jdk\\jre")
path <-"C:\\processing arduino\\processing_code\\sample\\202012499.csv"
data <-read.csv(path)

data$Status = as.factor(data$Status)

#partition of the data into 80:20
data_set_size=floor(nrow(data)*0.80)
index <- sample(1:nrow(data),size=data_set_size)
training <-data[index,]
testing <-data[-index,]

#Random Forest Model
#install.packages("randomForest")
library(randomForest)
rf1 <- randomForest(Status~., data = training,ntree=100,mtry=3,importance=TRUE,proximity=TRUE)
rf1
attributes(rf1)


# Prediction and Confusion matrix for train data
library(caret)
library(e1071)
predTrain <- predict(rf1, training,type="class")

cm1 <- confusionMatrix(predTrain,training$Status)
cm1


# Prediction and confusion matrix for test data
predTest <- predict(rf1, testing)
# calculate the confusion matrix
cm2 <- confusionMatrix(data = predTest, reference = testing$Status)
cm2

draw_confusion_matrix <- function(cm2) {
 
  layout(matrix(c(1,1,2)))
  par(mar=c(2,2,2,2))
  plot(c(100, 345), c(300, 450), type = "n", xlab="", ylab="", xaxt='n', yaxt='n')
  title('CONFUSION MATRIX', cex.main=2)
 
  # create the matrix
  rect(150, 430, 240, 370, col='#3F97D0')
  text(195, 435, '0', cex=1.2)
  rect(250, 430, 340, 370, col='#F7AD50')
  text(295, 435, '1', cex=1.2)
  text(125, 370, 'Predicted', cex=1.3, srt=90, font=2)
  text(245, 450, 'Actual', cex=1.3, font=2)
  rect(150, 305, 240, 365, col='#F7AD50')
  rect(250, 305, 340, 365, col='#3F97D0')
  text(140, 400, '1', cex=1.2, srt=90)
  text(140, 335, '0', cex=1.2, srt=90)
  text(50,5,'Random Forest',cex=1.3,font=2)
 
  # add in the cm results
  res <- as.numeric(cm2$table)
  text(195, 400, res[1], cex=1.6, font=2, col='white')
  text(195, 335, res[2], cex=1.6, font=2, col='white')
  text(295, 400, res[3], cex=1.6, font=2, col='white')
  text(295, 335, res[4], cex=1.6, font=2, col='white')
 
  # add in the specifics
  plot(c(100, 0), c(100, 0), type = "n", xlab="", ylab="", main = "DETAILS", xaxt='n', yaxt='n')
  text(10, 85, names(cm2$byClass[1]), cex=1.2, font=2)
  text(10, 70, round(as.double(cm2$byClass[1]), 3), cex=1.2)
  text(30, 85, names(cm2$byClass[2]), cex=1.2, font=2)
  text(30, 70, round(as.double(cm2$byClass[2]), 3), cex=1.2)
  text(50, 85, names(cm2$byClass[5]), cex=1.2, font=2)
  text(50, 70, round(as.double(cm2$byClass[5]), 3), cex=1.2)
  text(70, 85, names(cm2$byClass[6]), cex=1.2, font=2)
  text(70, 70, round(as.double(cm2$byClass[6]), 3), cex=1.2)
  text(90, 85, names(cm2$byClass[7]), cex=1.2, font=2)
  text(90, 70, round(as.double(cm2$byClass[7]), 3), cex=1.2)
 
  # add in the accuracy information
  text(30, 35, names(cm2$overall[1]), cex=1.5, font=2)
  text(30, 20, round(as.double(cm2$overall[1]), 3), cex=1.4)
  text(70, 35, names(cm2$overall[2]), cex=1.5, font=2)
  text(70, 20, round(as.double(cm2$overall[2]), 3), cex=1.4)
}
draw_confusion_matrix(cm2)

#error rate
plot(rf1)

#Tune mtry
t <- tuneRF(training[,-13],training[,13],stepFactor = 0.5,plot=TRUE,ntreeTry = 100, trace=TRUE,improve = 0.05)

#no of nodes for the trees
hist(treesize(rf1),main="no of trees",col="green")

varImpPlot(rf1)

#partialplot
partialPlot(rf1,training,Rain.Status,"0")
partialPlot(rf1,training,Rain.Status,"1")


#multiDimensional Scaling Plot of proximity Matrix
MDSplot(rf1,training$Status,xlab="Model",ylab="Status")
