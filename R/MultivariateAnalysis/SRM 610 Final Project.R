
# Final Project

# Votes for Republican Candidate in Presidential Elections

# Background

# The data shows the percentage of votes given to the republican
# candidate in presidential elections from 1856 to 1976. 
# Rows represent the 50 states, and columns the 31 elections.

# Source: S. Peterson (1973): A Statistical History of the American
# Presidential Elections. New York: Frederick Ungar Publishing Co.
# Data from 1964 to 1976 is from R. M. Scammon, American Votes 12,
# Congressional Quarterly.


# You may need to install these packages first
# install.packages("mclust")
# install.packages("flexclust")
# 

library(mclust)
library(MVA)
library(HSAUR2)
library(cluster)

prot <- read.csv("protein.csv", header=T)
head(prot)

rownames(prot) <- prot$Country

# Remove the first column of the data set
prot <- prot[, -1]
dim(prot)
head(prot)




# Calculate the distance matrix
dm <- dist(prot)


# Plot dendogram

# Single linkage
plot(slc <- hclust(dm, method = "single"))

# Single linkage
plot(clc <- hclust(dm, method = "complete"))

# Average linkage
plot(avc <- hclust(dm, method = "average"))



# Application of K-means clustering of votes
# ##############################################


# Calculate the WGSS for each k and save them in an object
wss <- rep(0, 6)
for (i in 1:6) 
{
  wss[i] <- sum(kmeans(prot, centers = i)$withinss)
}

wss

plot(1:6, wss, type ="b", ylab = "Within-group SS", xlab = "Number of groups")




#########################
# Plotting the clusters
#########################

# K-Means Clustering with 3 clusters
fit3 <- kmeans(prot, centers = 3)

# 2 cluster solution
fit2 <- kmeans(prot, centers = 2)


# Cluster Plot of first two principal components
library(cluster) 
clusplot(prot, fit3$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)

# Plot the two cluster solution
clusplot(prot, fit2$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)


# Solution with four clusters
fit4 <- kmeans(prot, centers=4)
clusplot(prot, fit4$cluster, color=T, shade=T, labels=2, lines=0)

# on standardized data
fit <- kmeans(scale(prot), centers=2)
clusplot(scale(prot), fit$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)


