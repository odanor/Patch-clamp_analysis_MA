%% Master datanalaysis Oda E. Riedesel 2023
%%% Author : Oda E. Riedesel
%%% Date : May 2023
%
%  Main analysis script of the data for the master thesis. Analysis of patch clamp data recorded for the Master
%  thesis using different stimulus protocols under different transfected  
%  conditions.

%         
%
% - Input : 
%  dataPath : external input vector [pA] 
%  stimulus_abbrevation : time step [ms] 
%  stimulus : time step [ms] 
%  xxx_struct : give the struct that will be created a name below
%  protocol_length: 
%%%             1 = short protocol (150 ms)
%%%             2 = long protocol (1200 ms)
%
% - Output : 
%   xxx_struct: struct with all calculations needed for plotting
%   t : time vector [ms]
%   plots: I-V curves will be plotted
%   
%
% *** Notes *** 
%   Save all data of one condition into one folder, then open the folder
%   with the data before starting. All .abf recordings in that folder will
%   be analysed successively. The filtered recording will be saved manually
%   as .mat file in the same folder as the raw traces.
%
%   The struct will not be automatically saved in the folder, check manually!
%   All data will be saved into one struct so calculations of one condition
%   can be easly be found in one struct
%
% - acronyms :
%   KA = A-type K+ current
%   DR = delayed rectifier current
%
% - stimulus protocols used :
%%%       A2 --> inactivation
%%%       A3 --> -30 mV holding potential
%%%       C5 --> -80 mV holding potential
%%%       C6 --> -40 mV holding potential
%%%       C7 --> -80 mV holding potential with 1000 ms stimulation 
%%%       C8 --> -20 mV holding potential
%
% - used custom-written functions :
%   Notchfilter_Oda.m
%   Mean_currents_MA.m
%   exp_fit_taucalc.m
%   fit_IV_func.m
%   transparent_errorbar_fig

% empty/close everything 
clc,clear,close all 

%% Determine data paths

% Give the path where the data files are stored (".." parent directory, "." current directory)
dataPath = "/Users/oda/Desktop/Uni/Master/MA/Daten/CRY4/A3/";
scriptPath = "/Users/oda/Desktop/Uni/Master/MA/Daten/Matlabscrips"; % Give the path where the Matlabscripts are stored 
stimulus_protocols = "/Users/oda/Desktop/Uni/Master/MA/Daten/stimulusprotocols";  % Path where the stimulus protocols are saved

% List all .abf files in the folder
fileList = dir(dataPath+"*.abf");

%% Inputs. Please change!!

% create data struct including the fileList with files that were analyzed
%%% change name here and in the end of the script!!!!

CRY4_A3_struct = struct('fileList',fileList);

% Stimulus Protcol used
stimulus_abbrevation = 'A3';

% stimulus protocol of the recordings
stimulus = 2; 

    %%%  1 --> calculation of the KA currents in the
    %%%                   beginning of the stimulus (C5/C7)
    %%%  2 --> calculation of mean outward currents at the end of the
    %%%                   stimulus -> DR (C5/C6/C8/A3)
    %%%  3 --> calculation of mean outward currents at the end of the
    %%%                   stimulus -> DR (C7)
    %%%  4 --> calculation of the KA currents for the first pulse and the 
    %%%                   second pulse simultaneously (A2)

protocol_length = 1; % for find peaks stim = 1

    %%%  1 --> short protocol (150 ms)
    %%%  2 --> long protocol (1200 ms)

voltage_change_for_exp_fit = 30; % choose voltage step that should be fitted exponentially

delayed_rectifier = 1;
% = 1 dr will be fitted exponentially at the chosen voltage change
% ~= 1 exponential fit will be skipped

% change current folder to folder where this script, all function and stimulus protocols used are saved
cd '/Users/oda/Desktop/Uni/Master/MA/Daten/Matlabscrips' 


%% chose stimulus protocol
% the .mat file of the chosen stimulus protocol will be opened and used for
% determining timings etc. in the further analysis

cd(stimulus_protocols)

if stimulus == 1
    load('protocol_C5.mat')
    t_stim = load('time_vector_C5_C6_C8.mat');
elseif stimulus == 2
    if strcmp('C5',stimulus_abbrevation) == 1
        load('protocol_C5.mat')
    elseif strcmp('C6',stimulus_abbrevation) == 1
        load('protocol_C6.mat')
    elseif strcmp('C8',stimulus_abbrevation) == 1 
        load('protocol_C8.mat')
    elseif strcmp('A3',stimulus_abbrevation) == 1 
        load('protocol_C5.mat')
    end
    t_stim = load('time_vector_C5_C6_C8.mat');
elseif    stimulus == 3
     load('protocol_C7.mat')
      t_stim = load('time_vector_C7.mat');
elseif  stimulus == 4
    load('protocol_A2.mat')
    t_stim = load('time_vector_A2.mat');
end

%% create data path and stimulus protocol

% define voltage step vector 
if stimulus == 1 ||stimulus == 2 || stimulus == 3  % C5/C6/C7/C8/A3
    voltage_steps = (-100):10:60; % vector for used voltage steps for x-axis
elseif stimulus == 4 % A2
    voltage_steps = (-100):10:-10; % vector for used voltage steps for x-axis
end

voltage_steps = voltage_steps'; % reverse vector

% find the right sweep where the desired voltage step is saved
exp_fit_sweep = find(voltage_steps == voltage_change_for_exp_fit);
        

%% define all tables and stimulus protocol used
%%% The here listed variables are predefined and the first block needs to
%%% be re-named with every calculation of an new condition.

% empty tables for potassium current peaks/mean and timing of peaks
% no need to re-name:
Baseline_K = table(); 
K_current_mean = table(); % table for all current means in the end of the stimulation
KA_front_current_peak = table(); % for all KA peaks calculated in the first pulse
KA_front_current_timing = table(); % for timing of all KA peaks calculated in the first pulse


KA_back_current_peak = table(); % for all KA peaks calculated in the second pulse
KA_back_current_timing = table(); % back tables applies only for protocol A2


% empty tables for sodium currents
NA_front_current_peak = table();
NA_front_current_timing = table();
NA_back_current_peak = table();
NA_back_current_timing = table();
pre_Na_front_current_peak_normalized = table();
pre_Na_back_current_peak_normalized = table();

% Empty cell arrays to save the exponential fits
exp_fitresults = cell(length(voltage_steps),1); 
exp_gof = cell(length(voltage_steps),1); 
exp_tau_1 = cell(length(voltage_steps),1); 
exp_tau_2 = cell(length(voltage_steps),1); 
exponential_fits_all_cells_30mV = cell(4,length(fileList));

% Empty tables to store data and shift into the struct to save all together
% for one condition
KA_front_current_peak_normalized_table = table();
KA_back_current_peak_normalized_table = table();
K_current_mean_normalized_table = table();

K_current_mean_Imax_norm_table = table();
KA_current_peak_Imax_norm_table = table();
KA_back_current_peak_Imax_norm_table = table();
Na_front_current_peak_Imax_norm_table = table();
Na_back_current_peak_Imax_norm_table = table();

indiv_cell_fits = cell(5,length(fileList));   % create cell array to save each individuall fits
fit_cell_array_explained = cell(5,length(fileList)); % create cell array with information of what to find in the fit cell array
Mean_std_Kcurrent = table(); % empty table to save mean and std of all cells for mean I-V curve
Na_Mean_std_current = table();

% maybe no need to re-name depends on need
Na_indiv_cell_fits = cell(5,length(fileList)); 


% define variables to save the normalized data into matrices for further
% calculations
%%% no need to re-name!
KA_front_current_peak_normalized = zeros(length(voltage_steps),length(fileList));
KA_back_current_peak_normalized = zeros(length(voltage_steps),length(fileList));
K_current_mean_normalized = zeros(length(voltage_steps),length(fileList));
Na_front_current_peak_normalized = zeros(length(voltage_steps),length(fileList));
Na_back_current_peak_normalized = zeros(length(voltage_steps),length(fileList));

K_current_mean_I_Imax_norm = zeros(length(voltage_steps),length(fileList));
KA_front_current_peak_I_Imax_norm = zeros(length(voltage_steps),length(fileList));
KA_back_current_peak_I_Imax_norm = zeros(length(voltage_steps),length(fileList));
Na_front_current_peak_I_Imax_norm = zeros(length(voltage_steps),length(fileList));
Na_back_current_peak_I_Imax_norm = zeros(length(voltage_steps),length(fileList));

slope_fit = zeros(length(fileList),1);
k_slope_value = zeros(length(fileList),1);
midpoint_fit = zeros(length(fileList),1);
slope_fit_back = zeros(length(fileList),1);
k_slope_value_back = zeros(length(fileList),1);
midpoint_fit_back = zeros(length(fileList),1);

Na_slope_fit_back = zeros(length(fileList),1);
Na_k_slope_value_back = zeros(length(fileList),1);
Na_midpoint_fit_back = zeros(length(fileList),1);

% Random distinguishable line colors for each cell
Cell_color_code = linspecer(length(fileList)); 

%% Pre-created/ saved variables needed
%%% Variables that are needed for the calculation will be chosen from the
%%% file right before the calculation
%%% The folder will open and the right file need to be selscted.

% Norm_fact == table with saved Normalization values

% Normalization of the capacitance and first plots

% open folder to load table with the saved normalization factors
uiopen(dataPath); 

% convert table into an array for further calculations
Normation = table2array(Norm_fact);

%% Begin of calculations!

% Iterate through all files in the file list
for file = 1:length(fileList)
 
    % Load the next file and display name in command window
    raw_abf_file = abfload(dataPath+fileList(file).name);
    fprintf("Currently working on file: %s!\n",fileList(file).name)

    % extract raw data from the matrix
    data = raw_abf_file(:,3,:);
  
    %% filter data

    % change to folder where functions are saved
    cd(scriptPath) 

    % custom-written filter function
    [recordings_filtered,Fs] = Notchfilter_Oda(data,0);
    
   % cd(datapath) % change to folder where the data is and should be saved collected
    name = fileList(file).name(1:end-4); % delete .abf to save a .mat file
   
    % save the filtered recordings in specific file
    save(dataPath+name,'recordings_filtered') 


%% K+ current calculation

    % calculation of peak of KA or mean of current in the end of the pulse
    % dependent on the stimulus protocol with Mean_currents_MA.m function
    if stimulus == 1 %%% peak KA (C5)
        
        % find KA peaks 
       % [t,baseline,K_current_mean,KA_front_pulse_and_timing,KA_back_pulse_and_timing,Na_front_pulse_and_timing,Na_back_pulse_and_timing] = Mean_currents_MA(recordings_filtered,plotflag,stim_pos,Ion)
         [t,baseline,~,KA_front_pulse_and_timing] = Mean_currents_MA(recordings_filtered,0,stimulus,1,protocol_length);

        % relocate data into the table
        KA_front_current_peak{:,fileList(file).name} = KA_front_pulse_and_timing(:,1);
        KA_front_current_timing{:,fileList(file).name} = KA_front_pulse_and_timing(:,2);
    
    elseif stimulus == 2 %%% mean of DR current (C5/C6/C8/A3)
        % find mean current in the last 30 ms of stimulation and relocate data into a table
                                               % Mean_currents_MA(recordings_filtered,plotflag,stim_pos,Ion)
        [t,baseline,K_current_mean_corrected]  = Mean_currents_MA(recordings_filtered,0,stimulus,1,protocol_length);
        K_current_mean{:,fileList(file).name} = K_current_mean_corrected;
    
    elseif stimulus == 3 %%% mean of DR current (C7)
        % find mean current in the last 30 ms of stimulation and relocate data into a table
        [t,baseline,K_current_mean_corrected]  = Mean_currents_MA(recordings_filtered,0,stimulus,1,protocol_length);
        K_current_mean{:,fileList(file).name} = K_current_mean_corrected;
    
    elseif stimulus == 4 % peak of KA and Na+ current at front and back pulse (A2)
      
        %%% K+
        % run findpeaks function for both pulses and relocate data into the tables
        [t,~,~,KA_front_pulse_and_timing,KA_back_pulse_and_timing]  = Mean_currents_MA(recordings_filtered,0,stimulus,1,protocol_length);

        % relocate the current peaks and their timing into a table to save
        % KA_front_current_peak{:,fileList(file).name} = KA_front_pulse_and_timing(:,1);
        % KA_front_current_timing{:,fileList(file).name} = KA_front_pulse_and_timing(:,2);

        KA_back_current_peak{:,fileList(file).name} = KA_back_pulse_and_timing(:,1);
        KA_back_current_timing{:,fileList(file).name} = KA_back_pulse_and_timing(:,2);



        %%% Na+
        % run findpeaks function for both pulses and relocate data into the tables
       [~,baseline,~,~,~,Na_front_pulse_and_timing,Na_back_pulse_and_timing] = Mean_currents_MA(recordings_filtered,0,stimulus,2,protocol_length);
      
       % relocate the current peaks and their timing into a table to save
        % NA_front_current_peak{:,fileList(file).name} = Na_front_pulse_and_timing(:,1);
        % NA_front_current_timing{:,fileList(file).name} = Na_front_pulse_and_timing(:,2);

        NA_back_current_peak{:,fileList(file).name} = Na_back_pulse_and_timing(:,1);
        NA_back_current_timing{:,fileList(file).name} = Na_back_pulse_and_timing(:,2);

    end
    
   % relocate the calculated baseline for each sweep for each recording in a table
    Baseline_K{:,fileList(file).name} = baseline;


%% Exponential fit for dr currents for each sweep
% runs when stimulus is set to 2 or 3 for delayed rectifier currents. Otherwise it will be skipped.

   % exponential_fits_all_cells_all_sweeps = cell(4,length(fileList))
    if delayed_rectifier == 1
        if stimulus == 2  %%% (C5/C6/C8/A3)
            
            % pulse_timepoints = stim(:,1,17) > 0;
            % V1 = find(pulse_timepoints, 1,'last');
            % stop_time = t(V1);
             stop_time = 125; % --> end of stimulus in ms
            
            % take out recording to be exponentially fitted
            recording = recordings_filtered(:,1,exp_fit_sweep); % exp_fit_sweep is sweep number chosen in the beginning
    
            % run custom-written function to fit two-term exponential
            %[fitresult,gof2,tau_1,tau_2,tsubset] = exp_fit_taucalc(t,stop_time,recordings_filtered,smooth_for_fit,plotflag)
            [fitresult,gof2,tau_1,tau_2,tsubset] = exp_fit_taucalc(t,stop_time,recording,1,1);
           
    
            % locate the cell arrays with the values from the chosen sweep into a cell
            % array sorted by reccording
            exponential_fits_all_cells_30mV{1,file} = name;
            exponential_fits_all_cells_30mV{2,file} = fitresult;
            exponential_fits_all_cells_30mV{3,file} = gof2;
            exponential_fits_all_cells_30mV{4,file} = tau_1;
            exponential_fits_all_cells_30mV{5,file} = tau_2;
    
    
        elseif stimulus == 3 %%% (C7)
            
            % pulse_timepoints = stim(:,1,17) > 0;
            % V1 = find(pulse_timepoints, 1,'last');
            % stop_time = t(V1);
            stop_time = 1042; % --> end of stimulus in ms
            
            % take out recording to be exponentially fitted
            recording = recordings_filtered(:,1,exp_fit_sweep);
    
       % run custom-written function to fit two-term exponential
            %[fitresult,gof2,tau_1,tau_2,tsubset] = exp_fit_taucalc(t,stop_time,recordings_filtered,smooth_for_fit,plotflag)
            [fitresult,gof2,tau_1,tau_2,tsubset] = exp_fit_taucalc(t,stop_time,recording,1,1);

            % save 
            % exp_fitresults{sweep,1} = fitresult;
            % exp_gof{sweep,1} = gof2;
            % exp_tau_1{sweep,1} = tau_1;
            % exp_tau_2{sweep,1} = tau_2;
            % exp_t_vec{sweep,1} = tsubset;
    
            % locate the cell arrays with the values from the chosen sweep into a cell
            % array sorted by reccording
            exponential_fits_all_cells_30mV{1,file} = name;
            exponential_fits_all_cells_30mV{2,file} = fitresult;
            exponential_fits_all_cells_30mV{3,file} = gof2;
            exponential_fits_all_cells_30mV{4,file} = tau_1;
            exponential_fits_all_cells_30mV{5,file} = tau_2;
    
        end % end exponential fit
    else
    end
end % end for analysis for each data file individually
    

%% Explanatory cell array for the exponential fits 
    % creates cell array as it was created to save all fits just with
    % explanation what can be found at which point in the cell array
   
    exponential_fits_explained{1,1} = 'Name of recording which was exponentially fitted';
    exponential_fits_explained{2,1} = 'Fitresults of fit of each sweep. This cell contains a cell array where each row contains the fitresult of the corresponding sweep.';
    exponential_fits_explained{3,1} = 'Goodness-of-fit of fit of each sweep. This cell contains a cell array where each row contains the goodness-of-fit of the corresponding sweep.';
    exponential_fits_explained{4,1} = 'Tau 1 value of fit of each sweep. This cell contains a cell array where each row contains the tau 1 value of the corresponding sweep.';
    exponential_fits_explained{5,1} = 'Tau 2 of fit of each sweep. This cell contains a cell array where each row contains the tau 2 of the corresponding sweep.';


%% from here only the tables of all the cells for each condition are used

% created tables will be transformed into matrices for further
% calculations.
% The tables will be later saved and the matrices serve exclusively for
% further calculations

all_cells_mean_K = table2array(K_current_mean);
all_cells_mean_KA_front = table2array(KA_front_current_peak);
all_cells_mean_KA_back = table2array(KA_back_current_peak);

all_cells_mean_Na_front = table2array(NA_front_current_peak);
all_cells_mean_Na_back = table2array(NA_back_current_peak);


%% Normalization of currents from each cell to compensate for cell size
% with plots of thw raw I-V curve from each individual cell

if stimulus == 1 %%% KA (C5)
    
    % normation for each cell individually. 
    for cells = 1:size(Normation,2) 

        % normation of the cell current to 10 pF           
        KA_front_current_peak_normalized(:,cells) = all_cells_mean_KA_front(:,cells)/(Normation(cells)/10);
        
        % relocate data into table
        KA_front_current_peak_normalized_table{:,fileList(cells).name} = KA_front_current_peak_normalized(:,cells);

    end


elseif stimulus == 2 %%% K+ DR mean current (C5/C6/C8/A3)
 
    % normation for each cell individually. 
    for cells = 1:size(Normation,2)            

        % normation of the cell current to 10 pF           
        K_current_mean_normalized(:,cells) = all_cells_mean_K(:,cells)/(Normation(cells)/10);
        
        % relocate into table
        K_current_mean_normalized_table{:,fileList(cells).name} = K_current_mean_normalized(:,cells);
     
    end

elseif stimulus == 3 %%% K+ DR mean current (C7) 
  
    for cells = 1:size(Normation,2)

        % normation of the cell current to 10 pF                
        K_current_mean_normalized(:,cells) = all_cells_mean_K(:,cells)/(Normation(cells)/10);
      
        % relocate into table
        K_current_mean_normalized_table{:,fileList(cells).name} = K_current_mean_normalized(:,cells);
 
    end

elseif stimulus == 4 %%% peak KA and Na+ current at front and back pulse (A2)
    
    for cells = 1:size(Normation,2)
        
        %%% K+
        % normation of the cell KA current in the front to 10 pF                
      %  KA_front_current_peak_normalized(:,cells) = all_cells_mean_KA_front(:,cells)/(Normation(cells)/10);
        
        % normation of the cell KA current in the back to 10 pF                
        KA_back_current_peak_normalized(:,cells) = all_cells_mean_KA_back(:,cells)/(Normation(cells)/10);

        
        % relocate into table to save
       % KA_front_current_peak_normalized_table{:,fileList(cells).name} = KA_front_current_peak_normalized(:,cells);
        KA_back_current_peak_normalized_table{:,fileList(cells).name} = KA_back_current_peak_normalized(:,cells);



        %%% Na+ 
        % normation of the cell Na current in the front to 10 pF                
       % Na_front_current_peak_normalized(:,cells) = all_cells_mean_Na_front(:,cells)/(Normation(cells)/10);


        % normation of the cell  Na current in the back to 10 pF                
        Na_back_current_peak_normalized(:,cells) = all_cells_mean_Na_back(:,cells)/(Normation(cells)/10);
      
        % relocate into table to save
      %  pre_Na_front_current_peak_normalized{:,fileList(cells).name} = Na_front_current_peak_normalized(:,cells);
        pre_Na_back_current_peak_normalized{:,fileList(cells).name} = Na_back_current_peak_normalized(:,cells);

    end % end for-loop for calculation of each cell/recording individually
end % end if stimulus loop


%% Normalize Data to I/Imax for I-V curves
% normalize y axis for I-V curve between 0 and 1 I/Imax for better
% evaluation of I-V curves
% they are used for further calculation of the mean I-V curve of each
% condition
        
if stimulus == 1 %%% KA (C5)
    figure('Name','KA I-V curves') % plot raw I-V plots for each cell (not fitted)
    hold on

    for cells = 1:size(Normation,2)
       % normalize data of cell with maximum current of cell 
       KA_front_current_peak_I_Imax_norm(:,cells) = KA_front_current_peak_normalized(:,cells)/max(KA_front_current_peak_normalized(:,cells));
       % relocate into table
       KA_current_peak_Imax_norm_table{:,fileList(cells).name} = KA_front_current_peak_I_Imax_norm(:,cells);
 
      % plot of normalized currents
        plot(voltage_steps,KA_front_current_peak_I_Imax_norm(:,cells),'*','LineWidth',1,'Color',Cell_color_code(cells,:)) % Potassium I-V curve
        xlabel( 'V [mV]')
        ylabel('I/I_{max}')
        title('K2 potassium channel I-V curve')
        box off 
   
    end % end for each cell

elseif stimulus == 2 || stimulus == 3 %%% DR mean current (C5/C6/C7/C8/A3)
    figure('Name','K+ I-V curves') 
    hold on

    for cells = 1:size(Normation,2)

        % normalize data of cell with maximum current of cell 
        K_current_mean_I_Imax_norm(:,cells) = K_current_mean_normalized(:,cells)/max(K_current_mean_normalized(:,cells));
        % relocate into table that will be saved in the struct
        K_current_mean_Imax_norm_table{:,fileList(cells).name} = K_current_mean_I_Imax_norm(:,cells);

        % plot of normalized currents
        plot(voltage_steps,K_current_mean_I_Imax_norm(:,cells),'*','LineWidth',1,'Color',Cell_color_code(cells,:)) % Potassium I-V curve
        xlabel( 'V [mV]')
        ylabel('I/I_{max}')
        title('K2 potassium channel I-V curve')
        box off
   
    end % end for each cell

elseif stimulus == 4 %%% KA and Na+ current at front and back pulse (A2)
  
    % create figures and set axes
    figure(1), ax1 = gca; % front KA currents
    figure(2), ax2 = gca; % back KA currents
    
    figure(3), ax3 = gca; % front Na+ currents
    figure(4), ax4 =gca; % back Na+ currents
   
    for cells = 1:size(Normation,2)
       
       %%% K+ 

        %%% The calculation for the peaks at the front pulse was taken out because it was not needed at this point. 
        %%% However if its needed the calculations need to be checked
        %
        % hold(ax1,"on") % plot on figure 1
        % 
        % % normalize data of cell with maximum current of cell 
        % KA_front_current_peak_I_Imax_norm(:,cells) = KA_front_current_peak_normalized(:,cells)/max(KA_front_current_peak_normalized(:,cells));
        % % relocate into table
        % KA_current_peak_Imax_norm_table{:,fileList(cells).name} = KA_front_current_peak_I_Imax_norm(:,cells);
        % 
        % % plot I-V relation for KA front 
        % plot(voltage_steps,KA_front_current_peak_I_Imax_norm(:,cells),'*','LineWidth',1,'Color',Cell_color_code(cells,:)) % Potassium I-V curve
        % title('Raw KA I-V front pulse')
        % xlabel( 'V [mV]')
        % ylabel('I/I_{max}')
        % title('K2 potassium channel I-V curve')
        % box off
        % 
        % hold(ax1,"off") % stop plotting on figure 1
        % hold(ax2,"on") % plotting on figure 2
        % 
        

        % normalize data of cell with maximum current of cell 
        KA_back_current_peak_I_Imax_norm(:,cells) = KA_back_current_peak_normalized(:,cells)/max(KA_back_current_peak_normalized(:,cells));
        % relocate into table
        KA_back_current_peak_Imax_norm_table{:,fileList(cells).name} = KA_back_current_peak_I_Imax_norm(:,cells);

        % plot I-V relation for KA peaks at the back pulse
        plot(voltage_steps,KA_back_current_peak_I_Imax_norm(:,cells),'*','LineWidth',1,'Color',Cell_color_code(cells,:)) % Potassium I-V curve
        title('Raw KA I-V back pulse')
        xlabel( 'V [mV]')
        ylabel('I/I_{max}')
        title('K2 potassium channel I-V curve')
        box off
        
        hold(ax2,"off") % stop plotting on figure 2


        %%% Na+
       
        %%% The calculation for the peaks at the front pulse was taken out because it was not needed at this point. 
        %%% However if its needed the calculations need to be checked

        % normalize data of cell with maximum current of cell 
        % Na_front_current_peak_I_Imax_norm(:,cells) = Na_front_current_peak_normalized(:,cells)/max(Na_front_current_peak_normalized(:,cells));
        % 
        % hold(ax3,"on") % plot on figure 3
        % % plot I-V relation for Na front 
        % plot(voltage_steps,Na_front_current_peak_I_Imax_norm(:,cells),'*','LineWidth',1,'Color',Cell_color_code(cells,:)) % Potassium I-V curve
        % title('Raw Na+ I-V front pulse')
        % xlabel('V [mV]')
        % ylabel('I/I_{max}')
        % title('K2 sodium channel I-V curve')
        % box off
        % 
        % hold(ax3,"off") % stop plotting on figure 3
        % hold(ax4,"on") % plotting on figure 4        
        % 
        % relocate into table

        % Normalization of the NA currents
        Na_back_current_peak_I_Imax_norm(:,cells) = Na_back_current_peak_normalized(:,cells)/(-min(Na_back_current_peak_normalized(:,cells)));
      
        % plot I-V relation for Na back
        plot(voltage_steps,Na_back_current_peak_I_Imax_norm(:,cells),'*','LineWidth',1,'Color',Cell_color_code(cells,:)) % Potassium I-V curve
        title('Raw Na I-V back pulse')
        xlabel('V [mV]')
        ylabel('I/I_{max}')
        title('K2 sodium channel I-V curve')
        box off
        
        hold(ax4,"off") % stop plotting on figure 4
       
        % relocate into table
    %    Na_front_current_peak_Imax_norm_table{:,fileList(cells).name} =
    %    Na_front_current_peak_I_Imax_norm(:,cells);  % was removed due to incompleteness and because it is not required for the analysis.
        Na_back_current_peak_Imax_norm_table{:,fileList(cells).name} = Na_back_current_peak_I_Imax_norm(:,cells);

    end
end % end for stimulus chosen

hold off % stop of all plots


%% seperate I-V curve fitting 
% curve fitting of each I-V curve with appropriate function

%%% gof = Goodness-of-fit statistics
%%% fitresult = fit (to plot)

for cells = 1:size(Normation,2)
    % run custom written fit-function to fit I-V of each cell
    % Ion = 1 --> Bolzmann function 'A2+(A1-A2)/(1+exp((x-x0)/dx))'
    %  "  = 2 --> Gauss function

    if stimulus == 1 %%% KA --> Boltzmann
        % run function to fit curve
        [fitresult_front,gof2_front] = fit_IV_func(KA_front_current_peak_I_Imax_norm(:,cells),voltage_steps,4);

        % calculate values for a scatter plot I-V curve 
        % get y-values of the fit for specific x-values
         IV_scatter_plotvalues = fitresult_front(voltage_steps);

        % take out the calculated fit coefficient values of the fit 
        coeff_fit = coeffvalues(fitresult_front);   
       
        % locate the slopes and midpoints from the fits of all cells into
        % seperate vectors for further calcluations
        slope_fit(cells,:) = coeff_fit(2);
        
        %  1/slope from fit to get k as inclination from I-V curve';
        k_slope_value(cells,:) = 1/slope_fit(cells,:);

         % take out the midpoint from the fit
        midpoint_fit(cells,:) = coeff_fit(3);

          
    elseif stimulus == 2 %%% K+ DR --> Boltzmann
        [fitresult_front,gof2_front] = fit_IV_func(K_current_mean_I_Imax_norm(:,cells),voltage_steps,4);  
        % calculate values for a scatter plot I-V curve 
        % get y-values of the fit for specific x-values
        IV_scatter_plotvalues = fitresult_front(voltage_steps);
       
        % take out the calculated fit coefficient values of the fit 
        coeff_fit = coeffvalues(fitresult_front);   
        
        % locate the slopes and midpoints from the fits of all cells into
        % seperate vectors for further calcluations
        slope_fit(cells,:) = coeff_fit(2);
        
        %  1/slope from fit to get k as inclination from I-V curve';
        k_slope_value(cells,:) = 1/slope_fit(cells,:);
         % take out the midpoint from the fit
        midpoint_fit(cells,:) = coeff_fit(3);

  
    elseif stimulus == 3 %%% K+ DR --> Boltzmann
        [fitresult_front,gof2_front] = fit_IV_func(K_current_mean_I_Imax_norm(:,cells),voltage_steps,4);
        % calculate values for a scatter plot I-V curve 
        % get y-values of the fit for specific x-values
        IV_scatter_plotvalues = fitresult_front(voltage_steps);
        
        % take out the calculated fit coefficient values of the fit 
        coeff_fit = coeffvalues(fitresult_front);    
                
        % locate the slopes and midpoints from the fits of all cells into
        % seperate vectors for further calcluations
        slope_fit(cells,:) = coeff_fit(2);
       
        %  1/slope from fit to get k as inclination from I-V curve';
        k_slope_value(cells,:) = 1/slope_fit(cells,:);
        % calculate values for a scatter plot I-V curve 
        midpoint_fit(cells,:) = coeff_fit(3);

  
    elseif stimulus == 4 
        %%% KA --> Boltzmann

        %%% Frontpulse
        %%% calculations of the frontpulse have been coomented. When its
        %%% needed check before 

        % [fitresult_front,gof2_front] = fit_IV_func(KA_front_current_peak_I_Imax_norm(:,cells),voltage_steps,1);
        % calculate values for a scatter plot I-V curve 
        % get y-values of the fit for specific x-values
                % IV_scatter_plotvalues = fitresult_front(voltage_steps);
         
        % take out the calculated fit coefficient values of the fit 
        % coeff_fit = coeffvalues(fitresult_front);   
        % 
        % % locate the slopes and midpoints from the fits of all cells into
        % % seperate vectors for further calcluations
        % slope_fit(cells,:) = coeff_fit(3);
        % k_slope_value(cells,:) = 1/slope_fit(cells,:);
        % midpoint_fit(cells,:) = coeff_fit(4);
        
        % as long the front pulse results are not needed or further used
        % they will be set 0
         fitresult_front = 0; 
         gof2_front = 0;
         IV_scatter_plotvalues = 0;
         midpoint_fit = zeros(length(fileList),1);
         k_slope_value = zeros(length(fileList),1);


        %%% Backpulse
        %%% KA
        % fit --> Boltzmann
        [fitresult_back,gof2_back] = fit_IV_func(KA_back_current_peak_I_Imax_norm(:,cells),voltage_steps,3);
        
        % get y-values of the fit for specific x-values
        IV_backpulse_scatter_plotvalues = fitresult_back(voltage_steps);
        
        % take out the calculated fit coefficient values of the fit 
        coeff_fit_back = coeffvalues(fitresult_back);  
                
        % locate the slopes and midpoints from the fits of all cells into
        % seperate vectors for further calcluations
        slope_fit_back(cells,:) = coeff_fit_back(2);
        k_slope_value_back(cells,:) = 1/slope_fit_back(cells,:);% calculate slope factor
        midpoint_fit_back(cells,:) = coeff_fit_back(3);

  
        %%% Na+ --> Boltzmann (not Gauss any more)
        % [fitresult_Na_front,gof_Na_front] = fit_IV_func(Na_front_current_peak_I_Imax_norm(:,cells),voltage_steps,2);
        
        % get y-values of the fit for specific x-values
                % IV_Na_front_scatter_plotvalues = fitresult_Na_front(voltage_steps);

        
        % fit --> Boltzmann
        [fitresult_Na_back,gof_Na_back] = fit_IV_func(Na_back_current_peak_I_Imax_norm(:,cells),voltage_steps,3);
    
        % get y-values of the fit for specific x-values
        IV_Na_back_scatter_plotvalues = fitresult_Na_back(voltage_steps); 
        
        % take out the calculated fit coefficient values of the fit 
        Na_coeff_fit_back = coeffvalues(fitresult_Na_back);  
                
        % locate the slopes and midpoints from the fits of all cells into
        % seperate vectors for further calcluations
        Na_slope_fit_back(cells,:) = Na_coeff_fit_back(2);
        Na_k_slope_value_back(cells,:) = 1/Na_slope_fit_back(cells,:); % calculate slope factor
        Na_midpoint_fit_back(cells,:) = Na_coeff_fit_back(3); % take midpoint from fit

    end % end if statement for fit for each stimulus protocol 
    


    %% save fits into a cell array
        % first row with recording name for each fit
        indiv_cell_fits{1,cells} = fileList(cells).name;

        % save fit results into the array, second row = fit, third row =
        % Goodness-of-fit statistics, fourth row = scatter plot values from
        % fit 
        indiv_cell_fits{2,cells} = fitresult_front; 
        indiv_cell_fits{3,cells} = gof2_front; 
        indiv_cell_fits{4,cells} = IV_scatter_plotvalues;
        indiv_cell_fits{5,cells} = midpoint_fit(cells,:);
        indiv_cell_fits{6,cells} = k_slope_value(cells,:);

        % only when second stimulus is existent
        if ~isempty(KA_back_current_timing) == 1
           
           % save fit results into the array, fourth row = fit of KA back pulse, fifth row = Goodness-of-fit statistics of KA back pulse
           indiv_cell_fits{7,cells} = fitresult_back;
           indiv_cell_fits{8,cells} = gof2_back;
           indiv_cell_fits{9,cells} = IV_backpulse_scatter_plotvalues;
          
           % I just want a snickers.... and sleep...
           indiv_cell_fits{10,cells} = midpoint_fit_back(cells,:); % V50 value from Bolzmann fit
           indiv_cell_fits{11,cells} = slope_fit_back(cells,:); % slope from Bolzmann fit
        end

        % if Na+ currents were calcuated save all values in an extra cell
        % array for only Na+ currents
        if ~isempty(NA_back_current_peak) == 1 
            Na_indiv_cell_fits{1,cells} = fileList(cells).name;
            % Na_indiv_cell_fits{2,cells} = fitresult_Na_front;
            % Na_indiv_cell_fits{3,cells} = gof_Na_front; 
            % Na_indiv_cell_fits{4,cells} = IV_Na_front_scatter_plotvalues;
            Na_indiv_cell_fits{7,cells} = fitresult_Na_back;
            Na_indiv_cell_fits{8,cells} = gof_Na_back; 
            Na_indiv_cell_fits{9,cells} =  IV_Na_back_scatter_plotvalues;
            Na_indiv_cell_fits{10,cells} = Na_midpoint_fit_back(cells,:); % V50 value from Bolzmann fit
            Na_indiv_cell_fits{11,cells} = Na_k_slope_value_back(cells,:); % slope from Bolzmann fit

        end % end if statement to relocate Na+ currents 


end % end for-loop for fitting of each individual cell


%% Mean of I-V with std, fitting of mean I-V curve, calculation of values for scatter plot and V50
% calculation of mean and std between the cells of each condition
% and fit of I-V curve with custom fit function 
% save vectors of mean and std in table

if stimulus == 1 %%% KA (C5)
    % mean and standard deviation calculation over all cells 
    IV_total_mean_KA_front = mean(KA_front_current_peak_I_Imax_norm,2); IV_total_std_KA_front = std(KA_front_current_peak_I_Imax_norm,0,2);
    % fit of mean 
    [mean_cell_fitresult,gof2] = fit_IV_func(IV_total_mean_KA_front,voltage_steps,4);
    % calculate values for a scatter plot I-V curve 
    % get y-values of the fit for specific x-values
    IV_mean_scatter_plotvalues = mean_cell_fitresult(voltage_steps); % get y-values of the fit for specific x-values


    % take out the calculated fit coefficient values of the fit 
    coeff_fit_mean = coeffvalues(mean_cell_fitresult);   

    % locate the slope and midpoint from the fit into seperate variables 
    slope_fit_mean = coeff_fit_mean(2);
    k_slope_value_mean = 1/slope_fit_mean; % calculate slope factor

    midpoint_fit_mean = coeff_fit_mean(3); % take midpoit out of fit


elseif stimulus == 2 %%% DR mean current(C5/C6/C8/A3)   
    % mean and standard deviation calculation over all cells 
    IV_total_mean_K = mean(K_current_mean_I_Imax_norm,2); IV_total_std_K = std(K_current_mean_I_Imax_norm,0,2);
    % fit of mean with Boltzmann
    [mean_cell_fitresult,gof2] = fit_IV_func(IV_total_mean_K,voltage_steps,4);
    
    % calculate values for a scatter plot I-V curve 
    % get y-values of the fit for specific x-values
    IV_mean_scatter_plotvalues = mean_cell_fitresult(voltage_steps);
    
    
    % take out the calculated fit coefficient values of the fit 
    coeff_fit_mean = coeffvalues(mean_cell_fitresult);    
    
    % locate the slope and midpoint from the fit into seperate variables    
    slope_fit_mean = coeff_fit_mean(2);
    k_slope_value_mean = 1/slope_fit_mean; % calculate slope factor

    midpoint_fit_mean = coeff_fit_mean(3); % take midpoit out of fit

  
elseif stimulus == 3 %%% DR mean current (C7)
     % mean and standard deviation calculation over all cells 
    IV_total_mean_K = mean(K_current_mean_I_Imax_norm,2); IV_total_std_K = std(K_current_mean_I_Imax_norm,0,2);
    % fit of mean with Boltzmann
    [mean_cell_fitresult,gof2] = fit_IV_func(IV_total_mean_K,voltage_steps,4);
    % calculate values for a scatter plot I-V curve 
    % get y-values of the fit for specific x-values
    IV_mean_scatter_plotvalues = mean_cell_fitresult(voltage_steps);
    
    
    % take out the calculated fit coefficient values of the fit 
    coeff_fit_mean = coeffvalues(mean_cell_fitresult);   
    
    % locate the slope and midpoint from the fit into seperate variables 
    slope_fit_mean = coeff_fit_mean(2);
    k_slope_value_mean = 1/slope_fit_mean; % calculate slope factor

    midpoint_fit_mean = coeff_fit_mean(3);


elseif stimulus == 4 %%% KA and Na+ current at front and back pulse (A2)
   
    %%% K+

    % mean and standard deviation calculation over all cells for the KA currents of the
    % front pulse
   % IV_total_mean_KA_front = mean(KA_front_current_peak_I_Imax_norm,2); IV_total_std_KA_front = std(KA_front_current_peak_I_Imax_norm,0,2);
    % fit of mean with Boltzmann
   % [mean_cell_fitresult,gof2] = fit_IV_func(IV_total_mean_KA_front,voltage_steps,1);
    mean_cell_fitresult = 0;
    gof2 = 0;
    % calculate values for a scatter plot I-V curve 
    % get y-values of the fit for specific x-values
    IV_mean_scatter_plotvalues = 0;

    % take out the calculated fit coefficient values of the fit 
   % coeff_fit_mean = coeffvalues(mean_cell_fitresult);    
    
    % locate the slope and midpoint from the fit into seperate variables 
   % slope_fit_mean= coeff_fit_mean(3);
   % k_slope_value_mean = 1/slope_fit_mean; % calculate slope factor

    %midpoint_fit_mean = coeff_fit_mean(4);


    % mean and std calculation over all cells for the KA currents of the
    % back pulse
    IV_total_mean_KA_back = mean(KA_back_current_peak_I_Imax_norm,2); IV_total_std_KA_back = std(KA_back_current_peak_I_Imax_norm,0,2);
    % fit of mean with Boltzmann
    [mean_cells_fitresult_back,gof2_back] = fit_IV_func(IV_total_mean_KA_back,voltage_steps,3);
    % calculate values for a scatter plot I-V curve 

    % get y-values of the fit for specific x-values
    IV_mean_scatter_plotvalues_backpulse = mean_cells_fitresult_back(voltage_steps);

    % take out the calculated fit coefficient values of the fit 
    coeff_fit_mean_back = coeffvalues(mean_cells_fitresult_back);    
    
    % locate the slope and midpoint from the fit into seperate variables 
    slope_fit_mean_back = coeff_fit_mean_back(2);
    k_slope_value_mean_back = 1/slope_fit_mean_back; % calculate slope factor

    midpoint_fit_mean_back = coeff_fit_mean_back(3);


    %%% Na+

    % mean and standard deviation over all cells for Na+ current peak in the
    % front stimulus
   % IV_total_mean_Na_front = mean(Na_front_current_peak_I_Imax_norm,2); IV_total_std_Na_front = std(Na_front_current_peak_I_Imax_norm,0,2);
    % fit of mean with Gauss
    %[mean_cells_Na_fitresult_front,gof2_Na_front] = fit_IV_func(IV_total_mean_Na_front,voltage_steps,2);
    % calculate values for a scatter plot I-V curve 
    % get y-values of the fit for specific x-values
    %IV_mean_NA_scatter_plotvalues = mean_cells_Na_fitresult_front(voltage_steps);
   

    % mean and standard deviation over all cells for Na+ current peak in the
    % back stimulus
    IV_total_mean_Na_back = mean(Na_back_current_peak_I_Imax_norm,2); IV_total_std_Na_back = std(Na_back_current_peak_I_Imax_norm,0,2);
    % fit of mean with Gauss
    [mean_cells_Na_fitresult_back,gof2_Na_back] = fit_IV_func(IV_total_mean_Na_back,voltage_steps,3);
    % calculate values for a scatter plot I-V curve 
    % get y-values of the fit for specific x-values
    IV_mean_Na_scatter_plotvalues_backpulse = mean_cells_Na_fitresult_back(voltage_steps);


    % take out the calculated fit coefficient values of the fit 
    NA_coeff_fit_mean_back = coeffvalues(mean_cells_Na_fitresult_back);    
    
    % locate the slope and midpoint from the fit into seperate variables 
    Na_slope_fit_mean_back = coeff_fit_mean_back(2);
    Na_slope_value_mean_back = 1/Na_slope_fit_mean_back; % calculate slope factor

    Na_midpoint_fit_mean_back = coeff_fit_mean_back(3);

end % end if-loop for mean, std and fitting


%% Calculate mean and std of the I-V midpoint and std over all cells and create matrix to locate into the fit cell array to save

% if the value in the matrix at position (1,1) is not zero
if ~nonzeros(midpoint_fit(1,1)) == 0
   
    % calculate mean and std of all midpoints and slopes to compare with
    % those from the mean fit row-wise 
    midpoint_all_cells_mean = mean(midpoint_fit,1); midpoint_all_cells_std = std(midpoint_fit,0,1);
    slope_all_cells_mean = mean(k_slope_value,1); slope_all_cells_std = std(k_slope_value,0,1);

    % put all midpoint values into one matrix that will be saved in the cell array
    % of the fits
    midpoints_collection = [midpoint_all_cells_mean, midpoint_fit_mean];
    midpoints_collection(2,1) = midpoint_all_cells_std;

    % put all slope values into one matrix that will be saved in the cell array
    % of the fits
    slope_collection = [slope_all_cells_mean, k_slope_value_mean];
    slope_collection(2,1) = slope_all_cells_std;

end % end collect all midpoint in a matrix

    
if  exist('slope_fit_mean_back','var') == 1

    % calculate mean and std of all midpoints and slopes to compare with
    % those from the mean fit row-wise
    midpoint_all_cells_mean_back = mean(midpoint_fit_back,1); midpoint_all_cells_std_back = std(midpoint_fit_back,0,1);
    slope_all_cells_mean_back = mean(k_slope_value_back,1); slope_all_cells_std_back = std(k_slope_value_back,0,1);
    
    % put all midpoint values into one matrix that will be saved in the cell array
    % of the fits
    midpoints_collection_back = [midpoint_all_cells_mean_back, midpoint_fit_mean_back];
    midpoints_collection_back(2,1) = midpoint_all_cells_std_back;

    % put all slope values into one matrix that will be saved in the cell array
    % of the fits
    slope_collection_back = [slope_all_cells_mean_back, slope_fit_mean_back];
    slope_collection_back(2,1) = slope_all_cells_std_back;

end

if  exist('Na_slope_fit_mean_back','var') == 1

    % calculate mean and std of all midpoints and slopes to compare with
    % those from the mean fit row-wise
    Na_midpoint_all_cells_mean_back = mean(Na_midpoint_fit_back,1); Na_midpoint_all_cells_std_back = std(Na_midpoint_fit_back,0,1);
    Na_slope_all_cells_mean_back = mean(Na_k_slope_value_back,1); Na_slope_all_cells_std_back = std(Na_k_slope_value_back,0,1);
    
    % put all midpoint values into one matrix that will be saved in the cell array
    % of the fits
    Na_midpoints_collection_back = [Na_midpoint_all_cells_mean_back, Na_midpoint_fit_mean_back];
    Na_midpoints_collection_back(2,1) = Na_midpoint_all_cells_std_back;

    % put all slope values into one matrix that will be saved in the cell array
    % of the fits
    Na_slope_collection_back = [Na_slope_all_cells_mean_back, Na_slope_fit_mean_back];
    Na_slope_collection_back(2,1) = Na_slope_all_cells_std_back;

end

%% relocation of Mean, std and fits into table and cell array
% Calculated mean and std and resulted fits are saved in to a table/ cell
% array to keep the data and store it in the end 

% save mean over all cells in a table 
if stimulus == 1 % for KA calculations 
    Mean_std_Kcurrent{:,'mean'} = IV_total_mean_KA_front;
    Mean_std_Kcurrent{:,'std'} = IV_total_std_KA_front;
                              

% for mean current in the back
elseif stimulus == 2 || stimulus == 3
    Mean_std_Kcurrent{:,'mean'} = IV_total_mean_K;
    Mean_std_Kcurrent{:,'std'} = IV_total_std_K;
elseif stimulus == 4 

    % when back pulse were analyzed (only if stimulus == 4) (A2)
       Mean_std_Kcurrent{:,'mean back KA'} = IV_total_mean_KA_back;
       Mean_std_Kcurrent{:,'std back KA'} = IV_total_std_KA_back;
  
        % when Na currents were analyzed (now only if stimulus == 4) (A2)  
        % save of mean Na+ current of the back pulse
        Na_Mean_std_current{:,'mean back Na'} = IV_total_mean_Na_back;
        Na_Mean_std_current{:,'std back Na'} = IV_total_std_Na_back;
end


%% relocate the fits into cell array which was filled earleir to save  
% fits of the mean over all cells will be just added as a further column
% behind all the alredy existing fits from this condition 

indiv_cell_fits{1,length(fileList)+1} = 'fit of mean'; % fit (front) pulse
indiv_cell_fits{2,length(fileList)+1} = mean_cell_fitresult;
indiv_cell_fits{3,length(fileList)+1} = gof2;
indiv_cell_fits{4,length(fileList)+1} = IV_mean_scatter_plotvalues; % save scatter plot values under the correspomding fit

if exist('midpoint_fit_mean','var') == 1 && ~isempty(midpoint_fit_mean) == 1
    indiv_cell_fits{5,length(fileList)+1} = midpoints_collection; % V50 value from fit
    indiv_cell_fits{6,length(fileList)+1} = slope_collection; % slope from fit

else % just leave space empty if not Bolzmann was used
    indiv_cell_fits{5,length(fileList)+1} = []; 
    indiv_cell_fits{6,length(fileList)+1} = []; 
end

% fill in the fit results of the mean of all cells of the second pulse if existing 
if ~isempty(KA_back_current_peak) == 1  % if variable exist in workspace (stimulus == 4)
    indiv_cell_fits{7,length(fileList)+1} = mean_cells_fitresult_back; % fit back pulse
    indiv_cell_fits{8,length(fileList)+1} = gof2_back;
    indiv_cell_fits{9,length(fileList)+1} = IV_mean_scatter_plotvalues_backpulse; % save scatter plot values under the correspomding fit
    indiv_cell_fits{10,length(fileList)+1} = midpoints_collection_back;
    indiv_cell_fits{11,length(fileList)+1} = slope_collection_back;
end

%%% Na+

% fill Na+ current fit results of the mean over all cells of the front and
% back pulse into a table if analysis was done (stimulus == 4; A2)
if ~isempty(NA_back_current_peak) == 1

    Na_indiv_cell_fits{1,length(fileList)+1} = 'fit of mean'; % title of column in table
   % Na_indiv_cell_fits{2,length(fileList)+1} = mean_cells_Na_fitresult_front; % fit front pulse
   % Na_indiv_cell_fits{3,length(fileList)+1} = gof2_Na_front;
   % Na_indiv_cell_fits{4,length(fileList)+1} = IV_mean_NA_scatter_plotvalues; % save scatter plot values under the correspomding fit
   % Na_indiv_cell_fits{5,length(fileList)+1} = V50_values_Na_frontpulse;

    % fill Na+ current fit results into cell array for the currents of the
    % second pulse of the stimulus protocol
    Na_indiv_cell_fits{7,length(fileList)+1} = mean_cells_Na_fitresult_back; % fit back pulse
    Na_indiv_cell_fits{8,length(fileList)+1} = gof2_Na_back; 
    Na_indiv_cell_fits{9,length(fileList)+1} = IV_mean_Na_scatter_plotvalues_backpulse; % save scatter plot values under the correspomding fit
    Na_indiv_cell_fits{10,length(fileList)+1} = Na_midpoints_collection_back;
    Na_indiv_cell_fits{11,length(fileList)+1} = Na_slope_collection_back;

end % end if

%% Calculate median as mean and locate into the matrices
 
if stimulus == 1 %%% KA (C5)
    % mean and standard deviation calculation over all cells 
    IV_total_median_KA_front = median(KA_front_current_peak_I_Imax_norm,2);
    % fit of mean 
    [median_cell_fitresult,gof2] = fit_IV_func(IV_total_median_KA_front,voltage_steps,4);
    % calculate values for a scatter plot I-V curve 
    % get y-values of the fit for specific x-values
    IV_median_scatter_plotvalues = median_cell_fitresult(voltage_steps);


    % take out the calculated fit coefficient values of the fit 
    coeff_fit_median = coeffvalues(median_cell_fitresult);   

    % locate the slope and midpoint from the fit into seperate variables 
    slope_fit_median = coeff_fit_median(2);
    k_slope_value_median = 1/slope_fit_median; % calculate slope factor

    midpoint_fit_median = coeff_fit_median(3);


elseif stimulus == 2 %%% DR mean current(C5/C6/C8/A3)   
    % median calculation over all cells 
    IV_total_median_K = median(K_current_mean_I_Imax_norm,2);
    % fit of mean with Boltzmann
    [median_cell_fitresult,gof2] = fit_IV_func(IV_total_median_K,voltage_steps,4);
    
    % calculate values for a scatter plot I-V curve 
    % get y-values of the fit for specific x-values
     IV_median_scatter_plotvalues = median_cell_fitresult(voltage_steps);

     
    % take out the calculated fit coefficient values of the fit 
    coeff_fit_median = coeffvalues(median_cell_fitresult);    
    
    % locate the slope and midpoint from the fit into seperate variables    
    slope_fit_median = coeff_fit_median(2);
    k_slope_value_median = 1/slope_fit_median; % calculate slope factor

    midpoint_fit_median = coeff_fit_median(3);

  
elseif stimulus == 3 %%% DR mean current (C7)
     % mean and standard deviation calculation over all cells 
    IV_total_median_K = median(K_current_mean_I_Imax_norm,2); 
    % fit of mean with Boltzmann
    [median_cell_fitresult,gof2] = fit_IV_func(IV_total_median_K,voltage_steps,4);
    % calculate values for a scatter plot I-V curve 

    % get y-values of the fit for specific x-values
    IV_median_scatter_plotvalues = median_cell_fitresult(voltage_steps);

    % take out the calculated fit coefficient values of the fit 
    coeff_fit_median = coeffvalues(median_cell_fitresult);   
    
    % locate the slope and midpoint from the fit into seperate variables 
    slope_fit_median = coeff_fit_median(2);
    k_slope_value_median = 1/slope_fit_median; % calculate slope factor

    midpoint_fit_median = coeff_fit_median(3);


elseif stimulus == 4 %%% KA and Na+ current at front and back pulse (A2)
   
    %%% K+

    % mean and standard deviation calculation over all cells for the KA currents of the
    % front pulse
   % IV_total_mean_KA_front = mean(KA_front_current_peak_I_Imax_norm,2); IV_total_std_KA_front = std(KA_front_current_peak_I_Imax_norm,0,2);
    % fit of mean with Boltzmann
   % [mean_cell_fitresult,gof2] = fit_IV_func(IV_total_mean_KA_front,voltage_steps,1);
    median_cell_fitresult = 0;
    gof2 = 0;
    % calculate values for a scatter plot I-V curve 
    % get y-values of the fit for specific x-values
   % IV_mean_scatter_plotvalues = mean_cell_fitresult(voltage_steps);
    IV_median_scatter_plotvalues = 0; % set 0 because not used

    % mean and std calculation over all cells for the KA currents of the
    % back pulse
    IV_total_median_KA_back = median(KA_back_current_peak_I_Imax_norm,2);
    % fit of mean with Boltzmann
    [median_cells_fitresult_back,gof2_back] = fit_IV_func(IV_total_median_KA_back,voltage_steps,3);
    % calculate values for a scatter plot I-V curve 
    % get y-values of the fit for specific x-values
    IV_median_scatter_plotvalues_backpulse = median_cells_fitresult_back(voltage_steps);

    % take out the calculated fit coefficient values of the fit 
    coeff_fit_median_back = coeffvalues(median_cells_fitresult_back);    
    
    % locate the slope and midpoint from the fit into seperate variables 
    slope_fit_median_back = coeff_fit_median_back(2);
    k_slope_value_median_back = 1/slope_fit_median_back; % calculate slope factor

    midpoint_fit_median_back = coeff_fit_median_back(3);


    %%% Na+

    % mean and standard deviation over all cells for Na+ current peak in the
    % front stimulus
   % IV_total_mean_Na_front = mean(Na_front_current_peak_I_Imax_norm,2); IV_total_std_Na_front = std(Na_front_current_peak_I_Imax_norm,0,2);
    % fit of mean with Gauss
    %[mean_cells_Na_fitresult_front,gof2_Na_front] = fit_IV_func(IV_total_mean_Na_front,voltage_steps,2);
    % calculate values for a scatter plot I-V curve 
    % get y-values of the fit for specific x-values

        % IV_mean_NA_scatter_plotvalues = mean_cells_Na_fitresult_front(voltage_steps);
   

    % mean and standard deviation over all cells for Na+ current peak in the
    % back stimulus
    IV_total_median_Na_back = median(Na_back_current_peak_I_Imax_norm,2); 
    % fit of mean with Gauss
    [median_cells_Na_fitresult_back,gof2_Na_back] = fit_IV_func(IV_total_median_Na_back,voltage_steps,3);
    % calculate values for a scatter plot I-V curve 
    % get y-values of the fit for specific x-values
    IV_median_Na_scatter_plotvalues_backpulse = median_cells_Na_fitresult_back(voltage_steps);
    
    
    % take out the calculated fit coefficient values of the fit 
    NA_coeff_fit_median_back = coeffvalues(median_cells_Na_fitresult_back);    
    
    % locate the slope and midpoint from the fit into seperate variables 
    Na_slope_fit_median_back = coeff_fit_median_back(2);
    Na_slope_value_median_back = 1/Na_slope_fit_median_back; % calculate slope factor

    Na_midpoint_fit_median_back = coeff_fit_median_back(3);

end % end if-loop for mean, std and fitting



%% relocate the fits of the median into cell array which was filled earlier to save 
% fits of the mean over all cells will be just added as a further column
% behind all the alredy existing fits from this condition 

indiv_cell_fits{1,length(fileList)+2} = 'fit of median'; % fit (front) pulse
indiv_cell_fits{2,length(fileList)+2} = median_cell_fitresult;
indiv_cell_fits{3,length(fileList)+2} = gof2;
indiv_cell_fits{4,length(fileList)+2} = IV_median_scatter_plotvalues; % save scatter plot values under the correspomding fit

if exist('midpoint_fit_median','var') == 1 && ~isempty(midpoint_fit_median) == 1
    indiv_cell_fits{5,length(fileList)+2} = midpoint_fit_median; % V50 value from fit
    indiv_cell_fits{6,length(fileList)+2} = k_slope_value_median; % slope from fit

else % just leave space empty if not Bolzmann was used
    indiv_cell_fits{5,length(fileList)+2} = []; 
    indiv_cell_fits{6,length(fileList)+2} = []; 
end

% fill in the fit results of the mean of all cells of the second pulse if existing 
if ~isempty(KA_back_current_peak) == 1  % if variable exist in workspace (stimulus == 4)
    indiv_cell_fits{7,length(fileList)+2} = median_cells_fitresult_back; % fit back pulse
    indiv_cell_fits{8,length(fileList)+2} = gof2_back;
    indiv_cell_fits{9,length(fileList)+2} = IV_median_scatter_plotvalues_backpulse; % save scatter plot values under the correspomding fit
    indiv_cell_fits{10,length(fileList)+2} = midpoint_fit_median_back;
    indiv_cell_fits{11,length(fileList)+2} = k_slope_value_median_back;
end

%%% Na+

% fill Na+ current fit results of the mean over all cells of the front and
% back pulse into a table if analysis was done (stimulus == 4; A2)
if ~isempty(NA_back_current_peak) == 1

    Na_indiv_cell_fits{1,length(fileList)+2} = 'fit of median'; % title of column in table
   % Na_indiv_cell_fits{2,length(fileList)+2} = mean_cells_Na_fitresult_front; % fit front pulse
 %   Na_indiv_cell_fits{3,length(fileList)+2} = gof2_Na_front;
  %  Na_indiv_cell_fits{4,length(fileList)+2} = IV_mean_NA_scatter_plotvalues; % save scatter plot values under the correspomding fit
%    Na_indiv_cell_fits{5,length(fileList)+2} = V50_values_Na_frontpulse;

    % fill Na+ current fit results into cell array for the currents of the
    % second pulse of the stimulus protocol
    Na_indiv_cell_fits{7,length(fileList)+2} = median_cells_Na_fitresult_back; % fit back pulse
    Na_indiv_cell_fits{8,length(fileList)+2} = gof2_Na_back; 
    Na_indiv_cell_fits{9,length(fileList)+2} = IV_median_Na_scatter_plotvalues_backpulse; % save scatter plot values under the correspomding fit
    Na_indiv_cell_fits{10,length(fileList)+2} = Na_midpoint_fit_median_back;
    Na_indiv_cell_fits{11,length(fileList)+2} = Na_slope_value_median_back;

end % end if



%% explanatory cell for fit cell array
% creation and filling of an explanatory cell array. This cell array
% explains what can be found in each row of the cell array created above
% for the results of the curve fitting

fit_cell_array_explained{1,1} = 'Name of recording or mean. Content rowise is explained here. Each column contains all values calculated either from one recording (cell) or the mean of all the recordings (cells) listed before.'; 
fit_cell_array_explained{2,1} = 'result from fit function to plot'; 
fit_cell_array_explained{3,1} = 'Goodness-of-fit: values for determination for the goodness of the fit';
fit_cell_array_explained{4,1} = 'Calculated values for each voltage change to create an I-V scatter plot. Values calculated with the equation used for the fit'; 
fit_cell_array_explained{5,1} = 'V50 value calculated in fit of Bolzmann'; 
fit_cell_array_explained{6,1} = 'Slope of calculated Bolzmann fit. Stays empty if Bolzann was not used'; 

fit_cell_array_explained{7,1} = 'result from fit function to plot for the second pulse in the stimulus protocol if existent. Empty if non existent'; 
fit_cell_array_explained{8,1} = 'Goodness-of-fit: values for determination for the goodness of the fitfor the second pulse in the stimulus protocol if existent. Empty if non existent'; 
fit_cell_array_explained{9,1} = 'Calculated values for each voltage change to create an I-V scatter plot. Values calculated with the equation used for the fit  for the second pulse in the stimulus protocol if existent. Empty if non existent'; 
fit_cell_array_explained{10,1} = 'Midpoint (V50 value). For the mean calculated from the midpoints of all cells got from the Bolzmann fit. Position 2,1 contains the standard deviation corresponding to the mean at position 1,1. Position 1,2 containing the midpoint (V50) from the fit of the mean I-V curve'; 
fit_cell_array_explained{11,1} = 'Slope k. For the mean matrix containing at 1,1 the mean slope calculated from the slopes of all cells got from the Bolzmann fit. Position 2,1 contains the standard deviation corresponding to the mean at position 1,1. Position 1,2 containing the slope obtained from the Bolzmann fit of the mean I-V curve'; 


%% save everything in a struct
% all in the scripts created cell arrays, tables and vectors where data was
% stored will be collected here into one struct and will be save in the folder with the raw data. 
% Only arrays, tables and vectors used for the specific stimulus protocol
% will be saved

% relocate basic variables (included in every analysis) into struct
CRY4_A3_struct.stimulus_abbrevation = stimulus_abbrevation;
CRY4_A3_struct.time_vector = t;
CRY4_A3_struct.baseline = Baseline_K;
CRY4_A3_struct.voltage_steps = voltage_steps;
CRY4_A3_struct.normalization_val = Norm_fact;
CRY4_A3_struct.stim_calc = stimulus;
% relocate the exponenital fits 
if delayed_rectifier == 1
    CRY4_A3_struct.voltage_step_for_exp_and_calc = voltage_change_for_exp_fit;
    CRY4_A3_struct.sweep_for_exp_and_calc = exp_fit_sweep;
    CRY4_A3_struct.exponential_fit_values = exponential_fits_all_cells_30mV;
    CRY4_A3_struct.exponential_fit_cell_explained = exponential_fits_explained;
end

% relocate variables dependent on which analysis into struct
if stimulus == 1 || stimulus == 4 % relocation of KA data

    CRY4_A3_struct.A_peak_front = KA_front_current_peak;
    CRY4_A3_struct.A_timing_front = KA_front_current_timing;
    CRY4_A3_struct.A_peak_front_normalized = KA_front_current_peak_normalized_table;
    CRY4_A3_struct.A_peak_Imax_norm = KA_current_peak_Imax_norm_table;

    % when A2 protocol (stimulus == 4) were analyzed with its two pulses the associated
    % table will be included in the struct
    if ~isempty(KA_back_current_peak) == 1
        CRY4_A3_struct.A_peak_back = KA_back_current_peak;
        CRY4_A3_struct.A_timing_back = KA_back_current_timing;
        CRY4_A3_struct.A_peak_back_normalized = KA_back_current_peak_normalized_table;
        CRY4_A3_struct.A_peak_back_Imax_norm = KA_back_current_peak_Imax_norm_table;
    else
    end

elseif stimulus == 2 || stimulus == 3 % Calculation of K+ DR
    CRY4_A3_struct.mean_currents = K_current_mean;
    CRY4_A3_struct.mean_currents_normalized = K_current_mean_normalized_table;
    CRY4_A3_struct.mean_currents_Imax_norm = K_current_mean_Imax_norm_table;
end

% relocate basic variables (included in every analysis) into struct 
CRY4_A3_struct.IV_fits_explained = fit_cell_array_explained;
CRY4_A3_struct.IV_fits = indiv_cell_fits;
CRY4_A3_struct.Mean_std_overall = Mean_std_Kcurrent;

% when Na+ currents were analyzed the will be included in the struct
if ~isempty(NA_back_current_peak) == 1
    
%    A2_pretest_struct.Na_peak_front = NA_front_current_peak;
%    A2_pretest_struct.Na_timing_front = NA_front_current_timing;
    CRY4_A3_struct.Na_peak_back = NA_back_current_peak;
    CRY4_A3_struct.Na_timing_back = NA_back_current_timing;

 %   A2_pretest_struct.Na_peak_front_normalized = pre_Na_front_current_peak_normalized;
    CRY4_A3_struct.Na_peak_back_normalized = pre_Na_back_current_peak_normalized;
    
 %   A2_pretest_struct.Na_peak_front_Imax_norm = Na_front_current_peak_Imax_norm_table;
    CRY4_A3_struct.Na_peak_back_Imax_norm = Na_back_current_peak_Imax_norm_table;
    CRY4_A3_struct.Na_IV_fits = Na_indiv_cell_fits;
    CRY4_A3_struct.Na_Mean_std_overall = Na_Mean_std_current;

    
end 

%% save

% change folder with the raw data 
cd(dataPath)
% warning for own safety that nothing is overwritten by mistake 
f = warndlg('Change name and save!','Warning');

%% save struct in data folder
%%% You have to save it manually to avoid that any preceding struct will
%%% not be overwritten when its forgotten to change the name 

% save('CRY4_A3_struct','CRY4_A3_struct'); 

