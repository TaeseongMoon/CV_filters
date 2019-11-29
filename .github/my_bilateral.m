function filter_img = my_bilateral(img, filter_size, sigma, sigma2)
% Apply bilateral filter
% img        : GrayScale Image
% filter_img : bilateral filtered image 
[x, y] = size(img);
[X, Y] = meshgrid(-filter_size:filter_size,-filter_size:filter_size);

mask = exp(-(X.^2+Y.^2)/(2*sigma^2));
filter_img = zeros(x,y);

for i = 1:x
    for j = 1:y
        %adjacent indeces
        iMin = max(i-filter_size,1);
        iMax = min(i+filter_size,x);
        jMin = max(j-filter_size,1);
        jMax = min(j+filter_size,y);
        %adjacent index image
        I = double(img(iMin:iMax, jMin: jMax));
        
        %weight filter
        mask2 = exp(-(I-double(img(i,j))).^2/(2*sigma2^2));
        
        %apply filter with weighted intensity
        F = mask2.*mask((iMin:iMax)-i+filter_size+1,(jMin:jMax)-j+filter_size+1);
        filter_img(i,j) = sum(F(:).*I(:))/sum(F(:));
    end
end

filter_img = uint8(filter_img);

% figure
% subplot(1, 1000, 1:490), imshow(img), title('original image');
% subplot(1, 1000, 501:990), imshow(filter_img), title('bilateral filter image');

end

