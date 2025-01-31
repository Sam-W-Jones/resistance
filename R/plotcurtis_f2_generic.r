#' plot Resistance Allele frequencies over time
#' 
#' Recreates figure 2 of Curtis(1985)
#' Plot frequency of resistance allele at locus 1 (red) and locus 2 (blue)
#' 
#' @param combmat combined insecticide results matrix 
#' @param bmat single insecticide (hch) results matrix 
#' @param amat single insecticide (ddt) results matrix
#' @param gencol column number containing generation
#' @param r1col column number containing frequency of allele at R1
#' @param r2col column number containing frequency of allele at R2
#' @param main title for the plot
#' @param criticalPoints critical resistance points to be displayed in the plot
#' @param addCombinedStrategy whether to add a line for the combined mixture/individual strategy, makes plot confusing so set to FALSE by default
#' @param addStrategyLabels add labels to plot for where strategies cross 0.5 line TRUE gives seq,mix1,mix2,mix3
#' @param strategyLabels = c("seq","mix1","adapt","mix2")
#' @param xlab xlab
#' @param ylab ylab
#' @param ylabs whether to add tick labels
#' @param xlabs whether to add tick labels
#' @param yticks tick positions
#' @param cex.axis scaling for x&y tick labs 
#' @param addLegend whether to add a legend inside plot
#' @param vlines colour of vertical lines to add to plot, NULL for none
#' @param maxX optional max x value for the plot to facilitate comparison with other plots
#' @param labelMixSeqRatio how many dp in label of the ratio of mix/seq, NULL for no label, only option compatible with addLegend
#' 
#' @examples
#' listOutMix <- sensiAnPaperPart( 2, insecticideUsed = 'mixture' )
#' listOutI1 <- sensiAnPaperPart( 2, insecticideUsed = 'insecticide1' )
#' listOutI2 <- sensiAnPaperPart( 2, insecticideUsed = 'insecticide2' )
#' plotcurtis_f2_generic( listOutMix$results[[1]], listOutI2$results[[1]], listOutI1$results[[1]] )
#' 
#' @return list of plot components
#' @export

plotcurtis_f2_generic <- function( combmat, bmat, amat, gencol=1, r1col=2, r2col=3,
                                   #main="Rise of resistance; sequential insecticides v mixtures",
                                   main="",                                   
                                   criticalPoints = c(0.1,0.25,0.5),
                                   addCombinedStrategy = FALSE,
                                   addStrategyLabels = TRUE,
                                   strategyLabels = c("seq","mix1","adapt","mix2"),
                                   ylab = "Allele frequency %",
                                   ylabs = TRUE,
                                   yticks = c(0.1,1,5,10,50,100),
                                   xlab = "Generation",
                                   xlabs = TRUE,
                                   cex.axis = 0.8,
                                   addLegend = TRUE,
                                   vlines = 'grey95',
                                   maxX = NULL,
                                   labelMixSeqRatio = NULL
                                   
                                   ){
  
  #find generations to reach max resistance points
  #to help with setting x axis
  maxGensI1 <- findResistancePoints(amat, locus=1, criticalPoints = criticalPoints)
  maxGensI2 <- findResistancePoints(bmat, locus=2, criticalPoints = criticalPoints)  
  maxGensMix <- findResistancePoints(combmat, locus='both', criticalPoints = criticalPoints)    

  maxGens <- max( (maxGensI1+maxGensI2), maxGensMix )  
    
  #maxX can be set as an arg to facilitate plot comparisons
  if (is.null(maxX))
  {
    maxX <- maxGens    
  } else if (maxX < maxGens)
  {
    warning("the specified maxX = ",maxX," is less than max generations needed for the plot = ",maxGens)
  }

  
  minf <- min( combmat[,r1col], combmat[,r2col] )
  #cat("in plotcurtis_f2_generic minf:",minf," ", log10(minf),"\n")
  
  f <- c((100*minf):100)				## for y axis
  #f <- c(1:100)				## for y axis 
  fl <- log10(f)
  
  #pty="s" #to create a square plot region
  #tcl for smaller ticks (def=-0.5)
  #mgp margin line for axis title, labels and line.
  #mgp[1] affects title whereas mgp[2:3] affect axis. default is c(3, 1, 0).
  par(pty="s", tcl=-0.2, mgp=c(2.5, 0.5, 0) ) #, plt=c(0.1,0.8,0.1,0.8)) 
  
  # blank plot with x axis max as max_gen for combination scenario, and y axis max as log10(100) (for 100%)			
  plot( 0, 0, type="n", axes=F,						## Blank square 1,1 plot
        #xlim=c(1,maxGens), ylim=c(0,(max(fl))),
        xlim=c(1,maxX), ylim=c(min(fl),(max(fl))),
        #xlim=c(1,(max(combmat[,gencol]))), ylim=c(0,(max(fl))),
        xlab="", ylab="" ) #, main=main)
  
  #to left justify title
  title(main,adj=0)
  #to put titles closer to axes
  title(xlab=xlab, ylab=ylab,line=2)
  
  # add axis labels
  # default x axis
  xticks <- axis( side=1, labels=xlabs, cex.axis=cex.axis, col='grey' )
  #to add vertical lines
  if (!is.null(vlines)) abline(v=xticks, col=vlines)

  #can I divide by 12 to show years ? but breaks would be ugly
  #instead could allow xlab to be changed from Generation to Month ?    
  
  
  # plotting combination scenario (in combmat)
  # set frequencies in vectors as log10 percentages from frequencies
  R1 <- log10( 100 * combmat[,r1col] )
  R2 <- log10( 100 * combmat[,r2col] )
  # set generations in vector
  gens <- combmat[,gencol]		
  # add allele frequencies as lines to the plot
  lines( gens, R1, col=adjustcolor("red", alpha.f = 0.5) )
  lines( gens, R2, col=adjustcolor("blue", alpha.f = 0.5) )
  
  # add line at maximum of critical points
  abline( h=(log10(100*max(criticalPoints)) ), col='grey' )
  
  
  #allows ylabs to be set to FALSE for no labels
  logylabs <- log10( yticks )
  if (ylabs)  ylabs <- yticks
  axis( side=2, at=logylabs, labels=ylabs, tick=T, cex.axis = cex.axis, las = 1, col='grey' ) #las=1 for horiz labs  
  
  ## Single insecticide scenarios
  #andy remember that in this from Beth hch is insecticide1 & ddt is insecticide2
  
  # Only plots up to generation where 0.5 is first reached/exceeded, so this generation is found
  hch_cutoff <- min(which((amat[,r1col])>max(criticalPoints)))
  ddt_cutoff <- min(which((bmat[,r2col])>max(criticalPoints)))
  
  # check if resistance has not been reached
  # and prevent an error, by seeting to max generations from input
  # beware this may have other unintended consequences
  if (is.infinite(hch_cutoff)) hch_cutoff <- nrow(amat)
  if (is.infinite(ddt_cutoff)) ddt_cutoff <- nrow(bmat)  
  
  # set results columns as vectors from single insecticide treatment
  hch <- amat[1:hch_cutoff,r1col]	# trim vector to point where freq of R > 0.5
  hch <- log10( 100 * hch )
  ddt <- bmat[1:ddt_cutoff,r2col]	# trim vector to point where freq of R > 0.5
  ddt <- log10( 100 * ddt )
  
  hch_gens <- c(1:hch_cutoff)
  ddt_gens <- c((hch_cutoff):(hch_cutoff+(ddt_cutoff-1)))
  
  # add these as lines
  lines( hch_gens, hch, col=adjustcolor("red", alpha.f = 0.5), lty=2 )
  lines( ddt_gens, ddt, col=adjustcolor("blue", alpha.f = 0.5), lty=2 )

  # BEWARE if the cutoff is not reached for either of these they return Inf
  cutoff_i1_mix <- min(which((combmat[,r1col])>max(criticalPoints)))
  cutoff_i2_mix <- min(which((combmat[,r2col])>max(criticalPoints)))  
  
  if (cutoff_i1_mix == Inf | cutoff_i2_mix == Inf)
  {
    warning("critical point not reached for i1 or i2: cutoff_i1_mix=",cutoff_i1_mix," cutoff_i2_mix=",cutoff_i2_mix)
    #don't add the combined(adaptive) strategy to the graph
    addCombinedStrategy <- FALSE
  }
  
  #andy added
  if( addCombinedStrategy )
  {
    #trying to add a dotted line for the combined strategy
    #it should start at the point that the resistance to the first insecticide is reached
    #and go parallel to the other individual insecticide after
    #but remember that resistance may be reached for insecticide2 first
    if ( cutoff_i1_mix < cutoff_i2_mix )
    {
      
      #add a vertical line for switch from mix to single
      abline( v = cutoff_i1_mix, col="grey", lty=3 ) 
      
      #this is tricky
      #have to log the starting point
      #find resistance level for i2 at the point the cutoff is reached for i1
      startR <- log10( 100 * combmat[cutoff_i1_mix,r2col] ) 
      
      #take the values above the cutoff
      comb <- ddt[ddt>startR]
      
      #don't plot line if no values above the cutoff (previously gave an x,y lengths differ error)
      if( length(comb) > 0 )
      {
        #finding which generations
        gens <- c( cutoff_i1_mix : (cutoff_i1_mix+length(comb)-1 ) )
        
        lines( gens, comb, col=adjustcolor("blue", alpha.f = 0.5), lty=3 )
      }
      
      
    } else #if cutoff_i2_mix <= cutoff_i1_mix
    {
      
      #add a vertical line for switch from mix to single
      abline( v = cutoff_i2_mix, col="grey", lty=3 ) 
      
      gens <- c( cutoff_i2_mix : (cutoff_i2_mix+length(hch)-1 ) )

      #find resistance level for i1 at the point the cutoff is reached for i2            
      startR <- log10( 100 * combmat[cutoff_i2_mix,r1col] ) 
      
      #take the values above the cutoff
      comb <- hch[hch>startR]
      
      #don't plot line if no values above the cutoff (previously gave an x,y lengths differ error)
      if( length(comb) > 0 )
      {
        #finding which generations
        gens <- c( cutoff_i2_mix : (cutoff_i2_mix+length(comb)-1 ) )
        
        lines( gens, comb, col=adjustcolor("red", alpha.f = 0.5), lty=3 )        
      }
    }
  }  
  
  
  #when switch made from I1 to I2
  abline( v = max(maxGensI1), col="grey", lty=2 )  
  
  if (addLegend)
  {
    if( addCombinedStrategy )
    {
      #added a dotted line for combined
      legend( 'bottomright', legend=c("sequential", "mixture", "adaptive", "insecticide 1", "insecticide 2"), 
              col=c("black","black","black","red", "blue"), lty=c(2,1,3,0,0), pch=c(NA,NA,NA,15,15), bty="n", cex=0.7 )     
    } else
    {
      #legend( 'bottomright', legend=c("sequential", "mixture", "insecticide 1", "insecticide 2"), 
      #        col=c("black","black","red", "blue"), lty=c(2,1,0,0), pch=c(NA,NA,15,15), bty="n", cex=0.7 )    
      # trying clearer 
      legend( 'bottomright', legend=c("insecticide1 alone", "insecticide1 in mix", "insecticide2 alone", "insecticide2 in mix"), 
              col=c("red","red","blue","blue"), lty=c(2,1,2,1), pch=c(NA,NA,NA,NA), bty="n", cex=0.7 )    
      
    }    
  }

 #recording generations for seq, mix & adaptive mix for labelling
  x_seq <- max(maxGensI1) + max(maxGensI2)
  
  x_mix2 <- max(gens) #adaptive mix
  
  if ( cutoff_i1_mix < cutoff_i2_mix )
  {
    x_mix1 <- cutoff_i1_mix
    x_mix3 <- cutoff_i2_mix
  } else
  {
    x_mix1 <- cutoff_i2_mix
    x_mix3 <- cutoff_i1_mix
  }  
  
  #add a label of ratio mix to seq, BEWARE will conflict with other legend
  if( !is.null(labelMixSeqRatio) )
  {
    legend( 'bottomright', legend=paste0("mix/seq=",round(x_mix3/x_seq,labelMixSeqRatio)), pch=NA, bty="n", cex=1 ) 
  }


 if( addStrategyLabels )
   {
    y <- log10(max(criticalPoints)*100)

    #text(x_seq, y, strategyLabels[1])
    #text(x_mix1, y, strategyLabels[2])
    #text(x_mix3, y, strategyLabels[4])
    at <- c(x_seq,x_mix1,x_mix3)
  
    if( addCombinedStrategy )
      {
        #text(x_mix2, y, strategyLabels[3])
        at <- c(x_seq,x_mix1,x_mix2,x_mix3)
       } else
       {
         strategyLabels <- strategyLabels[-3] 
       }
  
    #a fudge to take out any labels that are ''
    if( length(which(strategyLabels=='')) > 0 )
    {
      at <- at[ - which(strategyLabels=='')]    
      strategyLabels <- strategyLabels[ - which(strategyLabels=='')]      
    }

    
    #or can I add these as an axis above
    #horizontal labels if max of 2 chars in label
    if (max(nchar(strategyLabels)<3))
    {
      axis(3, at=at, labels=strategyLabels, cex.axis=0.6, hadj=1.5 )#, tcl=-0.3, padj=1,    
    } else 
    {
      #vertical labels hadj bigger moves away from axis
      axis(3, at=at, labels=strategyLabels, cex.axis=0.8, tcl=-0.2, padj=0, hadj=0.1, las=3 )      
    }
        
   }
  
    			
  
  box(col='grey')
  
}