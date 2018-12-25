function drawFourierSpecter(x,N,Fs)
X = fftshift(fft(x));

dF = Fs/N;                      % hertz
f = -Fs/2:dF:Fs/2-dF;           % hertz

figure;
plot(f,abs(X)/N);
xlabel('Frequency (in hertz)');
title('Magnitude Response');