%% Script for the raw plots for the Master thesis
%%% Author: Oda E. Riedesel
%%% Date: 2023
%
% This script includes the example raw data plots that were
% created for the SFB 1372 Winter 2023 Meeting poster and Master thesis. Here is also the code for the plotted correlation and the example for the exponential fit. 
%
% Sections:
% raw data plots:
%       Plots the raw recordings for transfected K2 cells. The workspace used for
%       this plot can be found in the .mat file: "Raw_data_plots.mat"
%
% Raw K2 cell -80 mV and -30 mV holding: 
%
%       Plots of the raw recordings from QNR/K2 cells with a holding
%       potential at -80 mV and -30 mV. Stimulus protocols are accrodingly
%       plotted into the plot of the raw recording. Both plots are beside
%       of each other.
%       For the poster is the option to plot the I-V curve of the -30 mV
%       holding potential data beside of both raw recordings
%      
% needed data :
%   raw data examples -->  workspaces were saved
%   workspace of the example trace of the exponential is as well saved
%   for the correlation the structs of the data analysis of each transfected
%   condition recorded at -30 mV is needed : 
%                                         KCNB1_pretest_struct.mat
%                                         KCNV2_struct.mat
%                                         KCNB1_KCNV2_struct.mat
%                                         CRY4_KCNB1_KCNV2_struct.mat
%                                         A3_pretest_struct.mat
%
% Matrix with the saved color codes for each condition: 
%                                         new_color_code.mat
%                                         raw_plot_color_code.mat
% *** Notes *** 
%%% The codes saving the figures as PDF were commented to avoid accidental
%%% saving before adjusting the plot as wished
%%%
%%%

%% Raw data plots
%%% Inactivation protocol (A2) example

figure % new figures

for sweep = 1:10 
    plot(t_A2,A2_pretest_recordings_filtered(:,1,sweep),'k') % all sweeps of example
    ylim([-300 400])
    xlim([0 260])
    
    % mark time where the baseline is calculated
    patch([2 2 22 22],[210 230 230 210],raw_plot_color_code(1,:),'FaceAlpha',0.09,'EdgeColor','none'); 
    % mark the peaks
    plot(A2_example_KA_back_pulse_and_timing(sweep,2),A2_example_KA_back_pulse_and_timing(sweep,1),'*','Color',raw_plot_color_code(2,:),'MarkerSize',9,'LineWidth',1);
     
    
    plot(Na_back_pulse_and_timing(sweep,2),Na_back_pulse_and_timing(sweep,1),'*','Color',raw_plot_color_code(3,:),'MarkerSize',9,'LineWidth',1);

    hold on
    ylabel('Current [pA]','FontSize',14)
    xlabel('Time [ms]','FontSize',14)
    
    box off
end

ax = gca; % get properties for current axles
ax.FontSize = 14; 
ax.LineWidth= 1.25; %change to the desired value     


raw_1 = get(gca, 'Position'); % get position of plot
axes('Parent', gcf, 'Position', [raw_1(1)+.56 raw_1(2)+.64 raw_1(3)-.58 raw_1(4)-.65]); % place inset in specific position and set size
hold on

for sweep = 1:10 
    % create smaller axes in top right, and plot on it
    plot(t_A2,A2_stim(:,sweep),'Color','k') % plot stimulus protocolm in inset 
end
% set properties for inset (child)
ylim([-125 70]) 
xlim([0 300])

ax = gca;
ax.FontSize = 12; 
ax.LineWidth= 1; %change to the desired value 
ax.TickLength = [0.03, 0.025];
ylabel('Voltage [mV]','FontSize',11)
xlabel('Time [ms]','FontSize',11)

% example how to save figues as PDF when child (inset) is included in
% figure

 % child = gcf;
 % exportgraphics(child,'A2_raw.pdf','ContentType','vector')


%% -40 (C6), -30 (A3) and -20 (C8) mV holding potential examples

figure('Position',[59,326,1196,387]);  % figure specific for three subplots beside of each other 

hold on
t_tiled = tiledlayout(1,3,'TileSpacing','compact'); % tile plot into three
a = nexttile; % first tile

for sweep = 1:17
    plot(t,C6_pretest_recordings_filtered(:,1,sweep),'k') % -40 mV example
    ylim([-120 450])
    yticks([-100 0 100 200 300 400])
    
    % Marks where the calculations happened
    patch([2 2 22 22],[73 90 90 73],raw_plot_color_code(1,:),'FaceAlpha',0.09,'EdgeColor','none'); % baseline calculation
    patch([93 93 123 123],[73 90 90 73],raw_plot_color_code(2,:),'FaceAlpha',0.09,'EdgeColor','none'); % mean current calculation

    hold on
    ylabel('Current [pA]','FontSize',14)
    xlabel('Time [ms]','FontSize',14)
    
    box off
end

ax = gca; % get axes properties
ax.FontSize = 14; 
ax.LineWidth= 1.25; %change to the desired value     
ax.TitleHorizontalAlignment = 'left'; % Alignment of the title for the first tile
ax.TickLength = [0.025, 0.025];

title('{\fontsize{25}A}') % Title of first tile 

b = nexttile; % second tile
for sweep = 1:17
    plot(t,A3_pretest_recordings_filtered(:,1,sweep),'k') % -30 mV example

    ylim([-120 450]) % set y-axis length
    yticks([-100 0 100 200 300 400]) % set y-axis ticks

    % Marks where the calculations happened
    patch([2 2 22 22],[73 90 90 73],raw_plot_color_code(1,:),'FaceAlpha',0.09,'EdgeColor','none'); % baseline calculation
    patch([93 93 123 123],[73 90 90 73],raw_plot_color_code(2,:),'FaceAlpha',0.09,'EdgeColor','none'); % mean current calculation 
    
    hold on
    xlabel('Time [ms]','FontSize',14)
    box off
   
end

   ax = gca;
   ax.FontSize = 14; 
   ax.LineWidth= 1.25; %change to the desired value     
   ax.TitleHorizontalAlignment = 'left'; % Alignment of the title for the second tile
   ax.TickLength = [0.025, 0.025];


   title('{\fontsize{25}B}') % Title of second tile 


c = nexttile;
for sweep = 1:17
    plot(t_C8,C8_pretest_recordings_filtered(:,1,sweep),'k') % -20 mV example
    ylim([-120 450])
    yticks([-100 0 100 200 300 400])
  
    % Marks where the calculations happened
    patch([2 2 22 22],[73 90 90 73],raw_plot_color_code(1,:),'FaceAlpha',0.09,'EdgeColor','none'); % baseline calculation 
    patch([93 93 123 123],[73 90 90 73],raw_plot_color_code(2,:),'FaceAlpha',0.09,'EdgeColor','none'); % mean current calculation
    
    hold on
    xlabel('Time [ms]','FontSize',14)
    box off
    
end

    ax = gca;
    ax.FontSize = 14; 
    ax.LineWidth= 1.25; %change to the desired value     

    ax.TitleHorizontalAlignment = 'left'; % Alignment of the title for the third tile
    ax.TickLength = [0.025, 0.025];

    title('{\fontsize{25}C}') % Title of third tile  


% focus and hold back to the first tile   
axes(a)

raw_1 = get(gca, 'Position'); % get axes of first tile 
axes('Parent', gcf, 'Position', [raw_1(1)+.045 raw_1(2)+.62 raw_1(3)-.17 raw_1(4)-.63]); % position the child (inset) 
hold on

for sweep = 1:17
    % create smaller axes in top right, and plot on it
    plot(t_C6,C6_stim(:,sweep),'Color','k') % plot stimulus protocol
end

ylim([-125 70])

ax = gca; % get axes of child (inset)
ax.FontSize = 12; 
ax.LineWidth= 1; %change to the desired value  
ax.TickLength = [0.03, 0.025];

% labels of child (inset)
ylabel('Voltage [mV]','FontSize',11)
xlabel('Time [ms]','FontSize',11)

% focus and hold back to the second tile 
axes(b)

raw_1 = get(gca, 'Position'); % get axes of second tile
axes('Parent', gcf, 'Position', [raw_1(1)+.045 raw_1(2)+.62 raw_1(3)-.17 raw_1(4)-.63]); % position the child (inset)
hold on

for sweep = 1:17
    % create smaller axes in top right, and plot on it
    plot(t,stim(:,sweep),'Color','k') % plot stimulus protocol
end

ylim([-125 70])

ax = gca; % get axes of child (inset)
ax.FontSize = 12; 
ax.LineWidth= 1; %change to the desired value    
ax.TickLength = [0.03, 0.025];

% labels of child (inset)
ylabel('Voltage [mV]','FontSize',11)
xlabel('Time [ms]','FontSize',11)


% focus and hold back to the third tile 
axes(c)

raw_1 = get(gca, 'Position'); % get axes of third tile
axes('Parent', gcf, 'Position', [raw_1(1)+.045 raw_1(2)+.62 raw_1(3)-.17 raw_1(4)-.63]); % position the child (inset)
hold on

for sweep = 1:17
    % create smaller axes in top right, and plot on it
    plot(t,C8_stim(:,sweep),'Color','k')
end

ylim([-125 70])

ax = gca; % get axes of child (inset)
ax.FontSize = 12; 
ax.LineWidth= 1; %change to the desired value  
ax.TickLength = [0.03, 0.025];

ylabel('Voltage [mV]','FontSize',11)
xlabel('Time [ms]','FontSize',11)

hold off
 
% save figues as PDF when child (inset) is included in figure
% child = gcf;
% exportgraphics(child,'C6_A3_C8_raw.pdf','ContentType','vector')

%% raw example plot, -80 mV holding potential with 100 ms stimulus (C5) and 1000 ms stimulus (C7) together

figure('Position',[136,307,861,381]); % figure size for two plots beside each other

hold on
tiled = tiledlayout(1,2,'TileSpacing','compact'); % two plots
a = nexttile; 

for sweep = 1:17
    plot(t,C5_pretest_recordings_filtered(:,1,sweep),'k') % 100 ms stimulus
    ylim([-500 1200])

    yticks([-400 0 400 800 1200])
    
    patch([2 2 22 22],[270 320 320 270],raw_plot_color_code(1,:),'FaceAlpha',0.09,'EdgeColor','none'); % mark baseline calculation
    patch([93 93 123 123],[270 320 320 270],raw_plot_color_code(2,:),'FaceAlpha',0.09,'EdgeColor','none'); % mark mean current calculation

    plot(KA_front_pulse_and_timing(sweep,2),KA_front_pulse_and_timing(sweep,1),'*','Color',raw_plot_color_code(2,:),'MarkerSize',9,'LineWidth',1); % mark A-type current peak calculation

    hold on
    ylabel('Current [pA]','FontSize',14)
    xlabel('Time [ms]','FontSize',14)
    
    box off
end

ax = gca;
ax.FontSize = 14; 
ax.LineWidth= 1.25; %change to the desired value     

ax.TitleHorizontalAlignment = 'left'; % Alignment of the title 
title('{\fontsize{20}A}')


b = nexttile;

for sweep = 1:17
    plot(t_C7,C7_pretest_recordings_filtered(:,1,sweep),'k') % 1000 ms stimulus
    
    % specify axes length
    ylim([-500 1200])
    xlim([0 1100])

    % specify ticks shown
    yticks([-400 0 400 800 1200])
    xticks([200 600 1000])

    % mark time where the baseline is calculated
    patch([2 2 22 22],[270 320 320 270],raw_plot_color_code(1,:),'FaceAlpha',0.09,'EdgeColor','none'); % mark baseline calculation
    patch([1000 1000 700 700],[270 320 320 270],raw_plot_color_code(2,:),'FaceAlpha',0.09,'EdgeColor','none'); % mark mean current calculation
   
    % mark the peaks
    plot(C7_example_KA_back_pulse_and_timing(sweep,2),C7_example_KA_back_pulse_and_timing(sweep,1),'*','Color',raw_plot_color_code(2,:),'MarkerSize',9,'LineWidth',1); % mark A-type current peak calculation
 
    hold on
    xlabel('Time [ms]','FontSize',14)
    
    box off
end

ax = gca;
ax.FontSize = 14; 
ax.LineWidth= 1.25; %change to the desired value     

xticks([0 500 1000])

ax.TitleHorizontalAlignment = 'left'; % Alignment of the title 
title('{\fontsize{20}B}')

% focus and hold back to the first tile   
axes(a)

raw_1 = get(gca, 'Position'); % get axes of first tile
axes('Parent', gcf, 'Position', [raw_1(1)+.22 raw_1(2)+.59 raw_1(3)-.23 raw_1(4)-.6]);  % position the child (inset)
hold on

for sweep = 1:17
    % create smaller axes in top right, and plot on it
    plot(t,stim(:,sweep),'Color','k')
end

ylim([-125 70])
xlim([-10 150])


ax = gca; % axes properties of child (inset)
ax.FontSize = 12; 
ax.LineWidth= 1; %change to the desired value     
ax.TickLength = [0.03, 0.025];

ylabel('Voltage [mV]','FontSize',11)
xlabel('Time [ms]','FontSize',11)


% focus and hold back to the second tile   
axes(b)

raw_1 = get(gca, 'Position'); % get axes of second tile
axes('Parent', gcf, 'Position', [raw_1(1)+.22 raw_1(2)+.59 raw_1(3)-.23 raw_1(4)-.6]);  % position the child (inset)
hold on

for sweep = 1:17
    % create smaller axes in top right, and plot on it
    plot(t_C7,C7_stim(:,sweep),'Color','k')
end

ylim([-125 70])
xlim([-100 1100])

ax = gca;% axes properties of child (inset)
ax.FontSize = 12; 
ax.LineWidth= 1; %change to the desired value  
ax.TickLength = [0.03, 0.025];

ylabel('Voltage [mV]','FontSize',11)
xlabel('Time [ms]','FontSize',11)

% save:
 % child = gcf;
 % exportgraphics(child,'C5_C7_raw.pdf','ContentType','vector')

%% Examplarly raw currents from all transfected conditions recorded at -30 mV holding potential

tiled = tiledlayout(2,2,'TileSpacing','compact'); % 4 by 4 plots in one figure 
nexttile % first figure upper left

for sweep = 1:17
    plot(t,KCNB1_recordings_filtered(:,1,sweep),'k') % KCNB1 transfection
    
    % axes settings
    ylim([-100 400])
    yticks([0 200 400])
    xticklabels([]) % empty x axis label
    hold on
    ylabel('Current [pA]')
    box off
    ax = gca;
    ax.FontSize = 14; 
    ax.LineWidth= 1; % change to the desired value     
    ax.TitleHorizontalAlignment = 'left'; % Figure title left orientated
    ax.TickLength = [0.025, 0.025];
    title('{\fontsize{20}A} - Kv2.1')
end

nexttile % second plot upper right
for sweep = 1:17
    plot(t_2,KCNV2_recordings_filtered(:,1,sweep),'k') % KCNV2 transfection
    hold on
    
    % axes settings
    xticklabels([]) % empty x axis label
    ylim([-100 400])
    yticks([0 200 400])
    box off
    ax = gca;
    ax.FontSize = 14; 
    ax.LineWidth= 1; %change to the desired value     
    ax.TitleHorizontalAlignment = 'left';  % Figure title left orientated
    ax.TickLength = [0.025, 0.025];
    title('{\fontsize{20}B} - Kv8.2')
end

hold off
nexttile % third plot lower left
for sweep = 1:17
    plot(t_2,KCNB1_KCNV2_recordings_filtered(:,1,sweep),'k') % KCNB1/KCNV2 transfection
    hold on

    % axes settings
    ylim([-100 400])
    yticks([0 200 400])
    xlabel('Time [ms]','FontSize',14)
    ylabel('Current [pA]','FontSize',14)
    box off
    ax = gca;
    ax.FontSize = 14; 
    ax.LineWidth= 1; %change to the desired value     
    ax.TitleHorizontalAlignment = 'left';  % Figure title left orientated
    ax.TickLength = [0.025, 0.025];

    title('{\fontsize{20}C} - Kv2.1/Kv8.2')

end
hold off

nexttile % fourth plot lower right
for sweep = 1:17
    plot(t,CRY4_recordings_filtered(:,1,sweep),'k') % KCNB1/KCNV2/Cry4 transfection
    hold on
    
    % axes settings
    ylim([-100 400])
    yticks([0 200 400])
    xlabel('Time [ms]','FontSize',14)
    box off
    ax = gca;
    ax.FontSize = 14; 
    ax.LineWidth= 1; %change to the desired value     
    ax.TitleHorizontalAlignment = 'left';  % Figure title left orientated
    ax.TickLength = [0.025, 0.025];

    title('{\fontsize{20}D} - Kv2.1/Kv8.2/Cry4')
end


% save:
 % exportgraphics(tiled,'A3_transfected_cond.pdf','ContentType','vector')

%% Examplarly raw currents from all transfected conditions recorded at -80 mV holding potential

figure
tiled = tiledlayout(2,2,'TileSpacing','compact'); % 4 by 4 plots in one figure

nexttile % first figure upper left
for sweep = 1:17
    plot(t_3000,KCNB1_C5_data_notchfiltered(:,1,sweep),'k')  % KCNB1 transfection
   
    % axes settings
    ylim([-400 1300])
    yticks([0 600 1200])
    xticklabels([]) % no x-axis label
    
    hold on
    ylabel('Current [pA]')
    box off
    ax = gca;
    ax.FontSize = 14; 
    ax.LineWidth= 1; %change to the desired value     
    ax.TitleHorizontalAlignment = 'left'; % Figure title left orientated
    ax.TickLength = [0.025, 0.025];

    title('{\fontsize{20}A} - Kv2.1')

end 
hold off

nexttile % second figure upper right
for sweep = 1:17
    plot(t_1500,KCNV2_C5_data_notchfiltered(:,1,sweep),'k')  % KCNV2 transfection
    hold on
  
    % axes settings
    xticklabels([])
    ylim([-400 1300])
    yticks([0 600 1200])
    box off
    ax = gca;
    ax.FontSize = 14; 
    ax.LineWidth= 1; %change to the desired value     
    ax.TitleHorizontalAlignment = 'left'; % Figure title left orientated
    ax.TickLength = [0.025, 0.025];

    title('{\fontsize{20}B} - Kv8.2')

end

hold off
nexttile % thirf figure lower left
for sweep = 1:17
    plot(t_3000,KCNB1_KCNV2_C5_data_notchfiltered(:,1,sweep),'k')  % KCNB1/KCNV2 transfection
    hold on

    % axes settings 
    ylim([-400 1300])
    yticks([0 600 1200])
    
    xlabel('Time [ms]','FontSize',14)
    ylabel('Current [pA]','FontSize',14)
    box off
    ax = gca;
    ax.FontSize = 14; 
    ax.LineWidth= 1; %change to the desired value     
    ax.TitleHorizontalAlignment = 'left'; % Figure title left orientated
    ax.TickLength = [0.025, 0.025];

    title('{\fontsize{20}C} - Kv2.1/Kv8.2')

end
hold off

nexttile % fourth figure lower right
for sweep = 1:17
    plot(t_1500,CRY4_C5_data_notchfiltered(:,1,sweep),'k') % KCNB1/KCNV2/Cry4 transfection
    hold on
   
    % axes settings 
    ylim([-400 1300])
    yticks([0 600 1200])
    xlabel('Time [ms]','FontSize',14)
    box off
    ax = gca;
    ax.FontSize = 14; 
    ax.LineWidth= 1; %change to the desired value   
    ax.TitleHorizontalAlignment = 'left'; % Figure title left orientated
    ax.TickLength = [0.025, 0.025];

    title('{\fontsize{20}D} - Kv2.1/Kv8.2/Cry4')

end

 
% save:
 % exportgraphics(tiled,'C5_transfected_cond.pdf','ContentType','vector')

%% Example plot of the exponential fit

% set axis 
t = 0:0.05:150-0.05;
y1 = 0:108; 
x1(1,1:109) = 30;
x2(1,1:109) = 125;
x3 = 30:125;
y3(1,1:96) = 0;
y4(1,1:96) = 108;


figure % plot example current not extra smoothed with exponential fit 
hold on

plot(t,recordings_filtered(:,1,14),'Color','k','LineWidth',1) % current
plot(t_subset+t(722),y_new,'LineWidth',2) % fit

% plot grey box around to create visible cut-out
plot(x1,y1,'Color',[.2 .2 .2],'LineWidth',0.5)
plot(x2,y1,'Color',[.2 .2 .2],'LineWidth',0.5)
plot(x3,y3,'Color',[.2 .2 .2],'LineWidth',0.5)
plot(x3,y4,'Color',[.2 .2 .2],'LineWidth',0.5)

% axes settings 
ylim([-20 125])
yticks([-20 0 20 40 60 80 100 120])

ax = gca;
ax.XTickLabelRotation = 0;
ax.FontSize = 13; 
ax.LineWidth= 1; %change to the desired value     
ax.Position = [0.13,0.149643705463183,0.789064748201439,0.774346793349169];

xlabel('Time [ms]','FontSize',15)
ylabel('Current [pA]','FontSize',15)
legend('','Double exponential fit','Location','northwest','Orientation', 'Horizontal','Box','off')

% save:
% ax = gca;
% exportgraphics(ax,'exp_fit_raw.pdf','ContentType','vector')


%% plot example current smoothed with resulted fit

figure 
hold on

plot(t_subset+t(722),smoothie(:,1),'Color','k','LineWidth',1) % current
plot(t_subset+t(722),y_new,'LineWidth',2)  % fit

% axes settings 
ylim([-20 110])
yticks([-20 0 20 40 60 80 100])

ax = gca;
ax.XTickLabelRotation = 0;
ax.FontSize = 13; 
ax.LineWidth= 1; %change to the desired value     
ax.Position = [0.13,0.149643705463183,0.789064748201439,0.774346793349169];

xlabel('Time [ms]','FontSize',15)
ylabel('Current [pA]','FontSize',15)

xticks([0 50 100 150])

% save:
% ax = gca;
% exportgraphics(ax,'exp_fit_raw_inset.pdf','ContentType','vector')


%% Correlation plot

% take out all V50 and slope values
KCNB1_V50 = cell2mat(KCNB1_A3_struct.IV_fits(5,1:size(KCNB1_A3_struct.IV_fits,2)-2));
KCNB1_slope = cell2mat(KCNB1_A3_struct.IV_fits(6,1:size(KCNB1_A3_struct.IV_fits,2)-2));

KCNV2_V50 = cell2mat(KCNV2_A3_struct.IV_fits(5,1:size(KCNV2_A3_struct.IV_fits,2)-2));
KCNV2_slope = cell2mat(KCNV2_A3_struct.IV_fits(6,1:size(KCNV2_A3_struct.IV_fits,2)-2));

KCNB1_KCNV2_V50 = cell2mat(KCNB1_KCNV2_A3_struct.IV_fits(5,1:size(KCNB1_KCNV2_A3_struct.IV_fits,2)-2));
KCNB1_KCNV2_slope = cell2mat(KCNB1_KCNV2_A3_struct.IV_fits(6,1:size(KCNB1_KCNV2_A3_struct.IV_fits,2)-2));

CRY4_V50 = cell2mat(CRY4_A3_struct.IV_fits(5,1:size(CRY4_A3_struct.IV_fits,2)-2));
CRY4_slope = cell2mat(CRY4_A3_struct.IV_fits(6,1:size(CRY4_A3_struct.IV_fits,2)-2));

A3_V50 = cell2mat(A3_pretest_struct_mean.IV_fits(5,1:size(A3_pretest_struct_mean.IV_fits,2)-2));
A3_slope = cell2mat(A3_pretest_struct_mean.IV_fits(6,1:size(A3_pretest_struct_mean.IV_fits,2)-2));

figure
hold on
box off

% plot all V50 values with
% their corresponding slope value 
% colors depends on the condition 
plot(KCNB1_slope,KCNB1_V50,'*','Color',new_color_code(1,:),'MarkerSize',10,'LineWidth',1)
plot(KCNV2_slope,KCNV2_V50,'*','Color',new_color_code(2,:),'MarkerSize',10,'LineWidth',1)
plot(KCNB1_KCNV2_slope,KCNB1_KCNV2_V50,'*','Color',new_color_code(3,:),'MarkerSize',10,'LineWidth',1)
plot(CRY4_slope,CRY4_V50,'*','Color',new_color_code(4,:),'MarkerSize',10,'LineWidth',1)
plot(A3_slope,A3_V50,'*','Color',new_color_code(5,:),'MarkerSize',10,'LineWidth',1)


% axes settings 
ylim([-2 52])
yticks([0 10 20 30 40 50])

xlim([0 17])
ax = gca;
ax.XTickLabelRotation = 0;
ax.FontSize = 14; 
ax.LineWidth= 1; %change to the desired value     
ax.Position = [0.13,0.149643705463183,0.789064748201439,0.774346793349169];


xlabel('Voltage sensitivity per e-fold increase [mV]','FontSize',14) % voltage dependence of activation
ylabel('V_{50} [mV]','FontSize',14)

legend('Kv2.1','Kv8.2','Kv2.1/Kv8.2','Kv2.1/Kv8.2/Cry4','Control','Location','southwest','FontSize',15,'Box','off')

text(14.75,50,'r  = -0.031','HorizontalAlignment','center','FontSize',15) % spearmans correlation test results
text(14.75,47,'p =  0.869','HorizontalAlignment','center','FontSize',15)

% save:
% ax = gca;
% exportgraphics(ax,'correlation.pdf','ContentType','vector')


%% example of how to save
% ax = gca;
% exportgraphics(ax,'correlation.pdf','ContentType','vector')
 
