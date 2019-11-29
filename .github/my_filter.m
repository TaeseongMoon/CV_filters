function filter_img = my_filter(img, filter_size, type)
%  img: Image.     dimension (X x Y)
%  fil_size: Filter maks(kernel)'s size.  type: (uint8)
%  type: Filter type. {'avr', 'laplacian', 'median', 'sobel', 'unsharp'}
pad_size = floor(filter_size/2);
pad_img = my_padding(img, pad_size, 'mirror');
[x, y] = size(img);
filter_img = zeros(x, y);

if strcmp(type, 'avr')
    for i = 1:x
        for j = 1:y
            % fil_size-1까지로 해야 filter size만큼의 mask가 잡힘
            filter_img(i,j) = mean(mean(pad_img(i:i+filter_size-1, j:j+filter_size-1)));
        end
    end
elseif strcmp(type, 'weight')
    %다른 필터의 마스크를 만들때에 참고
    
    mask = [1:pad_size+1 pad_size:-1:1]' * [1:pad_size+1 pad_size:-1:1];
    % 필터의 합이 1이 되게 하기위해 sum을 미리 구함
    s = sum(sum(mask));
    for i = 1:x
       for j = 1:y
           filter_img(i,j) = sum(sum(double(pad_img(i:i+filter_size-1,j:j+filter_size-1)).*mask))/s; 
       end
    end
elseif strcmp(type, 'laplacian') % Laplacian Filter
    % Fill here
    mask = ones(filter_size,filter_size);
    mask (ceil(filter_size/2),ceil(filter_size/2)) = -(filter_size.^2-1);
    for i = 1:x
       for j = 1:y
           filter_img(i,j) = sum(sum(double(pad_img(i:i+filter_size-1,j:j+filter_size-1)).*mask)); 
       end
    end
    
    
elseif strcmp(type, 'median') % Median Filter
    % Fill here
   
     for i = 1:x
       for j = 1:y
           filter_img(i,j) = median(reshape(pad_img(i:i+filter_size-1,j:j+filter_size-1),[filter_size^2,1])); 
       end
    end
    
    
elseif strcmp(type, 'sobel') % Sobel Filter
    
    % Fill it
    v_img = zeros(x, y);
    h_img = zeros(x, y);
    
    % Fill here
    v_mask = [1:pad_size+1 pad_size:-1:1]' * [-pad_size:pad_size];
    
    for i = 1:x
       for j = 1:y
         v_img(i,j) = sum(sum(double(pad_img(i:i+filter_size-1,j:j+filter_size-1)).*v_mask)); 
       end
    end
        
      h_mask = v_mask';
    for i = 1:x
       for j = 1:y
          h_img(i,j) = sum(sum(double(pad_img(i:i+filter_size-1,j:j+filter_size-1)).*h_mask)); 
       end
    end
    for i = 1:x
       for j = 1:y
           filter_img(i,j) = sqrt(h_img(i,j)^2+ v_img(i,j)^2);
       end
    end
   
    % Sobel에서 만들어지는 이미지 비교
    figure
    subplot(1, 1500, 1:490), imshow(uint8(v_img)), title('v mask image');
    subplot(1, 1500, 501:990), imshow(uint8(h_img)), title('h mask image');
    subplot(1, 1500, 1001:1490), imshow(uint8(filter_img)), title('sobel image');
elseif strcmp(type, 'unsharp')
    % k는 조정해도 괜찮음(0 <= k <= 1)
    k = 0.8;
    k2 = 0.5;
    % Fill it
    I = zeros(filter_size,filter_size);
    I(ceil(filter_size/2),ceil(filter_size/2)) = 1;
    
    L = ones(filter_size,filter_size);
    L = L/(filter_size^2);
    
    %F = I - k*L;
    F = I/(1-k)-(L*k/(1-k));
    F2 =I/(1-k2)-(L*k2/(1-k2));
    for i = 1:x
       for j = 1:y
          filter_img(i,j) = sum(sum(double(pad_img(i:i+filter_size-1,j:j+filter_size-1)).*F));
          f2_img(i,j) = sum(sum(double(pad_img(i:i+filter_size-1,j:j+filter_size-1)).*F2));
       end
    end
    
    
    figure
    subplot(1, 1500, 1:490), imshow(uint8(img)), title('true image');
    subplot(1, 1500, 501:990), imshow(uint8(f2_img)), title('0.5k image');
    subplot(1, 1500, 1001:1490), imshow(uint8(filter_img)), title('0.8k image');
end
filter_img = uint8(filter_img);
end