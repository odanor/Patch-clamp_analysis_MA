%% Script for the boxplotsfor the Master thesis
%%% Author: Oda E. Riedesel
%%% Date: 2024
%
% This script includes the plots for the median and IQR calculations of the current amplitude, V50 and slope k, and the tau from the exponential fits 
% for the Master thesis. 
% 
% needed data :
% the structs of the data analysis of each transfected
% condition recorded at -30 mV is needed : 
%                                         KCNB1_pretest_struct.mat
%                                         KCNV2_struct.mat
%                                         KCNB1_KCNV2_struct.mat
%                                         CRY4_KCNB1_KCNV2_struct.mat
%                                         A3_pretest_struct.mat
%
% and the structs of the data analysis of each transfected
% condition recorded at -80 mV : 
%                                         KCNB1_C5_struct_mean.mat
%                                         KCNV2_C5_struct_mean.mat
%                                         KCNB1_KCNV2_C5_struct_mean.mat
%                                         CRY4_C5_struct_mean.mat
%                                         C5_pretest_struct_mean.mat
%
%                                         KCNB1_C5_struct_peak.mat
%                                         KCNV2_C5_struct_peak.mat
%                                         KCNB1_KCNV2_C5_struct_peak.mat
%                                         CRY4_C5_struct_peak.mat
%                                         C5_pretest_struct_peak.mat
%
% further needed structs: 
%                                         A2_pretest_struct_peak
%                                         C7_pretest_struct_mean
%                                         C7_pretest_struct_peak
%                                         C6_pretest_struct_mean
%                                         C8_pretest_struct_mean
%
% matrix with the saved color codes for each condition: 
%                                         new_color_code.mat
% *** Notes *** 
%%% 
%%%
%%%

%% Current amplitude, ransfected conditions, -30 mV holding potential 

cd '/Users/oda/Desktop/Uni/Master/MA/Daten/Matlabscrips'

% store the current amplitude at +30 mV for each cell into seperate variables
KCNB1 = KCNB1_A3_struct.mean_currents_normalized(14,:);
KCNV2 = KCNV2_A3_struct.mean_currents_normalized(14,:);
KCNB1_KCNV2 = KCNB1_KCNV2_A3_struct.mean_currents_normalized(14,:);
CRY4 =  CRY4_A3_struct.mean_currents_normalized(14,:);
Control = A3_pretest_struct_mean.mean_currents_normalized(14,:);

figure
box off
hold on


% transparent_errorbar_fig(cells,Cell_color_code,Cell_color_code_transparent,num_cond,mode,handle_visibility_legend,handle_visibility_dots)

% run function to create transparent IQR and create plot
transparent_errorbar_fig(KCNB1,new_color_code(1,:),new_color_code_transparent(1,:),1,2,0,0)
transparent_errorbar_fig(KCNV2,new_color_code(2,:),new_color_code_transparent(2,:),1.25,2,0,0)
transparent_errorbar_fig(KCNB1_KCNV2,new_color_code(3,:),new_color_code_transparent(3,:),1.5,2,0,0)
transparent_errorbar_fig(CRY4,new_color_code(4,:),new_color_code_transparent(4,:),1.75,2,0,0)
transparent_errorbar_fig(Control,new_color_code(5,:),new_color_code_transparent(5,:),2,2,1,0)

legend('Median across cells','Location','northeast','Box','off')

% set axis properties
ylim([-20 200])
yticks([0 50 100 150 200])
xlim([0.95 2.05])
xticks([1 1.25 1.5 1.75 2]) 
xticklabels({sprintf('Kv2.1'),sprintf('Kv8.2'),sprintf('Kv2.1/Kv8.2'),sprintf('       Kv2.1/ \\newline   Kv8.2/Cry4'), sprintf('Control')})
ax = gca;
ax.XTickLabelRotation = 0;
ax.FontSize = 14; 
ax.LineWidth= 1;      
ax.Position = [0.13,0.149643705463183,0.789064748201439,0.774346793349169];

% include text under x-axis lables with sample size 
text(1,-55,'n = 5','HorizontalAlignment','center','FontSize',14)
text(1.25,-55,'n = 4','HorizontalAlignment','center','FontSize',14)
text(1.5,-55,'n = 6','HorizontalAlignment','center','FontSize',14)
text(1.75,-55,'n = 10','HorizontalAlignment','center','FontSize',14)
text(2,-55,'n = 5','HorizontalAlignment','center','FontSize',14)


ylabel('Current [pA]/10pF capacitance of cell membrane','FontSize',14)

% save:
% ax = gca;
% exportgraphics(ax,'A3_current_size.pdf','ContentType','vector')

%% Current amplitude, ransfected conditions, -80 mV holding potential peak IA showing outlier

cd '/Users/oda/Desktop/Uni/Master/MA/Daten/Matlabscrips'

% store the current amplitude at +30 mV for each cell into seperate variables
KCNB1 = KCNB1_C5_struct_peak.A_peak_front_normalized(14,:);
KCNV2 = KCNV2_C5_struct_peak.A_peak_front_normalized(14,:);
KCNB1_KCNV2 = KCNB1_KCNV2_C5_struct_peak.A_peak_front_normalized(14,:);
CRY4 =  CRY4_C5_struct_peak.A_peak_front_normalized(14,:);
Control = C5_pretest_struct_peak.A_peak_front_normalized(14,:);

figure
box off
hold on

%transparent_errorbar_fig(cells,Cell_color_code,Cell_color_code_transparent,num_cond,mode,handle_visibility_legend,handle_visibility_dots)
% run function to create transparent IQR and create plot
transparent_errorbar_fig(KCNB1,new_color_code(1,:),new_color_code_transparent(1,:),1,2,0,0)
transparent_errorbar_fig(KCNV2,new_color_code(2,:),new_color_code_transparent(2,:),1.25,2,0,0)
transparent_errorbar_fig(KCNB1_KCNV2,new_color_code(3,:),new_color_code_transparent(3,:),1.5,2,0,0)
transparent_errorbar_fig(CRY4,new_color_code(4,:),new_color_code_transparent(4,:),1.75,2,0,0)
transparent_errorbar_fig(Control,new_color_code(6,:),new_color_code_transparent(6,:),2,2,1,0)

legend('Median across cells','Location','northeast','Box','off')

% set axis properties
ylim([-900 4250])
xlim([0.95 2.05])
xticks([1 1.25 1.5 1.75 2])
xticklabels({sprintf('Kv2.1'),sprintf('Kv8.2'),sprintf('Kv2.1/Kv8.2'),sprintf('       Kv2.1/ \\newline   Kv8.2/Cry4'), sprintf('Control')})
yticks([0 1000 2000 3000 4000])
ax = gca;
ax.XTickLabelRotation = 0;
ax.FontSize = 14; 
ax.LineWidth= 1;   
ax.Position = [0.13,0.149643705463183,0.789064748201439,0.774346793349169];

% include text under x-axis lables with sample size 
text(1,-1750,'n = 7','HorizontalAlignment','center','FontSize',14)
text(1.25,-1750,'n = 4','HorizontalAlignment','center','FontSize',14)
text(1.5,-1750,'n = 4','HorizontalAlignment','center','FontSize',14)
text(1.75,-1750,'n = 4','HorizontalAlignment','center','FontSize',14)
text(2,-1750,'n = 8','HorizontalAlignment','center','FontSize',14)


ylabel('Current [pA]/10pF capacitance of cell membrane','FontSize',14)


%%% save:
% ax = gca;
% exportgraphics(ax,'C5_current_amplitude_transfected_outlier.pdf','ContentType','vector')



%% Current amplitude, ransfected conditions, -80 mV holding potential peak IA and mean IK

cd '/Users/oda/Desktop/Uni/Master/MA/Daten/Matlabscrips'


figure('Position',[54,247,1094,486]) 

tiledlayout(1,2,'TileSpacing','compact'); % 1x2 figure 
nexttile %%% IA peak

% store the current amplitude at +30 mV for each cell into seperate variables
KCNB1_peak = KCNB1_C5_struct_peak.A_peak_front_normalized(14,:);
KCNB1_peak = KCNB1_peak(1,1:6);
KCNV2_peak = KCNV2_C5_struct_peak.A_peak_front_normalized(14,:);
KCNB1_KCNV2_peak = KCNB1_KCNV2_C5_struct_peak.A_peak_front_normalized(14,:);
CRY4_peak =  CRY4_C5_struct_peak.A_peak_front_normalized(14,:);
Control_peak = C5_pretest_struct_peak.A_peak_front_normalized(14,:);

box off
hold on

%transparent_errorbar_fig(cells,Cell_color_code,Cell_color_code_transparent,num_cond,mode,handle_visibility_legend,handle_visibility_dots)
% run function to create transparent IQR and create plot
transparent_errorbar_fig(KCNB1_peak,new_color_code(1,:),new_color_code_transparent(1,:),1,2,0,0)
transparent_errorbar_fig(KCNV2_peak,new_color_code(2,:),new_color_code_transparent(2,:),1.25,2,0,0)
transparent_errorbar_fig(KCNB1_KCNV2_peak,new_color_code(3,:),new_color_code_transparent(3,:),1.5,2,0,0)
transparent_errorbar_fig(CRY4_peak,new_color_code(4,:),new_color_code_transparent(4,:),1.75,2,0,0)
transparent_errorbar_fig(Control_peak,new_color_code(6,:),new_color_code_transparent(6,:),2,2,0,0)

% set axis properties
ylim([-100 900])
yticks([0 200 400 600 800])
xlim([0.95 2.05])
xticks([1 1.25 1.5 1.75 2])
xticklabels({sprintf('Kv2.1'),sprintf('Kv8.2'),sprintf('Kv2.1/Kv8.2'),sprintf('       Kv2.1/ \\newline   Kv8.2/Cry4'), sprintf('Control')})
ax = gca;
ax.XTickLabelRotation = 0;
ax.FontSize = 14; 
ax.LineWidth= 1; %change to the desired value     
ax.Position = [0.13,0.149643705463183,0.789064748201439,0.774346793349169];
ax.TitleHorizontalAlignment = 'left';

% include text under x-axis lables with sample size 
text(1,-220,'n = 6','HorizontalAlignment','center','FontSize',14)
text(1.25,-220,'n = 4','HorizontalAlignment','center','FontSize',14)
text(1.5,-220,'n = 4','HorizontalAlignment','center','FontSize',14)
text(1.75,-220,'n = 4','HorizontalAlignment','center','FontSize',14)
text(2,-220,'n = 8','HorizontalAlignment','center','FontSize',14)

title('{\fontsize{20}A}')
ylabel('Current [pA]/10pF capacitance of cell membrane','FontSize',14)


nexttile %%% IK mean

% store the current amplitude at +30 mV for each cell into seperate variables
KCNB1 = KCNB1_C5_struct_mean.mean_currents_normalized(14,:);
KCNB1 = KCNB1(1,1:6);
KCNV2 = KCNV2_C5_struct_mean.mean_currents_normalized(14,:);
KCNB1_KCNV2 = KCNB1_KCNV2_C5_struct_mean.mean_currents_normalized(14,:);
CRY4 =  CRY4_C5_struct_mean.mean_currents_normalized(14,:);
Control = C5_pretest_struct_mean.mean_currents_normalized(14,:);

box off
hold on

%transparent_errorbar_fig(cells,Cell_color_code,Cell_color_code_transparent,num_cond,mode,handle_visibility_legend,handle_visibility_dots)
% run function to create transparent IQR and create plot
transparent_errorbar_fig(KCNB1,new_color_code(1,:),new_color_code_transparent(1,:),1,2,0,0)
transparent_errorbar_fig(KCNV2,new_color_code(2,:),new_color_code_transparent(2,:),1.25,2,0,0)
transparent_errorbar_fig(KCNB1_KCNV2,new_color_code(3,:),new_color_code_transparent(3,:),1.5,2,0,0)
transparent_errorbar_fig(CRY4,new_color_code(4,:),new_color_code_transparent(4,:),1.75,2,0,0)
transparent_errorbar_fig(Control,new_color_code(6,:),new_color_code_transparent(6,:),2,2,1,0)

% set axis properties
ylim([-100 900])
yticks([0 200 400 600 800])
xlim([0.95 2.05])
xticks([1 1.25 1.5 1.75 2])
xticklabels({sprintf('Kv2.1'),sprintf('Kv8.2'),sprintf('Kv2.1/Kv8.2'),sprintf('       Kv2.1/ \\newline   Kv8.2/Cry4'), sprintf('Control')})
ax = gca;
ax.XTickLabelRotation = 0;
ax.FontSize = 14; 
ax.LineWidth= 1; %change to the desired value     
ax.Position = [0.13,0.149643705463183,0.789064748201439,0.774346793349169];
ax.TitleHorizontalAlignment = 'left';

% include text under x-axis lables with sample size 
text(1,-220,'n = 6','HorizontalAlignment','center','FontSize',14)
text(1.25,-220,'n = 4','HorizontalAlignment','center','FontSize',14)
text(1.5,-220,'n = 4','HorizontalAlignment','center','FontSize',14)
text(1.75,-220,'n = 4','HorizontalAlignment','center','FontSize',14)
text(2,-220,'n = 8','HorizontalAlignment','center','FontSize',14)


title('{\fontsize{20}B}')
legend('Median across cells','Location','northeast','Orientation', 'Horizontal','Box','off');
 % child = gcf;
 % exportgraphics(child,'C5_current_amplitude_transfected.pdf','ContentType','vector')


%% Current amplitude, -40 mV (C6), -30 mV (A3) and -20 mV (C8) holding potential
cd '/Users/oda/Desktop/Uni/Master/MA/Daten/Matlabscrips'

% store the current amplitude at +30 mV for each cell into seperate variables
C6 = C6_pretest_struct_mean.mean_currents_normalized(14,:);
A3 = A3_pretest_struct_mean.mean_currents_normalized(14,:);
C8 = C8_pretest_struct_mean.mean_currents_normalized(14,:);

figure
box off
hold on

%transparent_errorbar_fig(cells,Cell_color_code,Cell_color_code_transparent,num_cond,mode,handle_visibility_legend,handle_visibility_dots)
% run function to create transparent IQR and create plot
transparent_errorbar_fig(C6,new_color_code(7,:),new_color_code_transparent(7,:),1,2,0,0)
transparent_errorbar_fig(A3,new_color_code(5,:),new_color_code_transparent(5,:),1.25,2,0,0)
transparent_errorbar_fig(C8,new_color_code(8,:),new_color_code_transparent(8,:),1.5,2,1,0)

legend('Median across cells','Location','northeast','Box','off')

% set axis properties
ylim([-13 60])
xlim([0.95 1.55])
xticks([1 1.25 1.5])
xticklabels({sprintf('-40'),sprintf('-30'),sprintf('-20')})
ax = gca;
ax.XTickLabelRotation = 0;
ax.FontSize = 14; 
ax.LineWidth= 1;  
ax.Position = [0.13,0.149643705463183,0.789064748201439,0.774346793349169];

% include text under x-axis lables with sample size 
text(1,-20,'n = 2','HorizontalAlignment','center','FontSize',14)
text(1.25,-20,'n = 5','HorizontalAlignment','center','FontSize',14)
text(1.5,-20,'n = 3','HorizontalAlignment','center','FontSize',14)

ylabel('Current [pA]/10pF capacitance of cell membrane','FontSize',14)
xlabel('Holding potential [mV]','FontSize',14,'Position',[1.250000256299955,-23,-1])


%%% save:
% ax = gca;
% exportgraphics(ax,'C6_A3_C8_current_size.pdf','ContentType','vector')


%% Current amplitude, -80 mV holding potential,100 ms and 1000 ms, IA peak and IK mean in one fig beside each other 


cd '/Users/oda/Desktop/Uni/Master/MA/Daten/Matlabscrips'
% store the current amplitude at +30 mV for each cell into seperate variables
%%% IK mean
C5_mean = C5_pretest_struct_mean.mean_currents_normalized(14,:);
C7_mean = C7_pretest_struct_mean.mean_currents_normalized(14,:);

%%% IA peak
C5_peak = C5_pretest_struct_peak.A_peak_front_normalized(14,:);
C7_peak = C7_pretest_struct_peak.A_peak_front_normalized(14,:);

figure 
box off
hold on

%transparent_errorbar_fig(cells,Cell_color_code,Cell_color_code_transparent,num_cond,mode,handle_visibility_legend,handle_visibility_dots)
% run function to create transparent IQR and create plot
transparent_errorbar_fig(C5_peak,new_color_code(6,:),new_color_code_transparent(6,:),1,2,0,0)
transparent_errorbar_fig(C7_peak,new_color_code(9,:),new_color_code_transparent(9,:),1.25,2,1,0)

transparent_errorbar_fig(C5_mean,new_color_code(6,:),new_color_code_transparent(6,:),1.75,2,0,0)
transparent_errorbar_fig(C7_mean,new_color_code(9,:),new_color_code_transparent(9,:),2,2,0,0)


legend('Median across cells','Location','northoutside','Position', [0.376785731068527,0.93,0.295535714285714,0.058333333333333],'Box','off')

% set axis properties
ylim([-250 1000])
yticks([-200 0 200 400 600 800 1000])
xlim([0.8 2.2])
xticks([1 1.25 1.75 2])
xticklabels({sprintf(' 100 ms \\newline   pulse'),sprintf(' 1000 ms \\newline    pulse'),sprintf(' 100 ms \\newline   pulse'),sprintf(' 1000 ms \\newline    pulse')})
ax = gca;
ax.XTickLabelRotation = 0;
ax.FontSize = 14; 
ax.LineWidth= 1;     
ax.Position = [0.13,0.149643705463183,0.789064748201439,0.774346793349169];

% include text under x-axis lables with sample size 
text(1,-445,'n = 8','HorizontalAlignment','center','FontSize',14)
text(1.25,-445,'n = 4','HorizontalAlignment','center','FontSize',14)
text(1.75,-445,'n = 8','HorizontalAlignment','center','FontSize',14)
text(2,-445,'n = 4','HorizontalAlignment','center','FontSize',14)

ylabel('Current [pA]/10pF capacitance of cell membrane','FontSize',14)

% include text which plot includes the peak and which the mean calculated
% data
text(1.125,950,'A-type peak','HorizontalAlignment','center','FontSize',16)
text(1.89,950,'Mean current','HorizontalAlignment','center','FontSize',16)


%%% save:
% ax = gca;
% exportgraphics(ax,'C5_C7_current_amplitude_bearbeitet.pdf','ContentType','vector')

%% V50 plots

%% V50 all transfections together at -30 mV holding potential (A3) with control 

cd '/Users/oda/Desktop/Uni/Master/MA/Daten/Matlabscrips'

% store the V50 values for each cell into seperate variables
KCNB1 = cell2table(KCNB1_A3_struct.IV_fits(5,1:size(KCNB1_A3_struct.IV_fits,2)-2));
KCNV2 = cell2table(KCNV2_A3_struct.IV_fits(5,1:size(KCNV2_A3_struct.IV_fits,2)-2));
KCNB1_KCNV2 = cell2table(KCNB1_KCNV2_A3_struct.IV_fits(5,1:size(KCNB1_KCNV2_A3_struct.IV_fits,2)-2));
CRY4 =  cell2table(CRY4_A3_struct.IV_fits(5,1:size(CRY4_A3_struct.IV_fits,2)-2));
Control = cell2table(A3_pretest_struct_mean.IV_fits(5,1:size(A3_pretest_struct_mean.IV_fits,2)-2));

figure 
box off
hold on

%transparent_errorbar_fig(cells,Cell_color_code,Cell_color_code_transparent,num_cond,mode,handle_visibility_legend,handle_visibility_dots)
% run function to create transparent IQR and create plot for each
% condition

transparent_errorbar_fig(KCNB1,new_color_code(1,:),new_color_code_transparent(1,:),1,2,0,0)
transparent_errorbar_fig(KCNV2,new_color_code(2,:),new_color_code_transparent(2,:),1.25,2,0,0)
transparent_errorbar_fig(KCNB1_KCNV2,new_color_code(3,:),new_color_code_transparent(3,:),1.5,2,0,0)
transparent_errorbar_fig(CRY4,new_color_code(4,:),new_color_code_transparent(4,:),1.75,2,0,0)
transparent_errorbar_fig(Control,new_color_code(5,:),new_color_code_transparent(5,:),2,2,1,0)

legend('Median V_{50} across cells','Location','northwest','Box','off')

% set axis properties
ylim([0 60])
xlim([0.95 2.05])
xticks([1 1.25 1.5 1.75 2])
xticklabels({sprintf('Kv2.1'),sprintf('Kv8.2'),sprintf('Kv2.1/Kv8.2'),sprintf('       Kv2.1/ \\newline   Kv8.2/Cry4'), sprintf('Control')})
ax = gca;
ax.XTickLabelRotation = 0;
ax.FontSize = 14; 
ax.LineWidth= 1; %change to the desired value     
ax.Position = [0.13,0.149643705463183,0.789064748201439,0.774346793349169];

% include text under x-axis lables with sample size 
text(1,-9,'n = 5','HorizontalAlignment','center','FontSize',14)
text(1.25,-9,'n = 4','HorizontalAlignment','center','FontSize',14)
text(1.5,-9,'n = 6','HorizontalAlignment','center','FontSize',14)
text(1.75,-9,'n = 10','HorizontalAlignment','center','FontSize',14)
text(2,-9,'n = 5','HorizontalAlignment','center','FontSize',14)

% include line and star for significance
line = 1.5:0.05:1.75;
y_line = [54 54 54 54 54 54];

plot(line,y_line,'Color','k','LineWidth',1,'HandleVisibility','off')
plot(1.625,56,'*','Color','k','LineWidth',1,'HandleVisibility','off','MarkerSize',8)
ylabel('Voltage [mV]','FontSize',14)


%%% save:
% ax = gca;
% exportgraphics(ax,'V50_A3.pdf','ContentType','vector')

%% V50 all transfections together at -80 mV holding potential (C5) with control 

cd '/Users/oda/Desktop/Uni/Master/MA/Daten/Matlabscrips'

% store the V50 values for each cell into seperate variables
KCNB1_peak = cell2table(KCNB1_C5_struct_peak.IV_fits(5,1:size(KCNB1_C5_struct_peak.IV_fits,2)-2));
KCNV2_peak = cell2table(KCNV2_C5_struct_peak.IV_fits(5,1:size(KCNV2_C5_struct_peak.IV_fits,2)-2));
KCNB1_KCNV2_peak = cell2table(KCNB1_KCNV2_C5_struct_peak.IV_fits(5,1:size(KCNB1_KCNV2_C5_struct_peak.IV_fits,2)-2));
CRY4_peak = cell2table(CRY4_C5_struct_peak.IV_fits(5,1:size(CRY4_C5_struct_peak.IV_fits,2)-2));
Control_peak = cell2table(C5_pretest_struct_peak.IV_fits(5,1:size(C5_pretest_struct_peak.IV_fits,2)-2));

figure('Position',[54,247,1094,486]) % figure with two plots

tiled = tiledlayout(1,2,'TileSpacing','compact');
nexttile % IA peaks
box off
hold on

%transparent_errorbar_fig(cells,Cell_color_code,Cell_color_code_transparent,num_cond,mode,handle_visibility_legend,handle_visibility_dots)
% run function to create transparent IQR and create plot for each
% condition
transparent_errorbar_fig(KCNB1_peak,new_color_code(1,:),new_color_code_transparent(1,:),1,2,0,0)
transparent_errorbar_fig(KCNV2_peak,new_color_code(2,:),new_color_code_transparent(2,:),1.25,2,0,0)
transparent_errorbar_fig(KCNB1_KCNV2_peak,new_color_code(3,:),new_color_code_transparent(3,:),1.5,2,0,0)
transparent_errorbar_fig(CRY4_peak,new_color_code(4,:),new_color_code_transparent(4,:),1.75,2,0,0)
transparent_errorbar_fig(Control_peak,new_color_code(6,:),new_color_code_transparent(6,:),2,2,0,0)

% set axis properties
ylim([3 45])
yticks([10 20 30 40])
xlim([0.95 2.05])
xticks([1 1.25 1.5 1.75 2])
xticklabels({sprintf('Kv2.1'),sprintf('Kv8.2'),sprintf('Kv2.1/Kv8.2'),sprintf('       Kv2.1/ \\newline   Kv8.2/Cry4'), sprintf('Control')})
ax = gca;
ax.XTickLabelRotation = 0;
ax.FontSize = 13; 
ax.LineWidth= 1;      
ax.Position = [0.13,0.149643705463183,0.789064748201439,0.774346793349169];
ax.TitleHorizontalAlignment = 'left';

% include text under x-axis lables with sample size 
text(1,-1.7,'n = 7','HorizontalAlignment','center','FontSize',14)
text(1.25,-1.7,'n = 4','HorizontalAlignment','center','FontSize',14)
text(1.5,-1.7,'n = 4','HorizontalAlignment','center','FontSize',14)
text(1.75,-1.7,'n = 4','HorizontalAlignment','center','FontSize',14)
text(2,-1.7,'n = 8','HorizontalAlignment','center','FontSize',14)
title('{\fontsize{20}A}')

ylabel('Voltage [mV]','FontSize',14)


%%%%%%%%%%%%%%%%%

nexttile %%% IK mean 
hold on
box off

% store the V50 values for each cell into seperate variables
KCNB1 = cell2table(KCNB1_C5_struct_mean.IV_fits(5,1:size(KCNB1_C5_struct_mean.IV_fits,2)-2));
KCNV2 = cell2table(KCNV2_C5_struct_mean.IV_fits(5,1:size(KCNV2_C5_struct_mean.IV_fits,2)-2));
KCNB1_KCNV2 = cell2table(KCNB1_KCNV2_C5_struct_mean.IV_fits(5,1:size(KCNB1_KCNV2_C5_struct_mean.IV_fits,2)-2));
CRY4 =  cell2table(CRY4_C5_struct_mean.IV_fits(5,1:size(CRY4_C5_struct_mean.IV_fits,2)-2));
Control = cell2table(C5_pretest_struct_mean.IV_fits(5,1:size(C5_pretest_struct_mean.IV_fits,2)-2));


%transparent_errorbar_fig(cells,Cell_color_code,Cell_color_code_transparent,num_cond,mode,handle_visibility_legend,handle_visibility_dots)
% run function to create transparent IQR and create plot for each
% condition 
transparent_errorbar_fig(KCNB1,new_color_code(1,:),new_color_code_transparent(1,:),1,2,0,0)
transparent_errorbar_fig(KCNV2,new_color_code(2,:),new_color_code_transparent(2,:),1.25,2,0,0)
transparent_errorbar_fig(KCNB1_KCNV2,new_color_code(3,:),new_color_code_transparent(3,:),1.5,2,0,0)
transparent_errorbar_fig(CRY4,new_color_code(4,:),new_color_code_transparent(4,:),1.75,2,0,0)
transparent_errorbar_fig(Control,new_color_code(6,:),new_color_code_transparent(6,:),2,2,1,0)

legend('Median V_{50} across cells','Location','best','Orientation', 'Horizontal','Box','off');

% set axis properties
ylim([3 45])
yticks([10 20 30 40])
xlim([0.95 2.05])
xticks([1 1.25 1.5 1.75 2])
xticklabels({sprintf('Kv2.1'),sprintf('Kv8.2'),sprintf('Kv2.1/Kv8.2'),sprintf('       Kv2.1/ \\newline   Kv8.2/Cry4'), sprintf('Control')})
ax = gca;
ax.XTickLabelRotation = 0;
ax.FontSize = 13; 
ax.LineWidth= 1; %change to the desired value     
ax.Position = [0.13,0.149643705463183,0.789064748201439,0.774346793349169];
ax.TitleHorizontalAlignment = 'left';

% include text under x-axis lables with sample size 
text(1,-1.7,'n = 7','HorizontalAlignment','center','FontSize',14)
text(1.25,-1.7,'n = 4','HorizontalAlignment','center','FontSize',14)
text(1.5,-1.7,'n = 4','HorizontalAlignment','center','FontSize',14)
text(1.75,-1.7,'n = 4','HorizontalAlignment','center','FontSize',14)
text(2,-1.7,'n = 8','HorizontalAlignment','center','FontSize',14)
title('{\fontsize{20}B}')


%%% save
% exportgraphics(tiled,'C5_V50_transfected.pdf','ContentType','vector')


        %% V50 C6, A3 and C8
%% V50 of -40 (C6), -30 (A3), -20 mV (C8) holding potential

cd '/Users/oda/Desktop/Uni/Master/MA/Daten/Matlabscrips'

% store the V50 values for each cell into seperate variables
C6 = cell2table(C6_pretest_struct_mean.IV_fits(5,1:size(C6_pretest_struct_mean.IV_fits,2)-2));
A3 = cell2table(A3_pretest_struct_mean.IV_fits(5,1:size(A3_pretest_struct_mean.IV_fits,2)-2));
C8 = cell2table(C8_pretest_struct_mean.IV_fits(5,1:size(C8_pretest_struct_mean.IV_fits,2)-2));

figure 
box off
hold on

%transparent_errorbar_fig(cells,Cell_color_code,Cell_color_code_transparent,num_cond,mode,handle_visibility_legend,handle_visibility_dots)
% run function to create transparent IQR and create plot for each
% condition
transparent_errorbar_fig(C6,new_color_code(7,:),new_color_code_transparent(7,:),1,2,0,0)
transparent_errorbar_fig(A3,new_color_code(5,:),new_color_code_transparent(5,:),1.25,2,0,0)
transparent_errorbar_fig(C8,new_color_code(8,:),new_color_code_transparent(8,:),1.5,2,1,0)

legend('Median V_{50} across cells','Location','northeast','Box','off')

% set axis properties
ylim([15 60])
yticks([20 30 40 50 60])
xlim([0.95 1.55])
xticks([1 1.25 1.5 1.75 2])
xticklabels({sprintf('-40'),sprintf('-30'),sprintf('-20')})
ax = gca;
ax.XTickLabelRotation = 0;
ax.FontSize = 14; 
ax.LineWidth= 1; %change to the desired value     
ax.Position = [0.13,0.149643705463183,0.789064748201439,0.774346793349169];

% include text under x-axis lables with sample size 
text(1,11,'n = 2','HorizontalAlignment','center','FontSize',14)
text(1.25,11,'n = 5','HorizontalAlignment','center','FontSize',14)
text(1.5,11,'n = 3','HorizontalAlignment','center','FontSize',14)

% axis labels
ylabel('Voltage [mV]','FontSize',14)
xlabel('Holding potential [mV]','FontSize',14,'Position',[1.250000256299955,9.5,-1])


%%% save:
% ax = gca;
% exportgraphics(ax,'V50_C6_A3_C8.pdf','ContentType','vector')


%% V50 all transfections together at -80 mV holding potential with 100 ms (C5) and 1000 ms (C7) stimulation


cd '/Users/oda/Desktop/Uni/Master/MA/Daten/Matlabscrips'

% store the V50 values for each cell into seperate variables
C5_mean = cell2table(C5_pretest_struct_mean.IV_fits(5,1:size(C5_pretest_struct_mean.IV_fits,2)-2));
C7_mean = cell2table(C7_pretest_struct_mean.IV_fits(5,1:size(C7_pretest_struct_mean.IV_fits,2)-2));

C5_peak = cell2table(C5_pretest_struct_peak.IV_fits(5,1:size(C5_pretest_struct_peak.IV_fits,2)-2));
C7_peak = cell2table(C7_pretest_struct_peak.IV_fits(5,1:size(C7_pretest_struct_peak.IV_fits,2)-2));

figure 
box off
hold on


%transparent_errorbar_fig(cells,Cell_color_code,Cell_color_code_transparent,num_cond,mode,handle_visibility_legend,handle_visibility_dots)
% run function to create transparent IQR and create plot for each
% condition
%%% IA peak
transparent_errorbar_fig(C5_peak,new_color_code(6,:),new_color_code_transparent(6,:),1,2,0,0)
transparent_errorbar_fig(C7_peak,new_color_code(9,:),new_color_code_transparent(9,:),1.25,2,1,0)

%%% IK mean
transparent_errorbar_fig(C5_mean,new_color_code(6,:),new_color_code_transparent(6,:),1.75,2,0,0)
transparent_errorbar_fig(C7_mean,new_color_code(9,:),new_color_code_transparent(9,:),2,2,0,0)


legend('Median V_{50} across cells','Location','northoutside','Position', [0.376785731068527,0.93,0.295535714285714,0.058333333333333],'Box','off')

% set axis properties
ylim([8 40])
yticks([10 20 30 40])
xlim([0.8 2.2])
xticks([1 1.25 1.75 2])
xticklabels({sprintf(' 100 ms \\newline   pulse'),sprintf(' 1000 ms \\newline    pulse'),sprintf(' 100 ms \\newline    pulse'),sprintf(' 1000 ms \\newline    pulse')})
ax = gca;
ax.XTickLabelRotation = 0;
ax.FontSize = 14; 
ax.LineWidth= 1;  
ax.Position = [0.13,0.149643705463183,0.789064748201439,0.774346793349169];

% include text under x-axis lables with sample size 
text(1,3,'n = 8','HorizontalAlignment','center','FontSize',14)
text(1.25,3,'n = 4','HorizontalAlignment','center','FontSize',14)
text(1.75,3,'n = 8','HorizontalAlignment','center','FontSize',14)
text(2,3,'n = 4','HorizontalAlignment','center','FontSize',14)

ylabel('Voltage [mV]','FontSize',14)

% include text which plot includes the peak and which the mean calculated
% data
text(1.125,39.3,'A-type peak','HorizontalAlignment','center','FontSize',16)
text(1.89,39.3,'Mean current','HorizontalAlignment','center','FontSize',16)


%%% save:
% ax = gca;
% exportgraphics(ax,'C5_C7_V50_bearbeitet.pdf','ContentType','vector')


%% slope k
%% slope, transfected conditions, -30 mV holding potential (A3) 

cd '/Users/oda/Desktop/Uni/Master/MA/Daten/Matlabscrips'

% store the V50 values for each cell into seperate variables
KCNB1 = cell2table(KCNB1_A3_struct.IV_fits(6,1:size(KCNB1_A3_struct.IV_fits,2)-2));
KCNV2 = cell2table(KCNV2_A3_struct.IV_fits(6,1:size(KCNV2_A3_struct.IV_fits,2)-2));
KCNB1_KCNV2 = cell2table(KCNB1_KCNV2_A3_struct.IV_fits(6,1:size(KCNB1_KCNV2_A3_struct.IV_fits,2)-2));
CRY4 =  cell2table(CRY4_A3_struct.IV_fits(6,1:size(CRY4_A3_struct.IV_fits,2)-2));
Control = cell2table(A3_pretest_struct_mean.IV_fits(6,1:size(A3_pretest_struct_mean.IV_fits,2)-2));

figure 
box off
hold on


%transparent_errorbar_fig(cells,Cell_color_code,Cell_color_code_transparent,num_cond,mode,handle_visibility_legend,handle_visibility_dots)
% run function to create transparent IQR and create plot for each
% condition
transparent_errorbar_fig(KCNB1,new_color_code(1,:),new_color_code_transparent(1,:),1,2,0,0)
transparent_errorbar_fig(KCNV2,new_color_code(2,:),new_color_code_transparent(2,:),1.25,2,0,0)
transparent_errorbar_fig(KCNB1_KCNV2,new_color_code(3,:),new_color_code_transparent(3,:),1.5,2,0,0)
transparent_errorbar_fig(CRY4,new_color_code(4,:),new_color_code_transparent(4,:),1.75,2,0,0)
transparent_errorbar_fig(Control,new_color_code(5,:),new_color_code_transparent(5,:),2,2,1,0)

legend('Median sensitivity across cells','Location','northeast','Box','off');

% set axis properties
ylim([-0.8 20])
yticks([0 5 10 15 20])

xlim([0.95 2.05])
xticks([1 1.25 1.5 1.75 2])
xticklabels({sprintf('Kv2.1'),sprintf('Kv8.2'),sprintf('Kv2.1/Kv8.2'),sprintf('       Kv2.1/ \\newline   Kv8.2/Cry4'), sprintf('Control')})
ax = gca;
ax.XTickLabelRotation = 0;
ax.FontSize = 14; 
ax.LineWidth= 1;     
ax.Position = [0.13,0.149643705463183,0.789064748201439,0.774346793349169];

% include text under x-axis lables with sample size 
text(1,-4,'n = 5','HorizontalAlignment','center','FontSize',14)
text(1.25,-4,'n = 4','HorizontalAlignment','center','FontSize',14)
text(1.5,-4,'n = 6','HorizontalAlignment','center','FontSize',14)
text(1.75,-4,'n = 10','HorizontalAlignment','center','FontSize',14)
text(2,-4,'n = 5','HorizontalAlignment','center','FontSize',14)

% axis labels
ylabel('Voltage sensitivity per e-fold increase [mV]','FontSize',14) % voltage dependence of activation

% save: 
% ax = gca;
% exportgraphics(ax,'slope_A3.pdf','ContentType','vector')


%% slope, transfected conditions, -80 mV holding potential (C5) 

% voltage dependence of activation
cd '/Users/oda/Desktop/Uni/Master/MA/Daten/Matlabscrips'

% store the V50 values for each cell into seperate variables
KCNB1_peak = cell2table(KCNB1_C5_struct_peak.IV_fits(6,1:size(KCNB1_C5_struct_peak.IV_fits,2)-2));
KCNV2_peak = cell2table(KCNV2_C5_struct_peak.IV_fits(6,1:size(KCNV2_C5_struct_peak.IV_fits,2)-2));
KCNB1_KCNV2_peak = cell2table(KCNB1_KCNV2_C5_struct_peak.IV_fits(6,1:size(KCNB1_KCNV2_C5_struct_peak.IV_fits,2)-2));
CRY4_peak = cell2table(CRY4_C5_struct_peak.IV_fits(6,1:size(CRY4_C5_struct_peak.IV_fits,2)-2));
Control_peak = cell2table(C5_pretest_struct_peak.IV_fits(6,1:size(C5_pretest_struct_peak.IV_fits,2)-2));


figure('Position',[54,247,1094,486]) % figure for two plots beside each other

tiled = tiledlayout(1,2,'TileSpacing','compact'); %1x2 figure
nexttile %%% IA peak
box off
hold on

%transparent_errorbar_fig(cells,Cell_color_code,Cell_color_code_transparent,num_cond,mode,handle_visibility_legend,handle_visibility_dots)
% run function to create transparent IQR and create plot for each
% condition
transparent_errorbar_fig(KCNB1_peak,new_color_code(1,:),new_color_code_transparent(1,:),1,2,0,0)
transparent_errorbar_fig(KCNV2_peak,new_color_code(2,:),new_color_code_transparent(2,:),1.25,2,0,0)
transparent_errorbar_fig(KCNB1_KCNV2_peak,new_color_code(3,:),new_color_code_transparent(3,:),1.5,2,0,0)
transparent_errorbar_fig(CRY4_peak,new_color_code(4,:),new_color_code_transparent(4,:),1.75,2,0,0)
transparent_errorbar_fig(Control_peak,new_color_code(6,:),new_color_code_transparent(6,:),2,2,1,0)

% set axis properties
ylim([4.3 25])
yticks([5 10 15 20 25])

xlim([0.95 2.05])
xticks([1 1.25 1.5 1.75 2])
xticklabels({sprintf('Kv2.1'),sprintf('Kv8.2'),sprintf('Kv2.1/Kv8.2'),sprintf('       Kv2.1/ \\newline   Kv8.2/Cry4'), sprintf('Control')})
ax = gca;
ax.XTickLabelRotation = 0;
ax.FontSize = 14; 
ax.LineWidth= 1; %change to the desired value     
ax.Position = [0.13,0.149643705463183,0.789064748201439,0.774346793349169]; % set axis
ax.TitleHorizontalAlignment = 'left'; % align plot title left

% include text under x-axis lables with sample size 
text(1,1.9,'n = 7','HorizontalAlignment','center','FontSize',14)
text(1.25,1.9,'n = 4','HorizontalAlignment','center','FontSize',14)
text(1.5,1.9,'n = 4','HorizontalAlignment','center','FontSize',14)
text(1.75,1.9,'n = 4','HorizontalAlignment','center','FontSize',14)
text(2,1.9,'n = 8','HorizontalAlignment','center','FontSize',14)


ylabel('Voltage sensitivity per e-fold increase [mV]','FontSize',14) % voltage dependence of activation
%title('voltage dependence of activation mean C5')

title('{\fontsize{20}A}')

%%%%%

nexttile %%% IK mean
hold on
box off

% store the V50 values for each cell into seperate variables
KCNB1 = cell2table(KCNB1_C5_struct_mean.IV_fits(6,1:size(KCNB1_C5_struct_mean.IV_fits,2)-2));
KCNV2 = cell2table(KCNV2_C5_struct_mean.IV_fits(6,1:size(KCNV2_C5_struct_mean.IV_fits,2)-2));
KCNB1_KCNV2 = cell2table(KCNB1_KCNV2_C5_struct_mean.IV_fits(6,1:size(KCNB1_KCNV2_C5_struct_mean.IV_fits,2)-2));
CRY4 =  cell2table(CRY4_C5_struct_mean.IV_fits(6,1:size(CRY4_C5_struct_mean.IV_fits,2)-2));
Control = cell2table(C5_pretest_struct_mean.IV_fits(6,1:size(C5_pretest_struct_mean.IV_fits,2)-2));

%transparent_errorbar_fig(cells,Cell_color_code,Cell_color_code_transparent,num_cond,mode,handle_visibility_legend,handle_visibility_dots)
% run function to create transparent IQR and create plot for each
% condition
transparent_errorbar_fig(KCNB1,new_color_code(1,:),new_color_code_transparent(1,:),1,2,0,0)
transparent_errorbar_fig(KCNV2,new_color_code(2,:),new_color_code_transparent(2,:),1.25,2,0,0)
transparent_errorbar_fig(KCNB1_KCNV2,new_color_code(3,:),new_color_code_transparent(3,:),1.5,2,0,0)
transparent_errorbar_fig(CRY4,new_color_code(4,:),new_color_code_transparent(4,:),1.75,2,0,0)
transparent_errorbar_fig(Control,new_color_code(6,:),new_color_code_transparent(6,:),2,2,1,0)


% set axis properties
ylim([4.3 25])
yticks([5 10 15 20 25])

xlim([0.95 2.05])
xticks([1 1.25 1.5 1.75 2])
xticklabels({sprintf('Kv2.1'),sprintf('Kv8.2'),sprintf('Kv2.1/Kv8.2'),sprintf('       Kv2.1/ \\newline   Kv8.2/Cry4'), sprintf('Control')})
ax = gca;
ax.XTickLabelRotation = 0;
ax.FontSize = 14; 
ax.LineWidth= 1;  
ax.Position = [0.13,0.149643705463183,0.789064748201439,0.774346793349169];  % set axis
ax.TitleHorizontalAlignment = 'left'; % align plot title left

% include text under x-axis lables with sample size 
text(1,1.9,'n = 7','HorizontalAlignment','center','FontSize',14)
text(1.25,1.9,'n = 4','HorizontalAlignment','center','FontSize',14)
text(1.5,1.9,'n = 4','HorizontalAlignment','center','FontSize',14)
text(1.75,1.9,'n = 4','HorizontalAlignment','center','FontSize',14)
text(2,1.9,'n = 8','HorizontalAlignment','center','FontSize',14)

title('{\fontsize{20}B}')
%title('voltage dependence of activation peak C5')

leg = legend('Median sensitivity across cells','Location','northeast','Orientation', 'Horizontal','Box','off');                                     
fontsize(leg,15,'points') % increase fontsize

% save: 
% exportgraphics(tiled,'C5_slope_transfected.pdf','ContentType','vector')


%% slope of -40 (C6), -30 (A3), -20 mV (C8) holding potential


cd '/Users/oda/Desktop/Uni/Master/MA/Daten/Matlabscrips'

% store the V50 values for each cell into seperate variables
C6 = cell2table(C6_pretest_struct_mean.IV_fits(6,1:size(C6_pretest_struct_mean.IV_fits,2)-2));
A3 = cell2table(A3_pretest_struct_mean.IV_fits(6,1:size(A3_pretest_struct_mean.IV_fits,2)-2));
C8 = cell2table(C8_pretest_struct_mean.IV_fits(6,1:size(C8_pretest_struct_mean.IV_fits,2)-2));

figure 
box off
hold on

% transparent_errorbar_fig(cells,Cell_color_code,Cell_color_code_transparent,num_cond,mode,handle_visibility_legend,handle_visibility_dots)
% run function to create transparent IQR and create plot for each
% condition
transparent_errorbar_fig(C6,new_color_code(7,:),new_color_code_transparent(7,:),1,2,0,0)
transparent_errorbar_fig(A3,new_color_code(5,:),new_color_code_transparent(5,:),1.25,2,0,0)
transparent_errorbar_fig(C8,new_color_code(8,:),new_color_code_transparent(8,:),1.5,2,1,0)


legend('Median sensitivity across cells','Location','northeast','Box','off');

% set axis properties
ylim([-0.5 20])
yticks([0 5 10 15 20])

xlim([0.95 1.55])
xticks([1 1.25 1.5 1.75 2])
xticklabels({sprintf('-40'),sprintf('-30'),sprintf('-20')})
ax = gca;
ax.XTickLabelRotation = 0;
ax.FontSize = 14; 
ax.LineWidth= 1;     
ax.Position = [0.13,0.149643705463183,0.789064748201439,0.774346793349169]; % set axis position

% include text under x-axis lables with sample size 
text(1,-2.5,'n = 2','HorizontalAlignment','center','FontSize',14)
text(1.25,-2.5,'n = 5','HorizontalAlignment','center','FontSize',14)
text(1.5,-2.5,'n = 3','HorizontalAlignment','center','FontSize',14)

% axis labels 
xlabel('Holding potential [mV]','FontSize',14,'Position',[1.250000256299955,-3.2,-1])
ylabel('Voltage sensitivity per e-fold increase [mV]','FontSize',14) % voltage dependence of activation
% title('voltage dependence of activation C6/A3/C8')



%%% save:
% ax = gca;
% exportgraphics(ax,'slope_C6_A3_C8.pdf','ContentType','vector')



%% tau
        %% exponential fit --> all transfections together (poster) with control A3 

cd '/Users/oda/Desktop/Uni/Master/MA/Daten/Matlabscrips'
figure('Position',[54,247,1094,486]) % two plots beside each other

tiled = tiledlayout(1,2,'TileSpacing','compact');
nexttile %%% tau fast

% store the V50 values for each cell into seperate variables
KCNB1_exp_fast = cell2table(KCNB1_A3_struct.exponential_fit_values(5,1:size(KCNB1_A3_struct.exponential_fit_values,2)));
KCNV2_exp_fast = cell2table(KCNV2_A3_struct.exponential_fit_values(5,1:size(KCNV2_A3_struct.exponential_fit_values,2)));
KCNB1_KCNV2_exp_fast = cell2table(KCNB1_KCNV2_A3_struct.exponential_fit_values(5,1:size(KCNB1_KCNV2_A3_struct.exponential_fit_values,2)));
CRY4_exp_fast = cell2table(CRY4_A3_struct.exponential_fit_values(5,1:size(CRY4_A3_struct.exponential_fit_values,2)));

box off
hold on

% transparent_errorbar_fig(cells,Cell_color_code,Cell_color_code_transparent,num_cond,mode,handle_visibility_legend,handle_visibility_dots)
% run function to create transparent IQR and create plot for each
% condition
transparent_errorbar_fig(KCNB1_exp_fast,new_color_code(1,:),new_color_code_transparent(1,:),1,2,0,0)
transparent_errorbar_fig(KCNV2_exp_fast,new_color_code(2,:),new_color_code_transparent(2,:),1.25,2,0,0)
transparent_errorbar_fig(KCNB1_KCNV2_exp_fast,new_color_code(3,:),new_color_code_transparent(3,:),1.5,2,0,0)
transparent_errorbar_fig(CRY4_exp_fast,new_color_code(4,:),new_color_code_transparent(4,:),1.75,2,1,0)


% set axis properties
ylim([-5 75])
xlim([0.95 1.8])
xticks([1 1.25 1.5 1.75])
xticklabels({sprintf('Kv2.1'),sprintf('Kv8.2'),sprintf('Kv2.1/Kv8.2'),sprintf('       Kv2.1/ \\newline   Kv8.2/Cry4')})
ax = gca;
ax.XTickLabelRotation = 0;
ax.FontSize = 14; 
ax.LineWidth= 1;     
ax.Position = [0.13,0.149643705463183,0.789064748201439,0.774346793349169];
ax.TitleHorizontalAlignment = 'left'; % align plot title left


% include text under x-axis lables with sample size 
text(1,-14.5,'n = 5','HorizontalAlignment','center','FontSize',14)
text(1.25,-14.5,'n = 4','HorizontalAlignment','center','FontSize',14)
text(1.5,-14.5,'n = 6','HorizontalAlignment','center','FontSize',14)
text(1.75,-14.5,'n = 10','HorizontalAlignment','center','FontSize',14)

% set axis properties
line = 1.25:0.05:1.75;
y_line = [64 64 64 64 64 64 64 64 64 64 64];

plot(line,y_line,'Color','k','LineWidth',1,'HandleVisibility','off')
plot(1.5,66,'*','Color','k','LineWidth',1,'HandleVisibility','off','MarkerSize',10)
ylabel('\fontsize{24} \tau\fontsize{14} [ms]') 

%title('\tau_{fast}')
title('{\fontsize{20}A}')


%%%%%

% store the V50 values for each cell into seperate variables
KCNB1_exp = cell2table(KCNB1_A3_struct.exponential_fit_values(4,1:size(KCNB1_A3_struct.exponential_fit_values,2)));
KCNV2_exp = cell2table(KCNV2_A3_struct.exponential_fit_values(4,1:size(KCNV2_A3_struct.exponential_fit_values,2)));
KCNB1_KCNV2_exp = cell2table(KCNB1_KCNV2_A3_struct.exponential_fit_values(4,1:size(KCNB1_KCNV2_A3_struct.exponential_fit_values,2)));
CRY4_exp = cell2table(CRY4_A3_struct.exponential_fit_values(4,1:size(CRY4_A3_struct.exponential_fit_values,2)));


nexttile %%% tau slow
box off
hold on

% transparent_errorbar_fig(cells,Cell_color_code,Cell_color_code_transparent,num_cond,mode,handle_visibility_legend,handle_visibility_dots)
% run function to create transparent IQR and create plot for each
% condition
transparent_errorbar_fig(KCNB1_exp,new_color_code(1,:),new_color_code_transparent(1,:),1,2,0,0)
transparent_errorbar_fig(KCNV2_exp,new_color_code(2,:),new_color_code_transparent(2,:),1.25,2,0,0)
transparent_errorbar_fig(KCNB1_KCNV2_exp,new_color_code(3,:),new_color_code_transparent(3,:),1.5,2,0,0)
transparent_errorbar_fig(CRY4_exp,new_color_code(4,:),new_color_code_transparent(4,:),1.75,2,1,0)

% set axis properties
ylim([-100 2600])

xlim([0.95 1.8])
xticks([1 1.25 1.5 1.75])
xticklabels({sprintf('Kv2.1'),sprintf('Kv8.2'),sprintf('Kv2.1/Kv8.2'),sprintf('       Kv2.1/ \\newline   Kv8.2/Cry4')})
ax = gca;
ax.XTickLabelRotation = 0;
ax.FontSize = 14; 
ax.LineWidth= 1; 
ax.Position = [0.13,0.149643705463183,0.789064748201439,0.774346793349169];
ax.TitleHorizontalAlignment = 'left'; % align plot title left


% include text under x-axis lables with sample size 
text(1,-415,'n = 5','HorizontalAlignment','center','FontSize',14)
text(1.25,-415,'n = 4','HorizontalAlignment','center','FontSize',14)
text(1.5,-415,'n = 6','HorizontalAlignment','center','FontSize',14)
text(1.75,-415,'n = 10','HorizontalAlignment','center','FontSize',14)


%title('\tau_{slow}')
title('{\fontsize{20}B}')

legend('\fontsize{14}Median \fontsize{20}\tau \fontsize{14}across cells','Location','northeast','Box','off');

% save:
% exportgraphics(tiled,'median_tau.pdf','ContentType','vector')
