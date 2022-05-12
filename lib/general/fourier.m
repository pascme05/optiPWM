function [ P_harmonic,V1] = fourier(y)


%% Definitions of variables and signals   
L = length(y);                                                              % Length of signal
P_harmonic = zeros(L,1);                                                    % harmonic content (sum(n=2 -> n=end)

%% Fourier transform
Y = fft(y);
n = length(y);
P2 = abs(Y/n);
P1 = P2(1:n/2+1);
P1(2:end-1) = 2*P1(2:end-1);
[V1,I] = max(P1);

for i = I:length(P1)
    P_harmonic(i) = (P1(i)/(i-(I-1))^2);
end
P_harmonic = sum(P_harmonic)/P1(I);



