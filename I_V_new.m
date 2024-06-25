%% Script for the raw plots for the Master thesis
%%% Author: Oda E. Riedesel
%%% Date: 2024
%
% This script includes the plots for the I-V curves for the Master thesis. 
%
% needed data :
% raw data examples -->  workspaces were saved
% workspace of the example trace of the exponential is as well saved
% for the correlation the structs of the data analysis of each transfected
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
%                                         A2_pretest_struct_peak.mat
%                                         C7_pretest_struct_mean.mat
%                                         C7_pretest_struct_peak.mat
%                                         C6_pretest_struct_mean.mat
%                                         C8_pretest_struct_mean.mat
%
% matrix with the saved color codes for each condition: 
%                                         new_color_code.mat
% *** Notes *** 
%%% 
%%%
%%%

%% -30 mV holding potential
% all transection together A3 with control

figure('Position',[41,63,922,734]) % figure for in total 5 subplots

tiled = tiledlayout(3,4,'TileSpacing','compact'); % 3x4 tiled layout
x_data = KCNB1_A3_struct.voltage_steps;    %create a x vector 

% store the fits and data into seperate variables
cell_fits = KCNB1_A3_struct.IV_fits; % all fits
median_fit = KCNB1_A3_struct.IV_fits{2,size(KCNB1_A3_struct.IV_fits,2)}; % median fit

% take normalized raw data
KCNB1_median_rawvalues = table2array(KCNB1_A3_struct.mean_currents_Imax_norm);
% calculate median 
median_raw = median(KCNB1_median_rawvalues,2);


nexttile([1,2]) %%% KCNB1 transfection

% plot raw data point of each cell
plot(x_data,KCNB1_median_rawvalues,'*','Color',new_color_code(1,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on
plot(x_data(1),KCNB1_median_rawvalues(1,1),'*','Color',new_color_code(1,:),'MarkerSize',9,'HandleVisibility','on') % plot one point for HandleVisibility in legend

% plot each seperate cell fit
for i = 1: size(cell_fits,2)-2
    p1 = plot(cell_fits{2,i}); 
    p1.LineWidth = 1;
    p1.Color = new_color_code_less_transparent(1,:); % color of each seperate fit 
    p1.HandleVisibility = 'off';
    hold on
end 
  
  p2 = plot(cell_fits{2,i}); % plot one line again to get only one HandleVisibility
  p2.LineWidth = 1;
  p2.Color = new_color_code_less_transparent(1,:);
  p2.HandleVisibility = 'on';

p = plot(median_fit); % plot fit of the median
p.LineWidth = 2.5;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','on') % plot values of median for fit again


    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit 
    x_1 = median(cell2mat(cell_fits(5,1:size(cell_fits,2)-2)),2);  

    blub = cell_fits{2,size(cell_fits,2)};  % take median fit

    % plot V50 value on the median fit 
    plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75,'HandleVisibility','on') 

    % plot gray line to mark V50 value for better comparison between I-V
    % curves
    xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13)
    % yline(0.5,'--','LineWidth',1,'FontSize',12)

box off
xlabel([]) % delete x-axis label
ylabel('I/I_{max}','FontSize',14)

legend off
ax = gca; % get axis properties
ax.FontSize = 14; 
ax.LineWidth= 1; 
ax.TitleHorizontalAlignment = 'left'; % align plot title left

% set axis properties and title
ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])
title('{\fontsize{20}A} - Kv2.1')

% create legend and set legend properties 
% legend will be plotted lower right panel beisde last plot
[~, hobj, ~, ~] = legend('Raw data','Single cell fit','Median across cells','Fit of median','Median V_{50}','Orientation', 'Vertical','Position',[0.723373143326468,0.13,0.157266811279826,0.16]);
hl = findobj(hobj,'type','line'); % find the characters in the legend
set(hl,'LineWidth',1.5,'MarkerSize',10); % increase size 
ht = findobj(hobj,'type','text'); % find text in legend                                      
fontsize(ht,15,'points') % set text font
legend('boxoff') % no box 



nexttile([1,2]) %%% KCNV2 transfection

% store the fits and data into seperate variables
cell_fits = KCNV2_A3_struct.IV_fits;
median_fit = KCNV2_A3_struct.IV_fits{2,size(cell_fits,2)};
% take normalized raw data
KCNV2_median_rawvalues = table2array(KCNV2_A3_struct.mean_currents_Imax_norm);
% calculate median 
median_raw = median(KCNV2_median_rawvalues,2);


% plot raw data point of each cell
plot(x_data,KCNV2_median_rawvalues,'*','Color',new_color_code(2,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on

% plot each seperate cell fit
for i = 1: size(cell_fits,2)-2
  p1 = plot(cell_fits{2,i}); 
  p1.LineWidth = 1;
  p1.Color = new_color_code_less_transparent(2,:);
  p1.HandleVisibility = 'off';
    hold on
end 

p = plot(median_fit); % plot fit of the median
p.LineWidth = 2.5;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','off') % plot values of median for fit


    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit 
    x_1 = median(cell2mat(cell_fits(5,1:size(cell_fits,2)-2)),2);  
    blub = cell_fits{2,size(cell_fits,2)};  % take median fit

    % plot gray line to mark V50 value for better comparison between I-V
    % curves
    plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75,'HandleVisibility','off')
    xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13)
    % yline(0.5,'--','LineWidth',1,'FontSize',12)

% box, axis-label, and legend off
box off
xlabel([])
ylabel([])

legend off
ax = gca;
ax.FontSize = 14; 
ax.LineWidth= 1; 
ax.TitleHorizontalAlignment = 'left';  % align plot title left

% set axis properties and title
ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])
title('{\fontsize{20}B} - Kv8.2')



nexttile(5,[1,2]) %%% KCNB1/KCNV2 transfection

% store the fits and data into seperate variables
cell_fits = KCNB1_KCNV2_A3_struct.IV_fits;
median_fit = KCNB1_KCNV2_A3_struct.IV_fits{2,size(cell_fits,2)};
% take normalized raw data
KCNB1_KCNV2_median_rawvalues = table2array(KCNB1_KCNV2_A3_struct.mean_currents_Imax_norm);
% calculate median 
median_raw = median(KCNB1_KCNV2_median_rawvalues,2);


% plot raw data point of each cell
plot(x_data,KCNB1_KCNV2_median_rawvalues,'*','Color',new_color_code(3,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on

% plot each seperate cell fit
for i = 1: size(cell_fits,2)-2
   p1 = plot(cell_fits{2,i}); 
  p1.LineWidth = 1;
  p1.Color = new_color_code_less_transparent(3,:);
  p1.HandleVisibility = 'off';
    hold on
end 
 
p = plot(median_fit); % plot fit of the median
p.LineWidth = 2.5;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','off') % plot values of median for fit


    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit 
    x_1 = median(cell2mat(cell_fits(5,1:size(cell_fits,2)-2)),2);

    blub = cell_fits{2,size(cell_fits,2)};  
   
    % plot gray line to mark V50 value for better comparison between I-V
    % curves
    plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75,'HandleVisibility','off')
    xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13)
    % yline(0.5,'--','LineWidth',1,'FontSize',12)

% box, axis-label, and legend off
box off
xlabel('Voltage [mV]','FontSize',14)
ylabel('I/I_{max}','FontSize',14)

legend off
ax = gca;
ax.FontSize = 14; 
ax.LineWidth= 1; 
ax.TitleHorizontalAlignment = 'left'; % align plot title left

% set axis properties and title
ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])
title('{\fontsize{20}C} - Kv2.1/Kv8.2')


nexttile(7,[1,2]) %%% KCNB1/KCNV2/CRY4 transfection

% store the fits and data into seperate variables
cell_fits = CRY4_A3_struct.IV_fits;
median_fit = CRY4_A3_struct.IV_fits{2,size(cell_fits,2)};
CRY4_median_rawvalues = table2array(CRY4_A3_struct.mean_currents_Imax_norm);
median_raw = median(CRY4_median_rawvalues,2);

% plot raw data point of each cell
plot(x_data,CRY4_median_rawvalues,'*','Color',new_color_code(4,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on

% plot each seperate cell fit
for i = 1: size(cell_fits,2)-2
   p1 = plot(cell_fits{2,i}); % plot each seperate cell fit
  % p1.Color = [.7 .7 .7];
  p1.LineWidth = 1;
  p1.Color = new_color_code_less_transparent(4,:);
  p1.HandleVisibility = 'off';
    hold on
end 

p = plot(median_fit); % plot fit of the median
p.LineWidth = 2;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','off') % plot values of median for fit


    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit
    x_1 = median(cell2mat(cell_fits(5,1:size(cell_fits,2)-2)),2);    
    blub = cell_fits{2,size(cell_fits,2)};  
    
    % plot gray line to mark V50 value for better comparison between I-V
    % curves
    plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75,'HandleVisibility','off')
   % yline(0.5,'--','LineWidth',1,'FontSize',12)
    xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13)

% box, axis-label, and legend off
box off
xlabel('Voltage [mV]','FontSize',14)
ylabel([])

legend off
ax = gca;
ax.FontSize = 14; 
ax.LineWidth= 1;   
ax.TitleHorizontalAlignment = "left"; % align plot title left

% set axis properties and title
ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])
title('{\fontsize{20}D} - Kv2.1/Kv8.2/Cry4')



%%% Control
nexttile(10,[1 2])

% store the fits and data into seperate variables
cell_fits = A3_pretest_struct_mean.IV_fits;
median_fit = A3_pretest_struct_mean.IV_fits{2,size(A3_pretest_struct_mean.IV_fits,2)};
A3_median_rawvalues = table2array(A3_pretest_struct_mean.mean_currents_Imax_norm);
median_raw = median(A3_median_rawvalues,2);

% plot raw data point of each cell
plot(x_data,A3_median_rawvalues,'*','Color',new_color_code(5,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on

% plot each seperate cell fit
for i = 1: size(cell_fits,2)-2
  p1 = plot(cell_fits{2,i}); % plot each seperate cell fit
  p1.LineWidth = 1;
  p1.Color = new_color_code_less_transparent(5,:);
  p1.HandleVisibility = 'off';
    hold on
end 

p = plot(median_fit); % plot fit of the median
p.LineWidth = 2;
plot(x_data,median_raw,'.k','MarkerSize',15) % plot values of median for fit

    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit 
    x_1 = median(cell2mat(cell_fits(5,1:size(cell_fits,2)-2)),2);   
    blub = cell_fits{2,size(cell_fits,2)};  

    % plot gray line to mark V50 value for better comparison between I-V
    % curves
    plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75)
    xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13)
   % yline(0.5,'--','LineWidth',1,'FontSize',12)


% box, axis-label, and legend off
box off
xlabel('Voltage [mV]','FontSize',14)
ylabel('I/I_{max}','FontSize',14)

legend off
ax = gca;
ax.FontSize = 14; 
ax.LineWidth= 1;
ax.TitleHorizontalAlignment = 'left'; % align plot title left

% set axis properties and title
ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])

legend off
title('{\fontsize{20}E} - Control')


% exportgraphics(tiled,'A3_transfected_IV.pdf','ContentType','vector')

%% -30 mV holding potential without Cry4
% all transection together A3 with control

figure('Position',[41,63,922,734]) % figure for in total 5 subplots

tiled = tiledlayout(3,4,'TileSpacing','compact'); % 3x4 tiled layout
x_data = KCNB1_A3_struct.voltage_steps;    %create a x vector 

% store the fits and data into seperate variables
cell_fits = KCNB1_A3_struct.IV_fits; % all fits
median_fit = KCNB1_A3_struct.IV_fits{2,size(KCNB1_A3_struct.IV_fits,2)}; % median fit

% take normalized raw data
KCNB1_median_rawvalues = table2array(KCNB1_A3_struct.mean_currents_Imax_norm);
% calculate median 
median_raw = median(KCNB1_median_rawvalues,2);


nexttile([1,2]) %%% KCNB1 transfection

% plot raw data point of each cell
plot(x_data,KCNB1_median_rawvalues,'*','Color',new_color_code(1,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on
plot(x_data(1),KCNB1_median_rawvalues(1,1),'*','Color',new_color_code(1,:),'MarkerSize',9,'HandleVisibility','on') % plot one point for HandleVisibility in legend

% plot each seperate cell fit
for i = 1: size(cell_fits,2)-2
    p1 = plot(cell_fits{2,i}); 
    p1.LineWidth = 1;
    p1.Color = new_color_code_less_transparent(1,:); % color of each seperate fit 
    p1.HandleVisibility = 'off';
    hold on
end 
  
  p2 = plot(cell_fits{2,i}); % plot one line again to get only one HandleVisibility
  p2.LineWidth = 1;
  p2.Color = new_color_code_less_transparent(1,:);
  p2.HandleVisibility = 'on';

p = plot(median_fit); % plot fit of the median
p.LineWidth = 2.5;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','on') % plot values of median for fit again


    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit 
    x_1 = median(cell2mat(cell_fits(5,1:size(cell_fits,2)-2)),2);  

    blub = cell_fits{2,size(cell_fits,2)};  % take median fit

    % plot V50 value on the median fit 
    plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75,'HandleVisibility','on') 

    % plot gray line to mark V50 value for better comparison between I-V
    % curves
    xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13)
    % yline(0.5,'--','LineWidth',1,'FontSize',12)

box off
xlabel([]) % delete x-axis label
ylabel('I/I_{max}','FontSize',14)

legend off
ax = gca; % get axis properties
ax.FontSize = 14; 
ax.LineWidth= 1; 
ax.TitleHorizontalAlignment = 'left'; % align plot title left

% set axis properties and title
ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])
title('{\fontsize{20}A} - Kv2.1')

% create legend and set legend properties 
% legend will be plotted lower right panel beisde last plot
[~, hobj, ~, ~] = legend('Raw data','Single cell fit','Median across cells','Fit of median','Median V_{50}','Orientation', 'Vertical','Position',[0.723373143326468,0.13,0.157266811279826,0.16]);
hl = findobj(hobj,'type','line'); % find the characters in the legend
set(hl,'LineWidth',1.5,'MarkerSize',10); % increase size 
ht = findobj(hobj,'type','text'); % find text in legend                                      
fontsize(ht,15,'points') % set text font
legend('boxoff') % no box 



nexttile([1,2]) %%% KCNV2 transfection

% store the fits and data into seperate variables
cell_fits = KCNV2_A3_struct.IV_fits;
median_fit = KCNV2_A3_struct.IV_fits{2,size(cell_fits,2)};
% take normalized raw data
KCNV2_median_rawvalues = table2array(KCNV2_A3_struct.mean_currents_Imax_norm);
% calculate median 
median_raw = median(KCNV2_median_rawvalues,2);


% plot raw data point of each cell
plot(x_data,KCNV2_median_rawvalues,'*','Color',new_color_code(2,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on

% plot each seperate cell fit
for i = 1: size(cell_fits,2)-2
  p1 = plot(cell_fits{2,i}); 
  p1.LineWidth = 1;
  p1.Color = new_color_code_less_transparent(2,:);
  p1.HandleVisibility = 'off';
    hold on
end 

p = plot(median_fit); % plot fit of the median
p.LineWidth = 2.5;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','off') % plot values of median for fit


    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit 
    x_1 = median(cell2mat(cell_fits(5,1:size(cell_fits,2)-2)),2);  
    blub = cell_fits{2,size(cell_fits,2)};  % take median fit

    % plot gray line to mark V50 value for better comparison between I-V
    % curves
    plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75,'HandleVisibility','off')
    xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13)
    % yline(0.5,'--','LineWidth',1,'FontSize',12)

% box, axis-label, and legend off
box off
xlabel([])
ylabel([])

legend off
ax = gca;
ax.FontSize = 14; 
ax.LineWidth= 1; 
ax.TitleHorizontalAlignment = 'left';  % align plot title left

% set axis properties and title
ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])
title('{\fontsize{20}B} - Kv8.2')



nexttile(5,[1,2]) %%% KCNB1/KCNV2 transfection

% store the fits and data into seperate variables
cell_fits = KCNB1_KCNV2_A3_struct.IV_fits;
median_fit = KCNB1_KCNV2_A3_struct.IV_fits{2,size(cell_fits,2)};
% take normalized raw data
KCNB1_KCNV2_median_rawvalues = table2array(KCNB1_KCNV2_A3_struct.mean_currents_Imax_norm);
% calculate median 
median_raw = median(KCNB1_KCNV2_median_rawvalues,2);


% plot raw data point of each cell
plot(x_data,KCNB1_KCNV2_median_rawvalues,'*','Color',new_color_code(3,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on

% plot each seperate cell fit
for i = 1: size(cell_fits,2)-2
   p1 = plot(cell_fits{2,i}); 
  p1.LineWidth = 1;
  p1.Color = new_color_code_less_transparent(3,:);
  p1.HandleVisibility = 'off';
    hold on
end 
 
p = plot(median_fit); % plot fit of the median
p.LineWidth = 2.5;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','off') % plot values of median for fit


    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit 
    x_1 = median(cell2mat(cell_fits(5,1:size(cell_fits,2)-2)),2);

    blub = cell_fits{2,size(cell_fits,2)};  
   
    % plot gray line to mark V50 value for better comparison between I-V
    % curves
    plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75,'HandleVisibility','off')
    xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13)
    % yline(0.5,'--','LineWidth',1,'FontSize',12)

% box, axis-label, and legend off
box off
xlabel('Voltage [mV]','FontSize',14)
ylabel('I/I_{max}','FontSize',14)

legend off
ax = gca;
ax.FontSize = 14; 
ax.LineWidth= 1; 
ax.TitleHorizontalAlignment = 'left'; % align plot title left

% set axis properties and title
ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])
title('{\fontsize{20}C} - Kv2.1/Kv8.2')

%%% Control
nexttile(7,[1,2]) 

% store the fits and data into seperate variables
cell_fits = A3_pretest_struct_mean.IV_fits;
median_fit = A3_pretest_struct_mean.IV_fits{2,size(A3_pretest_struct_mean.IV_fits,2)};
A3_median_rawvalues = table2array(A3_pretest_struct_mean.mean_currents_Imax_norm);
median_raw = median(A3_median_rawvalues,2);

% plot raw data point of each cell
plot(x_data,A3_median_rawvalues,'*','Color',new_color_code(5,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on

% plot each seperate cell fit
for i = 1: size(cell_fits,2)-2
  p1 = plot(cell_fits{2,i}); % plot each seperate cell fit
  p1.LineWidth = 1;
  p1.Color = new_color_code_less_transparent(5,:);
  p1.HandleVisibility = 'off';
    hold on
end 

p = plot(median_fit); % plot fit of the median
p.LineWidth = 2;
plot(x_data,median_raw,'.k','MarkerSize',15) % plot values of median for fit

    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit 
    x_1 = median(cell2mat(cell_fits(5,1:size(cell_fits,2)-2)),2);   
    blub = cell_fits{2,size(cell_fits,2)};  

    % plot gray line to mark V50 value for better comparison between I-V
    % curves
    plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75)
    xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13)
   % yline(0.5,'--','LineWidth',1,'FontSize',12)


% box, axis-label, and legend off
box off
xlabel('Voltage [mV]','FontSize',14)
ylabel('I/I_{max}','FontSize',14)

legend off
ax = gca;
ax.FontSize = 14; 
ax.LineWidth= 1;
ax.TitleHorizontalAlignment = 'left'; % align plot title left

% set axis properties and title
ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])

legend off
title('{\fontsize{20}D} - Control')


% exportgraphics(tiled,'A3_transfected_IV_without_Cry4.pdf','ContentType','vector')

 %% Inactivaiton protocol (A2) Na+ and K+

figure 
hold on
%%% Na+

x_data = A2_pretest_struct_peak.voltage_steps;    % create a x vector 

% store the fits and data into seperate variables
median_fit_Na = A2_pretest_struct_peak.Na_IV_fits{7,size(A2_pretest_struct_peak.Na_IV_fits,2)};
median_rawvalues_Na = table2array(A2_pretest_struct_peak.Na_peak_back_Imax_norm);
median_raw_Na = median(median_rawvalues_Na,2);

% plot raw data point of each cell
plot(x_data,median_rawvalues_Na,'*','Color',new_color_code(10,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',8);
hold on
plot(x_data(1),median_rawvalues_Na(1,1),'*','Color',new_color_code(10,:),'MarkerSize',6.5) % plot one point for HandleVisibility in legend

% plot each seperate cell fit
counter = 0;  
for i = 1:size(A2_pretest_struct_peak.Na_IV_fits,2)-2
  p1 = plot(A2_pretest_struct_peak.Na_IV_fits{7,i}); 
  p1.LineWidth = 1;
  p1.Color = new_color_code_less_transparent(10,:);
  
  if counter < size(A2_pretest_struct_peak.Na_IV_fits,2)-2
    p1.HandleVisibility = 'off';
  elseif counter == size(A2_pretest_struct_peak.Na_IV_fits,2)-2 % HandleVisibility for legend is only plotted for the last fit
    p1.HandleVisibility = 'on';
  end 
    hold on
  counter = counter+1;
end 

p = plot(median_fit_Na); % plot fit of the median
p.HandleVisibility = "off";
p.LineWidth = 2.5;
plot(x_data,median_raw_Na,'.k','MarkerSize',18,'HandleVisibility','off') % plot values of median for fit


    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit 
   x_1 = median(cell2mat(A2_pretest_struct_peak.Na_IV_fits(10,1:size(A2_pretest_struct_peak.Na_IV_fits,2)-2)),2);  
   blub = A2_pretest_struct_peak.Na_IV_fits{7,size(A2_pretest_struct_peak.Na_IV_fits,2)};  

   % plot V50 value on the median fit 
   plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75,'HandleVisibility','off')
   xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13,'HandleVisibility','off')
   % yline(0.5,'--','LineWidth',1,'FontSize',12)



%%% K+

% store the fits and data into seperate variables
median_fit_K = A2_pretest_struct_peak.IV_fits{7,size(A2_pretest_struct_peak.IV_fits,2)};
median_rawvalues_K = table2array(A2_pretest_struct_peak.A_peak_back_Imax_norm);
median_raw_K = median(median_rawvalues_K,2);

% plot raw data point of each cell
plot(x_data,median_rawvalues_K,'*','Color',new_color_code(11,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',8);
hold on
plot(x_data(1),median_rawvalues_K(1,1),'*','Color',new_color_code(11,:),'MarkerSize',6.5,'HandleVisibility','on') % plot one point for HandleVisibility in legend

% plot each seperate cell fit
for i = 1:size(A2_pretest_struct_peak.IV_fits,2)-2
  p1 = plot(A2_pretest_struct_peak.IV_fits{7,i}); % plot each seperate cell fit
  p1.LineWidth = 1;
  p1.Color = new_color_code_less_transparent(11,:);
  p1.HandleVisibility = 'off';   
end 

p2 = plot(A2_pretest_struct_peak.IV_fits{7,size(A2_pretest_struct_peak.IV_fits,2)-2});  % plot one line again to get only one HandleVisibility
p2.LineWidth = 0.25;
p2.Color = new_color_code_less_transparent(11,:);
p2.HandleVisibility = 'on';


plot(x_data,median_raw_K,'.k','MarkerSize',18) % plot fit of the median to have the HandleVisibility on the right position in the legend
p = plot(median_fit_K); % plot fit of the median
p.LineWidth = 2.5;
plot(x_data,median_raw_K,'.k','MarkerSize',18,'HandleVisibility','off') % plot values of median for fit to have it 

   
% calculate median V50 from middlepoint of all single single fits   
% take out the calculated fit coefficient values of the fit 
   x_1 = median(cell2mat(A2_pretest_struct_peak.IV_fits(10,1:size(A2_pretest_struct_peak.IV_fits,2)-2)),2);  
   blub = A2_pretest_struct_peak.IV_fits{7,size(A2_pretest_struct_peak.IV_fits,2)};  

   % plot V50 value on the median fit 
   plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75,'HandleVisibility','on')
   
    % plot gray line to mark V50 value for better comparison between I-V
    % curves
   xline(x_1,'-','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13,'HandleVisibility','off')
   % yline(0.5,'--','LineWidth',1,'FontSize',12)

% set label and axis
box off
xlabel('Voltage [mV]','FontSize',14)
ylabel('I/I_{max}','FontSize',14)

legend off
ax = gca;
ax.FontSize = 14; 
ax.LineWidth= 1; %change to the desired value     

ylim([-1.2 1.2])
xlim([-105 -5])

% create legend
[~, hobj, ~, ~] = legend('Raw Na^{+} data','Raw K^{+} data','Single cell fit','Median across cells','Fit of median','Median V_{50}','Location','best','Orientation', 'Vertical','Box','off');

% set legend properties
hl = findobj(hobj,'type','line');
set(hl,'LineWidth',1.5,'MarkerSize',10);
ht = findobj(hobj,'type','text');
fontsize(ht,12,'points')

%%% save
ax = gca;
% exportgraphics(ax,'A2_IV.pdf','ContentType','vector')


%% -40 mV (C6), -30 mV (A3) and -20 mV holding potential (C8)

figure('Position',[475,63,451,724]) %figure for three plots under each other

tiled = tiledlayout(3,2,'TileSpacing','compact'); % 3x2 matrix for plots

x_data = C6_pretest_struct_mean.voltage_steps;  % create a x vector 

% store the fits and data into seperate variables
cell_fits = C6_pretest_struct_mean.IV_fits;
median_fit = C6_pretest_struct_mean.IV_fits{2,size(C6_pretest_struct_mean.IV_fits,2)};
median_rawvalues = table2array(C6_pretest_struct_mean.mean_currents_Imax_norm);
median_raw = median(median_rawvalues,2);

%%% -40 mV holding potential (C6)
nexttile([1,2])

% plot raw data point of each cell
plot(x_data,median_rawvalues,'*','Color',new_color_code(7,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on
plot(x_data(1),median_rawvalues(1,1),'*','Color',new_color_code(7,:),'MarkerSize',6.5,'HandleVisibility','on') % plot one point for HandleVisibility in legend

% plot each seperate cell fit
for i = 1:size(cell_fits,2)-2
  p1 = plot(cell_fits{2,i}); % plot each seperate cell fit
  p1.LineWidth = 1;
  p1.Color = new_color_code_less_transparent(7,:);
  p1.HandleVisibility = 'off';
  hold on
end 

  p2 = plot(cell_fits{2,1}); % plot one line again to get only one HandleVisibility
  p2.LineWidth = 1;
  p2.Color = new_color_code_less_transparent(7,:);
  p2.HandleVisibility = 'on';


plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','on') % plot fit of the median to have the HandleVisibility on the right position in the legend

p = plot(median_fit); % plot fit of the median
p.LineWidth = 2.5;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','off') % plot values of median for fit


    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit 
    x_1 = median(cell2mat(cell_fits(5,1:size(cell_fits,2)-2)),2);  
    blub = cell_fits{2,size(cell_fits,2)};  % take median fit

    % plot V50 value on the median fit 
    plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75,'HandleVisibility','on')
  
    % plot gray line to mark V50 value for better comparison between I-V
    % curves
    xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13,'HandleVisibility','off')
    % yline(0.5,'--','LineWidth',1,'FontSize',12)

% set axis and labels
box off
xlabel([]) % delete x-axis label
ylabel('I/I_{max}','FontSize',14)

ax = gca;
ax.FontSize = 14; 
ax.LineWidth= 1;  
ax.TitleHorizontalAlignment = 'left'; % align plot title left

% set axis properties and title
ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])
title('{\fontsize{20}A} ')

% create legend and set legend properties 
[~, hobj, ~, ~] = legend('Raw data','Single cell fit','Median across cells','Fit of median','Median V_{50}','Location','best','Orientation', 'Vertical','NumColumns',2,'Box','off');
hl = findobj(hobj,'type','line');
set(hl,'LineWidth',1.5,'MarkerSize',10);
ht = findobj(hobj,'type','text');
fontsize(ht,13,'points')


%%% -30 mV holding membrane potential (A3)
nexttile(3,[1 2])

% store the fits and data into seperate variables
cell_fits = A3_pretest_struct_mean.IV_fits;
median_fit = A3_pretest_struct_mean.IV_fits{2,size(A3_pretest_struct_mean.IV_fits,2)};
median_rawvalues = table2array(A3_pretest_struct_mean.mean_currents_Imax_norm);
median_raw = median(median_rawvalues,2);

% plot raw data point of each cell
plot(x_data,median_rawvalues,'*','Color',new_color_code(5,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on

% plot each seperate cell fit
for i = 1:size(cell_fits,2)-2
  p1 = plot(cell_fits{2,i}); % plot each seperate cell fit
  p1.LineWidth = 1;
  p1.Color = new_color_code_less_transparent(5,:);
  p1.HandleVisibility = 'off';
  hold on
end 

p = plot(median_fit); % plot fit of the median
p.HandleVisibility = "off";
p.LineWidth = 2.5;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','off') % plot values of median for fit again

    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit 
    x_1 = median(cell2mat(cell_fits(5,1:size(cell_fits,2)-2)),2);  
    blub = cell_fits{2,size(cell_fits,2)};  % take median fit

    % plot V50 value on the median fit 
    plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75,'HandleVisibility','off')
   
    % plot gray line to mark V50 value for better comparison between I-V
    % curves
    xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13,'HandleVisibility','off')
   % yline(0.5,'--','LineWidth',1,'FontSize',12)

 % set axis and labels   
box off
xlabel([]) % delete x-axis label
ylabel('I/I_{max}','FontSize',14)

legend off
ax = gca;  % get axis properties
ax.FontSize = 14; 
ax.LineWidth= 1;  
ax.TitleHorizontalAlignment = 'left'; % align plot title left

% set axis properties and title
ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])
title('{\fontsize{20}B} ')


%%% -20 mV holding potential (C8)

nexttile(5,[1 2])

% store the fits and data into seperate variables
cell_fits = C8_pretest_struct_mean.IV_fits;
median_fit = C8_pretest_struct_mean.IV_fits{2,size(cell_fits,2)};
median_rawvalues = table2array(C8_pretest_struct_mean.mean_currents_Imax_norm);
median_raw = median(median_rawvalues,2);

% plot raw data point of each cell
plot(x_data,median_rawvalues,'*','Color',new_color_code(8,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on

% plot each seperate cell fit
for i = 1:size(cell_fits,2)-2
  p1 = plot(cell_fits{2,i});
  p1.LineWidth = 1;
  p1.Color = new_color_code_less_transparent(8,:);
  p1.HandleVisibility = 'off';
    hold on
end 


p = plot(median_fit); % plot fit of the median
p.HandleVisibility = "off";
p.LineWidth = 2.5;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','off') % plot values of median for fit

    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit 
   x_1 = median(cell2mat(cell_fits(5,1:size(cell_fits,2)-2)),2);  

   blub = cell_fits{2,size(cell_fits,2)};  % take median fit

   % plot V50 value on the median fit 
   plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75,'HandleVisibility','off')
    
   % plot gray line to mark V50 value for better comparison between I-V
   % curves
   xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13,'HandleVisibility','off')
   % yline(0.5,'--','LineWidth',1,'FontSize',12)

  % set labels and axis properties
box off
xlabel('Voltage [mV]','FontSize',14)
ylabel('I/I_{max}','FontSize',14)

legend off
ax = gca; % get axis properties
ax.FontSize = 14; 
ax.LineWidth= 1;   
ax.TitleHorizontalAlignment = 'left';  % align plot title left

ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])
title('{\fontsize{20}C} ')

%%% save
% exportgraphics(tiled,'C6_A3_C8_IV.pdf','ContentType','vector')


%% I-V of transfected conditions mean IK at -80 mV holding potential with control 

figure('Position',[41,63,922,734])  % figure for in total 5 subplots

tiled = tiledlayout(3,4,'TileSpacing','compact'); % 3x4 tiled layout
x_data = KCNB1_C5_struct_mean.voltage_steps;    %create a x vector 

% store the fits and data into seperate variables
cell_fits = KCNB1_C5_struct_mean.IV_fits;
median_fit = KCNB1_C5_struct_mean.IV_fits{2,size(KCNB1_C5_struct_mean.IV_fits,2)};
KCNB1_median_rawvalues = table2array(KCNB1_C5_struct_mean.mean_currents_Imax_norm);
median_raw = median(KCNB1_median_rawvalues,2);


nexttile([1,2]) %%% KCNB1 transfection

% plot raw data point of each cell
plot(x_data,KCNB1_median_rawvalues,'*','Color',new_color_code(1,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on
plot(x_data(1),KCNB1_median_rawvalues(1,1),'*','Color',new_color_code(1,:),'MarkerSize',8,'HandleVisibility','on') % plot one point for HandleVisibility in legend

% plot each seperate cell fit
for i = 1: size(cell_fits,2)-2
  p1 = plot(cell_fits{2,i});
  p1.LineWidth = 1;
  p1.Color = new_color_code_less_transparent(1,:); % color of each seperate fit
  p1.HandleVisibility = 'off';
    hold on
end 
  
  p2 = plot(cell_fits{2,i}); % plot one line again to get only one HandleVisibility
  p2.LineWidth = 1;
  p2.Color = new_color_code_less_transparent(1,:);
  p2.HandleVisibility = 'on';

plot(x_data,median_raw,'.k','MarkerSize',15)  % plot values of median for HandleVisibility in legend
p = plot(median_fit); % plot fit of the median
p.LineWidth = 2.5;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','off')  % plot values of median for fit again just that points are above fit


    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit
   x_1 = median(cell2mat(cell_fits(5,1:size(cell_fits,2)-2)),2);  

   blub = cell_fits{2,size(cell_fits,2)};    % take median fit

   % plot V50 value on the median fit 
   plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75,'HandleVisibility','on')

   % plot gray line to mark V50 value for better comparison between I-V
   % curves
   xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13)
   % yline(0.5,'--','LineWidth',1,'FontSize',12)

   
% set labels and axis properties 
box off
xlabel([]) % delete x-axis label
ylabel('I/I_{max}','FontSize',14)

legend off
ax = gca;
ax.FontSize = 14; 
ax.LineWidth= 1;  
ax.TitleHorizontalAlignment = 'left'; % align plot title left

% set axis properties and title
ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])
title('{\fontsize{20}A} - Kv2.1')

% create legend and set legend properties 
% legend will be plotted lower right panel beisde last plot
[~, hobj, ~, ~] = legend('Raw data','Single cell fit','Median across cells','Fit of median','Median V_{50}','Orientation', 'Vertical','Position',[0.723373143326468,0.13,0.157266811279826,0.16]);
hl = findobj(hobj,'type','line');  % find the characters in the legend
set(hl,'LineWidth',1.5,'MarkerSize',10);
ht = findobj(hobj,'type','text'); % find text in legend   
fontsize(ht,15,'points') % set text font

legend('boxoff')                                     



nexttile([1,2]) %%% KCNV2 transfection

% store the fits and data into seperate variables
cell_fits = KCNV2_C5_struct_mean.IV_fits;
median_fit = KCNV2_C5_struct_mean.IV_fits{2,size(cell_fits,2)};
KCNV2_median_rawvalues = table2array(KCNV2_C5_struct_mean.mean_currents_Imax_norm);
median_raw = median(KCNV2_median_rawvalues,2);

% plot raw data point of each cell
plot(x_data,KCNV2_median_rawvalues,'*','Color',new_color_code(2,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on

% plot each seperate cell fit
for i = 1: size(cell_fits,2)-2
   p1 = plot(cell_fits{2,i}); % plot each seperate cell fit
  % p1.Color = [.7 .7 .7];
  p1.LineWidth = 1;
  p1.Color = new_color_code_less_transparent(2,:);
  p1.HandleVisibility = 'off';
    hold on
end 

p = plot(median_fit); % plot fit of the median
p.LineWidth = 2.5;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','off') % plot values of median for fit


    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit 
    x_1 = median(cell2mat(cell_fits(5,1:size(cell_fits,2)-2)),2);  
    blub = cell_fits{2,size(cell_fits,2)};  % take median fit

    % plot V50 value on the median fit 
    plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75,'HandleVisibility','off')
   
    
    % plot gray line to mark V50 value for better comparison between I-V
    % curves
    xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13)
    % yline(0.5,'--','LineWidth',1,'FontSize',12)


% set labels and axis properties
box off
xlabel([]) % delete axis labels
ylabel([])

legend off
ax = gca;
ax.FontSize = 14; 
ax.LineWidth= 1; %change to the desired value     
ax.TitleHorizontalAlignment = 'left';

ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])
title('{\fontsize{20}B} - Kv8.2')



nexttile(5,[1,2]) %%% KCNB1/KCNV2 transfection

% store the fits and data into seperate variables
cell_fits = KCNB1_KCNV2_C5_struct_mean.IV_fits;
median_fit = KCNB1_KCNV2_C5_struct_mean.IV_fits{2,size(cell_fits,2)};
KCNB1_KCNV2_median_rawvalues = table2array(KCNB1_KCNV2_C5_struct_mean.mean_currents_Imax_norm);
median_raw = median(KCNB1_KCNV2_median_rawvalues,2);


% plot raw data point of each cell
plot(x_data,KCNB1_KCNV2_median_rawvalues,'*','Color',new_color_code(3,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on

% plot each seperate cell fit
for i = 1: size(cell_fits,2)-2
  p1 = plot(cell_fits{2,i}); 
  p1.LineWidth = 1;
  p1.Color = new_color_code_less_transparent(3,:);
  p1.HandleVisibility = 'off';
    hold on
end 
 
p = plot(median_fit); % plot fit of the median
p.LineWidth = 2.5;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','off') % plot values of median for fit


    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit 
    x_1 = median(cell2mat(cell_fits(5,1:size(cell_fits,2)-2)),2);
    blub = cell_fits{2,size(cell_fits,2)};  % get median fit

    % plot V50 value on the median fit 
    plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75,'HandleVisibility','off')
   
    % plot gray line to mark V50 value for better comparison between I-V
    % curves
    xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13)
    % yline(0.5,'--','LineWidth',1,'FontSize',12)

% set labels and axis properties
box off
xlabel('Voltage [mV]','FontSize',14)
ylabel('I/I_{max}','FontSize',14)

legend off
ax = gca;
ax.FontSize = 14; 
ax.LineWidth= 1; 
ax.TitleHorizontalAlignment = 'left'; % align plot title left

ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])
title('{\fontsize{20}C} - Kv2.1/Kv8.2')



%%% KCNB1/KCNV2/CRY4 transfection
nexttile(7,[1,2])

% store the fits and data into seperate variables
cell_fits = CRY4_C5_struct_mean.IV_fits;
median_fit = CRY4_C5_struct_mean.IV_fits{2,size(cell_fits,2)};
CRY4_median_rawvalues = table2array(CRY4_C5_struct_mean.mean_currents_Imax_norm);
median_raw = median(CRY4_median_rawvalues,2);

% plot raw data point of each cell
plot(x_data,CRY4_median_rawvalues,'*','Color',new_color_code(4,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on

% plot each seperate cell fit
for i = 1: size(cell_fits,2)-2
   p1 = plot(cell_fits{2,i}); 
  p1.LineWidth = 1;
  p1.Color = new_color_code_less_transparent(4,:);
  p1.HandleVisibility = 'off';
    hold on
end 

p = plot(median_fit); % plot fit of the median
p.LineWidth = 2.5;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','off') % plot values of median for fit

    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit 
    x_1 = median(cell2mat(cell_fits(5,1:size(cell_fits,2)-2)),2);    
    blub = cell_fits{2,size(cell_fits,2)};  % take median fit

    % plot V50 on fit
    plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75,'HandleVisibility','off')
    
    % plot gray line to mark V50 value for better comparison between I-V
    % curves
    xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13)
    % yline(0.5,'--','LineWidth',1,'FontSize',12)

% no box, axis-labels, and no legend
box off
xlabel('Voltage [mV]','FontSize',14)
ylabel([])

legend off
ax = gca;
ax.FontSize = 14; 
ax.LineWidth= 1; 
ax.TitleHorizontalAlignment = "left"; % align plot title left

% set axis properties and title
ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])
title('{\fontsize{20}D} - Kv2.1/Kv8.2/Cry4')



%%% Control
nexttile(10,[1 2])

% store the fits and data into seperate variables
cell_fits = C5_pretest_struct_mean.IV_fits;
median_fit = C5_pretest_struct_mean.IV_fits{2,size(C5_pretest_struct_mean.IV_fits,2)};
A3_median_rawvalues = table2array(C5_pretest_struct_mean.mean_currents_Imax_norm);
median_raw = median(A3_median_rawvalues,2);

% plot raw data point of each cell
plot(x_data,A3_median_rawvalues,'*','Color',new_color_code(6,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on

% plot each seperate cell fit
for i = 1: size(cell_fits,2)-2
  p1 = plot(cell_fits{2,i}); 
  p1.LineWidth = 1;
  p1.Color = new_color_code_less_transparent(6,:);
  p1.HandleVisibility = 'off';
    hold on
end 

p = plot(median_fit); % plot fit of the median
p.LineWidth = 2.5;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','off') % plot values of median for fit


    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit 
    x_1 = median(cell2mat(cell_fits(5,size(cell_fits,2)-2)),2);   
    blub = cell_fits{2,size(cell_fits,2)};  % take median fit

    % plot V50 value on fit
    plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75)

    % plot gray line to mark V50 value for better comparison between I-V
    % curves
    xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13)
    % yline(0.5,'--','LineWidth',1,'FontSize',12)

% box, and legend off and axis lables
box off
xlabel('Voltage [mV]','FontSize',14)
ylabel('I/I_{max}','FontSize',14)

legend off
ax = gca;
ax.FontSize = 14; 
ax.LineWidth= 1;   
ax.TitleHorizontalAlignment = 'left'; % align plot title left

% set axis properties and title

ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])

title('{\fontsize{20}E} - Control')

%%% save 
% exportgraphics(tiled,'C5_mean_transfected.pdf','ContentType','vector')


%% I-V of transfected conditions peak IA at -80 mV holding potential with control 


figure('Position',[41,63,922,734]) % figure for in total 5 subplots

tiled = tiledlayout(3,4,'TileSpacing','compact'); % 3x4 tiled layout
x_data = KCNB1_C5_struct_peak.voltage_steps;    %create a x vector 

% store the fits and data into seperate variables
cell_fits = KCNB1_C5_struct_peak.IV_fits;
median_fit = KCNB1_C5_struct_peak.IV_fits{2,size(KCNB1_C5_struct_peak.IV_fits,2)};
KCNB1_median_rawvalues = table2array(KCNB1_C5_struct_peak.A_peak_Imax_norm);
median_raw = median(KCNB1_median_rawvalues,2);


nexttile([1,2])  %%% KCNB1 transfection

% plot raw data point of each cell
plot(x_data,KCNB1_median_rawvalues,'*','Color',new_color_code(1,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on
plot(x_data(1),KCNB1_median_rawvalues(1,1),'*','Color',new_color_code(1,:),'MarkerSize',6.5,'HandleVisibility','on')

% plot each seperate cell fit
for i = 1: size(cell_fits,2)-2
   p1 = plot(cell_fits{2,i}); 
  p1.LineWidth = 0.25;
  p1.Color = new_color_code_less_transparent(1,:);
  p1.HandleVisibility = 'off';
    hold on
end 
  
  p2 = plot(cell_fits{2,i});% plot one line again to get only one HandleVisibility
  p2.LineWidth = 0.25;
  p2.Color = new_color_code_less_transparent(1,:);
  p2.HandleVisibility = 'on';

plot(x_data,median_raw,'.k','MarkerSize',15)  % plot values of median for HandleVisibility in legend
p = plot(median_fit); % plot fit of the median
p.LineWidth = 2.5;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','off') % plot values of median that dots are above fit


    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit 
   x_1 = median(cell2mat(cell_fits(5,1:size(cell_fits,2)-2)),2);  

   blub = cell_fits{2,size(cell_fits,2)};   % take median fit
   
   % plot V50 value on the median fit 
   plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75,'HandleVisibility','on')

   % plot gray line to mark V50 value for better comparison between I-V
   % curves
   xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13)
   % yline(0.5,'--','LineWidth',1,'FontSize',12)
        
box off
xlabel([]) % delete x-axis label
ylabel('I/I_{max}','FontSize',14)

legend off
ax = gca; % get axis properties
ax.FontSize = 14; 
ax.LineWidth= 1; 
ax.TitleHorizontalAlignment = 'left'; % align plot title left

% set axis properties and title
ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])
title('{\fontsize{20}A} - Kv2.1')

% create legend and set legend properties 
% legend will be plotted lower right panel beisde last plot
[~, hobj, ~, ~] = legend('Raw data','Single cell fit','Median across cells','Fit of median','Median V_{50}','Orientation', 'Vertical','Position',[0.723373143326468,0.13,0.157266811279826,0.16]);
hl = findobj(hobj,'type','line');  % find the characters in the legend
set(hl,'LineWidth',1.5,'MarkerSize',10); % increase size 
ht = findobj(hobj,'type','text');
fontsize(ht,15,'points') % set text font

legend('boxoff')                                        



nexttile([1,2]) %%% KCNV2 transfection

% store the fits and data into seperate variables
cell_fits = KCNV2_C5_struct_peak.IV_fits;
median_fit = KCNV2_C5_struct_peak.IV_fits{2,size(cell_fits,2)};
KCNV2_median_rawvalues = table2array(KCNV2_C5_struct_peak.A_peak_Imax_norm);
median_raw = median(KCNV2_median_rawvalues,2);

% plot raw data point of each cell
plot(x_data,KCNV2_median_rawvalues,'*','Color',new_color_code(2,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on

% plot each seperate cell fit
for i = 1: size(cell_fits,2)-2
   p1 = plot(cell_fits{2,i});
  p1.LineWidth = 1;
  p1.Color = new_color_code_less_transparent(2,:);
  p1.HandleVisibility = 'off';
    hold on
end 

p = plot(median_fit); % plot fit of the median
p.LineWidth = 2.5;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','off') % plot values of median for fit


    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit 
    x_1 = median(cell2mat(cell_fits(5,1:size(cell_fits,2)-2)),2);  
    blub = cell_fits{2,size(cell_fits,2)};  

    % plot V50 value
    plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75,'HandleVisibility','off')

    % plot gray line to mark V50 value for better comparison between I-V
    % curves
    xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13)
    % yline(0.5,'--','LineWidth',1,'FontSize',12)

% box, axis-label, and legend off
box off
xlabel([])
ylabel([])

legend off
ax = gca;
ax.FontSize = 14; 
ax.LineWidth= 1;   
ax.TitleHorizontalAlignment = 'left';  % align plot title left

% set axis properties and title
ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])
title('{\fontsize{20}B} - Kv8.2')



nexttile(5,[1,2]) %%% KCNB1/KCNV2 transfection

% store the fits and data into seperate variables
cell_fits = KCNB1_KCNV2_C5_struct_peak.IV_fits;
median_fit = KCNB1_KCNV2_C5_struct_peak.IV_fits{2,size(cell_fits,2)};
KCNB1_KCNV2_median_rawvalues = table2array(KCNB1_KCNV2_C5_struct_peak.A_peak_Imax_norm);
median_raw = median(KCNB1_KCNV2_median_rawvalues,2);

% plot raw data point of each cell
plot(x_data,KCNB1_KCNV2_median_rawvalues,'*','Color',new_color_code(3,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on

% plot each seperate cell fit
for i = 1: size(cell_fits,2)-2
   p1 = plot(cell_fits{2,i}); 
  p1.LineWidth = 1;
  p1.Color = new_color_code_less_transparent(3,:);
  p1.HandleVisibility = 'off';
    hold on
end 
 
p = plot(median_fit); % plot fit of the median
p.LineWidth = 2.5;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','off')  % plot values of median for fit again


    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit 
    x_1 = median(cell2mat(cell_fits(5,1:size(cell_fits,2)-2)),2);

    blub = cell_fits{2,size(cell_fits,2)};  % take median fit

    % plot V50 value on the median fit 
    plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75,'HandleVisibility','off')

    % plot gray line to mark V50 value for better comparison between I-V
    % curves
    xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13)
    % yline(0.5,'--','LineWidth',1,'FontSize',12)

% set axis properties and title
box off
xlabel('Voltage [mV]','FontSize',14)
ylabel('I/I_{max}','FontSize',14)

legend off
ax = gca;  % get axis properties
ax.FontSize = 14; 
ax.LineWidth= 1; %change to the desired value     
ax.TitleHorizontalAlignment = 'left';

ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])
title('{\fontsize{20}C} - Kv2.1/Kv8.2')



%%% KCNB1/KCNV2/CRY4 transfection
nexttile(7,[1,2])

% store the fits and data into seperate variables
cell_fits = CRY4_C5_struct_peak.IV_fits;
median_fit = CRY4_C5_struct_peak.IV_fits{2,size(cell_fits,2)};
CRY4_median_rawvalues = table2array(CRY4_C5_struct_peak.A_peak_Imax_norm);
median_raw = median(CRY4_median_rawvalues,2);

% plot raw data point of each cell
plot(x_data,CRY4_median_rawvalues,'*','Color',new_color_code(4,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on

% plot each seperate cell fit
for i = 1: size(cell_fits,2)-2
   p1 = plot(cell_fits{2,i}); % plot each seperate cell fit
  p1.LineWidth = 0.25;
  p1.Color = new_color_code_less_transparent(4,:); % color of each seperate fit 
  p1.HandleVisibility = 'off';
    hold on
end 

p = plot(median_fit); % plot fit of the median
p.LineWidth = 2.5;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','off') % plot values of median for fit

    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit
    x_1 = median(cell2mat(cell_fits(5,1:size(cell_fits,2)-2)),2);    

    blub = cell_fits{2,size(cell_fits,2)};  % take median fit

    % plot V50 value on the median fit 
    plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75,'HandleVisibility','off')
  
    % plot gray line to mark V50 value for better comparison between I-V
    % curves
    xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13)
    % yline(0.5,'--','LineWidth',1,'FontSize',12)

% set axis properties, labels and title
box off
xlabel('Voltage [mV]','FontSize',14)
ylabel([]) % delete y-axis label

legend off
ax = gca; % get axis properties
ax.FontSize = 14; 
ax.LineWidth= 1;
ax.TitleHorizontalAlignment = "left"; % align plot title left

ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])
title('{\fontsize{20}D} - Kv2.1/Kv8.2/Cry4')



%%% Control
nexttile(10,[1 2])

% store the fits and data into seperate variables
cell_fits = C5_pretest_struct_peak.IV_fits;
median_fit = C5_pretest_struct_peak.IV_fits{2,size(C5_pretest_struct_peak.IV_fits,2)};
A3_median_rawvalues = table2array(C5_pretest_struct_peak.A_peak_Imax_norm);
median_raw = median(A3_median_rawvalues,2);

% plot raw data point of each cell
plot(x_data,A3_median_rawvalues,'*','Color',new_color_code(6,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on

% plot each seperate cell fit
for i = 1: size(cell_fits,2)-2
   p1 = plot(cell_fits{2,i}); 
  p1.LineWidth = 0.25;
  p1.Color = new_color_code_less_transparent(6,:);
  p1.HandleVisibility = 'off';
    hold on
end 

p = plot(median_fit); % plot fit of the median
p.LineWidth = 2.5;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','off') % plot values of median for fit again


    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit 
    x_1 = median(cell2mat(cell_fits(5,size(cell_fits,2)-2)),2);     
    blub = cell_fits{2,size(cell_fits,2)};   % take median fit

    % plot V50 value on the median fit 
    plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75)

    % plot gray line to mark V50 value for better comparison between I-V
    % curves
    xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13)
  %  yline(0.5,'--','LineWidth',1,'FontSize',12)

% box, axis-label, and legend off
box off
xlabel('Voltage [mV]','FontSize',14)
ylabel('I/I_{max}','FontSize',14)

legend off
ax = gca;
ax.FontSize = 14; 
ax.LineWidth= 1;  
ax.TitleHorizontalAlignment = 'left'; % align plot title left

ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])


legend off
title('{\fontsize{20}E} - Control')

%%% save
% exportgraphics(tiled,'C5_peak_transfected.pdf','ContentType','vector')

        %% C5 and C7 (peak and) mean 

% figure('Position',[41,63,922,734]) % figure for in total 4 subplots
figure('Position',[41,63,922,734]) % figure for in total 5 subplots

% tiled = tiledlayout(2,4,'TileSpacing','compact');  % 2x2 tiled layout
tiled = tiledlayout(3,4,'TileSpacing','compact'); % 3x4 tiled layout

x_data = C5_pretest_struct_peak.voltage_steps;    %create a x vector 

%%% -80 mV, 100 ms (C5) IK peak
nexttile([1,2])

% store the fits and data into seperate variables
cell_fits = C5_pretest_struct_peak.IV_fits;
median_fit = C5_pretest_struct_peak.IV_fits{2,size(C5_pretest_struct_peak.IV_fits,2)};
A3_median_rawvalues = table2array(C5_pretest_struct_peak.A_peak_Imax_norm);
median_raw = median(A3_median_rawvalues,2);

% plot raw data point of each cell
plot(x_data,A3_median_rawvalues,'*','Color',new_color_code(6,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on

% plot each seperate cell fit
for i = 1: size(cell_fits,2)-2
   p1 = plot(cell_fits{2,i}); 
  p1.LineWidth = 1;
  p1.Color = new_color_code_less_transparent(6,:);
  p1.HandleVisibility = 'off';
    hold on
end 

p = plot(median_fit); % plot fit of the median
p.LineWidth = 2.5;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','off') % plot values of median for fit


    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit 
    x_1 = median(cell2mat(cell_fits(5,size(cell_fits,2)-2)),2);   
    blub = cell_fits{2,size(cell_fits,2)};   % take median fit


    % plot V50 value on the median fit 
    plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75)

    % plot gray line to mark V50 value for better comparison between I-V
    % curves
    xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13)
  %  yline(0.5,'--','LineWidth',1,'FontSize',12)


% set axis properties and title
legend off
ax = gca;
ax.FontSize = 14; 
ax.LineWidth= 1;  
ax.TitleHorizontalAlignment = 'left'; % align plot title left

yticks([-0.5 0 0.5 1])
ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])
title('{\fontsize{20}A}')


box off
xlabel([])
ylabel('I/I_{max}','FontSize',14)


    %%% -80 mV, 100 ms (C5) IK mean

nexttile([1,2])

cell_fits = C5_pretest_struct_mean.IV_fits;
median_fit = C5_pretest_struct_mean.IV_fits{2,size(C5_pretest_struct_mean.IV_fits,2)};
A3_median_rawvalues = table2array(C5_pretest_struct_mean.mean_currents_Imax_norm);
median_raw = median(A3_median_rawvalues,2);


plot(x_data,A3_median_rawvalues,'*','Color',new_color_code(6,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on
plot(x_data(1),A3_median_rawvalues(1,1),'*','Color',new_color_code(6,:),'MarkerSize',9,'HandleVisibility','on')

for i = 1: size(cell_fits,2)-2
   p1 = plot(cell_fits{2,i}); % plot each seperate cell fit
  % p1.Color = [.7 .7 .7];
  p1.LineWidth = 1;
  p1.Color = new_color_code_less_transparent(6,:);
  p1.HandleVisibility = 'off';
    hold on
end 
  p2 = plot(cell_fits{2,i}); % plot each seperate cell fit
  p2.LineWidth = 0.25;
  p2.Color = new_color_code_less_transparent(6,:);
  p2.HandleVisibility = 'on';


plot(x_data,median_raw,'.k','MarkerSize',15) % plot values of median for HandleVisibility
p = plot(median_fit); % plot fit of the median
p.LineWidth = 2.5;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','off') % plot values of median om fit


    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit
    x_1 = median(cell2mat(cell_fits(5,size(cell_fits,2)-2)),2);   

    blub = cell_fits{2,size(cell_fits,2)};   % take median fit

    % plot V50 value on the median fit 
    plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75)

    % plot gray line to mark V50 value for better comparison between I-V
    % curves
    xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13)
    %  yline(0.5,'--','LineWidth',1,'FontSize',12)


box off
xlabel([])
ylabel([])

% create legend and set legend properties 
% legend will be plotted lower right panel beisde last plot
[~, hobj, ~, ~] = legend('Raw data','Single cell fit','Median across cells','Fit of median','Median V_{50}','Location','south','Orientation', 'Vertical','Box','off');
hl = findobj(hobj,'type','line');
set(hl,'LineWidth',1.5,'MarkerSize',10);
ht = findobj(hobj,'type','text');
fontsize(ht,14,'points')


% set axis properties and title
ax = gca;
ax.FontSize = 14; 
ax.LineWidth= 1; %change to the desired value     
ax.TitleHorizontalAlignment = 'left';

yticks([-0.5 0 0.5 1])
ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])
title('{\fontsize{20}B}')
% title(C5 mean)


%%% -80 mV, 1000 ms (C7) IA peak

nexttile(5,[1,2])

% store the fits and data into seperate variables
cell_fits = C7_pretest_struct_peak.IV_fits;
median_fit = C7_pretest_struct_peak.IV_fits{2,size(C7_pretest_struct_peak.IV_fits,2)};
A3_median_rawvalues = table2array(C7_pretest_struct_peak.A_peak_Imax_norm);
median_raw = median(A3_median_rawvalues,2);

% plot raw data point of each cell
plot(x_data,A3_median_rawvalues,'*','Color',new_color_code(9,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on

% plot each seperate cell fit
for i = 1: size(cell_fits,2)-2
   p1 = plot(cell_fits{2,i}); 
  p1.LineWidth = 1;
  p1.Color = new_color_code(9,:);
  p1.HandleVisibility = 'off';
    hold on
end 

p = plot(median_fit); % plot fit of the median
p.LineWidth = 2.5;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','off') % plot values of median for fit


    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit  
    x_1 = median(cell2mat(cell_fits(5,size(cell_fits,2)-2)),2);   
    blub = cell_fits{2,size(cell_fits,2)};    % take median fit

    % plot V50 value on the median fit 
    plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75)

    % plot gray line to mark V50 value for better comparison between I-V
    % curves
    xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13)
   %  yline(0.5,'--','LineWidth',1,'FontSize',12)


% set axis properties and title
box off
xlabel('Voltage [mV]','FontSize',14)
ylabel('I/I_{max}','FontSize',14)

legend off
ax = gca;
ax.FontSize = 14; 
ax.LineWidth= 1;  
ax.TitleHorizontalAlignment = 'left'; % align plot title left
yticks([-0.5 0 0.5 1])
ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])

title('{\fontsize{20}C}')


%%% -80 mV, 1000 ms (C7) IK mean
nexttile(7,[1,2])

% store the fits and data into seperate variables
cell_fits = C7_pretest_struct_mean.IV_fits;
median_fit = C7_pretest_struct_mean.IV_fits{2,size(C7_pretest_struct_mean.IV_fits,2)};
A3_median_rawvalues = table2array(C7_pretest_struct_mean.mean_currents_Imax_norm);
median_raw = median(A3_median_rawvalues,2);

% plot raw data point of each cell
plot(x_data,A3_median_rawvalues,'*','Color',new_color_code(9,:),'HandleVisibility','off','LineWidth',0.9,'MarkerSize',9);
hold on

% plot each seperate cell fit
for i = 1: size(cell_fits,2)-2
   p1 = plot(cell_fits{2,i}); 
  p1.LineWidth = 1;
  p1.Color = new_color_code(9,:);
  p1.HandleVisibility = 'off';
    hold on
end 

p = plot(median_fit); % plot fit of the median
p.LineWidth = 2.5;
plot(x_data,median_raw,'.k','MarkerSize',15,'HandleVisibility','off') % plot values of median for fit

    % calculate median V50 from middlepoint of all single single fits   
    % take out the calculated fit coefficient values of the fit 
    x_1 = median(cell2mat(cell_fits(5,size(cell_fits,2)-2)),2);   
    blub = cell_fits{2,size(cell_fits,2)};  % take median fit

    % plot V50 value on the median fit 
    plot(x_1,blub(x_1),'o','MarkerSize',13,'MarkerEdgeColor','k','LineWidth',1.75)

    % plot gray line to mark V50 value for better comparison between I-V
    % curves
    xline(x_1,'-','V_{50}','LineWidth',1,'LabelHorizontalAlignment','right','LabelVerticalAlignment','top','LabelOrientation','horizontal','FontSize',13)
    %  yline(0.5,'--','LineWidth',1,'FontSize',12)


box off
xlabel('Voltage [mV]','FontSize',14)
ylabel([])  % delete y-axis label

% set axis properties and title
legend off
ax = gca;
ax.FontSize = 14; 
ax.LineWidth= 1;    
ax.TitleHorizontalAlignment = 'left';
yticks([-0.5 0 0.5 1])
ylim([-0.6 1.2])
xlim([-105 65])
xticks([-100 -80 -60 -40 -20 0 20 40 60])

title('{\fontsize{20}D}')

%%% save
% exportgraphics(tiled,'C5_C7_IV.pdf','ContentType','vector')
