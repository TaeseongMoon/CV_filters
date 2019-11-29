function img = my_connected(img)
% Find connected level using DFS for 4-direction
% img       : binary image

% Set Limit of recursion 3000
set(0, 'RecursionLimit', 3000);

% Set 1 to -1
img = ~img -1;
label = 1;
% recursive find 1 value
[height, width] = size(img);
for i = 1:height
    for j = 1:width
        if img(i,j) == -1
            img = my_recursive_label(img,j,i,height,width,label);
            label = label+1;
        end
    end
end
s = 255/ label;
img = uint8(img*s);

end

function img = my_recursive_label(img, y, x, height, width, c)
% Recursively Find 1
% img    : binary image
% y      : y index
% x      : x index
% height : height of image
% width  : width of image
% c      : value for labeling 

% Recursively find -1 and ignore 0
% Recursion in matlab should receive result of 'call by value'
img(x,y) = c;

    if y+1<=width && img(x,y+1)==-1
        img = my_recursive_label(img,y+1,x,height,width,c);
    end
    if x+1<=height && img(x+1,y)==-1
        img = my_recursive_label(img,y,x+1,height,width,c);
    end
    if y-1 ~=0 && img(x,y-1)==-1
        img = my_recursive_label(img,y-1,x,height,width,c);
    end
    if x-1 ~= 0 && img(x-1,y)==-1
        img = my_recursive_label(img,y,x-1,height,width,c);
    
    end

end