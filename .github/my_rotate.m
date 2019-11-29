function re_img = my_rotate(img, rad, interpolation)

c = cos(rad);
s = sin(rad);
[x,y] = size(img);
f = [c s; -s c]; %rotate 행렬
%회전한 이미지를 넣은 row와 col값을 계산해준다 
row = int64(x*abs(c)+y*abs(s));
col = int64(y*abs(c)+x*abs(s));
re_img = zeros(row,col);

if strcmp(interpolation, 'nearest')
    
    for i = 1:row
        for j = 1:col        
            %radian값에 따라 v값을 다르게 부여하여 회전축을 이동시켜주었다.
            if rad <= pi/2 
                v = f * double([i-y*s;j]);     
            elseif pi/2 < rad && rad <= pi 
                v = f * double([i-y*s+x*c;j+y*c]);
            elseif pi < rad && rad <= 3*pi/2
                v = f * double([i+x*c;j+y*c+x*s]);
            elseif 3*pi/2 < rad
                v = f * double([i;j+x*s]);
            end
            %인덱스의 밖으로 나가지 않도록 조정해준다
            if v(1) < 1 || v(1) > x || v(2) < 1 || v(2) > y
                continue;
            end
            %nearest 방식으로 근사 정수값을 대입해준다
            re_img(i,j) = img(int64(v(1)),int64(v(2)));
        end
    end
    
elseif strcmp(interpolation, 'bilinear')
   
    for i = 1:row
        for j = 1:col
            %radian값에 따라 서로다른 v값을 부여해준다
            if rad <= pi/2 
                v = f * double([i-y*s;j]);
            elseif pi/2 < rad && rad <= pi 
                v = f * double([i-y*s+x*c;j+y*c]);
            elseif pi < rad && rad <= 3*pi/2
                v = f * double([i+x*c;j+y*c+x*s]);
            elseif 3*pi/2 < rad <= 2*pi
                v = f * double([i;j+x*s]);
            end
            %index가 밖으로 튀지않도록 걸러내준다
            if v(1) < 1 || v(1) >= x || v(2) < 1 || v(2) >= y
                continue;
            end 
            %가장 가까운 왼쪽위의 index를 찾는다
            fm = floor(v(1));
            fn = floor(v(2));
            %인덱스에게 가중치를 부여하여 bilinear를 계산하는 공식에 대입해준다
            m = v(1) - fm;
            n = v(2) - fn;
            
            P1 = (1-m) * (1-n) * img(fm, fn);
            P2 = (1-n) * m * img(fm+1, fn);
            P3 = n * (1-m) * img(fm, fn+1);
            P4 = m * n * img(fm+1, fn+1);
            re_img(i, j) = P1 + P2 + P3 + P4;
                
        end
    end
end

re_img = uint8(re_img);
end