# Supplementary materials overview
This repository contains the supplementary materials for our paper "Simulating the Impact of Ground Surface Morphology on Archaeological Orientation Patterning"

The supplementary materials include the Python code for generating simulated artifacts, the QGIS file of the three selected terrains from the modern Shuidonggou landscape, the QGIS file of the experimental square, and the two-shot orientation data of the Shuidonggou Locality 2 artifacts. 

## Python code
There are two Python scripts included in the supplementary material, 'generate_two_shots.py' and 'generate_random_points.py'.

## QGIS file
In the QGIS file we have included raster layers of the three selected landscape from the modern SDG landscape.

## 3D plot of SDG 2 artifacts. 
'SDG2-piece-plot-3D.html' is the 3D interactive plot of SDG 2 artifacts made by Sam Lin in R. 

## Simulation guidance
1. To start the simulation, you will first need to create a set of random elongated virtual artifacts. To do this, please find the file named 'generate_two_shots.py', which will generate a set of random (X,Y) coordinates of the elongated artifacts within a selected landscape. To run this script, please open the file to set the number of simulations expected and set the boundary of the landscape, the script will produce a csv file containing the (X,Y) coordinates of a set of random elongated artifacts. 
2. After creating the initial file of the simulated artifacts, the next step is importing them to the QGIS file to obtain their corresponding altitude (the 'Z' value) on the landscape. 
3. To do so, please open the sdg.qgis file, add the csv file ('test.csv' in the qgis folder) as a delimitated text layer. You will see the a point layer overlaying with the corresponding landscape's raster layer if the layer is added successfully.
4. The next step is obtaining the 'Z' values of the simulated artifacts. To do so, you should first install the Point Sampling Tool plugin on QGIS. After that, open the Point Sampling Tool plugin in QGIS (Plugins --> Analyses --> Point Sampling Tool), select the csv file as the input layer ('test' in this case) and the corresponding raster layer ('irregular_dem_ground_final'). Also make sure to select all columns of the input layer. Save the output file in csv format. 
(Note that the coordinate reference system in this file is set to be WGS 84. The SDG coordinate system is local and does not reflect any physical location on Earth.)
5. Go to the output file and change the altitude column name to 'Z' for orientation analysis using the R code in McPherron (2018). Note that some points will not have an altitude value if they fall into the voids of the raster layer. You should remove these points and their pair point if only one of an artifact's endpoitns fall inside the layer. 
6. The last step to prepare the simulated data for orientation analysis is calculating the artifact length. To do this, open 'generate_two_shots.py', update the input and output file name. It is best to input file name with the complete path name to avoid possible permission error. For example, use '/Users/lili/sdg/test_output.csv' instead of 'test_output.csv'. The final csv file can then be used for orientation analysis with McPherron (2018) code. The code can be downloaded from : https://github.com/surf3s/Orientations
