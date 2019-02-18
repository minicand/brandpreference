#Multicore processing
install.packages("doMC")
library(doMC)
registerDoMC(cores=4)

#if(file.exists("./whatever.plot")){
#  plot1 <- load("whatever.plot")
#  plot1
#} else {
#  print("I dont have the file")
#}

##Installation of Caret and other packages
install.packages("caret", dependencies = c("Depends", "Suggests"))
install.packages("generics")
install.packages("gower")
install.packages("corrplot")
install.packages("ggridges")
install.packages("MLmetrics")
install.packages("ggplot2")
install.packages("ape")
install.packages("mlbench")
library("caret")
library("lattice")
library("MLmetrics")
library("readr")
library("ggplot2")
library("ggridges")
library("mlbench")
library("ape")

##Import and explore CompleteResponses
setwd("/Users/denizminican/documents/data")
Responses <- read.csv("CompleteResponses.csv")
Responses

#To see if there are duplicates
summary(duplicated(Responses))
##PREPROCESSING
#Type changes
as.ordered(Responses$elevel)
Responses$elevel <- as.ordered(Responses$elevel)
Responses$zipcode <- as.factor(Responses$zipcode)
Responses$car <- as.factor(Responses$car)
Responses$brand <- as.factor(Responses$brand)
levels(Responses$brand) <- c("Acer","Sony")

#Binning Age 
min(Responses$age)
agebin <- cut(Responses$age, 3, labels= c("20-40", "40-60", "60-80"))
agebin  

##Graphs
#Salary vs Brand
ggplot(Responses, aes(x=brand, y=salary, fill=brand))+ geom_boxplot()+ 
  ggtitle("Brand Preference-Salary")+ xlab("preference")
#Salary vs Age
ggplot(Responses, aes(x=brand, y=age, fill=brand))+ geom_boxplot()+ 
  ggtitle("Brand Preference-Age")+ xlab("preference")
#Salary vs Brand (density)
ggplot(Responses, aes(x=salary, y=brand, fill=brand, alpha=0.8))+ 
  geom_density_ridges()
#Salary+Age vs Brand ***
ggplot(Responses, aes(x=salary, y=age, color= brand))+ 
  geom_point()
#Salary]Age vs. Brand density***
ggplot(Responses, aes(x=salary, y=agebin, fill= brand, alpha=0.8))+ geom_density_ridges()+
  ylab("age") + guides(alpha=FALSE)
#Histograms
hist(Responses$age)
hist(Responses$salary)
z <- table(Responses$zipcode, Responses$brand)
barplot(z)
ggplot(Responses, aes(x=brand, y=credit, fill=brand))+geom_boxplot()

###MODEL TRAINING
set.seed(320)
training_indices <- createDataPartition(Responses$brand,p=.75, list=FALSE)  
trainSet <- Responses[training_indices, ]
testSet <- Responses[-training_indices, ]

###RANDOM FOREST
fitControl <- trainControl(method = "repeatedcv", 
                           number = 10,
                           classProbs = TRUE, 
                           summaryFunction = twoClassSummary)
system.time(rfFit1 <- train(brand~ ., data = trainSet, 
                            method = "rf",
                            metric= "ROC",
                            trControl=fitControl, 
                            tuneLength = 2))
rfFit1
#Test Predictions
rfPred1 <- predict(rfFit1, newdata = testSet)
rfProbs1 <- predict(rfFit1, newdata = testSet, type = "prob")
rfProbs1
testSet$rfPred1 <- rfPred1
ggplot(varImp(rfFit1))+geom_point(color="blue")

##MODEL ASSESSMENT
#Confusion Matrix
confusionMatrix(data=rfPred1, testSet$brand)
ggplot(testSet, aes(x=brand, y=rfPred1, color=brand))+ geom_jitter()

Error <- which(testSet$rfPred1 != testSet$brand)
testSet$error <- 0
testSet[Error,]$error<- 1
Error
ggplot(testSet, aes(x=salary, y=age, color=error))+geom_point()

###DECISION TREE C5.0
#install.packages("inum")
#install.packages("C50")
library("C50")
fitControl <- trainControl(method = "repeatedcv", 
                           number = 10, classProbs = TRUE, 
                           summaryFunction = twoClassSummary)
#Error: (when brands are 0 and 1) Class probabilities are needed to score models 
#using the area under the ROC curve. Set `classProbs = TRUE` in the trainControl() function.
system.time(dtFit1 <- train(brand~ .,
                            data = trainSet, 
                            method = "C5.0", 
                            metric="ROC", 
                            trControl = fitControl, 
                            tuneLength = 2))
summary(dtFit1)
dtFit1
varImp(dtFit1)
plot(varImp(dtFit1))

##MODEL ASSESSMENT
#Confusion Matrix
confusionMatrix(data=rfPred1, testSet$brand)
ggplot(testSet, aes(x=brand, y=rfPred1, color=brand))+ geom_jitter()
ggplot(rfPred1, aes(Brand))+geom_histogram()

Error <- which(testSet$rfPred1 != testSet$brand)
testSet$error <- 0
testSet[Error,]$error<- 1
Error
ggplot(testSet, aes(x=salary, y=age, color=error))+geom_point()

#Test Predictions
dtPred1 <- predict(dtFit1, newdata = testSet)
str(dtPred1)
dtProbs1 <- predict(dtFit1, newdata = testSet, type = "prob")
dtProbs1
testSet$dtPred1 <- dtPred1
ggplot(varImp(dtFit1))+geom_point(color="blue")

##Model Comparison
models <- resamples(list(rf = rfFit1, C5.0 = dtFit1))
models
summary(models)
postResample(dtPred1,testSet$brand)
postResample(rfPred1,testSet$brand)

###PREDICTIONS
Incomplete <- read.csv("SurveyIncomplete.csv")
levels(Incomplete$brand) <- c("Acer","Sony")
Incomplete$elevel <- as.ordered(Incomplete$elevel)
Incomplete$zipcode <- as.factor(Incomplete$zipcode)
Incomplete$car <- as.factor(Incomplete$car)
agebin2 <- cut(Incomplete$age, 3, labels= c("20-40", "40-60", "60-80"))
agebin2  

##With Random Forest
rfP1 <- predict(rfFit1, newdata = Incomplete)
str(rfP1)
rfPr1 <- predict(rfFit1, newdata = Incomplete, type = "prob")
rfPr1
Incomplete$brand.pred.rf <- rfP1
plot(rfP1)
summary(rfP1)

#Salary+Age vs Brand ***
ggplot(Incomplete, aes(x=salary, y=age, color= brand.pred.rf))+ 
  geom_point()
#Salary, Age vs. Brand density***
ggplot(Incomplete, aes(x=salary, y=agebin2, fill= brand.pred.rf, alpha=0.8))+ geom_density_ridges()+
  ylab("age") + guides(alpha=FALSE)

##With C5.0
dtP1 <- predict(dtFit1, newdata = Incomplete)
str(dtP1)
dtPr1 <- predict(dtFit1, newdata = Incomplete, type = "prob")
dtPr1
Incomplete$brand.pred.dt <- dtP1
plot(dtP1)
summary(dtP1)

##Joining Model Graphs
#Salary+Age vs Brand
plot1 <- ggplot(Incomplete, aes(x=salary, y=age, color= brand.pred.rf, fill= brand.pred.rf))+geom_point()
save(plot1, file = "whatever.plot")
#Salary+Age vs. Brand density
ggplot(Incomplete, aes(x=salary, y=agebin2, fill= brand.pred.rf, alpha=0.8))+ geom_density_ridges()+
  ylab("age") + guides(alpha=FALSE)
#Salary/Age per Brand
ggplot(Incomplete, aes(x=salary, y=agebin2, fill= brand.pred.rf, alpha=0.8))+ geom_density_ridges()+
  ylab("age") + guides(alpha=FALSE)+ facet_grid(brand.pred.rf ~ .)


