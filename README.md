# OpenWorks-Network
An Open Source implementation of Infoworks Model Network

The aim of this project is to create a fast equivelent of the InfoWorks ICM model network, for use in model data analysis and bulk model updates. The project will be optimised mainly for tracing speed, as connectivity is the most important part of hydraulic models. Other model data will also be accessible from the main geographical object, however the access of this data is likely to be slower, though this may change as this project evolves.

This project is **NOT** designed for hydraulic simulations, however, if someone knows how hydraulic simulation engines work, you are more than free to create one using this system.

This project is still mainly an experiment. The main experiment is - can we build it faster? If that proves fruitful, then I will continue creating the project.

The project was initially started in [Go](https://golang.org/), however it was later changed for [Crystal](https://crystal-lang.org/). Crystal should give users familiar with the InfoWorks ICM Ruby API the ability to quickly build algorithms in Crystal, as syntactically Ruby and Crystal are very alike.

Finally, I will be making Ruby scripts to easily bridge between InfoWorks and OpenWorks networks, hopefully allowing for easy and fast migration.
