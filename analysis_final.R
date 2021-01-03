library(CircStats)
library(fields)
library(circular)
library(tidyverse)
library(ggpubr)

###############################################
## Code to produce the bearing and plunge diagrams and related 
## statistics can be obtained from McPherron 2018.
## link to the McPherron 2018's gitbub page: https://github.com/surf3s/Orientations

# import source (from McPherron 2018)
source("orientations.R")

# call the generalized_prepared_dataset function to clean and prepare data for analysis
# read the SDG2 data
xdata = generalized_prepare_dataset(read.csv("SDG2_twoshots.csv"))

# read the test square data
test = generalized_prepare_dataset(read.csv("test_square_two_shots.csv"))

# simulation data to be produced with the python code
# A set of randomly generated data are also uploaded to the data folder
# flat = generalized_prepare_dataset(read.csv('flat_twoshots.csv'))
# sloped = generalized_prepare_dataset(read.csv('sloped_twoshots.csv'))
# irregular = generalized_prepare_dataset(read.csv('irregular_twoshots.csv'))
# test = generalized_prepare_dataset(read.csv('test_square_two_shots.csv'))

xdata = xdata %>%
  filter(Prism < 0.1) %>%
  mutate(elongation = Length/Width) %>%
  filter((code == 'BONE') |(code == 'LITHIC' & elongation >= 1.2))

# call the orientations function to generate the orientation diagrams
orientations(xdata, level = xdata$CL)

## how to make the Benn diagrams - from McPherron (2018) markdown file
# reference orientation data from Lenoble and Bertran (2004)
lenoble_and_bertran = readRDS('Lenoble_and_Bertran_2004.RDS') %>%
  filter(Type %in% c('Debris Flow','Runoff Shallow','Runoff Steep','Solifluction'))

# color for Lenoble and Bertran reference
formation_process_colors = adjustcolor(c('#404096','#57A3AD','#DEA73A','#D92120'), alpha = .3) 

# color for Lenoble and Bertran reference
lenoble_and_bertran_colors = factor(lenoble_and_bertran$Type, labels = formation_process_colors) 

p = .95 # p value for resampling - McPherron 2018

resampling = 10000	 # Number of resampling iterations

# Summary stats for isotropic ratio and elongation ratio for each layer
benn_sdg = round(benn(xyz = xdata, level = xdata$CL, min_sample = 30), 3) 

layout(matrix(c(1,3,2,4), nrow = 2, ncol = 2)) # configure layout of the plot space

for (levelname in (unique(xdata$CL))) {   # plot orientation ternary plot for each layer and draw area of bootstrapped zone.
  
  xyz_level = xdata %>% filter(CL==levelname)
  
  benn_diagram(cbind(benn_sdg[levelname,"EL"],benn_sdg[levelname,"IS"]),
               main = paste("Layer",levelname),
               cex = .7,
               labels = ifelse(levelname == (unique(xdata$CL))[1], 'outside', 'none'),
               dimnames_position = ifelse(levelname == (unique(xdata$CL))[1], 'corner', 'none'),
               grid_labels = ifelse(levelname == (unique(xdata$CL))[1], TRUE, FALSE))
  
  benn_diagram(lenoble_and_bertran, 
               drawhull = TRUE,
               new_page = FALSE,
               plot_points = FALSE, cex = .7,
               col = lenoble_and_bertran_colors,
               legend_names = switch((levelname == (unique(xdata$CL))[1]) + 1,
                                     NULL, levels(factor(lenoble_and_bertran$Type))),
               legend_colors = formation_process_colors)
  
  resampling_contours = benn_resampling(xyz_level, resampling = resampling, p = p) 
  
  for (contour in resampling_contours)
    lines(benn_coords(cbind(elongation = contour$x, isotropy = contour$y))) }

##############################################
## Code to run the Kuiper's test

# run the Kuiper's test on all bearings as an example to show how
# the function works in R.
# call the plunge_and_bearing function from orientations.R to process the data
# and get bearings only
bearing_angle = plunge_and_bearing(xdata)$bearing
bearing_angle = circular(bearing_angle, type = "angles", units = "degrees")
# according to the function's official documentation, alpha can be set to
# 0.15, 0.1, 0.05, 0.025, 0.01. as the significance level of the test.
# when an alpha level is omitted, a range for the p-value will be provided.
kuiper.test(bearing_angle, alpha = 0.05)
kuiper.test(bearing_angle)

# run the kuiper's test on each individual cultural layers
# CL1a data
CL1a = xdata %>%
  filter(CL == '1a')
CL1a_bearing = plunge_and_bearing(CL1a)$bearing
CL1a_bearing_df = as.data.frame(CL1a_bearing)
kuiper(circular(CL1a_bearing, type = "angles", units = "degrees"), alpha = 0.05)
# CL1b data
CL1b = xdata %>%
  filter(CL == '1b')
CL1b_bearing = plunge_and_bearing(CL1b)$bearing
CL1b_bearing_df = as.data.frame(CL1b_bearing)
kuiper(circular(CL1b_bearing, type = "angles", units = "degrees"), alpha = 0.05)

# CL2 data, also by artifact type
CL2 = xdata %>%
  filter(CL == 2)
CL2_bone = xdata %>%
  filter(CL == 2) %>%
  filter(code == 'BONE')
CL2_lithic = xdata %>%
  filter(CL == 2) %>%
  filter(code == 'LITHIC')
CL2_bearing = plunge_and_bearing(CL2)$bearing
CL2_bearing_df = as.data.frame(CL2_bearing)
CL2_bone_bearing = plunge_and_bearing(CL2_bone)$bearing
CL2_bone_bearing_df = as.data.frame(CL2_bone_bearing)
CL2_lithic_bearing = plunge_and_bearing(CL2_lithic)$bearing
CL2_lithic_bearing_df = as.data.frame(CL2_lithic_bearing)
# replace CL2_bone_bearing with corresponding the CL name needed to be examined
kuiper(circular(CL2_bone_bearing, type = "angles", units = "degrees"), alpha = 0.05)

# CL3 data, also by artifact type
CL3 = xdata %>%
  filter(CL == 3)
CL3_bone = xdata %>%
  filter(CL == 3) %>%
  filter(code == 'BONE')
CL3_lithic = xdata %>%
  filter(CL == 3) %>%
  filter(code == 'LITHIC')
CL3_bearing = plunge_and_bearing(CL3)$bearing
CL3_bearing_df = as.data.frame(CL3_bearing)
CL3_bone_bearing = plunge_and_bearing(CL3_bone)$bearing
CL3_bone_bearing_df = as.data.frame(CL3_bone_bearing)
CL3_lithic_bearing = plunge_and_bearing(CL3_lithic)$bearing
CL3_lithic_bearing_df = as.data.frame(CL3_lithic_bearing)
# replace CL3_lithic_bearing with corresponding CL name needed to be examined
kuiper(circular(CL3_lithic_bearing, type = "angles", units = "degrees"), alpha = 0.05)

# generate the histogram of bearings by CL
CL1a_bearing_plot = 
  ggplot(CL1a_bearing_df, aes(CL1a_bearing)) +
  geom_histogram(aes(y = ..density..), 
                 binwidth = 20, color = "grey30", fill = "grey87") +
  geom_density(alpha = .2, fill = "antiquewhite3") +
  theme_bw() +
  xlab("Bearing angle (degree)") +
  ylab("Density")
CL1a_bearing_plot


# run the Kuiper's test on testing square data
# the actual testing flakes
exp = test %>%
  filter(CL == 'Experimental Flakes')
exp_bearing = plunge_and_bearing(exp)$bearing
exp_bearing_df = as.data.frame(exp_bearing)
kuiper(circular(exp_bearing, type = "angles", units = "degrees"), alpha = 0.05)

# the simulating testing flakes
simulation = test %>%
  filter(CL == 'Simulation') 
simulation_bearing = plunge_and_bearing(simulation)$bearing
simulation_bearing_df = as.data.frame(simulation_bearing)
kuiper(circular(simulation_bearing, type = "angles", units = "degrees"), alpha = 0.05)

# produce histogram of the bearings
exp_bearing_plot = 
  ggplot(exp_bearing_df, aes(exp_bearing)) +
  geom_histogram(aes(y = ..density..), 
                 binwidth = 20, color = "grey30", fill = "grey87") +
  geom_density(alpha = .2, fill = "antiquewhite3") +
  theme_bw() +
  xlab("Bearing angle (degree)") +
  ylab("Density")
# exp_bearing_plot

simulation_bearing_plot = 
  ggplot(simulation_bearing_df, aes(simulation_bearing)) +
  geom_histogram(aes(y = ..density..), 
                 binwidth = 20, color = "grey30", fill = "grey87") +
  geom_density(alpha = .2, fill = "antiquewhite3") +
  theme_bw() +
  xlab("Bearing angle (degree)") +
  ylab("Density")
#simulation_bearing_plot

