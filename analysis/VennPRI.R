
source("~/bin/R/functions/vennUtils.R")

load("~/chipseq/results/20130227/fm.nm.RData")
c123 <- fm.nm[,c("Poised at T=0","Running","Induced")]
m <- c123
##m <- matrix(as.numeric(c123),ncol=3)
colnames(m) <- colnames(c123)
rownames(m) <- rownames(c123)

nonna <- names(which(!is.na(apply(m,1,sum))))
ptot <- sum(m[nonna,"Poised at T=0"])
rtot <- sum(m[nonna,"Running"])
itot <- sum(m[nonna,"Induced"])
s.nm <- paste("All:",length(nonna),", P:",ptot,", R:",rtot,", I:",itot,sep="")

a.nm <- vennCounts(m)

load("~/chipseq/results/20130227/fm.eid.RData")
c123 <- fm.eid[,c("Poised at T=0","Running","Induced")]
m <- c123
##m <- matrix(as.numeric(c123),ncol=3)
colnames(m) <- colnames(c123)
rownames(m) <- rownames(c123)

nonna <- names(which(!is.na(apply(m,1,sum))))
ptot <- sum(m[nonna,"Poised at T=0"])
rtot <- sum(m[nonna,"Running"])
itot <- sum(m[nonna,"Induced"])
s.eid <- paste("All:",length(nonna),", P:",ptot,", R:",rtot,", I:",itot,sep="")

a.eid <- vennCounts(m)

quartz()
par(mfrow=c(1,2))
vennDiagram(a.nm,main="RefSeq IDs")
mtext(s.nm,side=3,line=0,outer=FALSE,cex=1.5)
vennDiagram(a.eid,main="Entrez IDs")
mtext(s.eid,side=3,line=0,outer=FALSE,cex=1.5)

## Filtered on PolII Signal
all.nm <- rownames(fm.nm)
s1.nm <- all.nm[which(as.numeric(fm.nm[,"Max PolII Signal"])>1)] ## moderate signal filter

load("~/chipseq/results/20130227/fm.nm.RData")
c123 <- fm.nm[,c("Poised at T=0","Running","Induced")]
m <- c123
##m <- matrix(as.numeric(c123),ncol=3)
colnames(m) <- colnames(c123)
rownames(m) <- rownames(c123)

m <- m[s1.nm,]

nonna <- names(which(!is.na(apply(m,1,sum))))
ptot <- sum(m[nonna,"Poised at T=0"])
rtot <- sum(m[nonna,"Running"])
itot <- sum(m[nonna,"Induced"])
s.nm <- paste("All:",length(nonna),", P:",ptot,", R:",rtot,", I:",itot,sep="")

a.nm <- vennCounts(m)

vennDiagram(a.nm,main="RefSeq IDs")
mtext(s.nm,side=3,line=0,outer=FALSE,cex=1.5)

