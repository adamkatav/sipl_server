# ObjectMapper

### Overview ###

This is the image proccessing part of the project. Its input is the output of the deep learning part.
The main fuction in this system is mapObjects.m
![Project Diagram](https://github.com/vgoshat30/ObjectMapper/blob/master/Project%20Diagram.png?raw=true)

### Functions ###
There are three types of functions:
* Main functions. To execute the system call mapObjects.m, all other unmarked functions are used by it.
* TEST functions. Functions with TEST prefix can be ran separatley to test mapObjects.m and mapSpecifiedObject.m manually.
![TEST_mapObjects.mat example](https://github.com/vgoshat30/ObjectMapper/blob/master/EXAMPLE_mapObjects.png?raw=true)
* DEBUG function. One function is with DEBUG prefix and can be used to debug the code at occasion of use of hough lines. 

<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

### Notes - Project 2021 ###
In the "manual_single_output" directory you can fined 2 matlab scripts we added:

*single_output_mapping.m* - this file do mapping to one image.

	for run it properly:
	- the name (string) which is contained in the variable 'json_name' needs to be set to the name of the image you want to map.  
	- change variable 'treshold_score' to the wanted detection accuracy treshold you want to work with.
	- make sure that the files 'COCO.json' and 'our_json_new_result.bbox' and the pictures are exist in "manual_single_output" directory.
	  the json files and the pictures are matching to each other. if you want to work with new images you will have to create new json
	  files for them. COMPLETE HOW MAKE JSONS.
	  
	the output will be mapped images in the "mapped_img" directory and matching mapped json files in the "jsons" directory.
		- the location of the output json file set in "ObjectMapper/makeJSON.m" by the variable 'JSON_dir'.
		
*god of jsons.m* - do maping for all images in the directory. (simple loop, calls to single_output_mapping.m)