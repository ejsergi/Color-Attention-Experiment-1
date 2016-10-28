# Preparation of stimuli

A priori of running the experiment, the stimuli have to be created. Each stimulus is a PNG image of 1440x1440 pixels. The high computational requirements make impossible to create the stimuli in real time meanwhile running the experiment.
All the files and scripts needed in order to prepare the stimuli are found in the folder [`Scripts/Prepare/`](../Scripts/Prepare)

The first needed thing is to know all the possible *CIELAB* values that the experimental monitor can reproduce, and then apply a proportional space in terms of all chroma for all the different hues. The script [`MAKEPOINTS.m`] is designed for doing this, it simply need to be run with the path to the Monitor ICC profile in the line 8 of the code. The script will create a file on the same folder named `PointsLab.mat` which contains all the colors that the monitor can reproduce, this information will be needed to create the stimuli.

Next and last step is to create the actual set of stimuli. The script [`PREPARESTIMULI.m`] already does that for you, but is needed to edit variables in lines 7 and 8, by setting how many sets are to be created and which one is the last one created (so it does not overwrite it). Eg:

```matlab
num_set = 10;
last_created = 20;
```

Once you run it, the function may take several hours to complete the process, depending in how many sets has to create.

> Its important to always update the path directions. In this case an external path to a folder where to save the stimuli needs to be created. For instance: `STIMULI/`

The function is set to create the stimuli in the way it was set up for the experiment, therefore it will straight away create in the `STIMULI/` folder a new directory name as a set number, and fill it with all the 648 stimulus, sorted in the following order:

1. Chroma (24, 8 in each stimuli)
2. Trial (3)
3. Hue (18)
4. Lightness (4)

>Please refer to [`Tables/Index.xlsx`](../Tables/Index.xlsx) for a complete list of all the stimuli sorted by number and its correspondent characteristics.

Both background and patches were of a random distribution with specific means and deviations. Patches locations were set randomly within all possible locations. If any of these parameters should be changed, it is important to have a complete knowledge of how each function proceeds. Although detaild comments are found inside the function, the overall idea behind them will be explained next.  

[`PREPARESTIMULI.m`] is simply a function which loops changing in each loop the different characteristics that the stimuli must have and then calls [`CreatePatt_MeanValue.m`]. The function is called a total of 648 times, each of them giving as an output a stimulus. There are four blocks starting in lines 20, 61, 103 and 145 which repeat the same process but using different Lightness mean `L_Target` and deviation `Deviation`. Each specific lightness has three loops: hue , trial (for invi=1:3) and chromas (for i=1:3).

```matlab
for hue = 10:20:350
    for invi = 1:3
        for i = 1:3
```

For each loop, the function [`CreatePatt_MeanValue.m`] is called giving the following inputs and obtaining the next output:

```matlab
[TESTMoni,means,legendIm,meansSur] = CreatePatt_MeanValue...
    (meansvalues,L_Target,Deviation,HueRange,SL_Target,SDeviation,sHueRange);
```

We can see the meaning and examples of the inputs entered:

- Chroma values for the 8 patches

```matlab,
choi = randperm(length(MEANSTOCHOI));
meansvalues = MEANSTOCHOI(choi((i-1)*8+1:(i*8)));
```

- Lightness mean, deviation and hue values for patches

```matlab
L_Target = 50;
Deviation = 1;
HueRange = [hue-10 hue+10];
```

- Lightness mean, deviation and hue values for surround (background)

```matlab
SL_Target = 50;
SDeviation = 1;
sHueRange = [0 360];
```

After it is called, we obtain the following outputs:

- `TESTMoni`: image of the stimuli.
- `means`: information of the mean and deviation in CIELAB of each of the patch.
- `legendIm`: legend image with the location of each of the patches.
- `meansSur`:	CIELAB mean and deviation of the background.

Then the function stores all the information of each stimuli in the variable called info which is finally saved inside the folder [`STIMULISinfo/`](../Scripts/Prepare/STIMULISinfo) as a `.mat` file named as the number of the set. It also saves both PNG images (stimuli and legend) in the external folder `STIMULI/`.

Therefore, the main work is done by the function [`CreatePatt_MeanValue.m`] called inside the loop, which takes all the details of the stimulus characteristics and returns images and info. The function needs both **ICC profiles** (monitor and generic LAB) to be in the function folder. It also needs to load the `PointsLab.mat` file which has to be in the same folder (file can be created with [`MAKEPOINTS.m`]).

The process of the function is to, once knowing the color specifications, create first a random distribution pattern with chroma 0 by selecting random points out of all the possible points. Afterwards it starts a loop for the 8 patches with different chroma; for each patch, depending on the chroma, will create a pattern distribution. Then it will choose a random location in the stimuli, and if it hasn't been used yet, place the distribution by using a gaussian mask centered in the specific place.

More details of how the function works step by step can be found in the comments inside the code.

Other functions that are needed to be in the path when calling for creating the stimuli are:

- [`drawcircle.m`]: it creates a circle in a `npixels` square image located on the coordinates `centerX`, `centerY` with a radius `radius`.
- [`imgaussian.m`]: it filters a given image `I` by a gaussian with sigma `sigma` and kernel size `siz`.

[`MAKEPOINTS.m`]: ../Scripts/Prepare/MAKEPOINTS.m
[`PREPARESTIMULI.m`]: ../Scripts/Prepare/PREPARESTIMULI.m
[`CreatePatt_MeanValue.m`]: ../Scripts/Prepare/Other/CreatePatt_MeanValue.m
[`drawcircle.m`]: ../Scripts/Prepare/Other/drawcircle.m
[`imgaussian.m`]: ../Scripts/Prepare/Other/imgaussian.m
