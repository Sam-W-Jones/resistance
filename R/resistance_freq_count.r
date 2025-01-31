#' count resistance allele frequencies and optionally save to results
#' 
#' 
#' 
#' @param a_gtypes array of genotype frequencies
#' @param gen_num generation number
#' @param results matrix
#' 
#' @examples 
#' genotype.freq <- make.genotypemat ( 0.5, 0.5 )
#' a_gtypes <- array_named( sex=c("m","f"), loci=rownames( genotype.freq ) )
#' a_gtypes['m', ] <- a_gtypes['f', ] <- genotype.freq[]
#' resistance_freq_count(a_gtypes)

#' @return results matrix with values for this generation added OR an array with just these results
#' @export

resistance_freq_count <- function ( a_gtypes, 
                                    gen_num = NULL,
                                    results = NULL ){	

  
  #this could be extended to have >2 loci
  arr_freq <- array_named( sex=c('m','f'), locus = c('R1','R2') ) 
   
  ## frequency of resistance alleles
  # SS1SS2,SS1RS2,SS1RR2,RS1SS2,RS1RS2_cis,RS1RS2_trans,RS1RR2,RR1SS2,RR1RS2,RR1RR2
  names_genotypes <- colnames(a_gtypes)
  arr_freq['m','R1'] <- sum(a_gtypes['m',grep("RR1",names_genotypes)]) + ( 0.5 * sum(a_gtypes['m',grep("RS1",names_genotypes)]))
  arr_freq['m','R2'] <- sum(a_gtypes['m',grep("RR2",names_genotypes)]) + ( 0.5 * sum(a_gtypes['m',grep("RS2",names_genotypes)]))
  arr_freq['f','R1'] <- sum(a_gtypes['f',grep("RR1",names_genotypes)]) + ( 0.5 * sum(a_gtypes['f',grep("RS1",names_genotypes)]))
  arr_freq['f','R2'] <- sum(a_gtypes['f',grep("RR2",names_genotypes)]) + ( 0.5 * sum(a_gtypes['f',grep("RS2",names_genotypes)]))   
  
  # returning results, either to the passed results matrix or as a new object
  if ( !is.null(results) & !is.null(gen_num) )
  {
    results[gen_num,1] <- gen_num #generation number
    
    results[gen_num,2] <- arr_freq['m','R1']
    results[gen_num,3] <- arr_freq['m','R2']
    results[gen_num,5] <- arr_freq['f','R1']
    results[gen_num,6] <- arr_freq['f','R2']
    
    # record total fitnesses for m & f
    # which are always 1, not sure why Beth has here ?
    results[gen_num,8] <- sum(a_gtypes['m',])
    results[gen_num,9] <- sum(a_gtypes['f',])
    
  } else 
  {
    results <- arr_freq
  }
  
  return(results)
  
}	