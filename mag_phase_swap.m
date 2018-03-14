im1 = imread('homework8img1.jpg');
im2 = imread('homework8img2.jpg');
im1 = im2double(rgb2gray(im1));
im2 = im2double(rgb2gray(im2));

% crop larger image to size of smaller image
im2 = im2(101:600, 101:600);

% show original image
figure(1)
imshow(im1)
figure(2)
imshow(im2)

% take fourier transform of each image
im1fft = fft2(im1);
im2fft = fft2(im2);

% find magnitude of each image
mag1 = abs(fftshift(im1fft));
mag2 = abs(fftshift(im2fft));

figure(3)
imshow(log(mag1), [])
figure(4)
imshow(log(mag2), [])

% find phase of each image
phase1 = angle(fftshift(im1fft));
phase2 = angle(fftshift(im2fft));

figure(5)
imshow(phase1, [])
figure(6)
imshow(phase2, [])

% swap magnitude and phase of each image
Hswap_12 = mag1.*exp(sqrt(-1)*phase2);
Hswap_21 = mag2.*exp(sqrt(-1)*phase1);
im12 = ifft2(ifftshift(Hswap_12));
im21 = ifft2(ifftshift(Hswap_21));

figure(7)
imshow(im12, [])
figure(8)
imshow(im21, [])