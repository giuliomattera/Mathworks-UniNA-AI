%% Import image 

img = imread('plate.jpg');
img = imresize(img, 0.6);
img_gray = rgb2gray(img);

%% Find a threshold for binarization
level = graythresh(img); 

img_gray = imgaussfilt(img_gray, 2);

histogram(img_gray)

thr = 160/255;

img_bw = imbinarize(img_gray,thr);

%% Find cicles and measure diameters

[centers, radii, metric] = imfindcircles(img_gray,[10 2000]);

imshow(img)


viscircles(centers, radii,'EdgeColor','b');

s = size(centers);


for hole=1:s(1)
    h = drawcircle('Center',centers(hole, :),'Radius',2,'StripeColor','red');
end

