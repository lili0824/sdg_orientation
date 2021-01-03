# libraries used in this program
import random
import decimal
import csv
import math

# n is the number of simulations to create
# it is set to be 1, but can be changed depending on the situation
# m is the number of paris of random points created in each
# of simulation
n = 1
m = 150

# set up the minimum and maximun coordinates value of the selected area
# below are the SDG2 local total station coordiates used in this study
# Please note that the vegetation removal created a few voids,
# you can increase the random point numbers to offset the ones that
# might fall into the voids on the rasters in QGIS

# boundary points of the irregular surface
# xmin = 106.36
# xmax = 115.91
# ymin = 70.49
# ymax = 79.73

# boundary points of the flat surface
# xmin = 79.50
# xmax = 89.19
# ymin = 30.81
# ymax = 41.43

# boundary points of the sloped surface
# xmin = 113.430
# xmax = 122.450
# ymin = 103.218
# ymax = 112.200

# boundary points of the test square
# xmin = 113.430
# xmax = 122.450
# ymin = 103.218
# ymax = 112.200

# this is the file name you create, please change the file name to desired
file_name = '/path_name/test.csv'

with open(file_name, 'w') as csvfile:
	fieldnames = ['UNIT','ID', 'SUFFIX', 'X', 'Y', 'CL', 'code', 'Width', 'Prism']
	mywriter = csv.DictWriter(csvfile, fieldnames=fieldnames)
	mywriter.writeheader()
	for count in range(0,n):
		#for i in range(1,151):
		for i in range(1,301):
		# generate a set of random x y coordinate
			flake_x = float(random.randrange(int(xmin*1000), int(xmax*1000))/1000)
			flake_y = float(random.randrange(int(ymin*1000), int(ymax*1000))/1000)
		# generate a radius if 5cm
			r = 0.05
		# generate the second point
			for j in range(0,2):
				flake_ID = i
				flake_suffix = j
				if j == 0:
					mywriter.writerow({'UNIT':count,'ID': i, 'SUFFIX': j, 'X': "%.3f" % flake_x, 'Y': "%.3f" % flake_y, 'CL': 1, 'code': 'Lithic', 'Width': 5, 'Prism': 0})
				else:
				# math.pi is 180 degrees
					theta = 2 * math.pi * random.random()
					x_1 = flake_x + r * math.cos(theta)
					y_1 = flake_y + r * math.sin(theta)
				# re-run the loop if the random coordinate generated is the same as the first set
					while (round(x_1,3) == round(flake_x,3) and round(y_1,3) == round(flake_y,3)):
						print("Same x y values, generate a new set", i)
						print(round(x_1,2),round(y_1,2))
						print(round(flake_x,2),round(flake_y,2))
						theta = 2 * math.pi * random.random()
						x_1 = flake_x + r * math.cos(theta)
						y_1 = flake_y + r * math.sin(theta)
					while (int(round(x_1,3)*1000) not in range(int(xmin*1000),int(xmax*1000+1)) or int(round(y_1,3)*1000) not in range(int(ymin*1000), int(ymax*1000+1))):
						print("x y coordinate out of range")
						theta = 2 * math.pi * random.random()
						x_1 = flake_x + r * math.cos(theta)
						y_1 = flake_y + r * math.sin(theta)
					mywriter.writerow({'UNIT':count,'ID': i, 'SUFFIX': j, 'X': "%.3f" % x_1, 'Y': "%.3f" % y_1, 'CL': 1, 'code': 'Lithic', 'Width': 5, 'Prism': 0})

# end of the program
print("Program completed")
