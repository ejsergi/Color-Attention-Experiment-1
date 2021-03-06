# Documentation

This documentation goes through over all the files and data used either to prepare, run or analyze results of the experiment

The full path of all the files in the codes are relative the the computer used in the first experiment, so they might need to be adapted.

## Process of usage

1. [Preparation of stimuli](../doc/Preparation.md)
2. [Running the experiment](../doc/Run.md)
3. Analysis of the results (This section hasn't been documented yet)


## Content of folders

- [**Script**](../script) includes all the functions (mainly written in *Matlab*) and different data needed in order to prepare, run and analyze the experiment.
- In the folder [**Tables**](../Tables) we can find different *Excel* files which contains useful data which might be good analyze externally. You can see more information about each table already created in [Tables documentation](../doc/Tables.md)
- Finally, [**doc**](../doc) has all the information needed to understand, use and edit the program.

### Notice

> A extra folder containing all the PNG images has to be included in the Matlab path. Nevertheless, for reasons of size this folder cannot be included in the GitHub path, and has to always be stored locally.
> The folder is referred in the code as `STIMULUS/`, and the actual real patch needs to be changed in the code.
> The images inside the folder have to be created previously of running the experiment. More detailed information about how to do so can be find in the [Preparation of stimuli](../doc/Preparation.md) documentation.
