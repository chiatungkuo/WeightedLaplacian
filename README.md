## Guided Nodes Weight in Laplacians
This directory contains MATLAB code for learning selected nodes in a collection of graphs to distinguish different populations, to which the graphs belong.
The code builds upon and utilizes routines from existing public software packages as listed below, and it runs on MATLAB version 7 or higher.

File(s) in this directory: 

+ learn_weights.m: learn a set of nodes that are most important in distinguishing populations among a collection of graphs based on their (normalized) min cuts
+ apply_sp.m: run regular spectral clustering
+ apply_csp.m: run constrained spectral clustering where constraints are constructed from the results in "learn_weights.m"
+ apply_wsp.m: run weighted spectral clustering where nodes from the results in "learn_weights.m"

Dependence: 

+ [Gurobi](http://www.gurobi.com): state of the art solvers for linear programs (LP), quadratic programs (QP), mixed integer quadratic constrained programs (MIQCP), etc. A free academic trial license can be obtained.
+ [Constrained spectral clustering](http://github.com/gnaixgnaw/CSP): spectral clustering with (relaxed) MUST-LINK and CANNOT-LINK constraints 

This method is described in detail in the paper [Spectral Clustering for Medical Imaging](http://kuo.idav.ucdavis.edu/pubs/icdm2014.pdf).
The fMRI scan data set used in the experiments is a private data set; however fMRI data in similar format can be downloaded at [Alzheimer's Disease Neuroimaging Initiative](http://adni.loni.usc.edu) after proper disclosure agreement is signed. Please replace the load data routines in the code by your data.
