img = imread('coins.png');
img = rgb2gray(img);
img = img > 108;

r = my_connected(img);
figure, imshow(img);

figure, imshow(r);