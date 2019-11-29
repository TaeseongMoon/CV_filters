function filter_img = my_gaussian(img, filter_size, sigma)
%  img: Image.     dimension (X x Y)
%  fil_size: Filter maks(kernel)'s size.  type: (uint8)
%  sigma: Sigma value of gaussian filter.  type: (double)
pad_size = floor(filter_size/2);
pad_img = my_padding(img, pad_size, 'mirror');
[x, y] = size(img);
filter_img = zeros(x, y);

% Fill Here
    
    mask = zeros(filter_size,filter_size); %mask의 크기는 필터의 크기만큼
    m = ceil(filter_size/2);    %중간 인덱스값
   
    for i = 1:filter_size
        for j = 1:filter_size
            mask(i,j) =  exp(-((i - m)^2 +(j - m)^2)/ (2 * sigma^2))/(2*pi*sigma^2); %2차원 가우시안 공식
        end
    end
   
    
    for i = 1:x
       for j = 1:y
         filter_img(i,j) = sum(sum(double(pad_img(i:i+filter_size-1,j:j+filter_size-1)).*mask));%마스크 컨볼루션
       end
    end

filter_img = uint8(filter_img);
figure, surf(mask); title('filter image');
figure, imshow(filter_img); title('image');
end