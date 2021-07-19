# NESTED FIT

Nested_fit is a data program analysis based on the Bayesian statistics for the computation of, for a given set of data and chosen model, the complete probability distribution for each parameter and the Bayesian evidence.
The evidence calculation is based on the nested algorithm from Skilling 2004 [1,2] with the implementation of specific random walk for the search of new live points.
It is written in Fortran with some Python complementary routines for visualizing the output results and for doing automatic analyses of series of data.
More information on the program can be found in Refs. [A,B,C] here above.

### License

Users are required to accept the license agreement given in LICENSE file. Nested Fit is free for academic usage.

Users are also required to cite the Nested Fit papers here below in their publications (at least (A) and (B)) and their authors.

**Reference articles of nested_fit**:
- [A] M. Trassinelli, *Bayesian data analysis tools for atomic physics*, Nucl. Instrum. Methods B **408**, 301-312 (2017),
[doi:10.1016/j.nimb.2017.05.030](http://dx.doi.org/10.1016/j.nimb.2017.05.030),  [	arXiv:1611.10189](https://arxiv.org/abs/1611.10189)\
- [B] M. Trassinelli, *The Nested_fit Data Analysis Program*, Proceedings **33**, 14 (2019), [doi:10.3390/proceedings2019033014](https://doi.org/10.3390/proceedings2019033014)\
- [C] M. Trassinelli, P. Ciccodicola *Mean Shift Cluster Recognition Method Implementation in the Nested Sampling Algorithm*, Entropy **22**, 185 (2020), [doi:10.3390/e22020185](https://doi.org/10.3390/e22020185)

### Author
Dr. Martino Trassinelli\
CNRS, Institute of NanoSciences of Paris\
email: trassinelli AT insp.jussieu.fr\
email: m.trassinelli AT gmail.com

## Installation instructions ##
**Prerequisite**:
- Fortran compiler (gfortran by default)
- Python 3 with numpy, scipy, matplotlib, pandas, getdist

**Instruction**:
1. Download the latest version or clone the repository
2. Go to the source directory `src`
3. Edit the Makefile (change the compiler name, the `bin` directory if needed). If you want to run in parallel mode, \
  a. Uncomment `FFLAGS  = -fopenmp` in the Makefile\
  b. Put the variable `parallel_on = .TRUE.` in nested_fit.f
4. Run `make`  
5. For the python libraries: put in a directory listed in the `PYTHONPATH` in the .bashrc file (or similar) or in the directory of the input files

NOTE for getdist function in the python library:\
To make it work, change the file  xxx/pythonxx/site-packages/getdist/plots.py
`matplotlib.use('Agg')` to `matplotlib.use('TkAgg')`.

## Basic instructions

**Input files**:
- `nf_input.dat`: Main input file of the program with all user parameter definition.
About the model parameter, use the same order than that one you can find in `USERFCN.f` or `USERFCN_SET.f` files.
- `datafile` to analyze indicated in 'nf_input.dat'.

If set of data files are analyzed, also
- `nf_input_set.dat`: additional input relative to the other datafiles (name and fit limits).
- additional `datafiles` to analyze.

**Main output files**:
- `nf_output_res.dat`: main output with the results.
It contains the details of the computation (n. of live points trials, n. of total iteration), the final evidence value and its uncertainty, the parameter values corresponding to the maximum of the likelihood function, the mean, the median, the standard deviation and the confidence intervals (credible intervals) (68%, 95% and 99%) of the posterior probability distribution of each parameter.
The corresponding information gain and the Bayesian complexity are also provided.
- `nf_output_data_ .dat`: original input data together with the model function values corresponding to the parameters with the highest likelihood function value ('max') to the mean value ('mean') or median ('median'), the residuals and the uncertainty associated to the data.
- `nf_output_fit_ .dat`: Model function values with higher density sampling that the data (for plot purpose). In addition, different components of the model are given
- `nf_output_tries.dat`: For each live points trial, it contains the final evidence, the number of iterations and the maximum value of the likelihood function.
- `nf_output_points.txt`: contains all discarded and final live points values, their associated likelihood values and posterior probabilities. From them, the different parameter probability distributions can be built.
For this purpose, the python function in `nested_res_ .py` can be used.
Together with this file, also the files `nf_output_points.paramnames` and `nf_output_points.ranges` are created for the use of GetDist python library.


Additional information can be found in the reference articles.

## Present version and history of the past versions

The present version is 3.5.2\
New features:
- Modularization of the search and cluster recognition methods in preparation of implementation of new algorithms
- New interpolation options for 1D and 2D histograms using GetDist Python package
- Correction of some bugs in the python library
- Additional folder with exercises is now available
- Installation instructions now available
- Compatible now with intel fortran (options to change in Makefile)



Previous versions are:
 - 3.4 Introduction of benchmark tests with synthetic likelihood function via the module Mod_likelihood_tests,f90 (instead of Mod_likelihood.f90).
 Available tests: TEST_GAUSS (multidimensional Gaussian), TEST_GAUSSIAN_SHELLS (multidimensional Gaussian shells, worse case with available search and clustering methods),
 TEST_EGGBOX (eggbox style profile to test clustering), TEST_ROSENBROCK (Rosenbock function test for 2-n dimension).\
 Change of the outputs: nf_output_points.dat -> nf_output_points.txt, plus files nf_output_points.paramnames,  and nf_output_points.ranges to be compatible with GetDist Python package. New 'triangle plot' available now.
 - 3.3 Modular version of likelihood function in preparation for handling more complex data (2D data, ...).
 - 3.2  This is the first version with free sharing code only.
    Pion mass function and laser interpolation taken out to avoid Numerical Recipes.\
    Indexing for sorting data from SLATEC routine now.\
    Log(factorial) and gamma function from intrinsic function DLGAMMA now (and via a new routine for the factorial).\
    Test for integer input for Poisson likelihood.\
    Fitpack for splines in Shirley profile too.
 - 3.1  Optimization of parallel computing.\
      Corrections to Shirley functions.\
      Add of latest Shirley functions.\
      Fix a bug in the fixed parameters.\
      Add of the time stamp to the cluster analysis files
 - 3.0  Cluster analysis for live points to improve (very much!!!) the search efficiency.
 - 2.3  Parallelism optimization. Usercondition routine removed\
      Correction for gaussian priors (before was done at each jump, now only at the end).
 - 2.2  Add of "Rocking curve" profile that uses external simulated data for set of files
      (parallel and antiparallel, still to test).
      Solved problem with probabilities > 1 for gaussian data. Each data point is considered distributed
      with a Gaussian. But in the normalization factor, sigmas have not to appear. Otherwise probabilities
      can have a dimension.The variables are naturally transformed in dimensionless unit in the
      exponential part.\
      Extraction of live points values in case of non-convergence
 - 2.1  Add of "Rocking curve" profile that uses external simulated data and FITPACK routines for the use of smoothed B-splines.
 - 2.0  Treatment of data with error bars becomes possible.\
      No error bars: Likelihood with Poisson distribution.\
      Error bars   : Likelihood with Gaussian distribution.
 - 1.0  Add of Shirley background for photoemission spectra\
      Add of data output for mean and median parameter values (in addition to max likelihood values).
      Parallelization is back but only for the likelihood calculation otherwise it sucks (most of the time).
 - 0.9  Implementation of complex error function from TOMS algorithm n. 680 (included in Fortran 2008) WOFZ.f.
 - 0.8: Save in a file the different fit components (to implement in part of the functions).
 - 0.7: Add of pion mass function for sets.
 - 0.6: Add capabilities to analyze sets of spectra.
 - 0.5: Add of the pion mass function.
 - 0.4: Improved search algorithm for presence of local maxima
      Add of the information, minimum required iteration and complexity calculation
      D.S. Sivia, "Data Analysis, a Bayesian tutorial" (2006),
      R. Trotta, Contemporary Physics 49, 71 (2008),
      J. Veitch and A. Vecchio, Phys. Rev. D 81, 062003 (2010).
 - 0.3: Optimization with memory allocation and more variables accessible from the input file.
 - 0.2: Version with parallel seek of groups of live points inspired by (not working anymore since 2016)
      J. Veitch and A. Vecchio, Phys. Rev. D 81, 062003 (2010) and
      N. Chopin and C.P. Robert, Biometrika 97, 741-755 (2010).
 - 0.1: Program developed from D.S. Sivia, "Data Analysis, a Bayesian tutorial" (2006) and L. Simons' original program.

 ## Additional included sources

 In addition to the original files from the main author (M. Trassinelli), nesed_fit includes
 - *FITPACK (DIERCKX)* package, to fit and interpolating data with splines (no license)
   - Ref: Paul Dierckx, Curve and Surface Fitting with Splines, Oxford University Press, 1993
 Developer,
   - Address: Paul Dierckx, Department of Computer Science, K.U. Leuven, Celestijnenlaan 200 A, B-3001, Heverlee, Belgium, Paul.Dierckx@cs.kuleuven.ac.be
   - [http://nalag.cs.kuleuven.be/research/topics/fitpack.shtml](http://nalag.cs.kuleuven.be/research/topics/fitpack.shtml)
 - `dpsort.f` + dependencies from SLATEC library (no license) for sorting arrays with respect another array
 - `WOFZ.f`' for the complex error function from TOMS algorithm n. 680 (included in Fortran 2008)
 - `rinteg.f` to calculate the integral of a function using a nq points quadrature ( nq is any integer between 1 and 14 ). Written by C. C. J. Roothaan (no license)

## Other resources


**Articles about nested sampling method**:\   
[1] J. Skilling, *Nested sampling for general Bayesian computation*, Bayesian Anal. **1**, 833-859 (2006)\
[2] D.S. Sivia and J. Skilling, *Data analysis: a Bayesian tutorial*. Second ed. 2006: Oxford University Press
