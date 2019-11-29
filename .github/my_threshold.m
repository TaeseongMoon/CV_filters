function [thres_img, level] = my_threshold(img, type)
    % Find Threshold 
    % img       : GrayScale Image     dimension (height x width)
    % type      : kinds of threshold  {'within', 'between'}
    % thres_img : threshold image     dimension (height x width)
    % level     : threshold value     type( uint8 )
    
    [x,y] = size(img);
    hist = zeros(256,1);

    %histogram
    for i= 1:x
        for j = 1:y
            hist(img(i,j)+1) = hist(img(i,j)+1)+1; %[0 255] -> [1 246]
        end
    end
    
    %hist/MxN = p(i)
    hist = hist/(x*y);

    %q(k) = sigma(0~k) p(i)
    q1 = zeros(256, 1);
    for k = 1:256
        q1(k) = sum(hist(1:k));
    end
    q2 = 1 - q1;

    m = zeros(256, 1);
    intensity = (0:1:255)';
    %m = sigma(0~k) i*p(i)
    for k = 1:256   
        m(k) = sum(intensity(1:k).*hist(1:k));
    end
    
    %분산값이지만 sigma2를 표현하기 어려워 이용하지 않았다.
    %variance = zeros(256,1);
    %for k = 1:256
    %    variance(k) = sum(((intensity(1:k)-m(k)).^2).*hist(1:k));
    %end
    m_G = m(256);


    if strcmp(type, 'within')
        
        sigma_W = sum((intensity(1:255).^2).*hist(1:255))-((m.^2).*q1)-((m_G-m).^2)./q2;
        %최소가 되게하는 intense값인 index값으로 역치값을 찾는다 index이므로 -1해주어야 제대로된 역치값
        [M,level] = min(sigma_W);
        thres_img = img>level-1;
        thres_img2 = double(img).*thres_img;
        imshowpair(thres_img,thres_img2,'montage');
    
    else
        sigma_B = ((m-m_G*q1).^2)./(q1.*q2);
        %최대가 되게하는 index k를 찾는다
        [M,level] = max(sigma_B);
        thres_img = img>level-1;
        thres_img2 = double(img).*thres_img;
        imshowpair(thres_img,thres_img2,'montage');
    
    end


end
