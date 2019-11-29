function erosion = my_erosion(img, filter)
% Apply erosion of binary image
% img     : binary image
% filter  : filter for erosion
% erosion : result of erosion

% Apply erosion
[height, width] = size(img);
erosion = zeros(height,width);
filter_size = floor(filter/2);
for i = 1:height
    for j = 1:width
        if i-filter_size < 1 || i+filter_size > height || j-filter_size < 1 || j+filter_size > width
            continue
        
        elseif img(i-filter_size:i+filter_size, j-filter_size:j+filter_size) ~= 0
            erosion(i,j) = img(i,j);
        end 
    end
end

% erosion =uint8(erosion);

end