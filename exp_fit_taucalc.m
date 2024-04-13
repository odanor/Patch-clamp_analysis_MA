%% Function to fit with a double exponential function
%%% Author: Oda E. Riedesel
%%% Date: January 2024
%
% Funtion is fitting the delayed rectifier potassium currents with a double
% exponential function. 
%
% - Input: 
%  t :  time vector
%  stop_time : time point when the stimulus ended
%
%  recordings_filtered : recording that should be fitted
%  smooth_for_fit : 
%%%             0 = no smoothing
%%%             1 = with before fit smoothing
%  plotflag :
%%%             0 = no plot
%%%             1 = plot fit over recording
%
%
% - Output : 
%   fitresult : fit in cfit format
%   gof2 : goodness-of-fit
%   tau_1 : (slow) tau value of the exponential fit
%   tau_2 : (fast) tau value of the exponential fit
%   tsubset : time vector of the recording extract that should be fitted
%               exponentially
%
% *** Notes *** 
%%% If something seems off run curveFitter and check manually
%%% Note that the fits of the I-V curves are located in an extra function


function [fitresult,gof2,tau_1,tau_2,tsubset,smoothie] = exp_fit_taucalc(t,stop_time,recordings_filtered,smooth_for_fit,plotflag)

%% find time frame 

        % calculate baseline and standard deviation for a threshold
        % 2 ms -> 22 ms    (2 to 22 ms) time frame I want to use for the baseline
        baseline = mean(recordings_filtered(find(t == 2):find(t == 22)));
        standard_on_top = std(recordings_filtered(find(t == 2):find(t == 22)));

        threshold = baseline + standard_on_top*2; % create threshold
        
        %cross = diff(recordings_filtered > threshold); % find crosspoints of threshold 
        %positive_crosspoints = find(cross == 1); % get all crosspoints going from negative to positive

        %over_threshold = positive_crosspoints(end); %yields the last index which is above your threshhold
        
        % find start point of raising phase 
        %start_time = t(over_threshold);
        
        baseline_crosspoints = diff(recordings_filtered > baseline); % find crosspoints of baseline 
        positive_crosspoints_baseline = find(baseline_crosspoints == 1); % get all crosspoints going from negative to positive

        step_40ms = find(t == 40); step_25ms = find(t == 25); % find indices indicating start of stimulus and where search should end
        
        % find point that crosses the baseline in the beginning of the
        % stimulus to find a start point for the fit
        a = positive_crosspoints_baseline>= step_25ms & positive_crosspoints_baseline<=step_40ms;
       
        if isempty(a) == 1
        
            baseline_crosspoints = diff(recordings_filtered > threshold); % find crosspoints of baseline 
            positive_crosspoints_baseline = find(baseline_crosspoints == 1); % get all crosspoints going from negative to positive

        end 

        vlaues_in_range = positive_crosspoints_baseline(a==1); 
        start_time = vlaues_in_range(end);
        
        % get the vector between the calculated start time and the
        % pre-determined stop time
        % bsp: t_sel = t > 0.025 & t < 0.125;
        t_sel = t > t(start_time) & t < stop_time; 
        
        % get time vector from where to where it should be fitted
        tsubset = t(t_sel); tsubset = tsubset - tsubset(1); 
        tsubset = tsubset'; 
        recording_subset = recordings_filtered(t_sel); % get the section of the recording which should be fitted
        
%% smooth recording and fit     
    %%% smoothing of the section of the recording

if smooth_for_fit == 1
        smoothie = smooth(recording_subset,0.15,'loess');
        ft = fittype( 'exp2' ); % set with what model data should be fitted
        opts = fitoptions( 'Method', 'NonlinearLeastSquares' ); % creates fit option for nonlinear least squares 
        opts.Display = 'Off'; % do not show options 
        opts.StartPoint = [ 104.9  -0.001619  -116.2 -0.05671];
        % Startpoints of the fit

        [fitresult, gof2] = fit( tsubset, smoothie, ft, opts );
        % get fit and goodness-of-fit statistics in the structure gof2.

else

        ft = fittype( 'exp2' ); % set with what model data should be fitted
        opts = fitoptions( 'Method', 'NonlinearLeastSquares' ); % creates fit option for nonlinear least squares 
        opts.Display = 'Off'; % do not show options 
        opts.StartPoint = [ 104.9  -0.001619  -116.2 -0.05671];
        % Startpoints of the fit

        [fitresult, gof2] = fit(tsubset, recording_subset, ft, opts );
        % get fit and goodness-of-fit statistics in the structure gof2.
end
%% calculate tau

        coeff_fit = coeffvalues(fitresult);    % take out the results of the fit 

        tau_1 = 1/abs(coeff_fit(2)); % calculate tau 1
        tau_2 = 1/abs(coeff_fit(4)); % calculate tau 2

%% plot
    if plotflag == 1
        if smooth_for_fit == 1
            figure
            plot(tsubset,smoothie) % plot the fit over the template to see goodness-of-fit
            hold on
            plot(fitresult) % plot the fit
        else 
            figure
            plot(tsubset,recording_subset) % plot the fit over the template to see goodness-of-fit
            hold on
            plot(fitresult) % plot the fit
        end
    end 

end % end of function