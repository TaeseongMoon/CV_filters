function dilation = my_dilation(img, filter)
% Apply dilation of binary image
% img      : binary image
% filter   : filter for dilation
% dilation : result of dilation 

% Apply dilation

[height, width] = size(img);
dilation = zeros(height,width);
filter_size = floor(filter/2);
for i = 1:height
    for j = 1:width
        if i-filter_size < 1 || i+filter_size > height || j-filter_size < 1 || j+filter_size > width
            continue
        
        elseif img(i,j) ~= 0
            dilation(i-filter_size:i+filter_size, j-filter_size:j+filter_size) = img(i,j);
        end 
    end
end

% dilation =uint8(dilation);
end