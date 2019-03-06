### Brand Preference (Sony vs. Acer)

#### Introduction
The aim of this report is to show the findings from the predicted *brand preferences* of the clients between Sony and Acer, and come to a conclusion on with which brand to have a deeper strategic relationship.

#### Executive Summary
***Attention:*** There is serious doubt regarding if the client sample of this survey is representative of the population because both the Complete and Incomplete dataset has **uniform distributions**.

Assuming that the dataset is representative, both the real brand preferences from the complete and predicted ones from the incomplete data shows the same preference ratio: **38% Acer and 62% Sony**. 

A better approach would be looking at different age groups and different salary ranges to define the preferences of different customer groups.

#### Analysis
Almost all of the data is uniformly distributed, which most probably does not represent our real-life customer base (An example can be seen below). 

![histogram](https://user-images.githubusercontent.com/40642054/53869892-67a84b80-3ff9-11e9-8f3c-01f6beeb977d.png)

Still, I went ahead with the analysis to show the preferences of different customer profiles. The most important information for the analysis is the one that shows the joint correlation between Salary+Age with Brand Preferences. 

![age-salary_cross](https://user-images.githubusercontent.com/40642054/53869885-670fb500-3ff9-11e9-9b14-eb1a1b2a8a61.png)

As a result of the above scatterplot, to better see how certain age groups behave, I binned the age to 3: 20-40, 40-60 and 60-80.

![first](https://user-images.githubusercontent.com/40642054/53869894-67a84b80-3ff9-11e9-82d1-75817886035c.png)

I use C5.0 model to predict the incomplete data. Although both models gave a similarly good accuracy, C5.0 was slightly better. The features relevant for our model -as I predicted from the above graphs- are salary and age. 

![varimp](https://user-images.githubusercontent.com/40642054/53869895-67a84b80-3ff9-11e9-86bf-da3028fcce9c.png)

The following confusion plot shows how well our model did predicting the brands, looking at a test set inside the Complete Dataset. 

![confusion](https://user-images.githubusercontent.com/40642054/53869891-67a84b80-3ff9-11e9-8047-1739191b9e6f.png)

In addition, we can see that the preference distribution is the same in the real preferences from the complete set and the predicted ones for the incomplete one.

![complete](https://user-images.githubusercontent.com/40642054/53869889-670fb500-3ff9-11e9-8456-d97a9b3752e2.png)
![incomplete](https://user-images.githubusercontent.com/40642054/53869893-67a84b80-3ff9-11e9-9940-24c92ef79cf4.png)

#### Conclusions
* The data sample is almost 100% not representative of our real-life customers. Hence, any analysis made on this data should be taken with a grain of salt.
* Although we cannot predict the brand preferences for the total population, the analysis gives us a very good idea about the behavior of certain age and salary groups.
* This information should be projected to the real customer distribution to understand which brand to have a deeper strategic relationship with. 

#### Tech Appendix
In this section we can see a bit more about how our models did and some comparisons.

The below graph shows how our model did. Working on the testing set taken from the Complete Survey data, we tried predicting the actual preferences. 
The model did a pretty good job in general. The only parts that it was confused was the borders of the different age-salary groups which obviously is harder to predict. 

![borders](https://user-images.githubusercontent.com/40642054/53869886-670fb500-3ff9-11e9-8ea9-3d7e44b3f26f.png)

Both models have very good performance metrics.
```r
summary(models)
## 
## Call:
## summary.resamples(object = models)
## 
## Models: rf, C5.0 
## Number of resamples: 10 
## 
## ROC 
##           Min.   1st Qu.    Median      Mean   3rd Qu.      Max. NA's
## rf   0.9753316 0.9768674 0.9777253 0.9796653 0.9830083 0.9877259    0
## C5.0 0.9718653 0.9778052 0.9805437 0.9795956 0.9825665 0.9849507    0
## 
## Sens 
##           Min.   1st Qu.    Median      Mean   3rd Qu.      Max. NA's
## rf   0.8785714 0.8790036 0.8843416 0.8917349 0.8967050 0.9359431    0
## C5.0 0.8714286 0.8840271 0.8950178 0.8970653 0.9092527 0.9217082    0
## 
## Spec 
##           Min.   1st Qu.    Median      Mean   3rd Qu.      Max. NA's
## rf   0.9112554 0.9247835 0.9318182 0.9330657 0.9398999 0.9609544    0
## C5.0 0.9240781 0.9290750 0.9318182 0.9350039 0.9365862 0.9523810    0
```

#### C5.0
```r
postResample(dtPred1,testSet$brand)
##  Accuracy     Kappa 
## 0.9284559 0.8478110
```
#### Random Forest
```r
postResample(rfPred1,testSet$brand)
##  Accuracy     Kappa 
## 0.9219887 0.8339843
```

Both models give very high accuracies and decent kappas. Furthermore, the predictions of the models are almost exactly the same, therefore the model selection does not matter in this case.
```r
summary(dtP1)
## Acer Sony 
## 1888 3112
summary(rfP1)
## Acer Sony 
## 1887 3113
```

