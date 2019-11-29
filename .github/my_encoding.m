
function zigzag = my_encoding(img)
% Compress Image using portion of JPEG
% img    : GrayScale Image
% zigzag : result of zigzag scanning

[x, y] =size(img);
padding_x = 0;
padding_y = 0;

if mod(x,8) ~= 0
    padding_x = 8 - mod(x,8);
end
if mod(y,8) ~= 0
    padding_y = 8 - mode(x,8);
end
encode_img = zeros(x+padding_x, y+padding_y);

Quantization = [16 11 10 16 24 40 51 61;
                12 12 14 19 26 58 60 55;
                14 13 16 24 40 57 69 55;
                14 17 22 29 51 87 80 62;
                18 22 37 56 68 109 103 77;
                24 35 55 64 81 104 113 92;
                49 64 78 87 103 121 120 101;
                72 92 95 98 112 100 103 99];
                   
encode_img(1:x, 1:y) = img;
% Subtract 128
encode_img = double(encode_img)-128;

% Apply DCT
[x, y] = size(encode_img);
dct = zeros(x, y);
F = zeros(8,8);
for i = 1:x/8
    for j = 1:y/8
        f = encode_img( (i-1)*8+1 : (i-1)*8+8, (j-1)*8+1 : (j-1)*8+8 );
        
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
                
                sum = 0;
                for n = 0:7
                    for m = 0:7
                        sum = sum + f(n+1,m+1) * cos((2*n+1)*u*pi/16) * cos((2*m+1)*v*pi/16);
                    end
                end
                
                F(u+1,v+1) = c1*c2*sum;
            end
        end
        % Quantization F
        F = F./Quantization;
        
        
        for u = 1:8
            for v = 1:8
                
                %round F
                if F(u,v)-floor(F(u,v)) < 0.5
                    dct((i-1)*8 + u, (j-1)*8 + v) = (floor(F(u,v)));
                else 
                    dct((i-1)*8 + u, (j-1)*8 + v) = (ceil(F(u,v)));
                end
            end
        end
        
    end
end


% Zigzag scanning
zigzagList = cell(uint8(x/8),uint8(y/8));

for i = 1:x/8
    for j = 1:y/8
        block = dct((i-1)*8 + 1:(i-1)*8 + 8, (j-1)*8 + 1:(j-1)*8 + 8);
        scannedZigzag = zeros(1,64);
        
        row = 1; 
        col = 1; 
        for index = 1:64 
            if row == 1 && col ~= 8 && mod(row+col,2)==0
                %move right at the top
                scannedZigzag(index) = block(row, col);
                
                col = col + 1;
                
            elseif row == 8 && col ~= 8 && mod(row+col,2)~=0
                %move right at the bottom
                scannedZigzag(index) = block(row, col);
                col = col+1;
                
            elseif col == 1 && row ~= 8 && mod(row+col,2)~=0
                %move down at the left
                scannedZigzag(index) = block(row, col);
                row = row+1;
                
            elseif col == 8  && row ~= 8 && mod(row+col,2)==0
                %move down at the right
                scannedZigzag(index) = block(row, col);
                row = row+1;
                
            elseif col ~= 1 && row ~= 8 && mod(row+col,2)~=0
                %move diagonally left down
                scannedZigzag(index) = block(row, col);
                row = row+1;
                col = col-1;  
                
            elseif row ~= 1 && col ~= 8 && mod(row+col,2)==0
                %move diagonally right up
                scannedZigzag(index) = block(row,col);
                row = row-1;		
                col = col+1;
            end   
        end
        %split EOB
        index = 0;
        isEOB = false;
        for n = 64:-1:1
            if ~isEOB
                if scannedZigzag(n) ~= 0
                    index = n;
                    isEOB = true;
                end
            end
            
        end
        list = [];
        for n = 1:index
            list = [list,scannedZigzag(n)];
        end
        zigzagList{i,j} = list;
        
    end
end


zigzag = zigzagList;


end

