function [SignalFFT]=ComputeSignalFFT(Signal,Par)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% INPUT
% SIGNAL
% Signal.time       signal time values
% Signal.history    signal time history

% FFT Parameters
% Par.MAXSTEP   max number of values used in FFT
% Par.NNN       delta N	
% Par.firstN    first Signal value

%%% OUTPUT
% SignalFFT.FFT
% SignalFFT.ABS semi-aplitude!!!
% SignalFFT.FRQ frequency

% 15.June.2010 A.C.
% 24.June.2010 A.C.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


MAXSTEPreal = min([Par.MAXSTEP length(Signal.time)]);
NVector = [Par.firstN:Par.NNN:MAXSTEPreal];
NFFT = length(Signal.time(NVector));
NFFT2 = ceil(NFFT/2);

DeltaT = mean(diff(Signal.time));

SignalFFT.FFT = fft(Signal.history(NVector),NFFT)/NFFT;
SignalFFT.ABS = abs(SignalFFT.FFT)*2;                             %%% amplitude (=half*range)
SignalFFT.FRQ = [0:NFFT-1]'/(DeltaT*NFFT);
SignalFFT.NFFT2 = NFFT2;

% FIGURES Parameters
% Fig.Number    fig number
% Fig.Symb      line style
% Fig.yLabel    y label 
% Fig.LineWidth LineWidth
% Fig.LegendStr fig legend
% Fig.TitleStr  fig title

% figure(Fig.Number)
% hp=semilogy(SignalFFT.FRQ(1:NFFT2),SignalFFT.ABS(1:NFFT2),Fig.Symb);
% set (hp,'LineWidth',Fig.LineWidth);
% hx=xlabel('Frequency [Hz]'); hy=ylabel(Fig.yLabel);
% set (hx,'FontSize',12,'FontWeight','bold');
% set (hy,'FontSize',12,'FontWeight','bold');
% legend(Fig.LegendStr)
% ht = title(Fig.TitleStr);
% set (ht,'FontSize',10,'FontWeight','bold');
% grid on, hold on
