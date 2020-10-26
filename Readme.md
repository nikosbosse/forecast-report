Forecast Evaluation for the German Forecast Hub
================

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
----------------------

Visualisation of one week ahead forecasts

<img src="forecast-hub-report_files/figure-gfm/showdata-1.png" width="100%" /><img src="forecast-hub-report_files/figure-gfm/showdata-2.png" width="100%" /><img src="forecast-hub-report_files/figure-gfm/showdata-3.png" width="100%" /><img src="forecast-hub-report_files/figure-gfm/showdata-4.png" width="100%" />

Score Overview
--------------

Overview of all the models and metrics

<img src="forecast-hub-report_files/figure-gfm/scoretable-1.png" width="100%" /><img src="forecast-hub-report_files/figure-gfm/scoretable-2.png" width="100%" />

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

<img src="forecast-hub-report_files/figure-gfm/unnamed-chunk-3-1.png" width="100%" /><img src="forecast-hub-report_files/figure-gfm/unnamed-chunk-3-2.png" width="100%" />

Bias
----

<img src="forecast-hub-report_files/figure-gfm/unnamed-chunk-4-1.png" width="100%" /><img src="forecast-hub-report_files/figure-gfm/unnamed-chunk-4-2.png" width="100%" />
