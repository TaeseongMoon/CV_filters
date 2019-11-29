function pad_img = my_padding(img, pad, type)
% img: Image.     dimension (X x Y)
% pad: Pad Size.  type: (uint8)
% type: Padding type. {'mirror', 'repetition', 'zero'}
[x, y] = size(img);
pad_img = zeros(x+2*pad, y+2*pad);
pad_img(1+pad:x+pad, 1+pad:y+pad) = img;

if strcmp(type, 'mirror') % mirror padding
    
    pad_img(1:pad,1:pad) = img(x:-1:x-pad+1,y:-1:y-pad+1); %왼위모서리
    pad_img(1:pad,y+pad+1:y+2*pad) = img(x:-1:x-pad+1,y:-1:y-pad+1);   %오위모서리
    pad_img(x+pad+1:x+2*pad, 1:pad) = img(x:-1:x-pad+1,y:-1:y-pad+1);  %왼아모서리
    pad_img(x+pad+1:x+2*pad, y+pad+1:y+2*pad) = img(x:-1:x-pad+1,y:-1:y-pad+1);%오아모서리
    
    pad_img(pad+1:x+pad,1:pad) = img(1:x,y:-1:y-pad+1);       %왼
    pad_img(pad+1:x+pad,y+pad+1:y+2*pad) = img(1:x,y:-1:y-pad+1); %오
    pad_img(1:pad,pad+1:y+pad) = img(x:-1:x-pad+1,1:y);               %위
    pad_img(x+pad+1:x+2*pad,pad+1:y+pad) = img(x:-1:x-pad+1,1:y);      %아래
   
    
    % Fill it 
elseif strcmp(type, 'repetition') % repetition padding
    pad_img(1:pad,1:pad) = repmat(img(1,1),pad,pad);
    pad_img(1:pad,y+pad+1:y+2*pad) = repmat(img(1, y),pad,pad);
    pad_img(x+pad+1:x+2*pad, 1:pad) = repmat(img(x, 1),pad,pad);
    pad_img(x+pad+1:x+2*pad, y+pad+1:y+2*pad) = repmat(img(x, y),pad,pad);
    
    pad_img(pad+1:x+pad,1:pad) = repmat(img(1:x,1),1,pad);
    pad_img(pad+1:x+pad,y+pad+1:y+2*pad) = repmat(img(1:x,y),1,pad);
    pad_img(1:pad,pad+1:y+pad) = repmat(img(1,1:y),pad,1);
    pad_img(x+pad+1:x+2*pad,pad+1:y+pad) = repmat(img(x,1:y),pad,1);

    % Fill it 
else % zero padding
    % Free Solve Zero padding
    
end
pad_img = uint8(pad_img);
end