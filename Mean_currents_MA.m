%% Function to calculate mean of delayed rectifier currents and findpeak of A-type potassium and sodium currents
%%% Author: Oda E. Riedesel
%%% Date: 31.10.2023
%
% Funtion is calculating the mean of delayed rectifier currents and uses
% the findpeaks function to find the peaks of the A-type K+ currents and of
% the Na+ currents.
% 
%
% - Input: 
%   recordings_filtered : recording that should be analyzed which was
%                           already sufficiently filtered data
%
%   plotflag:
%%%             0 = no plot
%%%             1 = all peaks in one figure will be shown 
%%%             2 = sodium and potassium peaks will be shown in seperate
%%%                 figures
%
% stim_pos:
%%%             1 = calculation of sodium and potassium current peaks in the
%%%                     beginning of the stimulus (C5), 150 ms stimulus
%%%                     with single pulse and mean value of C6 and C8
%%%             2 = calculation of outward currents at the end of the
%%%                   stimulus, 150 ms stimulus with single pulse
%%%             3 = 1100 ms stimulus with single pulse (C7) 
%%%             4 = A-type current inactivation (A2)
%
% Ion:  
%%%             1 = K+
%%%             2 = Na+
%
%
% - Output: 
%   t : time vector
%
%   baseline : matrix with the basline value for each sweep which was used
%               to subtract and correcting the data
%
%   K_current_mean_corrected : Baseline corrected mean of the calculated K+ current at the end
%                               of the 100 ms pulse
%
%   KA_front_pulse_and_timing : Baseline corrected peaks found of the
%                               A-type currents in the recordings
%
%   KA_back_pulse_and_timing : Baseline corrected peaks found of the
%                               A-type currents in the recordings in the
%                               second pulse only of the inactivation
%                               protocol
%
%   Na_front_pulse_and_timing : 
%
%   Na_back_pulse_and_timing : 
%

% *** Notes *** 
%%% These calculations are tailored to my (Oda) stimulus protocols used for
%%% my master thesis. Except of protocol C7 and inactivation (A2) are all 150 ms long.
%%% The calculations were customized to the extreme length of C7 and the
%%% double pulse of the inactivation (A2) protocol
% for my 150 ms protocols


function [t,baseline,K_current_mean,KA_front_pulse_and_timing,KA_back_pulse_and_timing,Na_front_pulse_and_timing,Na_back_pulse_and_timing] = Mean_currents_MA(recordings_filtered,plotflag,stim_pos,Ion,protocol_length)


%% create empty vectors

baseline = zeros(size(recordings_filtered,3),1); 
KA_front_pulse_and_timing = zeros(size(recordings_filtered,3),2);
KA_back_pulse_and_timing = zeros(size(recordings_filtered,3),2);
K_current_mean = zeros(size(recordings_filtered,3),1);

Na_front_pulse_and_timing = zeros(size(recordings_filtered,3),2);
Na_back_pulse_and_timing= zeros(size(recordings_filtered,3),2);



    %% Baseline calculation
    % Baseline calculated between ms 5 and ms 25 h

    if size(recordings_filtered,1) == 1500
        Fs = 10; % sample rate
    else %size(recordings_filtered,1) == 3000
        Fs = 20; % sample rate
    end
     
    t = (0:length(recordings_filtered(:,1,2))-1)/Fs; % time vector for plot in ms
    
    
    for w = 1:1:size(recordings_filtered,3) % calculations for all trials 
    
        baseline(w,1) = mean(recordings_filtered(find(t == 2):find(t == 22),1,w));
        % calculate baseline for all sweeps 
        % 2 ms -> 22 ms    (2 to 22 ms) time frame I want to use for the baseline

    end % end for loop
 
    
    %% Potassium channels & Correct data
    % detection of current peaks of potassium currents for each sweep
      % and substraction of baseline to correct the data 

    if Ion == 1

        if stim_pos == 1 %findpeaks of potassium A-type current (C5/A3/C6/C7)
            if protocol_length == 1
                for sweep = 1:1:size(recordings_filtered,3) % calculations for all trials 
     %%% Na+
                % find Na+ current peak by reversing the recording just to get timing
                [Na_peaks_front,~]  = findpeaks(-recordings_filtered(find(t== 25):find(t== 32),1,sweep),'MinPeakHeight',-100);
                % 
                    if isempty(Na_peaks_front) == 1
                        
                        % if no peak for Na+ was found, the time point where to
                        % start looking for the peak is manually set to 25 ms. This
                        % is the time point where the stimulus starts
                        Na_peak_timing_in_time_vec = 25; 
                        recording_subsec_for_Na =recordings_filtered(:,1,sweep);
                        Na_peaks_front = recording_subsec_for_Na(t == 25); % find current value at the start point to subset it due to the manually set of the starting point 
        
                    elseif isempty(Na_peaks_front) == 0
        
                        Na_peaks_front = max(Na_peaks_front); % get max peak found
                        % get timing of peak
                        Na_peak_timing = find(recordings_filtered(:,1,sweep) == -Na_peaks_front);
                        Na_peak_timing_in_time_vec = Na_peak_timing/Fs;
            
                        Na_peaks_front = -Na_peaks_front; % reversing the value so that the right direction is restored
                        % because the values are going down
                    
                    end % end if a peak was found or not for Na+
        
    %%% KA+
                % find peaks of the K+ peak in the front or only pulse (depending on the stimulus protocol)
                [sweep_front_pulse]  = findpeaks(recordings_filtered(find(t == Na_peak_timing_in_time_vec):find(t == 40),1,sweep),'MinPeakHeight',-70);
                
                    if isempty(sweep_front_pulse) == 1
                        [sweep_front_pulse]  = findpeaks(recordings_filtered(find(t == 30):find(t == 50),1,sweep),'MinPeakHeight',-30);
                    end
                        
                sweep_front_pulse = max(sweep_front_pulse); %  get max peak found
                
                % get timing of peak
                peak_timing_front_pulse = find(recordings_filtered(:,1,sweep) == sweep_front_pulse);
        %             plot(t,recordings_filtered(:,1,sweep))
        %             hold on
        %             plot(peak_timing_front_pulse/20,A_front_pulse,'*')
                
         
                KA_front_pulse_and_timing(sweep,1) = sweep_front_pulse - baseline(sweep,1); % corrects for baseline and save peaks in matrix
                KA_front_pulse_and_timing(sweep,2) = peak_timing_front_pulse/Fs; % save peak timing in matrix
                
                Na_front_pulse_and_timing(sweep,1) = Na_peaks_front - baseline(sweep,1);
                Na_front_pulse_and_timing(sweep,2) = Na_peak_timing_in_time_vec;
        
                end

                elseif protocol_length == 2
                    for sweep = 1:1:size(recordings_filtered,3) % calculations for all trials 
                    %%% Na+
                    % find Na+ current peak by reversing the recording just to get timing
                    [Na_peaks_front,~]  = findpeaks(-recordings_filtered(find(t== 40):find(t== 45),1,sweep),'MinPeakHeight',-100);
                    % 
                        if isempty(Na_peaks_front) == 1
                            
                            % if no peak for Na+ was found, the time point where to
                            % start looking for the peak is manually set to 25 ms. This
                            % is the time point where the stimulus starts
                            Na_peak_timing_in_time_vec = 40; 
                            recording_subsec_for_Na =recordings_filtered(:,1,sweep);
                            Na_peaks_front = recording_subsec_for_Na(t == 40); % find current value at the start point to subset it due to the manually set of the starting point 
            
                        elseif isempty(Na_peaks_front) == 0
            
                    Na_peaks_front = max(Na_peaks_front); % get max peak found
                    % get timing of peak
                    Na_peak_timing = find(recordings_filtered(:,1,sweep) == -Na_peaks_front);
                    Na_peak_timing_in_time_vec = Na_peak_timing/Fs;
        
                    Na_peaks_front = -Na_peaks_front; % reversing the value so that the right direction is restored
                    % because the values are going down
                
                        end % end if a peak was found or not for Na+
    
                    %%% KA+
                    % find peaks of the K+ peak in the front or only pulse (depending on the stimulus protocol)
                    [sweep_front_pulse]  = findpeaks(recordings_filtered(find(t == Na_peak_timing_in_time_vec):find(t == 50),1,sweep),'MinPeakHeight',-70);
                    
                        if isempty(sweep_front_pulse) == 1
                            [sweep_front_pulse]  = findpeaks(recordings_filtered(find(t == 40):find(t == 50),1,sweep),'MinPeakHeight',-30);
                        end
                            
                    sweep_front_pulse = max(sweep_front_pulse); %  get max peak found
                
                    % get timing of peak
                    peak_timing_front_pulse = find(recordings_filtered(:,1,sweep) == sweep_front_pulse);
        %             plot(t,recordings_filtered(:,1,sweep))
        %             hold on
        %             plot(peak_timing_front_pulse/20,A_front_pulse,'*')
                
         
                    KA_front_pulse_and_timing(sweep,1) = sweep_front_pulse - baseline(sweep,1); % corrects for baseline and save peaks in matrix
                    KA_front_pulse_and_timing(sweep,2) = peak_timing_front_pulse/Fs; % save peak timing in matrix
                    
                    Na_front_pulse_and_timing(sweep,1) = Na_peaks_front - baseline(sweep,1);
                    Na_front_pulse_and_timing(sweep,2) = Na_peak_timing_in_time_vec;
            
                    end % end for each sweep
            end % end long protocol
    
    
        elseif stim_pos == 2 % mean (A3/C5/C6/C8) dr current mean calculations for stimulus protocols of 125 ms length
            for sweep = 1:1:size(recordings_filtered,3) % calculations for all trials 
            
                K_current_mean_sweep = mean(recordings_filtered(find(t == 93):find(t == 123),1,sweep));
                % calculate mean currents for all sweeps between 93 ms and 123 
                % ms 
                % Pulse is between 25 and 125 ms
                K_current_mean(sweep,1) = K_current_mean_sweep - baseline(sweep,1);

            end % end for loop
        
    
    
        elseif stim_pos == 3 % mean for C7 stimulus (-80 mV holding + 1 s stim) for stimulus protocols for 1100 ms
            for sweep = 1:1:size(recordings_filtered,3) % calculations for all trials 
            
                K_current_mean_sweep = mean(recordings_filtered(find(t == 700):find(t == 1000),1,sweep));
                % calculate mean currents for all sweeps between 700 ms and
                % 1000 ms
                % Pulse is between 50 and 1050 ms
                K_current_mean(sweep,1) = K_current_mean_sweep - baseline(sweep,1);

            end % end for loop
    
    
    
        elseif stim_pos == 4 % findpeaks of A-type currents for the varied inactivation protocol (A2) with two pulses
    
            for sweep = 1:1:size(recordings_filtered,3) % calculations for all trials 
            
                %%% front pulse
                [sweep_front_pulse]  = findpeaks(recordings_filtered(find(t == 30):find(t == 50),1,sweep),'MinPeakHeight',2);
                
                if isempty(sweep_front_pulse) == 1
                    [sweep_front_pulse]  = findpeaks(recordings_filtered(find(t == 30):find(t == 50),1,sweep),'MinPeakHeight',-30);
                end
                
                if isempty(sweep_front_pulse) == 1
                    [sweep_front_pulse]  = findpeaks(recordings_filtered(find(t == 30):find(t == 50),1,sweep),'MinPeakHeight',-80);
                end
                sweep_front_pulse = max(sweep_front_pulse); % find max peak
                
                peak_timing_front_pulse = find(recordings_filtered(:,1,sweep) == sweep_front_pulse); % find peak timing
    %             plot(t,recordings_filtered(:,1,sweep))
    %             hold on
    %             plot(peak_timing_front_pulse/20,A_front_pulse,'*')
    
                %%% back pulse
                % find peak in the second pulse
                [sweep_back_pulse]  = findpeaks(recordings_filtered(find(t == 130):find(t == 150),1,sweep),'MinPeakHeight',2);
                
                if isempty(sweep_back_pulse) == 1
                    [sweep_back_pulse]  = findpeaks(recordings_filtered(find(t == 130):find(t == 150),1,sweep),'MinPeakHeight',-50);
                end
               
                sweep_back_pulse = max(sweep_back_pulse); % max peak found

                % timing of the peak found
                peak_timing_back_pulse = find(recordings_filtered(:,1,sweep) == sweep_back_pulse);
    
    %             plot(t,recordings_filtered(:,1,17))
    %             hold on
    %             plot(peak_timing_back_pulse/20,A_back_pulse,'*')
                
                % save peaks and timing of the peaks that were found for
                % the first and second pulse 
                KA_front_pulse_and_timing(sweep,1) = sweep_front_pulse - baseline(sweep,1);
                KA_front_pulse_and_timing(sweep,2) = peak_timing_front_pulse/Fs;
    
                KA_back_pulse_and_timing(sweep,1) = sweep_back_pulse - baseline(sweep,1);
                KA_back_pulse_and_timing(sweep,2) = peak_timing_back_pulse/Fs;
            end % end for loop
   
        end
    

     %% Sodium &  Correct data 
           % substract baseline for corretction of the data with the baseline 
           
    elseif Ion == 2

        for sweep = 1:1:size(recordings_filtered,3) % calculations for all trials 
               % detection of current peaks of sodium currents for each sweep
    
            % findpeaks(-your_signal)  -> flip of the findpeaks function
            [Na_peaks_front,~]  = findpeaks(-recordings_filtered(find(t== 25):find(t== 32),1,sweep),'MinPeakHeight',2);
                % reversing the recordings to find downsided peak
                % 550:600 als per Hand festgelegt, durch anschauen der recodings, muss
                % ggf geändert werden
            if isempty(Na_peaks_front) == 1
                [Na_peaks_front,~]  = findpeaks(-recordings_filtered(find(t== 25):find(t== 32),1,sweep),'MinPeakHeight',-20);
            end

             if size(Na_peaks_front,1) > 1            % if more than one peak is detected
                    sodium_peaks = max(Na_peaks_front); % the maximum peak is chosen
 
            % elseif isempty(Na_peaks_front) == 1
            %         sodium_peaks(g,1) = recordings_filtered(550,1,g);
            %         sodium_max_I(g,1) = 560; % set 560 as time 
            %         continue
         
             elseif size(Na_peaks_front,1) == 1
                    sodium_peaks = Na_peaks_front; % if only one peak is found than okay
  
             end % end if loop
            
              
            sodium_peak_timing_front_pulse = find(recordings_filtered(:,1,sweep) == (-sodium_peaks)); % find time point of peak
            sodium_peaks_front = -sodium_peaks; % reversing the value so that the right direction is restored
            % because the values are going down
            
            
            %%% for pulse in the back

            % findpeaks(-your_signal)  -> flip of the findpeaks function
            [Na_peaks_back,~]  = findpeaks(-recordings_filtered(find(t== 127):find(t== 132),1,sweep),'MinPeakHeight',2);
                % reversing the recordings to find downsided peak
                % 550:600 als per Hand festgelegt, durch anschauen der recodings, muss
                % ggf geändert werden

            if isempty(Na_peaks_back) == 1 % if no peak was found 
                % peak was maybe to small so in the following the minimum height will be successively reduced
                [Na_peaks_back,~]  = findpeaks(-recordings_filtered(find(t== 127):find(t== 132),1,sweep),'MinPeakHeight',-2); 
            end

            if isempty(Na_peaks_back) == 1
                [Na_peaks_back,~]  = findpeaks(-recordings_filtered(find(t== 127):find(t== 132),1,sweep),'MinPeakHeight',-20);
            end

            if isempty(Na_peaks_back) == 1
                [Na_peaks_back,~]  = findpeaks(-recordings_filtered(find(t== 127):find(t== 132),1,sweep),'MinPeakHeight',-80);
            end
             if size(Na_peaks_back,1) > 1            % if more than one peak is detected
                    sodium_peaks_back = max(Na_peaks_back); % the maximum peak is chosen
 
            else
                    sodium_peaks_back = Na_peaks_back; % if only one peak is found than okay              
            end % end if loop

            sodium_peak_timing_back_pulse = find(recordings_filtered(:,1,sweep) == -sodium_peaks_back); % find time point of peak
            sodium_peaks_back = -sodium_peaks_back; % reversing the value so that the right direction is restored
            % because the values are going down
        
           
            % re-locate data into matrices and giving out for further calculations 
            Na_front_pulse_and_timing(sweep,1) = sodium_peaks_front - baseline(sweep,1);
            Na_front_pulse_and_timing(sweep,2) = sodium_peak_timing_front_pulse/Fs;
    
            Na_back_pulse_and_timing(sweep,1) = sodium_peaks_back - baseline(sweep,1);
            Na_back_pulse_and_timing(sweep,2) = sodium_peak_timing_back_pulse/Fs;

        end % end for each sweep
         
    end % end if-loop which ion current to calculate



%% Plot
         if plotflag == 1 % with sodium and potassium peaks in one plot
        
        %% Plot both peaks in one
        
        % hold on
            figure('Name','Sodium peaks');
            hold on
            for g = 1: size(recordings_filtered,3)
                plot(t,recordings_filtered(:,1,g))
                hold on
                plot((max_timing_potassium(g,1)/20),max_peaks_potassium(g,1),'r*')  % marking the 10th data point of x and y 
  
                xlabel('time [ms]')
                ylabel('membrane potential [mV]')
                legend('filtered response','potassium current peaks','sodium current peaks')
        %       ylim([-300 900])
             
           %  rectangle('position',[0.005 -100 0.02 200],'LineWidth',1,'EdgeColor','m')
            end % end for loo
        
        
        
         elseif plotflag == 2 % with peaks plotted for each ion seperately

        %% Plot potassium peaks
            %plot all sweeps in a seperate figure with inidcated found peaks for visual
            %verification if it is really a peak 
         
            figure('Name','Potassium peaks');
            hold on
            for g = 1: size(recordings_filtered,3)
                plot(recordings_filtered(:,1,g))
                hold on
                plot(max_timing_potassium(g,1),max_peaks_potassium(g,1),'r*')  % marking the 10th data point of x and y
        
                xlabel('time [ms]')
                ylabel('Current [pA]')
        %       ylim([-500 900])
        
            end % end for loop
    
         end % end plotflag if statemen

end % end function

