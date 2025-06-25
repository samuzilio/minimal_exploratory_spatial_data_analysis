# Minimal Exploratory Spatial Data Analysis
## Overview
This repository contains a script to perform a minimal exploratory spatial data analysis on a given dataset.
<br>
>*"Exploratory spatial data analysis (ESDA) is an extension of exploratory data analysis (EDA) as it explicitly focuses on the particular characteristics of geographical data. It is an increasingly popular GIS-based technique that allows users to describe and visualize spatial distributions, identify atypical locations or spatial outliers, discover patterns of spatial association, clusters or hot spots, and suggest spatial regimes or other forms of spatial heterogeneity. The strength of ESDA relies on its ‘data mining’ capacity which is particularly useful when no prior theoretical framework exists, as is often the case in multidisciplinary fields of social sciences. It proposes a wide range of largely graphical methods that explore the properties of datasets without the need for formal model building, which is not necessarily of interest to many GIS users."* ([S. Dall'Erba, 2009](https://doi.org/10.1016/B978-008044910-4.00433-8))

> [!IMPORTANT]
> For demonstration purposes this script uses sample point data stored in a GPKG file.

<br>

## Instructions
Follow these steps to set up and run the script on your local machine:

**1**. Clone the repository:
```
$ git clone https://github.com/samuzilio/minimal_exploratory_spatial_data_analysis.git
```
**2**. Launch your text editor;

**3**. Open the cloned repository;

**4**. Start a new R terminal;

**5**. Create and activate a virtual environment (requires [`renv`](https://rstudio.github.io/renv/index.html) package installed globally):
```
$ renv::activate()
```
**6**. Install dependencies:
```
$ renv::restore()
```
**7**. Open the `esda.R` file and run code cells.
