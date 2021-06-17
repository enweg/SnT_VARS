# A non-technical, interactive introduction to Vector AutoRegressive (VAR) models

## Purpose

The purpose of this interactive notebook is to provide a non-technical introduction to VAR models. VAR models are the backbone of modern multivariate time series modelling and used in many application areas, such as macroeconomics, finance, and marketing. Traditional classes covering VAR models are rather static in the sense that characteristics and techniques involving VAR models are only studied from a theoretical point of view, or only using one static example. This notebook tries to change this by being interactive and allowing users to learn through experimenting. 

The notebook does not go too much in depth and could therefore be used as a first, more intuitive introduction to VAR models, which could be followed up upon through more theoretical discussions and exercises. 

> This work was done during my student assistantship under Ines Wilms and was supported through the Elinor Ostrom Grant.

## Using the Notebook

The interactive notebook can be used in various forms. The easiest is to open the notebook on binder. This can be done by using one of the following links. The first only opens the notebook on mybinder.org. 

> :info: Please be aware that the loading process can take a while. By clicking on on the *show* button, you can see what is going on.

The scond link opens a complete RStudio session on mybinder.org. This is needed if you wish to use the notebook with your own data, as the first link does not support this functionality due to security reasons. For instructions on how to start the notebook ones you are in RStudio, please follow the intructions for the downloaded version (see below).

1. Notebook: [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/enweg/SnT_VARS/main?urlpath=shiny/App/)
2. RStudio Session: [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/enweg/SnT_VARS/main?urlpath=rstudio)

The third way to use the notebook is to download the repository and to start the notebook locally. This is also the only option that does not require any internet connection. Since this is the more complicated way, below is a more detailed description on how this can be done:

1. Download the repository
2. Open the project in RStudio
3. Open the *start_app.R* script
4. Run the script

## Problems, Suggestions, and Corrections

If you encounter any problems, have any suggestions, or found a mistake that should be corrected, please open an issue here on Github and let us know about it. We appreciate any feedback!

## Known issues and proposed fixes

* **(mybinder.org Notebook)** If the notebook thorws an initial error, but still shows that you can select variables, then just delete one of the variables and add it back in. This often solves the intial start-up error. I will try to figure out how to prevent this error. If you have any suggestions, please let me know.

