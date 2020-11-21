Forecast Evaluation for the German Forecast Hub
================

true

This is a preliminary evaluation of forecasts made for the [German
Forecast Hub](https://github.com/KITmetricslab/covid19-forecast-hub-de).
These evaluations are preliminary - this means I cannot currently rule
out any mistakes and the plots and analyses are subject to change. The
evaluations are not authorised by the German Forecast Hub team.

Feel free to reproduce this analysis. To that end, you can clone this
repository and the Forecast Hub repository, specify the directory of the
submissions files in the R-Markdown script and run the script.

If you have questions or want to give feedback, please create an issue
in this repository.

Forecast Visualisation
======================

Germany
-------

### 2020-10-12

<img src="forecast-hub-report_files/figure-gfm/showdata-1.png" width="100%" />

<img src="forecast-hub-report_files/figure-gfm/showdata-2.png" width="100%" />

### 2020-10-19

<img src="forecast-hub-report_files/figure-gfm/showdata-3.png" width="100%" />

<img src="forecast-hub-report_files/figure-gfm/showdata-4.png" width="100%" />

### 2020-10-26

<img src="forecast-hub-report_files/figure-gfm/showdata-5.png" width="100%" />

<img src="forecast-hub-report_files/figure-gfm/showdata-6.png" width="100%" />

### 2020-11-02

<img src="forecast-hub-report_files/figure-gfm/showdata-7.png" width="100%" />

<img src="forecast-hub-report_files/figure-gfm/showdata-8.png" width="100%" />

### 2020-11-09

<img src="forecast-hub-report_files/figure-gfm/showdata-9.png" width="100%" />

<img src="forecast-hub-report_files/figure-gfm/showdata-10.png" width="100%" />

Poland
------

### 2020-10-12

<img src="forecast-hub-report_files/figure-gfm/showdata-11.png" width="100%" />

<img src="forecast-hub-report_files/figure-gfm/showdata-12.png" width="100%" />

### 2020-10-19

<img src="forecast-hub-report_files/figure-gfm/showdata-13.png" width="100%" />

<img src="forecast-hub-report_files/figure-gfm/showdata-14.png" width="100%" />

### 2020-10-26

<img src="forecast-hub-report_files/figure-gfm/showdata-15.png" width="100%" />

<img src="forecast-hub-report_files/figure-gfm/showdata-16.png" width="100%" />

### 2020-11-02

<img src="forecast-hub-report_files/figure-gfm/showdata-17.png" width="100%" />

<img src="forecast-hub-report_files/figure-gfm/showdata-18.png" width="100%" />

### 2020-11-09

<img src="forecast-hub-report_files/figure-gfm/showdata-19.png" width="100%" />

<img src="forecast-hub-report_files/figure-gfm/showdata-20.png" width="100%" />

Score Overview
==============

Overview of all the models and metrics

Overall<img src="forecast-hub-report_files/figure-gfm/scoretable-1.png" width="100%" />
---------------------------------------------------------------------------------------

<img src="forecast-hub-report_files/figure-gfm/scoretable-2.png" width="100%" />

Germany
-------

### Overall

<img src="forecast-hub-report_files/figure-gfm/scoretable-3.png" width="100%" />
<img src="forecast-hub-report_files/figure-gfm/scoretable-4.png" width="100%" />\#\#\#
2020-10-12
<img src="forecast-hub-report_files/figure-gfm/scoretable-5.png" width="100%" />

<img src="forecast-hub-report_files/figure-gfm/scoretable-6.png" width="100%" />

### 2020-10-19

<img src="forecast-hub-report_files/figure-gfm/scoretable-7.png" width="100%" />

<img src="forecast-hub-report_files/figure-gfm/scoretable-8.png" width="100%" />

### 2020-10-26

<img src="forecast-hub-report_files/figure-gfm/scoretable-9.png" width="100%" />

<img src="forecast-hub-report_files/figure-gfm/scoretable-10.png" width="100%" />

### 2020-11-02

<img src="forecast-hub-report_files/figure-gfm/scoretable-11.png" width="100%" />

<img src="forecast-hub-report_files/figure-gfm/scoretable-12.png" width="100%" />

### 2020-11-09

<img src="forecast-hub-report_files/figure-gfm/scoretable-13.png" width="100%" />

<img src="forecast-hub-report_files/figure-gfm/scoretable-14.png" width="100%" />

Poland
------

### Overall

<img src="forecast-hub-report_files/figure-gfm/scoretable-15.png" width="100%" />
<img src="forecast-hub-report_files/figure-gfm/scoretable-16.png" width="100%" />\#\#\#
2020-10-12
<img src="forecast-hub-report_files/figure-gfm/scoretable-17.png" width="100%" />

<img src="forecast-hub-report_files/figure-gfm/scoretable-18.png" width="100%" />

### 2020-10-19

<img src="forecast-hub-report_files/figure-gfm/scoretable-19.png" width="100%" />

<img src="forecast-hub-report_files/figure-gfm/scoretable-20.png" width="100%" />

### 2020-10-26

<img src="forecast-hub-report_files/figure-gfm/scoretable-21.png" width="100%" />

<img src="forecast-hub-report_files/figure-gfm/scoretable-22.png" width="100%" />

### 2020-11-02

<img src="forecast-hub-report_files/figure-gfm/scoretable-23.png" width="100%" />

<img src="forecast-hub-report_files/figure-gfm/scoretable-24.png" width="100%" />

### 2020-11-09

<img src="forecast-hub-report_files/figure-gfm/scoretable-25.png" width="100%" />

<img src="forecast-hub-report_files/figure-gfm/scoretable-26.png" width="100%" />

Interval Score Components
-------------------------

Weighted interval score broken down into its components “overprediction
penalty”, “underprediction penalty” and “sharpness”

<img src="forecast-hub-report_files/figure-gfm/unnamed-chunk-1-1.png" width="100%" /><img src="forecast-hub-report_files/figure-gfm/unnamed-chunk-1-2.png" width="100%" />

Calibration
-----------

### Interval Coverage

Plot of the percentage of true values captured by each prediction
interval

<img src="forecast-hub-report_files/figure-gfm/unnamed-chunk-2-1.png" width="100%" /><img src="forecast-hub-report_files/figure-gfm/unnamed-chunk-2-2.png" width="100%" />

### Quantile Coverage

Plot of the percentage of true values below each predictive quantile
level

Bias
----

<img src="forecast-hub-report_files/figure-gfm/unnamed-chunk-4-1.png" width="100%" /><img src="forecast-hub-report_files/figure-gfm/unnamed-chunk-4-2.png" width="100%" />
