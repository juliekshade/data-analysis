B = 1
a = .5
t = linspace(0, 10);
f = linspace(-10, 10);

% calculate components of fourier transform
h_t = B * exp(-a.*t)
re_Hf = a*B./(a^2 + (2*pi.*f).^2)
im_Hf = (-2*pi*B.*f)./(a^2 + (2*pi.*f).^2)
amplitude = sqrt(re_Hf.^2 + im_Hf.^2)
phase = atan(im_Hf./re_Hf)

for a = 1:2
    h_t = [h_t; B * exp(-a.*t)]
    re_Hf = [re_Hf; a*B./(a^2 + (2*pi.*f).^2)]
    im_Hf = [im_Hf; (-2*pi*B.*f)./(a^2 + (2*pi.*f).^2)]
    amplitude = [amplitude; sqrt(re_Hf((a+1), :).^2 + im_Hf((a+1), :).^2)]
    phase = [phase; atan(im_Hf((a+1), :)./re_Hf((a+1), :))]
end

figure(1)
hold on
plot(t, h_t(1, :))
plot(t, h_t(2, :))
plot(t, h_t(3, :))
title('h(t)')
xlabel('time')
ylabel('h(t)')
legend('a = 0.5', 'a = 1', 'a = 2')

figure(2)
hold on
plot(f, re_Hf(1, :))
plot(f, re_Hf(2, :))
plot(f, re_Hf(3, :))
title('Real part of Fourier transform of h(t)')
xlabel('Frequency (Hz)')
ylabel('Re(H(f))')
legend('a = 0.5', 'a = 1', 'a = 2')

a = .5
x = linspace(-10, 10);
f = linspace(-10, 10);

% calculate components of fourier transform
h_t = exp(-(x.^2 ./ a^2));
Hf = sqrt(a^2 * pi) * exp(-(pi^2 * a^2 .* f.^2));

for a = 1:2
    h_t = [h_t; exp(-(x.^2 ./ a^2))];
    Hf = [Hf; sqrt(a^2 * pi) * exp(-(pi^2 * a^2 .* f.^2))];
end

figure(3)
hold on
plot(t, h_t(1, :))
plot(t, h_t(2, :))
plot(t, h_t(3, :))
title('h(x)')
xlabel('x')
ylabel('h(x)')
legend('a = 0.5', 'a = 1', 'a = 2')

figure(4)
hold on
plot(f, Hf(1, :))
plot(f, Hf(2, :))
plot(f, Hf(3, :))
title('Fourier transform of h(t)')
xlabel('Frequency (Hz)')
ylabel('H(f)')
legend('a = 0.5', 'a = 1', 'a = 2')

figure(5)
hold on
plot(f, im_Hf(1, :))
plot(f, im_Hf(2, :))
plot(f, im_Hf(3, :))
title('Imaginary part of Fourier transform of h(t)')
xlabel('Frequency (Hz)')
ylabel('Im(H(f))')
legend('a = 0.5', 'a = 1', 'a = 2')

figure(4)
hold on
plot(f, amplitude(1, :))
plot(f, amplitude(2, :))
plot(f, amplitude(3, :))
title('Amplitude of Fourier transform of h(t)')
xlabel('Frequency (Hz)')
ylabel('Amplitude(H(f))')
legend('a = 0.5', 'a = 1', 'a = 2')


figure(5)
hold on
plot(f, phase(1, :))
plot(f, phase(2, :))
plot(f, phase(3, :))
title('Phase of Fourier transform of h(t)')
xlabel('Frequency (Hz)')
ylabel('Phase(H(f))')
legend('a = 0.5', 'a = 1', 'a = 2')

