function edge_image = my_canny_edge(img, low_th, high_th, filter_size)
% Find edge of Image using canny edge detection
% img         : Grayscale image    dimension ( height x width )
% low_th      : low threshold      type ( uint8 )
% high_th     : high threshold     type ( uint8 )
% filter_size : size of filter     type ( int64 )
% edge_image  : edge of input img  dimension ( height x width )

[x, y] = size(img);
pad_size = floor(filter_size/2);
pad_img = zeros(x+2*pad_size, y+2*pad_size);
pad_img(1+pad_size:x+pad_size, 1+pad_size:y+pad_size) = img;
filter_img = zeros(x, y);

% Gaussian Filter의 적용 
sigma = 8;
[X, Y] = meshgrid(-pad_size:pad_size, -pad_size:pad_size);

mask = exp(-(X.^2+Y.^2)/(2*(sigma^2)));
mask = mask / (2*pi*(sigma^2));
mask = mask / sum(sum(mask));

for i = 1:x
    for j =1:y
        filter_img(i,j) = sum(sum(double(pad_img(i:i+filter_size-1, j:j+filter_size-1)).*mask));
    end
end

% Sobel filter 적용 

v_img = zeros(x, y);
h_img = zeros(x, y);
pad_img(1+pad_size:x+pad_size, 1+pad_size:y+pad_size) = filter_img;

v_mask = [1:pad_size+1 pad_size:-1:1]' * [-pad_size:pad_size];
h_mask = [-pad_size:pad_size]' * [1:pad_size+1 pad_size:-1:1];

for i = 1:x
    for j = 1:y
        v_img(i, j) = sum(sum(double(pad_img(i:i+filter_size-1, j:j+filter_size-1)).*v_mask));
        h_img(i, j) = sum(sum(double(pad_img(i:i+filter_size-1, j:j+filter_size-1)).*h_mask));
    end
end

% 필터 계산값으로  Magnitude, Angle 구하기
Magitude = sqrt(v_img.^2 + h_img.^2);
theta = atan(h_img./v_img);
supression_img = zeros(x, y);
%음수의 Angler값을 pi를 더해줘 양수로 만들어줌 
 for i = 1:x
     for j = 1:y
         if theta(i,j) < 0
             theta(i,j) = theta(i,j) + pi;
         end
     end
 end

% Non-Maximum 값들 제거 (linear 방식)
%주위 8개의 인덱스에 각 방향에 따른 p와 r값을 linear interpolation을 이용해 maximum값 검출

for i = 2:x-1
    for j = 2:y-1
        %agnle = 0
        if 0 <= theta(i, j) && theta(i,j) <= pi/4
            t = tan(theta(i, j));
            s = 1 - t;
            p = Magitude(i+1, j+1) * t + Magitude(i, j+1) * s;
            r = Magitude(i-1, j-1) * t + Magitude(i, j-1) * s;
        % angle = 45     
        elseif pi/4 < theta(i, j) && theta(i, j) <= pi/2
            t = 1 / tan(theta(i, j));
            s = 1 - t;
            p = Magitude(i+1, j+1) * t + Magitude(i+1, j) * s;
            r = Magitude(i-1, j-1) * t + Magitude(i-1, j) * s;
        % angle = 90
        elseif pi/2 < theta(i, j)&& theta(i, j) <= 3*pi/2
            t = -(1 / tan(theta(i, j)));
            s = 1 - t;
            p = Magitude(i+1, j-1) * t + Magitude(i+1, j) * s;
            r = Magitude(i-1, j+1) * t + Magitude(i-1, j) * s;
        % angle = 135
        elseif 3*pi/2 < theta(i, j) && theta(i, j) <= 2*pi
            t = -tan(theta(i, j));
            s = 1 - t;
            p = Magitude(i+1, j-1) * t + Magitude(i, j-1) * s;
            r = Magitude(i-1, j+1) * t + Magitude(i, j+1) * s;
        end
        
        %특징값을 가져옴. 나머지는 0처리가 됨
        if (Magitude(i, j) >= p) && (Magitude(i,j) >= r)
            supression_img(i, j) = Magitude(i, j);
        end
    end
end

% Double Threshold 계산
highThreshold = high_th*255;
lowThreshold = low_th*255;
week_pixel = 75;
strong_pixel = 255;
edge_image = zeros(x, y);

for i = 1:x
    for j = 1:y
        if supression_img(i, j) > highThreshold
            edge_image(i, j) = strong_pixel;
        
        elseif supression_img(i,j) < lowThreshold
        
        else
            edge_image(i, j) = week_pixel;
        end
    end
end
%Hysistersis 로 week_edge를 이어줌
for i = 2:x-1
    for j = 2:y-1
        if edge_image(i, j) == week_pixel
            if (edge_image(i+1,j-1) == strong_pixel) || (edge_image(i+1,j) == strong_pixel) ||(edge_image(i+1,j+1) == strong_pixel) ||(edge_image(i,j-1) == strong_pixel) || (edge_image(i,j+1) == strong_pixel) ||(edge_image(i-1,j-1) == strong_pixel) || (edge_image(i-1,j) == strong_pixel) || (edge_image(i-1,j+1) == strong_pixel)
                edge_image(i,j) = strong_pixel;
            else
                edge_image(i,j) = 0;
            end
            
        end
    end
end
edge_image = uint8(edge_image);
imshow(edge_image);
end