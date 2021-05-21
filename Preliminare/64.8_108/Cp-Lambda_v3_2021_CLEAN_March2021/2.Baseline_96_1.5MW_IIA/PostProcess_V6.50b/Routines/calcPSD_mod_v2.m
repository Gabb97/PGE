function [Signal]=calcPSD_mod_v2(vector, fs, N, wsize)
% 
% function [Pxx,f]=calcPSD(vector, fs, N)
% 
% CALCULATES PSD, WELCH'S METHOD, FROM A WORKSPACE VECTOR
% --------------------------------------------------------------------- 
% INVOLVED PARAMETERS
% 
% INPUTS:
% vector:   Input vector from workspace
% fs:       Sampling frequency
% N:        Numerical resolution (better if power of 2). This parameter 
%           improves PSD smoothing it 
%           - For fs=100Hz, N minimum suggested 2^12=4096
%           - For fs=20Hz, N minimum suggested 2^10=1024
% wsize:    window size
% 
% OUTPUTS:
% Signal.PSD:      Output PSD
% Signal.FRQ:      Frequency for the desired fs
% 
% --------------------------------------------------------------------- 
% IMPORTANT NOTES:
% 
% Window's size is set to 120s, within this window size, frequency
% resolution is 1/120=0.0083Hz (aprox). Other window sizes can be also
% suitable depending on the desired frequency resolution, i.e.
% 1/60=0.0167Hz has been proved successfully. To modify window's size
% simply edit calcPSD.
% 
% It is important to remark that N parameter doesn't improves frequency
% resolution, the only thing is that by increasing it more points are used
% in the PSD, so less interpolation is needed.
% 
% MODIFICATIONS
% 
% Modified mgr (1/2/2007). Added checking for window size smaller than 2
% min
% Modified fg (7/1/2011). Added wsize among inputs and changed the output
% as struct Signal.(var)
% --------------------------------------------------------------------- 

% wsize=60*fs; % window size (1 min) !!!!!

% Check for Window size smaller than 2 min
SeriesSize = length(vector);
if (SeriesSize >= wsize)
    wsize = round(wsize);
else 
    wsize = floor(SeriesSize);
end

% Welch: [Pxx,F] = PWELCH(X,WINDOW,NOVERLAP,NFFT,Fs)
[Signal.PSD, Signal.FRQ]=pwelch(detrend(vector),hann(wsize),[],N,fs);


return;