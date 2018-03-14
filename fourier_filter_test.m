im = imread('homework8img2.jpg');

im = im2double(rgb2gray(im));
figure(1) % show original image
imshow(im), colorbar

imff = fft2(im);
figure(2) % show fourier transform of original image
imshow(fftshift(imff)), colorbar

ind = -floor(662/2) : floor(662/2);
[X Y] = meshgrid(ind, ind);
sigma = 50
h = exp(-(X.^2 + Y.^2) / (2*sigma*sigma));
figure(3) % show smoothing gaussian filter in fourier domain
imshow(h), colorbar 

imffsmooth = bsxfun(@times, fftshift(imff), h(1:662, 1:662));
figure(4) % show fourier transform with filter applied
imshow(imffsmooth), colorbar

imsmooth = ifft2(ifftshift(imffsmooth));
imsmooth = imsmooth ./ max(max(imsmooth));
figure(5) % show smoothed image in space domain
imshow(imsmooth), colorbar

sigma = 50;
h = exp(-(X.^2 + Y.^2) / (2*sigma*sigma));
h_sharp = imcomplement(h);
figure(6)
imshow(h_sharp), colorbar % show sharpening filter in frequency domain

imffsharp = bsxfun(@times, fftshift(imff), h_sharp(1:662, 1:662));
figure(7) % show sharpened fourier transform
imshow(imffsharp), colorbar

imsharp = ifft2(ifftshift(imffsharp));
imsharp = imsharp ./ max(max(imsharp));
figure(8) % show sharpened image in space domain
imshow(imsharp), colorbar

mask = zeros(size(im));
mask(320:342, 320:342) = 1;
figure(9) % show mask in fourier domain
imshow(mask), colorbar

imffmask = bsxfun(@times, fftshift(imff), mask);
figure(10) %show fourier transform with mask applied
imshow(imffmask), colorbar

immask = ifft2(ifftshift(imffmask));
immask = immask ./ max(max(immask));
figure(11) % show sharpened image in space domain
imshow(immask), colorbar
