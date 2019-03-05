### Brand Preference (Sony vs. Acer)

#### Introduction
The aim of this report is to show the findings from the predicted *brand preferences* of the clients between Sony and Acer, and come to a conclusion on with which brand to have a deeper strategic relationship.

#### Executive Summary
***Attention:*** There is serious doubt regarding if the client sample of this survey is representative of the population because both the Complete and Incomplete dataset has **uniform distributions**.

Assuming that the dataset is representative, both the real brand preferences from the complete and predicted ones from the incomplete data shows the same preference ratio: **38% Acer and 62% Sony**. 

A better approach would be looking at different age groups and different salary ranges to define the preferences of different customer groups. The following graph demonstrates it the best: 

(((( IMAGE ))))

#### Analysis
Almost all of the data is uniformly distributed, which most probably does not represent our real-life customer base (An example can be seen below). 

(((( IMAGE ))))

Still, I went ahead with the analysis to show the preferences of different customer profiles. The most important information for the analysis is the one that shows the joint correlation between Salary+Age with Brand Preferences. 

(((( IMAGE ))))

As a result of the above scatterplot, to better see how certain age groups behave, I binned the age to 3: 20-40, 40-60 and 60-80.

(((( IMAGE ))))

I use C5.0 model to predict the incomplete data. Although both models gave a similarly good accuracy, C5.0 was slightly better. The features relevant for our model -as I predicted from the above graphs- are salary and age. 

(((( IMAGE ))))

The following confusion plot shows how well our model did predicting the brands, looking at a test set inside the Complete Dataset. 

(((( IMAGE ))))

In addition, we can see that the preference distribution is the same in the real preferences from the complete set and the predicted ones for the incomplete one.

#### Conclusions
* The data sample is almost 100% not representative of our real-life customers. Hence, any analysis made on this data should be taken with a grain of salt.
* Although we cannot predict the brand preferences for the total population, the analysis gives us a very good idea about the behavior of certain age and salary groups.
* This information should be projected to the real customer distribution to understand which brand to have a deeper strategic relationship with. 

### Tech Appendix
In this section we can see a bit more about how our models did and some comparisons.

The below graph shows how our model did. Working on the testing set taken from the Complete Survey data, we tried predicting the actual preferences. 
Our model did a pretty good job in general. The only parts that it was confused was the borders of the different age-salary groups which obviously is harder to predict. 

(((( IMAGE ))))

Both models have very good performances.

(((( IMAGE ))))

#### C5.0

(((( IMAGE ))))

Both models give very high accuracies and decent kappas.
Furthermore, the predictions of the models are almost exactly the same, therefore the model selection does not have crucial importance.


