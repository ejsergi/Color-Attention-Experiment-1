clear all
close all

Moni = iccread('ColorNavSergiExp.icc');
ProfLab = iccread('Generic Lab Profile.icc');

Lab2Moni = makecform('icc', ProfLab, Moni,'SourceRenderingIntent', 'AbsoluteColorimetric', 'DestRenderingIntent', 'AbsoluteColorimetric');
Moni2Lab = makecform('icc', Moni, ProfLab,'SourceRenderingIntent', 'AbsoluteColorimetric', 'DestRenderingIntent', 'AbsoluteColorimetric');

TEST = cat(3,ones(500)*50,ones(500)*60,ones(500)*0);

TESTmoni = applycform(TEST,Lab2Moni);

TESTtest = applycform(TESTmoni,Moni2Lab);

imshow(TESTmoni);

%%
xyz2lab = makecform('xyz2lab', 'WhitePoint', [68.68 73.35 81.90]);
applycform([21.25 12.79 14.69],xyz2lab)