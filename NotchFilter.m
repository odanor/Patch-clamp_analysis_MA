%% Function to filter patch-clamp recordings
%%% Author: Oda E. Riedesel
%%% Date: 2023
%
% Notch filter for filtering noise of electrophysiological recordings
%
% - Input: 
%   y : data to filter                     
%   f1 : HalfPowerFrequency1 -> lower half Frequency [Hz]
%   f2 : HalfPowerFrequency2 -> upper half Frequency [Hz] 
%   plotflag :
%%%             1 = plot is displayed
%
%
% - Output: 
%   Y : data filtered
%   t : time vector
%   Fs : sample rate
%
% - used custom-written functions:
%       NotchFilter.m
%
% *** Notes *** 
%%% example:
% [data_notchfiltered,t,Fs] = NotchFilter(data,49,51,0);
% [data_notchfiltered_8000Hz,t,Fs] = NotchFilter(data,7950,8050,0); 

function [Y,t,Fs]=NotchFilter(y,f1,f2,plotflag)

%%

%Fs = 100000; % sample rate
Fs = 20000;
t = (0:length(y)-1)/Fs; % time vector for plot
t = t*1000; % convert s into ms

% create filter
% filtered freqency: HalfPowerFrequency1 - HalfPowerFrequency2
d = designfilt('bandstopiir','FilterOrder',2, ...
    'HalfPowerFrequency1',f1,'HalfPowerFrequency2',f2, ... % 49, 51 als variablen festlegen --> input
    'DesignMethod','butter','SampleRate',Fs);

% apply filter
Y = filtfilt(d,y);

if plotflag==1 % plot
    figure;
    plot(t,y,t,Y)
    ylabel('Current [pA]'); xlabel('Time (s)')
    title('Response')
    legend('Unfiltered','Filtered')
    grid
    box off
end % end if loop

