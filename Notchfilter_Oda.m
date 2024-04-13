%% Function to filter patch-clamp recordings
%%% Author: Oda E. Riedesel
%%% Date: 2023
%
% Function using the notch filter to filter the noise of the patch clamp
% data first at 4 kHz followed by 8 kHz 
%
% - Input: 
%   recordings_filtered : recording that should be analyzed which was
%                           already sufficiently filtered
%   data : Matrix of recording 
%   plotflag :
%%%             1 = all traces will be plotted in one figure, one 
%%%                 filtered, one unfiltered
%%%             2 = all trafces will be plotted with the filter in
%%%                 seperate figures
%
% - Output: 
%   smoothing_8000Hz : data smoothed first at 4 and the 8 kHz
%   Fs : sample rate
%
% - used custom-written functions:
%       NotchFilter.m
%
% *** Notes *** 
%%% example :
% [data_notchfiltered,t,Fs] = NotchFilter(data,49,51,0);

%%

function [smoothing_8000Hz,Fs] = Notchfilter_Oda(data,plotflag)


    
%% 4 kHz filter first
    % 4000 Hz reicht 
    % [Y,t,Fs] = NotchFilter(y,f1,f2,plotflag)
   [data_notchfiltered_4000Hz] = NotchFilter(data,3950,4050,0); % Notch Filter from 3950 and 4050 Hz
    smoothing_4000Hz = movmean(data_notchfiltered_4000Hz,15); % take 

%% 8 kHz filter after

    [data_notchfiltered_8000Hz,t,Fs] = NotchFilter(smoothing_4000Hz,7950,8050,0); % Notch Filter from 7950 Hz to 8050 Hz
    smoothing_8000Hz = movmean(data_notchfiltered_8000Hz,15);
    warning off


%%% plotting of filtered data 
if plotflag == 1

    figure('Name','Filtered');
    hold on
    for f = 1:size(data,3)
        plot(t,smoothing_8000Hz(:,1,f)) %filtered data
        hold on
    end
    ylabel('Current [pA]'); xlabel('Time [ms]')
    % ylim([-500 900])
    title('Filtered Response')
    grid
    box off


%%% Plot of a single sweep filtered and unfiltered
elseif plotflag == 2

    figure('Name','single trial unfiltered vs filtered');
    plot(t,data(:,1,10))
    hold on
    plot(t,smoothing_8000Hz(:,1,10),'Color','r')
    ylabel('Current [pA]'); xlabel('Time [ms]')
    title('Response')
    legend('Unfiltered','Filtered')
    grid
    box off
end % end if loop 

warning off
end % end function

