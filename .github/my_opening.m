function opening = my_opening(img, filter)
% Apply opening of binary image
% img     : binary image
% filter  : filter for opening
% opening : result of opening

% Apply opening

ero = my_erosion(img,filter);
opening = my_dilation(ero,filter);


end