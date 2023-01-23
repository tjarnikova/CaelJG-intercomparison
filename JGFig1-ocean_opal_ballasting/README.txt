!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--- Required Prerequisites ---
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
(in scripts)
--------------------------
--- Python (.py) Files ---
--------------------------

major_axis_regression.py 
this is taken directly from: https://github.com/OceanOptics/pylr2 only the major axis regression is used and I save this in my own version here so that the variables are saved as numpy files rather than in a dictionary to make looping and saving the variables easier

parula.py  
this is a colourmap - the same that BB Cael used in their graphs. 

--------------------------------------
--- Python Notebook (.ipynb) Files ---
--------------------------------------

Replicate Cael Results Southern Ocean.ipynb
this recreates Cael's results for the Southern Ocean using his dataset - this is to identify whether the python code created here does the same thing as the matlab code created by BB Cael. 

EB21/OCCA_mask_to_sediment_coords.ipynb
this used coordinates found by Tereza Janikova and takes these coordinates for Cael's data - some of these values will be on land or within the bathymetry in the model ocean, these are removed later. 

------------
--- Data ---
------------

TOM12_JG_EB21 & TOM12_JG_OCCA -> contain depth profiles of each model created using depth_profiles.jnl in scripts from one year of model data

OCCA/EB21_masked2obs -> created by running Replicate Cael Results Southern Ocean.ipynb

CAELsedimentObsMappedToModelGrid.csv -> .csv of CAEL's coordinates on model grid created by Teresa Janikova

clq_basin_masks_ORCA.nc -> ORCA mask by Corinne Le Quere

forjoesouth.csv -> Cael's data (for only the Southern Ocean)

---------------
--- Scripts ---
---------------

Replicate Cael Results Southern Ocean.ipynb = replicates Cael's model results for the southern ocean with the sediment trap data

depth_profiles.jnl = creates code used to create depth profiles of model data to use for depth gradient

-- Folders --

data_creation -> contains .ipynb files to create the model data masked to observational locations (this does not remove the zeros on land or within the bathymetry of the model)

fig1_masked_model -> creates the Fig.1 

the file names are self naming: 
SO = southern ocean
TP = tropical pacific
TA = tropical atlantic
NA = north atlantic 
NP = north pacific

OCCA = parameterised run
EB21 = baseline run (with silica improvement and sediment model)