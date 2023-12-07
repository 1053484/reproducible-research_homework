---
output:
  pdf_document: default
  html_document: default
---
# Reproducible research: version control and R

Candidate number: 1053484

Questions 1, 2 & 3: 

[Linked here](https://github.com/841053/logistic_growth/tree/main/LogisticGrowthProject)

Question 4:
4.1 What do you observe?

A generated data frame defined as df, creates coordinates x and y at each time point starting at time 1. The first row and timepoint of df is assigned x and y coordinates of 0, 0. This means the walk always starts at these coordinates. 
From here a for loop denotes the rest of the coordinates starting from row two, with a constant 'step' size set at 0.25. The 'runif' function generates random deviates for the angle of the step bewteen 0 and 2pi. Then df is built upon, with the x based on the cosine of the random angles and the y based on the sine of the angle, both of which are multiplied by the step size of 0.25 to create the next coordinates at the next timepoint. This is repeated and builds up df. Data1 is df for 500 steps. Data2 is the same but is run separately to create other random angles for each step.  

A plot is then generated based on these datasets. 'plot1' is a ggplot with coordinates based on the x and y coordinates in data1. Function geom_path creats a plot whereby the generated coordinates are connected based on the order they appear in time, whilst the colour is also denoted by timepoint. 'plot2' is the same but instead based on coordinates in data2. The two plots are presented next to each other with number of colours for the two plots as two. 

The result is 2 randomly generated paths with 500 steps, the step distance is the same throughout but the angle of the step is random from one step to the next. The two colours are gradiented based on time, this allows us to observe the direction of the path in time. Because there are no limits in how far the coordinates reach, the plots are not scaled with each other.
Each time you run the code, the datasets can change, and therefore changing the plots.

4.2 Investigate the term 'random seeds'

Wikepedia defines a random seed as 'a number (or vector) used to initialise a pseudorandom number generator.' Pseudorandomness makes random processes detirministic and repeatable. A seed determines the outcome of the pseudorandomly generated numbers. A seed can be defined in programming, in R this is done by using the 'set.seed()' function.
Without a set seed detirmining the psuedorandom outcome, the seed will be set by default states of the computer system (e.g. Time). In situations where reproducibility is crucial then a seed must be set so others can see your results.

4.3 Generate a reproducible simulation of brownian motion.

4.4 Image showing commit
![Image showing commit changes](https://github.com/841053/reproducible-research_homework/blob/main/question%204%20commit.jpg)

# Question 5: 

Relationship between virus particle volume and genome length

[code found here](https://github.com/841053/reproducible-research_homework/blob/main/question-5-data/question_5_code.R)

5.1 How many rows and columns?
```{r}
#Dimensions i.e. number of rows and columns
dim.data.frame(q5_data)
```
There are 33 rows and 13 columns in the table.

5.2 What transformations can you use to fit a linear model to the data? Apply the transformation

**$`ln(V)=ln(\beta)+ ln(L){\alpha}`$**

A natural log can be used to fit a linear model to the data to apply the log I used the below code.
```{r}
#Clean column names
install.packages("janitor")
library(janitor)
q5_data_clean<-clean_names(q5_data)
#Log transform columns
q5_data_clean$log_genome_length<-log(q5_data_clean$genome_length_kb)
q5_data_clean$log_virion_volume<-log(q5_data_clean$virion_volume_nm_a_nm_a_nm)
```
5.3 Find exponent and scaling factor of the allometric law for dsDNA viruses and write p-values from the model you obtained.

```{r}
linear_model<-lm(log_virion_volume~log_genome_length, q5_data_clean )
summary(linear_model)

```
5.3.1 find estimates and p-values:
- Exponent ($\alpha$) estimate = 1.52
   - P-value of $\alpha$ estimate = 6.44e-10
- Scaling factor ($\beta$) estimate = 1182
   - P-value of $\beta$ = 2.28e-10

5.3.2 Are they statistically significant?
Both p-values are smaller than 0.05 therefore the estimates are statistically significant.

5.3.3 Compare the values to those shown in the paper, did you find the same values?
My results match the results for dsDNA in the paper.

5.4 Write the code to reproduce the figure shown below
```{r}
#plot

plot<-ggplot(q5_data_clean, aes(x=log_genome_length,y=log_virion_volume))+
  geom_point(size=2)+
  geom_smooth(method = lm, size=1)+
  labs(x="log [Genome length (kb)]", y="log [Virion volume (nm3)]")+
  theme_bw()+
  theme(axis.title=element_text(face="bold"))

plot

```
[Figure as png](https://github.com/841053/reproducible-research_homework/blob/main/question-5-data/reproduced_figure.png)

5.5 What is the estimated volume of a 300 kb dsDNA virus?
Using the linear model I can estimate the volume of a 300 kb dsDNA virus using the predict function.
The estimated volume of a 300kb dsDNA virus under the linear model is 6,698,076nm^3

```{r}
#5.5 Estimating virus volume

#Linear model
linear_model_2<-lm(log(virion_volume_nm_a_nm_a_nm)~log(genome_length_kb), q5_data_clean )
summary(linear_model_2)

#Creating a data.frame with a genome length of 300kb
genome_300_kb<-data.frame(genome_length_kb=(300))

#Using predict() function to estimate volume for this value
log_estimated_volume<-predict(linear_model_2, newdata=genome_300_kb)

#Back-transforming the volume to get true volume in nm^3
estimated_volume<-exp(log_estimated_volume)

print(estimated_volume)

```
Bonus: Explain the difference between reproducibility and replicability in scientific research. How can git and GitHub be used to enhance the reproducibility and replicability of your work? what limitations do they have? (e.g. check the platform [protocols.io](https://www.protocols.io/)).

If a scientific analysis is reproducible, the analysis of the same dataset can be rerun to create the same results. Data and analysis codes should be provided alongside the published results to increase the reproducibility of published research. This would allow others to ensure the credibility of the results by replicating the analysis. Replicability is when the same results are found using different datasets and analyses, which would further enhance the credibility of scientific findings. 

Git is a version control system that records changes to code in repositories. This allows researchers to return to previous versions of the code. This is important for reproducibility as the code used to create published results can always be traced by looking at commit histories. This code can then be reviewed to ensure the validity of results, and that no mistakes were made that could lead to incorrect results. The fact that Git has a remote repository, as well as a local repository, ensures that the code can constantly be retrieved if the local repository is lost. Git’s documentation of coding history can also be necessary for replicability. If a new dataset is generated, researchers can look back at what has been analysed for similar datasets to gather ideas for what kind of analysis they would wish to perform and test to see if they produce the same results.

GitHub is an online platform whereby the Git repository can be shared; this allows for reproducibility across the scientific field as other researchers can access the code for one analysis and reproduce the same results. They can also review the code to ensure no mistakes were made or worse that specific data was tampered with to produce a desirable result. GitHub also has a useful user interface with the incorporation of readme.md files can help provide insights into navigating complex analyses and large amounts of data.

However, although these systems allow for the reproducibility of the analysis, they don’t account for the replicability of the dataset. If someone wanted to replicate the results with a new dataset, there are no records of how data had been collected and measured previously. Issues with experimental design whilst collecting data could lead to a misleading/incorrect result when that data is analysed. 

Platform protocols.io tackles the limitation of the reproducibility of experimental methods. It is a platform where all methods of an experiment can be shared across a community or between individuals. It has elements similar to GitHub, such as forking, but instead of only annotating and reproducing code, many methods can be shared for all types of experiments. The website states numerous examples of protocols already shared, including molecular biology, medical trials and ecology. This means experiments can be made replicable and test the credibility of results. 


## Instructions

The homework for this Computer skills practical is divided into 5 questions for a total of 100 points (plus an optional bonus question worth 10 extra points). First, fork this repo and make sure your fork is made **Public** for marking. Answers should be added to the # INSERT ANSWERS HERE # section above in the **README.md** file of your forked repository.

Questions 1, 2 and 3 should be answered in the **README.md** file of the `logistic_growth` repo that you forked during the practical. To answer those questions here, simply include a link to your logistic_growth repo.

**Submission**: Please submit a single **PDF** file with your candidate number (and no other identifying information), and a link to your fork of the `reproducible-research_homework` repo with the completed answers. All answers should be on the `main` branch.

## Assignment questions 

1) (**10 points**) Annotate the **README.md** file in your `logistic_growth` repo with more detailed information about the analysis. Add a section on the results and include the estimates for $N_0$, $r$ and $K$ (mention which *.csv file you used).
   
2) (**10 points**) Use your estimates of $N_0$ and $r$ to calculate the population size at $t$ = 4980 min, assuming that the population grows exponentially. How does it compare to the population size predicted under logistic growth? 

3) (**20 points**) Add an R script to your repository that makes a graph comparing the exponential and logistic growth curves (using the same parameter estimates you found). Upload this graph to your repo and include it in the **README.md** file so it can be viewed in the repo homepage.
   
4) (**30 points**) Sometimes we are interested in modelling a process that involves randomness. A good example is Brownian motion. We will explore how to simulate a random process in a way that it is reproducible:

   - A script for simulating a random_walk is provided in the `question-4-code` folder of this repo. Execute the code to produce the paths of two random walks. What do you observe? (10 points)
   - Investigate the term **random seeds**. What is a random seed and how does it work? (5 points)
   - Edit the script to make a reproducible simulation of Brownian motion. Commit the file and push it to your forked `reproducible-research_homework` repo. (10 points)
   - Go to your commit history and click on the latest commit. Show the edit you made to the code in the comparison view (add this image to the **README.md** of the fork). (5 points)

5) (**30 points**) In 2014, Cui, Schlub and Holmes published an article in the *Journal of Virology* (doi: https://doi.org/10.1128/jvi.00362-14) showing that the size of viral particles, more specifically their volume, could be predicted from their genome size (length). They found that this relationship can be modelled using an allometric equation of the form **$`V = \beta L^{\alpha}`$**, where $`V`$ is the virion volume in nm<sup>3</sup> and $`L`$ is the genome length in nucleotides.

   - Import the data for double-stranded DNA (dsDNA) viruses taken from the Supplementary Materials of the original paper into Posit Cloud (the csv file is in the `question-5-data` folder). How many rows and columns does the table have? (3 points)
   - What transformation can you use to fit a linear model to the data? Apply the transformation. (3 points)
   - Find the exponent ($\alpha$) and scaling factor ($\beta$) of the allometric law for dsDNA viruses and write the p-values from the model you obtained, are they statistically significant? Compare the values you found to those shown in **Table 2** of the paper, did you find the same values? (10 points)
   - Write the code to reproduce the figure shown below. (10 points)

  <p align="center">
     <img src="https://github.com/josegabrielnb/reproducible-research_homework/blob/main/question-5-data/allometric_scaling.png" width="600" height="500">
  </p>

  - What is the estimated volume of a 300 kb dsDNA virus? (4 points)

**Bonus** (**10 points**) Explain the difference between reproducibility and replicability in scientific research. How can git and GitHub be used to enhance the reproducibility and replicability of your work? what limitations do they have? (e.g. check the platform [protocols.io](https://www.protocols.io/)).
