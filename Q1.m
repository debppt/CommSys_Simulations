%Time Domain Analysis
fm = 1000;           
t = 0:1e-5:1e-2;     
message_signal = sin(2*pi*fm*t); 

fs_oversample = 5 * fm;   
fs_nyquist = 2.1 * fm;     
fs_undersample = 0.8 * fm; 

t_oversample = 0:1/fs_oversample:1e-2;
t_nyquist = 0:1/fs_nyquist:1e-2;
t_undersample = 0:1/fs_undersample:1e-2;

sampled_oversample = sin(2*pi*fm*t_oversample);
sampled_nyquist = sin(2*pi*fm*t_nyquist);
sampled_undersample = sin(2*pi*fm*t_undersample);

%Sinc interpolation
function y = sinc_interp(x, fs, t)
    T = 1 / fs;                             %Sampling period
    n = 0:length(x)-1;                      %Sample indices
    s = n * T;                              %Sample times based on sampling frequency
    sinc_matrix = sinc((t(:) - s(:)') / T); % Sinc matrix for interpolation
    y = sinc_matrix * x(:);                 % Interpolated signal
end

reconstructed_oversample = sinc_interp(sampled_oversample, fs_oversample, t);
reconstructed_nyquist = sinc_interp(sampled_nyquist, fs_nyquist, t);
reconstructed_undersample = sinc_interp(sampled_undersample, fs_undersample, t);

%Plots
figure;
subplot(3, 2, 1);
plot(t, message_signal, 'k', t_oversample, sampled_oversample, 'bo');
title('Oversampled Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3, 2, 2);
plot(t, reconstructed_oversample, 'r');
title('Reconstructed Signal (Oversampling)');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3, 2, 3);
plot(t, message_signal, 'k', t_nyquist, sampled_nyquist, 'bo');
title('Nyquist Rate Sampled Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3, 2, 4);
plot(t, reconstructed_nyquist, 'r');
title('Reconstructed Signal (Nyquist Sampling Rate)');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3, 2, 5);
plot(t, message_signal, 'k', t_undersample, sampled_undersample, 'bo');
title('Undersampled Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3, 2, 6);
plot(t, reconstructed_undersample, 'r');
title('Reconstructed Signal (Undersampling)');
xlabel('Time (s)');
ylabel('Amplitude');


% Frequency Domain Analysis
nfft = 2048; 

oversampled_fft = abs(fftshift(fft(sampled_oversample, nfft)));
f_oversample = (-nfft/2:nfft/2-1) * (fs_oversample / nfft);

undersampled_fft = abs(fftshift(fft(sampled_undersample, nfft)));
f_undersample = (-nfft/2:nfft/2-1) * (fs_undersample / nfft);

%Plots
figure;

subplot(2, 1, 1);
plot(f_oversample, oversampled_fft);
title('Frequency Domain (Oversampling)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(2, 1, 2);
plot(f_undersample, undersampled_fft);
title('Frequency Domain (Undersampling)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

