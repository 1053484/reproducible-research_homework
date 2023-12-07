#Loading the data into environment
q5_data<-read.csv("question-5-data/Cui_etal2014.csv")
#Summary
summary(q5_data)
#Dimensions i.e. number of rows and columns
dim.data.frame(q5_data)

#Plot the virion volume against genome size
# Install packages
install.packages("ggplot2")
library(ggplot2)
install.packages("dplyr")
library(dplyr)
install.packages("janitor")
library(janitor)
install.packages("ragg")
library(ragg)

#Clean column names
q5_data_clean<-clean_names(q5_data)

#Log transform columns and add columns to dataset
q5_data_clean$log_genome_length<-log(q5_data_clean$genome_length_kb)
q5_data_clean$log_virion_volume<-log(q5_data_clean$virion_volume_nm_a_nm_a_nm)

#Linear Model
linear_model<-lm(log_virion_volume~log_genome_length, q5_data_clean )
summary(linear_model)

#Results
intercept<-coef(linear_model)[1]
scaling_factor<-exp(intercept)
exponent<-coef(linear_model)[2]
scaling_factor
exponent

#plot
plot<-ggplot(q5_data_clean, aes(x=log_genome_length,y=log_virion_volume))+
  geom_point(size=2)+
  geom_smooth(method = lm, size=1)+
  labs(x="log [Genome length (kb)]", y="log [Virion volume (nm3)]")+
  theme_bw()+
  theme(axis.title=element_text(face="bold"))

plot

#Save plot as png
save_plot_png<- function(plot, filename, width, height, res, scaling){
  agg_png(filename, width = width, 
          height= height, 
          units="cm",
          res=res,
          scaling=scaling)
  print(plot)
  dev.off()
}

save_plot_png(plot, "question-5-data/reproduced_figure.png",
              width=18, height=15, res=600, scaling=1)


#Using linear model to find estimated volume

linear_model_2<-lm(log(virion_volume_nm_a_nm_a_nm)~log(genome_length_kb), q5_data_clean )
summary(linear_model_2)

genome_300_kb<-data.frame(genome_length_kb=(300))

log_estimated_volume<-predict(linear_model_2, newdata=genome_300_kb)

log_estimated_volume

estimated_volume<-exp(log_estimated_volume)

estimated_volume



