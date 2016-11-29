Running the experiment
======================

This part of the documentation goes through the process of running the experiment, explaining in detail both hardware and software set up.

> Notice that all the files needed to run the experiment are found in the folder [`Run/`](../script/Run).

The experiment was prepared for a really specific set-up, therefore codes were created with the goal of being functional in this set-up. If different set-up is needed, probably big changes in the codes will be needed. Whether you want to replicate the experiment or run it differently, knowledge of the hardware set-up and how the codes works is needed.


Hardware set-up
---------------

The actual experimental devices and connections were as follows:

- **Main CPU** was the one running the program in *Matlab* and controlling all the experiment.
- **Monitor 1**, connected to the **main CPU**, showed the code where the instructor was controlling the experiment.
- **Monitor 2**, also connected to the **main CPU**, displayed the stimuli to the observer. This monitor had an specific calibration, and its ICC profile is the one used in the preparation of the experiment.
- **SMI CPU** is the computer provided by the eye-tracker manufacturer, and it was needed in order to make the eye-tracker work. This CPU was connected to the **Main CPU** through an *Ethernet cable*, so this could control the eye-tracker indirectly.
- **SMI eye-tracker**, connected to the **SMI CPU**, was placed under the **Monitor 2** in a way it could record the eye movements of the observer.
- **Monitor 3** was connected to the **SMI CPU** and it was used to display the eye-tracker information.

Probably the more challenging part is establish the connection between the two CPUs using a Ethernet cable. Both softwares, *Matlab* in the **Main CPU** and *SMI controller* in the **SMI CPU**, have to communicate internally, to do that in both programs the IP address and port of the other machine has to be introduced.

> There is no specific way in how to check all the connections are done in the proper way. But we will have to make sure that connection between both CPUs is correct and also than the instructor's monitor is set to **1** and observer's to **2**.


Running the code
----------------

The main function in order to run the experiment is [`RUNEXPERIMENT.m`]. Function needs having on patch both the [*Psychtoolbox*](http://psychtoolbox.org) and the [`SMIFiles/`](../script/Run/SMIFiles). The function need to also have a specific folder on where to save the reported data [`EXPERIMENTFILES/`] and a local folder on the **SMI CPU** on where save the eye movements file.

The function is configured to only run one trial for each chroma, hue, and lightness.

Several content has to be modified and adapted before running the script:

- in line `5` the the variable `nameExp` has to be equal to the stimuli set code that wants to be displayed.
- in lines `9-10` the path to *SMIFIles* folder needs to be added.
```matlab
addpath('SMIFiles/');
load('SMIFiles/EnvDet.mat');
```
- in line `13` add the path to the folder containing all the info of each stimuli set.
```matlab
load(['STIMULISinfo/' nameExp '.mat']);
```
- in line `40` introduce the path to a specific PNG stimuli image to use as an example for the observer.
```matlab
theImage = imread('/Volumes/myshares/Sergis share/STIMULIS/002/S258.png');
```
- in line `76` we should add the path to the the `STIMULUS/` folder, containing all the different set of PNG stimuli.
```matlab
theImage = imread(['/Volumes/myshares/Sergis share/STIMULIS/' nameExp '/S' ...
sprintf('%03d',sele(permu(i))) '.png']);
```
- in line `100` the folder where the eye movements have to be saved in the **SMI CPU**.
```matlab
toSend = ['ET_SAV "D:/SergiResults/' nameExp '/' sprintf('%03d', ...
sele(permu(i))) '.idf" "' nameExp '" "' sprintf('%03d',permu(i)) '" "OVR"'];
```
- in line `111` you can set in what stimulus to do a break.
- finally, in lines `112` and `152` you need to have the correct patch to the folder `EXPERIMENTFILES/` where the final `info` with the reported and times is saved.
```matlab
save(['EXPERIMENTFILES/' nameExp '.mat'],'info','-v7.3');
```

To have more details in how the function works step by step, refer to the comments located within the function.

[`RUNEXPERIMENT.m`]: ../script/Run/RUNEXPERIMENT.m
[`EXPERIMENTFILES/`]: ../script/Run/EXPERIMENTFILES
