function circlePixels = drawcircle(npixels,centerX,centerY,radius)


[columnsInImage, rowsInImage] = meshgrid(1:npixels, 1:npixels);

circlePixels = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 <= radius.^2;

circlePixels = cat(3,circlePixels,circlePixels,circlePixels);
end