#!/usr/bin/env python

# This program generates a 2D mesh of a wind turbine
# blade cross-section for the analysis with BECAS.
# The program is called using the following command:
# python airfoil2becas.py parameterfile.dat
# 
# In the file parameterfile.dat a number of input parameters
# must be defined using python syntax.
#
# This program simply creates a "dummy" Abaqus input file
# and calls shellexpander.py to process this file.
# The shellexpander.py file must be in the same directory
# as the airfoil2becas.py file.
#
# Robert Bitsche, DTU Wind Energy, 2012
# Please report bugs to: robi@dtu.dk


import sys, os, pprint, shutil
from copy import deepcopy

try:
    import numpy as np
except:
    print("ERROR: The NumPy module is required.")
    print("Please download and install from http://www.scipy.org")
    sys.exit(0)


#############################################################################
def splitline(string):
    """Split a string at every "," and strip
    individual strings from whitespace."""
    list=[]
    for word in string.split(","):
        strip = word.strip()
        if strip != '': list.append(strip)
    return list
#############################################################################


#############################################################################
def generous_round(t):
    """Round up t to the next decade. Return an integer.
    e.g. 9-->10; 10-->100; 11-->100
    """
    return int(10**round(np.log10(t)+0.5))
#############################################################################


#############################################################################
def write_node_definition(outfile, nudenumber, coordinates):
    """Write a dataline defining one node to the outfile
    """
    outfile.write('%d, ' % (nodenumber))
    for i in range(len(coordinates)):
        coord = coordinates[i]
        outfile.write('%14.8E' % (coord))
        if i < len(coordinates)-1: outfile.write(', ')
    outfile.write('\n')
#############################################################################


#############################################################################
def write_element_definition(outfile, elementnumber, nodenumbers):
    """Write a dataline defining one element to the outfile
    """
    outfile.write('%d, ' % (elementnumber))
    for i in range(len(nodenumbers)):
        n = nodenumbers[i]
        outfile.write('%d' % (n))
        if i < len(nodenumbers)-1: outfile.write(', ')
    outfile.write('\n')
#############################################################################

#############################################################################
def write_n_int_per_line(list_of_int,outfile,n):
  """Write the integers in list_of_int to the output file - n integers 
  per line, separated by commas"""
  i=0
  for number in list_of_int:
      i=i+1
      outfile.write('%d' %(number ))
      if i < len(list_of_int):
          outfile.write(',  ')
      if i%n == 0:
          outfile.write('\n')
  if i%n != 0: 
      outfile.write('\n')
#############################################################################


#############################################################################
#                               MAIN PROGRAM                                #
#############################################################################


# Parse command line
if len(sys.argv) != 2:
    print('ERROR! Usage: %s parameterfile.dat' % (sys.argv[0]))
    sys.exit(0)
parameterfilename = sys.argv[1]
#parameterfilename = 'Parameters_8.dat'

# Execute commands in parameterfile
print("Executing commands in %s ..." % parameterfilename)
exec(open(parameterfilename).read())

# Check if all required variables have been defined in parameterfile
required_variables = ['airfoilfilename', 'outputdir', 'material_properties', 
                      'layup_of_elset', 'number_of_web_elements', 'reverse_normals',
                      'shear_webs', 'element_layers']
for req_var in required_variables:
    if req_var not in globals():
        print("ERROR: Variable %s has not been defined in %s" % (req_var, parameterfilename))
        sys.exit(0)

# Sanity check
if len(shear_webs) != len(number_of_web_elements):
    print('ERROR: The lists "shear webs" and "number_of_web_elements" do not')
    print('have the same length.')
    sys.exit(0)

# Read airfoil coordinates
try:
    airfoilfile = open(airfoilfilename, 'rU')
except:
    print ("ERROR! Could not open", airfoilfilename)
    sys.exit(0)

airfoilfilestr = airfoilfile.read()
airfoilfile.close()
list_of_lines = airfoilfilestr.splitlines() 

coordinate_lines = []
for line in list_of_lines:
    if line[0] != '#':  # not a comment
        coordinate_lines.append(line)


# Initialize dictionaries
element_definitions = {}         # node numbers of each element
nodal_coordinates = {}           # coordiantes of all nodes
line_element_definitions = {}    # element definitions for 1D line elements
elset_definitions = {}           # element numbers for each ELSET


# Find nodal coordinates and line element definitions
kp_nn = []  # nodenumbers of the keypoints on the airfoil
current_nn = 0
for line in coordinate_lines[:-1]: # ignore last line, must be ident. to first 
    current_nn = current_nn + 1
    words = splitline(line)
    if len(words) == 3:  
        x, y, KP = words  
        if KP == 'KP': kp_nn.append(current_nn)  
    elif len(words) == 2:  # Regular point
        x, y = words
    else:  # Wrong input
        print('ERROR: Wrong number of items in list', words)
    nodal_coordinates[current_nn]=np.array([float(x), float(y), 0.0])
    current_en = current_nn # element number = node number
    line_element_definitions[current_en] = [current_nn,current_nn+1]

# the last element must be connected to the first node
line_element_definitions[max(line_element_definitions.keys())] = [current_nn, 1]
# the last keypoint is again the first keypoint
kp_nn.append(0) 

if len(kp_nn) != 11:
    print("ERROR: 11 keypoints are required.")
    sys.exit(0)

number_airfoil_elements = len(line_element_definitions)

# Add shear webs
all_web_elements = []
region_count = 11 # the first shear web is REGION11
for web, num_web in zip(shear_webs, number_of_web_elements):
    from_nn, to_nn = web
    fromnode = nodal_coordinates[from_nn]  
    tonode = nodal_coordinates[to_nn]  
    
    x_coords = np.linspace(fromnode[0], tonode[0], num_web+1)
    y_coords = np.linspace(fromnode[1], tonode[1], num_web+1)
    x_coords = x_coords[1:-1]  # do not use first and last item
    y_coords = y_coords[1:-1]  # do not use first and last item
    
    web_nodes = []
    web_elements = []
    for x,y in zip(x_coords,y_coords):
        current_nn = current_nn + 1
        nodal_coordinates[current_nn] = np.array([x,y, 0.0])
        web_nodes.append(current_nn)
    
    current_en = current_en + 1
    line_element_definitions[current_en] = [from_nn, web_nodes[0]]
    web_elements.append(current_en)
    
    for nn in web_nodes[:-1]:
        current_en = current_en + 1
        line_element_definitions[current_en] = [nn, nn+1]
        web_elements.append(current_en)
    
    current_en = current_en + 1
    line_element_definitions[current_en] = [web_nodes[-1], to_nn]
    web_elements.append(current_en)

    all_web_elements = all_web_elements + web_elements
    region_name = 'REGION%02d' % (region_count)
    elset_definitions[region_name] = web_elements
    region_count = region_count + 1

elset_definitions['WEBS'] = all_web_elements


# Find suitable jump for node numbers and element numbers
nnjump = generous_round(max(nodal_coordinates.keys()))
enjump = generous_round(max(line_element_definitions.keys()))

# Compute chord length
chord = np.linalg.norm(nodal_coordinates[kp_nn[5]]-nodal_coordinates[kp_nn[0]])

# Compute depth of 3D mesh as 1% of chord lenght
depth = -0.01 * chord
if reverse_normals:
    depth = depth * (-1)

# Add nodes for 3D mesh
offset = np.array([0, 0, depth])
for nn in list(nodal_coordinates.keys()):
    original_node = nodal_coordinates[nn]
    nodal_coordinates[nn+nnjump] = original_node + offset

# Generate shell elements
for en in line_element_definitions.keys():
    line_element = line_element_definitions[en]
    element_definitions[en] = [line_element[0], line_element[1], line_element[1]+nnjump, line_element[0]+nnjump]

# Define element sets
elset_definitions['REGION01'] = list(range(kp_nn[0], kp_nn[1]))
elset_definitions['REGION02'] = list(range(kp_nn[1], kp_nn[2]))
elset_definitions['REGION03'] = list(range(kp_nn[2], kp_nn[3]))
elset_definitions['REGION04'] = list(range(kp_nn[3], kp_nn[4]))
elset_definitions['REGION05'] = list(range(kp_nn[4], kp_nn[5]))
elset_definitions['REGION06'] = list(range(kp_nn[5], kp_nn[6]))
elset_definitions['REGION07'] = list(range(kp_nn[6], kp_nn[7]))
elset_definitions['REGION08'] = list(range(kp_nn[7], kp_nn[8]))
elset_definitions['REGION09'] = list(range(kp_nn[8], kp_nn[9]))
elset_definitions['REGION10'] = list(range(kp_nn[9], number_airfoil_elements+1))

elset_definitions['PRESSURE_SIDE'] = elset_definitions['REGION01'] + \
                                     elset_definitions['REGION02'] + \
                                     elset_definitions['REGION03'] + \
                                     elset_definitions['REGION04'] + \
                                     elset_definitions['REGION05']
elset_definitions['SUCTION_SIDE'] = elset_definitions['REGION06'] + \
                                    elset_definitions['REGION07'] + \
                                    elset_definitions['REGION08'] + \
                                    elset_definitions['REGION09'] + \
                                    elset_definitions['REGION10']

# Define the "element sets to offset" 
# (affects offset computation!)
# elsets_to_offset = ['PRESSURE_SIDE','SUCTION_SIDE','WEBS']

outfilename = 'temp.inp'
outfile = open(outfilename, 'w')

# Write nodal coordinates
outfile.write('**\n')
outfile.write('********************\n')
outfile.write('** NODAL COORDINATES\n')
outfile.write('********************\n')
outfile.write('*NODE\n')
for nodenumber in sorted(nodal_coordinates.keys()):
    coordinates = nodal_coordinates[nodenumber]
    write_node_definition(outfile, nodenumber, coordinates)

# Write element definitions
outfile.write('**\n')
outfile.write('***********\n')
outfile.write('** ELEMENTS\n')
outfile.write('***********\n')
outfile.write('*ELEMENT, TYPE=S4, ELSET=BECAS_SECTION\n')
for elementnumber in sorted(element_definitions.keys()):
    nodenumbers = element_definitions[elementnumber]
    write_element_definition(outfile, elementnumber, nodenumbers)

# Write new element sets
outfile.write('**\n')
outfile.write('***************\n')
outfile.write('** ELEMENT SETS\n')
outfile.write('***************\n')
for elset in sorted(elset_definitions.keys()):
    elements = elset_definitions[elset]
    outfile.write('*ELSET, ELSET=%s\n' % (elset))
    write_n_int_per_line(elements, outfile, 8)

# Write Shell Section definitions
outfile.write('**\n')
outfile.write('****************************\n')
outfile.write('** SHELL SECTION DEFINITIONS\n')
outfile.write('****************************\n')
for elset in sorted(layup_of_elset.keys()):
    layup = layup_of_elset[elset]
    outfile.write('*SHELL SECTION, ELSET=%s, COMPOSITE, OFFSET=-0.5\n' % (elset))
    for layer in layup:
        outfile.write('%g, %d, %s, %g, %s\n' % 
                (layer[0],layer[1],layer[2],layer[3],layer[4]))

# Write material properties
outfile.write('**\n')
outfile.write('**********************\n')
outfile.write('** MATERIAL PROPERTIES\n')
outfile.write('**********************\n')
for matname in sorted(material_properties.keys()):
    md = material_properties[matname]
    outfile.write('*MATERIAL, NAME=%s\n' % (matname))
    outfile.write('*ELASTIC, TYPE=ENGINEERING CONSTANTS\n')
    outfile.write('%g, %g, %g, %g, %g, %g, %g, %g\n' % (md['E1'], md['E2'], 
        md['E3'], md['nu12'], md['nu13'], md['nu23'], md['G12'], md['G13']))
    outfile.write('%g\n' % (md['G23']))
    outfile.write('*DENSITY\n')
    outfile.write('%g\n' % (md['rho']))
    outfile.write('**\n')

outfile.close()

# Call Shellexpander
# #################

shellexpander_path = os.path.join(sys.path[0], 'shellexpander.py')
if not os.path.isfile(shellexpander_path):
    print('ERROR: %s was not found!' % (shellexpander_path))
    sys.exit(0)

import subprocess
args = ['python', shellexpander_path, 
        '--in', 'temp.inp', 
        '--elsets', 'PRESSURE_SIDE', 'SUCTION_SIDE', 'WEBS', 
        '--sec', 'BECAS_SECTION', 
        '--layers', str(element_layers), 
        '--nthick', 'min', 
        '--dom', 'REGION03', 'REGION06',
        '--bdir', outputdir ]

p = subprocess.call(args)


print('FINISHED')

