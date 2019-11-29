function img = my_decoding(zigzag)
% Compress Image using portion of JPEG
% zigzag : result of zigzag scanning
% img    : GrayScale Image 

Quantization = [16 11 10 16 24 40 51 61;
                12 12 14 19 26 58 60 55;
                14 13 16 24 40 57 69 55;
                14 17 22 29 51 87 80 62;
                18 22 37 56 68 109 103 77;
                24 35 55 64 81 104 113 92;
                49 64 78 87 103 121 120 101;
                72 92 95 98 112 100 103 99];

% get block's index and x and y by zigzag
%[dim,index,x,y] = size(zigzag);
[x,y] = size(zigzag);
%get image size 
x = x*8;
y = y*8;
img = zeros(x, y);
f = zeros(8,8);
% zigzagMat = zeros(1,64,x,y);
% zero padding from index+1 to 64

for i = 1:x/8
    for j = 1:y/8
        padindex = size(zigzag{i,j},2);
        list = zigzag{i,j};
        list(padindex+1:64) = 0;
        zigzag{i,j} = list;
    end
end

% decode zigzag to matrix
for i = 1:x/8
    for j = 1:y/8
        block = zeros(8,8);
        scannedZigzag = zigzag{i,j};

        row = 1; 
        col = 1;
        for index = 1:64
            if row==1 && col~=8 && mod(row+col,2)==0 
                %move right at the top
                block(row, col) = scannedZigzag(index);
                col = col + 1;
                
            elseif row==8 && col~=8 && mod(row+col,2)~=0
                %move right at the bottom
                block(row, col) = scannedZigzag(index);
                col = col+1;
                
            elseif col==1 && row~=8 && mod(row+col,2)~=0
                %move down at the left
                block(row, col) = scannedZigzag(index);
                row = row+1;
                
            elseif col==8 && row~=8 && mod(row+col,2)==0
                %move down at the right
                block(row, col) = scannedZigzag(index);
                row = row+1;
                
            elseif col~=1 && row~=8 && mod(row+col,2)~=0
                %move diagonally left down
                block(row, col) = scannedZigzag(index);
                row = row+1;
                col = col-1;   
                
            elseif row~=1 && col~=8 && mod(row+col,2)==0
                %move diagonally right up
                block(row,col) = scannedZigzag(index);
                row = row-1;		
                col = col+1;
                
            end
        end
        %dequantization
        block = block.*Quantization;
        
        for n = 1:8
            for m = 1:8
                img((i-1)*8 + n, (j-1)*8 + m) = block(n,m);
            end
        end       
    end
end


% Apply Inverse DCT
for i = 1:x/8
    for j = 1:y/8
        F = img((i-1)*8 + 1:(i-1)*8 + 8, (j-1)*8 + 1:(j-1)*8 + 8);
        
        for x1 = 0:7
            for y1 = 0:7
                sum = 0;
                for u = 0:7
                    for v = 0:7
                        if u == 0
                            c1 = sqrt(1/8);
                        else
                            c1 = sqrt(1/4);
                        end

                        if v == 0
                            c2 = sqrt(1/8);
                        else
                            c2 = sqrt(1/4);
                        end
                
                        sum = sum + c1*c2*F(u+1,v+1)*cos((2*x1+1)*u*pi/16)*cos((2*y1+1)* v * pi/16);
                    end
                end
                f(x1+1,y1+1) = sum;
            end
        end
        %around f
        for n = 1:8
            for m = 1:8
                if f(n,m)-floor(f(n,m)) < 0.5
                    f(n,m) = floor(f(n,m));
                else 
                    f(n,m) = ceil(f(n,m));
                end
            end
        end
        img((i-1)*8+1:(i-1)*8+8, (j-1)*8+1:(j-1)*8+8) = f;
    end
end


% Add 128
img = uint8(img + 128);

end

