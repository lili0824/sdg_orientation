import numpy as np
import pandas as pd
import math

write_header = True

# this is the file produced from QGIS with the z values
file_name = '/path_name/test_output.csv'
# this is the desired output file name
output_file = '/path_name/two_shots_output.csv'

# read in the csv file
two_shots_df = pd.read_csv(file_name)
index_range = len(two_shots_df.index)
two_shots_df["Length"] = file_name

# calculate the theoretical length of the simulated artifacts
for i in range(0,index_range):
	if(i+1 < index_range and two_shots_df['ID'].iloc[i] == two_shots_df['ID'].iloc[i+1]):
		l = math.sqrt((two_shots_df['X'].iloc[i] - two_shots_df['X'].iloc[i+1])**2 + (two_shots_df['Y'].iloc[i] - two_shots_df['Y'].iloc[i+1])**2 + (two_shots_df['Z'].iloc[i] - two_shots_df['Z'].iloc[i+1])**2)
		length = round(l*1000, 2)
		two_shots_df["Length"].iloc[i] = length
		two_shots_df["Length"].iloc[i+1] = length

# append results to the output file
two_shots_df.to_csv(output_file, index = False, header = write_header, sep =',', mode='a')
write_header = False

# end of the program
print("Hello world")
