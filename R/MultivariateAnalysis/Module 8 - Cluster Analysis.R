
# Module 9 - Cluster Analysis

# You may need to install these packages first
# install.packages("mclust")
# install.packages("flexclust")
# 

library(mclust)
library(MVA)
library(HSAUR2)

2+2

# Data consisting of chest, waist, and hip measurements
# of 20 individuals

meas <- read.table("measure.txt")
head(meas)
dim(meas)

# Calculate the distance matrix
dm <- dist(meas[, c("chest", "waist", "hips")])

# Print the distance matrix
dm


# Plot dendogram

# Single linkage
plot(slc <- hclust(dm, method = "single"))

# Single linkage
plot(clc <- hclust(dm, method = "complete"))

# Average linkage
plot(avc <- hclust(dm, method = "average"))

slc

names(slc)

# ################################################
# Cutting the tree at appropriate height
# ################################################

# Suppose we want to create 4 clusters
cutree(slc, k = 4) # this is not appropriate for this data, though

# If you want to crate two clusters
cutree(slc, k = 2) 


# This is useful for displaying the graphs side by side
# use it to compare the graphs

layout(matrix(1:4, nr = 2), height = c(1, 1))

# Example 
# Obtain the Principal Components of the distances
body_pc <- princomp(dm, cor = TRUE)

# display what's in it (often not very useful information)
body_pc

# Listing the stored objects (this is useful)
names(body_pc)

# Results
#[1] "sdev"     "loadings" "center"   "scale"    "n.obs"    "scores"  
#[7] "call"


# display the loadings
body_pc$loadings

# display the scores
body_pc$scores


# Set the limit of x-axis (useful for this problem)
xlim <- range(body_pc$scores[,1])

# Setting the satage for plotting the principal components scores 
# for first two PCs. But first, we plot no values. Later, we will
# plot the labels

plot(body_pc$scores[,1:2], type = "n", xlim = xlim, ylim = xlim,
     xlab = "PC1", ylab = "PC2")

#####################################################
# Researcher defined clusters (where to cut the tree)
#####################################################

# Define the labels based on where the tree was cut
# We decide that h=3.8 would be a good height to cut

lab <- cutree(slc, h = 3.8)
lab

# This create labels based on where the tree was cut
# The PC scores gets labeled (categorized) and plotted

text(body_pc$scores[,1:2], labels = lab, cex=0.6)

# Plot the dendogram for single linkage clustering
plot(cs <- hclust(dm, method = "single"), main = "Single")

# Add a horizontal line at the given height 
abline(h = 3.8, col = "lightgrey")

###################################################
### Now cut the tree to get 2 clusters ##
# this time, we are not cutting at a given height
# rather, we are cutting so that we get 2 clusters
###################################################

plot(body_pc$scores[,1:2], type = "n", xlim = xlim, ylim = xlim,
     xlab = "PC1", ylab = "PC2")
lab <- cutree(slc, k=2)
text(body_pc$scores[,1:2], labels = lab, cex=0.6)
plot(slc <- hclust(dm, method = "single"), main = "Single")
abline(h = 3.5, col = "lightgrey")


# ################################################
# Ploting measure data agains the Principal Components
# ################################################

# Obtain the Principal Components
body_pc <- princomp(dm, cor = TRUE)

# Create a layout to draw the plots
layout(matrix(1:6, nr = 2), height = c(2, 1))

# Plot the dendogram for single linkage clustering
plot(cs <- hclust(dm, method = "single"), main = "Single")

# Add a horizontal line at the given height 
abline(h = 3.8, col = "lightgrey")

# Set the limit of x-axis
xlim <- range(body_pc$scores[,1])

# Plot the principal components scores for first two PCs
plot(body_pc$scores[,1:2], type = "n", xlim = xlim, ylim = xlim,
     xlab = "PC1", ylab = "PC2")

# Define the labels based on where the tree was cut
lab <- cutree(cs, h = 3.8)
text(body_pc$scores[,1:2], labels = lab, cex=0.6)

##
plot(cc <- hclust(dm, method = "complete"), main = "Complete")
abline(h = 10, col = "lightgrey")
plot(body_pc$scores[,1:2], type = "n", xlim = xlim, ylim = xlim,
     xlab = "PC1", ylab = "PC2")

lab <- cutree(cc, h = 10)  
text(body_pc$scores[,1:2], labels = lab, cex=0.6)     

##
plot(ca <- hclust(dm, method = "average"), main = "Average")
abline(h = 7.8, col = "lightgrey")

plot(body_pc$scores[,1:2], type = "n", xlim = xlim, ylim = xlim,
     xlab = "PC1", ylab = "PC2")

lab <- cutree(ca, h = 7.8)                             
text(body_pc$scores[,1:2], labels = lab, cex=0.6)  


##############
## Average linkage with h=6

plot(ca <- hclust(dm, method = "average"), main = "Average")
abline(h = 6, col = "lightgrey")

plot(body_pc$scores[,1:2], type = "n", xlim = xlim, ylim = xlim,
     xlab = "PC1", ylab = "PC2")

lab <- cutree(ca, h = 6)   
lab

text(body_pc$scores[,1:2], labels = lab, cex=0.6)  
##############


##


## US Crime data ##
## Hierarchical clustering example ##
crime<- read.table("crime.txt")
head(crime)

dim(crime)

# Distance matrix
dm.crime <- dist(crime)

# Dendogram
plot(slc <- hclust(dm.crime, method = "single"))
plot(clc <- hclust(dm.crime, method = "complete"))
plot(avc <- hclust(dm.crime, method = "average"))



######################################
# K-means clustering
######################################

library(MVA)

crime <- read.table("crime.txt")
head(crime)
dim(crime)
summary(crime)

#Scaterplot matrix
pairs(crime)

# scatterplot with different character symbol
plot(crime, pch = ".", cex = 3.5)

par(mfrow=c(2,3))
# Histogram of each of the variables
hist(crime$Murder) # Possible outlier
hist(crime$Rape)
hist(crime$Robbery) # Possible outlier
hist(crime$Assault)
hist(crime$Burg)
hist(crime$Theft)
hist(crime$Vehicle)

# Look for outlier in the data, clearly there is one
subset(crime, Murder > 15)

subset(crime, Robbery > 400)


# Crime plot with DC marked with an asterisk 
plot(crime, pch = c(".", "*")[(rownames(crime) == "DC") + 1], cex = 1.5)

# Exclude DC from the analysis by creating a new data set called crime2
crime2 <- crime[-c(rownames(crime)=="DC"), ]
head(crime2)
dim(crime2)
dim(crime)
crime2

# Look at the variances of the variables
round(apply( crime2, 2, var), 2)

# Steps:
# Calculate the range of each variabe, and standardize the 
# variable by the range

range2 <- function(x) {diff(range(x))}
range2(crime$Theft)

# Range of each variable
apply(crime, 2, range2)

# Create new data with columns standardized by the range
crime3 = crime2
crime3$Murder <- crime2$Murder/30
crime3$Rape <- crime2$Rape/61.1
crime3$Robbery <- crime2$Robbery/747
crime3$Assault <- crime2$Assault/636
crime3$Burglary <- crime2$Burglary/1836
crime3$Theft <- crime2$Theft/3015
crime3$Vehicle <- crime2$Vehicle/876

# Check the new variances
round(apply(crime3, 2, var), 4)

# kmeans clustering: Usage

# K-means clustering with different group sizes

# showing the centers of each variable when 2 groups are considered
round(kmeans(crime3, centers = 2)$centers, 4)

out <- kmeans(crime3, centers = 2)
out
names(out)

# Showing the cluster that each data-row belongs to
kmeans(crime3, centers = 2)$cluster
out$cluster

# Showing the cluster sizes
kmeans(crime3, centers = 2)$size

# Which cluster has what size?
table(kmeans(crime3, centers = 2)$cluster)


##########################################
# Analysis -- start with a single cluster
##########################################

# Shows you center of the group, with one group

kmeans(crime3, centers=1)$centers
# do it for 2, 3, 4, 5, 6, groups

# For example, for 6 groups
round(kmeans(crime3, centers = 6)$centers, 4)

# Calculate within group sum of squares for each 
sum(kmeans(crime3, centers = 1)$withinss) 
sum(kmeans(crime3, centers = 2)$withinss) 
sum(kmeans(crime3, centers = 3)$withinss) 

# Calculate the WGSS for each k and save them in an object
wss <- rep(0, 6)
for (i in 1:6) 
{
  wss[i] <- sum(kmeans(crime3, centers = i)$withinss)
}

wss

plot(1:6, wss, type ="b", ylab = "Within-group SS", xlab = "Number of groups")

######################################
# K-mean clustering continues
# Plot of the first two Principal Components
######################################
crime3_pca <- princomp(crime3, cor = TRUE)

plot(crime3_pca$scores[, 1:2], pch = kmeans(crime3, centers = 2)$cluster)


# Plot of plotting symbols
plot(1:19, pch=1:19)


########################################
# Complete Example of Clustering ##
# Public Utility Data (1975)
# Source: Johnson and Wichern 6/ed Table 12.4 p. 688
########################################

utility <- read.table("T12-4.dat")
head(utility)
util <- utility[, 1:8]
head(util)


dm.util <- dist(util)
dm.util


# 
rownames(util) <- utility$V9
head(util)

# Application of hierarchical clustering (of variables)
# Correlation matrix
cor(util)

## Use correlations between variables "as distance"
(1 - cor(util))/2


# Calculating the distance
dd <- as.dist((1 - cor(util))/2)
dd

round(1000 * dd) # (prints more nicely)
plot(hclust(dd)) # to see a dendrogram of clustered variables

# Try with different scaling
dd <- as.dist((1 - cor(util)))
round(1000 * dd) # (prints more nicely)
plot(hclust(dd)) # to see a dendrogram of clustered variables

# Comment: Clustering does not change.

# Application of hierarchical clustering (of companies)
dm.util <- dist(util)
plot(hclust(dm.util)) # to see a dendrogram of clustered companies


# Application of K-means clustering of companies
# ##############################################

# showing the centers of each variable when 2 groups are considered

kmeans(util, center=2)$centers

round(kmeans(util, centers = 2)$centers, 2)

#set.seed(10)
out <- kmeans(util, centers = 2)
out$cluster

# Showing the cluster that each data-row belongs to
kmeans(util, centers = 2)$cluster

# Showing the cluster sizes
kmeans(util, centers = 2)$size
table(kmeans(util, centers = 2)$cluster)

# Shows you center of the group, with one group
kmeans(util, centers=1)$centers
# do it for 2, 3, 4, 5, 6, groups

# For example, for 5 groups
round(kmeans(util, centers = 5)$centers, 4)

# Calculate within group sum of squares for each 
sum(kmeans(util, centers = 2)$withinss) 
sum(kmeans(util, centers = 3)$withinss) 
sum(kmeans(util, centers = 4)$withinss) 

# Calculate the WGSS for each k and save them in an object
wss <- rep(0, 6)
for (i in 1:6) 
{
  wss[i] <- sum(kmeans(util, centers = i)$withinss)
}

wss

plot(1:6, wss, type ="b", ylab = "Within-group SS", xlab = "Number of groups")


# Showing the cluster centers with two clusters
kmeans(util, centers = 2)$centers
table(kmeans(util, centers = 2)$cluster)



#########################
# Plotting the clusters
#########################

# K-Means Clustering with 3 clusters
fit3 <- kmeans(util, centers = 3)

# 2 cluster solution
fit2 <- kmeans(util, centers = 2)


# Cluster Plot of first two principal components
library(cluster) 
clusplot(util, fit3$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)

# Plot the two cluster solution
clusplot(util, fit2$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)


# Solution with four clusters
fit4 <- kmeans(util, centers=4)
clusplot(util, fit4$cluster, color=T, shade=T, labels=2, lines=0)

# on standardized data
clusplot(scale(util), fit$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)


## NOT COVERED

# # Centroid Plot against the discriminant functions
# # install.packages("fpc")
# library(fpc)
# plotcluster(util, fit$cluster)

###################################
# Example of Cluster Analysis ###
###################################

# Breakfast cereal data ##

# Measurements on 5 nutritional variables for 12 breakfast 
# cereals are available in the CEREAL.TXT data set.

cereal <- read.csv("cereal.csv", header=F)
head(cereal)

row.name <- c("Life", "Grape", "SuperSugar", "SpecialK", "RiceKrisp", "RaisinBran", "Prod19", "Weaties", "Total", "PuffedRice", "SugarCornPops", "SugarSmacks")

col.name <- c("Sl", "Brand", "Protein", "Carb", "Fat", "Calory", "VitA")

# Assign column names to ceral data object
colnames(cereal) <- col.name
rownames(cereal) <- row.name

head(cereal)

# Removing the first two columns from the data;
cereal <- cereal[,-c(1, 2)] # dropping col 1
head(cereal)


# Calculate the distance matrix
dm.cereal <-dist(cereal)


# Hierarchicical clustering of cereal brands
# Plot dendogram

# Single linkage
plot(slc.cereal <- hclust(dm.cereal, method = "single"))

# Single linkage
plot(clc.cereal <- hclust(dm.cereal, method = "complete"))

# Average linkage
plot(avc.cereal <- hclust(dm.cereal, method = "average"))


# K-means clustering of cereal brands
# ##################################

# showing the centers of each variable when 2 groups are considered

out <- kmeans(cereal, centers = 2)
names(out)

out$centers

# Showing the cluster that each data-row belongs to
out$cluster

# Showing the cluster sizes
table(kmeans(cereal, centers = 2)$cluster)

# Shows you center of the group, with one cluster
kmeans(cereal, centers=1)$centers
# do it for 2, 3, 4, 5, 6, groups

# For example, for 5 groups
round(kmeans(cereal, centers = 5)$centers, 4)

# Calculate within group sum of squares for each 
sum(kmeans(cereal, centers = 2)$withinss) 
sum(kmeans(cereal, centers = 3)$withinss) 
sum(kmeans(cereal, centers = 4)$withinss) 

# Calculate the WGSS for each k and save them in an object
wss <- rep(0, 6)
for (i in 1:6) 
{
  wss[i] <- sum(kmeans(cereal, centers = i)$withinss)
}

wss

plot(1:6, wss, type ="b", ylab = "Within-group SS", xlab = "Number of groups")


# Showing the cluster centers with two clusters
kmeans(cereal, centers = 2)$centers
table(kmeans(cereal, centers = 2)$cluster)



#########################
# Plotting the clusters
#########################

# K-Means Clustering with 3 clusters
fit3 <- kmeans(cereal, centers = 3)

# 2 cluster solution
fit2 <- kmeans(cereal, centers = 2)


# Cluster Plot of first two principal components
library(cluster) 
clusplot(cereal, fit3$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)

# Plot the two cluster solution
clusplot(cereal, fit2$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)


# on standardized data
fit <- kmeans(scale(cereal), centers=2)
clusplot(scale(cereal), fit$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)





#############################################
# Example:

# Admission officer of a graduate school has used an ``index'' of 
# undergraduate GPA and graduate management aptitude test (GMAT) 
# scores to help decide which applicants should be admitted to the
# graduate programs. The scatter plot of GPA vs GMAT (shown in the
# attached SAS output) shows recent applicants who have been 
# classified as ``Admit (A)'', ``Borderline (B)'', and ``Reject (R)''. 

# 1 = admitted
# 2 = rejected
# 3 = borderline

# We use this data set to demonstrate cluster analysis.
# In particular, we use the GPA and GMAT scores to see if 
# we can find the natural grouping in the data
#############################################

gpa <- read.table("admissn.dat")

head(gpa)

# keep only the first two columns
gpa2 <- gpa[, c(1:2)]

head(gpa2)
colnames(gpa2) <- c("GPA", "GMAT")

################################################
# Last analysis first
# Perform cluster analysis on standardized data
################################################

fit2 <- kmeans(scale(gpa), centers=2)
clusplot(scale(gpa), fit2$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)

fit3 <- kmeans(scale(gpa), centers=3)
clusplot(scale(gpa), fit3$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)


# Now carry out k-means clustering 

####################################
# K-means clustering of admission data
# ##################################

# showing the centers of each variable when 2 groups are considered

out <- kmeans(gpa2, centers = 2)
names(out)

out$centers

# Showing the cluster that each data-row belongs to
out$cluster

# Showing the cluster sizes
table(out$cluster)

# Shows you center of the group, with one cluster
kmeans(gpa2, centers=3)$centers
# do it for 2, 3, 4, 5, 6, groups

# For example, for 4 groups
round(kmeans(gpa2, centers = 4)$centers, 4)

# Calculate within group sum of squares for each 
sum(kmeans(gpa2, centers = 2)$withinss) 
sum(kmeans(gpa2, centers = 3)$withinss) 
sum(kmeans(gpa2, centers = 4)$withinss) 

# Calculate the WGSS for each k and save them in an object
wss <- rep(0, 6)
for (i in 1:6) 
{
  wss[i] <- sum(kmeans(gpa2, centers = i)$withinss)
}

wss

plot(1:6, wss, type ="b", ylab = "Within-group SS", xlab = "Number of groups")

# Frequency table (whether admission/rejected/borderline)
table(gpa[,3])

# Now plot the clusters (with raw data)
fit2 <- kmeans(gpa2, centers=2)
clusplot(gpa2, fit2$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)

fit3 <- kmeans(gpa2, centers=3)
clusplot(gpa2, fit3$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)



###################################
# Model based clustering (Not covered)
###################################

# install.packages("mclust")

library(mclust)

mclustModelNames

multivariateMixture



###################################################
### Plot with country as label
###################################################

thomsonprop <- prop.table(ttab, c(1,3))[,"yes",]

plot(1:(22 * 6), rep(-1, 22 * 6), 
      ylim = c(-nlevels(thomson$country), -1), type = "n",
      axes = FALSE, xlab = "", ylab = "")

for (q in 1:6) {   
  tmp <- ttab[,,q]
  xstart <- (q - 1) * 22 + 1
  y <- -rep(1:nrow(tmp), rowSums(tmp))
  x <- xstart + unlist(sapply(rowSums(tmp), function(i) 1:i))
  pch <- unlist(apply(tmp, 1, function(x) c(rep(19, x[2]), rep(1, x[1]))))
  points(x, y, pch = pch)
}

axis(2, at = -(1:nlevels(thomson$country)), labels = levels(thomson$country),
      las = 2, tick = FALSE, line = 0)

mtext(text = paste("Question", 1:6), 3, at = 22 * (0:5), adj = 0)


###################################################
### Finding the optimum number of clusters / components
###################################################

(mc <- Mclust(thomsonprop))
mc

# Plot of BIC agains the number of components
plot(mc, thomsonprop, what = "BIC", col = "black")


###################################################
### Plot with cluster names
###################################################


# Three cluster solution 
# Graphical illustration

cl <- mc$classification

nm <- unlist(sapply(1:3, function(i) names(cl[cl == i])))

ttab <- ttab[nm,,]

plot(1:(22 * 6), rep(-1, 22 * 6), 
      ylim = c(-nlevels(thomson$country), -1), type = "n",
      axes = FALSE, xlab = "", ylab = "")

for (q in 1:6) {   
  tmp <- ttab[,,q]
  xstart <- (q - 1) * 22 + 1
  y <- -rep(1:nrow(tmp), rowSums(tmp))
  x <- xstart + unlist(sapply(rowSums(tmp), function(i) 1:i))
  pch <- unlist(apply(tmp, 1, function(x) c(rep(19, x[2]), rep(1, x[1]))))
  points(x, y, pch = pch)
 }

axis(2, at = -(1:nlevels(thomson$country)), labels = dimnames(ttab)[[1]], 
     las = 2, tick = FALSE, line = 0)

mtext(text = paste("Question", 1:6), 3, at = 22 * (0:5), adj = 0)

abline(h = -cumsum(table(cl))[-3] - 0.5, col = "grey")

text(-c(0.75, 0.75, 0.75), -cumsum(table(cl)) + table(cl)/2,
    label = paste("Cluster", 1:3), srt = 90, pos = 1)

