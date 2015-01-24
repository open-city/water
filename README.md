# Chicago OpenWater Project
#### An open-source, open-data look at Chicago's water resources
---
This repo is part an ongoing project of Chicago's [OpenGov Hack Night](http://opengovhacknight.org/)

###JavaCrons
This project is for Java-based cronjobs that fill up our database


Combined Sewage Overflow (CSO) forecasting
==========================================

Dependencies:

* R

R packages:

* doMC
* gbm
* glmnet
* gplots
* pROC

To run:

	cd path/to/water
	make model
