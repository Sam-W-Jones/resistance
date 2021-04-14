# resistance

An insecticide resistance population genetics model with 2 loci and 2 insecticides.

Development by Andy South, Ian Hastings and Beth Levick, 2015-8.

The model is described here :

South, A., & Hastings, I. M. (2018). Insecticide resistance evolution with mixtures and sequences : a model-based explanation. Malaria Journal. [https://doi.org/10.1186/s12936-018-2203-y](https://doi.org/10.1186/s12936-018-2203-y)

Levick, B., South, A., & Hastings, I. M. (2017). A two-locus model of the evolution of insecticide resistance to inform and optimise public health insecticide deployment strategies. PLoS Computational Biology, 13, e1005327. [https://doi.org/10.1371/journal.pcbi.1005327](https://doi.org/10.1371/journal.pcbi.1005327).


The code is licensed GPL-3, please cite the paper above if you use it.

Running the code is slightly involved, you may want to explore the user interfaces below first.


### Installation

    #install.packages("devtools")
    require(devtools)    
    install_github('AndySouth/resistance')  
    require(resistance)
    
    
### User Interfaces

    #install.packages("shiny")
    require(shiny) 
    
##### UImix: allows 2 scenarios of mixture and sequential to be compared and modified   

    runUImix()       
    
##### UI1: single scenario, mixture, show all 4 loci    
    
    runUI1() 
    
##### UI2: effect of sex-linkage on a mixture
    
    runUI2() 

##### UI3: recreates Curtis(1985) Fig2 and allows params to be varied to modify the plot      

    runUI3()
   
    
### Main functions to run the model

    # Run model scenarios specified in an input object
    input <- setInputOneScenario(P_1=0.01)
    listOut <- runModel2(input, produce.plots = TRUE)
  
    # Recreate figure 2 of Curtis(1985), allows inputs to be tweaked
    runcurtis_f2()

### Code to reproduce figures and text for South & Hastings (2018)

[South and Hastings 2018, reproducible.](https://github.com/AndySouth/resistance/blob/master/inst/documents/paper2/paper2_resistance_mechanisms_mixtures.Rmd)
    
  
### Sensitivity analysis for Levick, South & Hastings (2017) 

    # inst/documents/sensiAnPaper1All.Rmd
    # an rmarkdown file that runs all of the sensitivity analysis for paper1
    # it runs the model itself like in this example :
    nScenarios <- 3 

    listOutMix <- sensiAnPaperPart( nScenarios, insecticideUsed = 'mixture' )
    listOutI1 <- sensiAnPaperPart( nScenarios, insecticideUsed = 'insecticide1' )
    listOutI2 <- sensiAnPaperPart( nScenarios, insecticideUsed = 'insecticide2' )
  
    # sensiAnPaperPart() contains hardcoded input ranges
    # it generates random numbers and repeatedly calls setInputOneScenario()
    # then it calls runModel2() to run the model using these inputs
    
    # all figures for Levick, South & Hastings (2017)
    # inst/documents/paper1/paper1_results_figs_slimmed_50_rr.Rmd
   
### Updated methodology for allowing multiple feeds (Mosaics, Panel nets)

    # Use SensiAnMosaic to simulate scenarios. Parameters can be directly configured inside this function
    # Correct_mix_deploy should be 0 for mosaics, 1 for mixtures, in between for panel nets. 
    # The functions and example code within combine_data_functions will create comparison files between methods
    # or (using the nocensor functions), trim the output to a more manageable size for looking at single methods. 
    
  
