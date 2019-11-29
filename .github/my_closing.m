function closing = my_closing(img, filter)
% Calculate closing of binary image
% img     : binary image
% filter  : filter for closing
% closing : result of closing

% Apply closing
dil = my_dilation(img,filter);
closing = my_erosion(dil,filter);

end