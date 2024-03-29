##
## Load Information on peak nearest to TSS
## 

load("~/chipseq/processed_data/PolIInearTSS/polII.tsswidth.RData")
load("~/chipseq/processed_data/PolIInearTSS/polII.nm.tsswidth.RData")

load("~/chipseq/processed_data/PolIInearTSS/polII.tssdist.RData")
load("~/chipseq/processed_data/PolIInearTSS/polII.nm.tssdist.RData")

load("~/chipseq/processed_data/PolIInearTSS/polII.scoretss.RData")
load("~/chipseq/processed_data/PolIInearTSS/polII.nm.scoretss.RData")

load("~/data/ncbi/eid.of.nm.RData")
load("~/data/ncbi/nms.of.eid.RData")
load("~/data/ncbi/gene.symbol.RData")
load("~/data/ncbi/gene.eid.RData")

max.width <- 500
max.dist <- 500
min.score <- 3

## Binary matrix for poising, at every time point
poised.logmat <- (abs(polII.nm.tssdist)<max.dist) &  (polII.nm.tsswidth<max.width)
poised.logmat <- replace(poised.logmat,which(is.na(poised.logmat)),FALSE) ## NA values also do not meet the criterion
poised.logmat <- poised.logmat*1 ## convert to binary rep
poised.logmat <- poised.logmat[,c(1,2,4,5)] ## restrict to A,skip 6hr

## Is there poising at t=0?
poised.t0.nm <- names(which(poised.logmat[,1]==1))
poised.t0.eid <- unique(eid.of.nm[poised.t0.nm])
m <- cbind(eid.of.nm[poised.t0.nm],
           gene.symbol[eid.of.nm[poised.t0.nm]]
           )
colnames(m) <- c("Entrez ID","Gene Symbol")
write.matrix(m,"RefSeq",file="PoisedUnstim.tsv")

## Is there poising at any time?
q <- apply(poised.logmat,1,sum)
poised.anytime.nm <- names(which(q>=1))
poised.anytime.eid <- unique(eid.of.nm[poised.anytime.nm])
m <- cbind(eid.of.nm[poised.anytime.nm],
           gene.symbol[eid.of.nm[poised.anytime.nm]],
           poised.logmat[poised.anytime.nm,])
colnames(m)[c(1,2)] <- c("Entrez ID","Gene Symbol")
write.matrix(m,"RefSeq",file="PoisedSometime.tsv")

## Study cases where gene is paused over *all* of time course
alwayspoised.nm <- names(which(q==4))
alwayspoised.eid <- as.character(eid.of.nm[alwayspoised.nm])
m <- cbind(eid.of.nm[alwayspoised.nm],
           gene.symbol[eid.of.nm[alwayspoised.nm]]
           )
colnames(m) <- c("Entrez ID","Gene Symbol")
write.matrix(m,"RefSeq",file="AlwaysPoised.tsv")

###
### Data exploration 
### 


baddies <- names(which(polII.nm.tssdist[,1] < -10000))
## Gene NM_001142963 appears twice in RefSeq. Who knows why.
goodies <- setdiff(rownames(polII.nm.tssdist),baddies)
polII.nm.tssdist <- polII.nm.tssdist[goodies,]
polII.nm.scoretss <- polII.nm.scoretss[goodies,]
polII.nm.tsswidth <- polII.nm.tsswidth[goodies,]

plot(polII.nm.tssdist[,1],polII.nm.tsswidth[,1],xlim=c(-1000,1000),ylim=c(0,1000))

tplot <- function(nm){
  op <- par(mfrow=c(2,1))
  plot(polII.nm.tssdist[nm,c(1,2,4,5,7)],type='l',ylim=c(-1000,1000),ylab="Distance")
  plot(polII.nm.tsswidth[nm,c(1,2,4,5,7)],type='l',ylim=c(0,1000),ylab="Width")
}

 
length(which((polII.nm.tssdist[,1]==0)&(polII.nm.tsswidth[,1]<500)))


## Saw a few cases of
## Multiple transcripts for a gene
## Incosistency between array types for the expression levels
## one array type showed expression

## by and large, the "always" paused cases seem to go with no gene expression
## 31, 61, 96 for q==5,4,3
## Taf13, Zc3h15 (no change) always poised but still expressed at decent levels

### Plan: identify predominant expression patters of the "always poised"
### See if / how many are also getting some amount of coverage

plot(max.abs[j.eid],max.rats[j.eid])
text(max.abs[j.eid],max.rats[j.eid],labels=gene.symbol[j.eid],pos=4)

## More low expression than expected?
## Strongest, Tor1aip2, has 5 transcripts
## Next: Slc2a1, is expressed late with increased PolII fracolap
## Pdss1 has some potential overlap with Abi1
## Kin has potential overlap with Atp5c1

j.nm <- names(which(q==4))
j.eid <- as.character(eid.of.nm[j.nm])
