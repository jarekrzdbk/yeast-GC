rm(list=ls())
install.packages("ggplot2")
install.packages("dplyr")
library(ggplot2)
library(dplyr)
setwd("./outputs")

cen_data <- read.delim("CEN.PK113-7D_Delft_2012_AEHG00000000.gc", header = FALSE, col.names = c("gc"), sep = "\n")
fl_data <- read.delim("FL100_SGD_2015_JRIT00000000.gc", header = FALSE, col.names = c("gc"), sep = "\n")
ec_data <- read.delim("EC9-8_ASinica_2011_AGSJ01000000.gc", header = FALSE, col.names = c("gc"), sep = "\n")

pdf("cen_gc_frequency_ratio.pdf")
ggplot(cen_data, aes(x = gc)) +
  ggtitle("count of orfs in CEN cen by gc content") +
  geom_histogram(fill = "white", colour = "black", binwidth = 0.01)
dev.off()

pdf("fl_gc_frequency_ratio.pdf")
ggplot(fl_data, aes(x = gc)) +
  ggtitle("count of orfs in FL100 by gc content") +
  geom_histogram(fill = "white", colour = "black", binwidth = 0.01)
dev.off()

pdf("ec_gc_frequency_ratio.pdf")
ggplot(ec_data, aes(x = gc)) +
  ggtitle("count of orfs in EC9 by gc content") +
  geom_histogram(fill = "white", colour = "black", binwidth = 0.01)
dev.off()

combdat <- dplyr::bind_rows(list(cen=cen_data,fl=fl_data, ec=ec_data),
                            .id="strain")
pdf("combined_histogram.pdf")
ggplot(combdat,aes(gc,fill=strain)) +
  ggtitle("combined histogram of all 3 strains by gc frequency ratio") +
  scale_fill_manual(values=c("red","blue", "green")) +
  geom_histogram(alpha=0.35,binwidth=0.01,position="identity")
dev.off()

pdf("combined_boxplot.pdf")
ggplot(combdat, aes(x=gc, y=strain, color=strain, fill=strain)) + 
  ggtitle("boxplot of 3 strains") +
  geom_boxplot() + 
  stat_summary(fun=mean, geom="point", shape=23, size=4) + 
  scale_fill_brewer(palette="Pastel2") + 
  theme_minimal()
dev.off()

pdf("combined_densityplot.pdf")
ggplot(combdat, aes(gc, fill = strain)) +
  ggtitle("density plot of 3 strains") +
  scale_fill_manual(values=c("red","blue", "green")) + 
  geom_density(alpha = 0.2)
dev.off()