%% Function to create transparent errorbars behin boxplots
%%% Author: Oda E. Riedesel
%%% Date: 31.10.2023

% Function is creating a transparent bar as a background to the data to
% create a kind of boxplot style. The bar is either the standarddevaition
% or ranging from the 25% to the 75% interquartile range. Depending on what was used, the mean or median is plotted.
% 
%
% - Input: 
%   cells : data that should be plotted 
%
%   Cell_color_code :  column vector with the color code for the data
%
%   Cell_color_code_transparent : column vector with the color code for the
%   transparent IQR

%   num_cond :  x-axis value where the boxplot in the plot should be
%   displayed
%
%   handle_visibility_legend : 
%%%      0 = HandleVisibility "off" for the dots of each data point
%%%      1 = HandleVisibility "on" for the dots of each data point
%
%   handle_visibility_dots :
%%%      0 = HandleVisibility "off" for the 
%%%      1 = HandleVisibility "on" for the dots of each data point
%
% *** Notes *** 
%%% The function was used for the plots in my Master thesis to see the idea behind it.
%%%
%%%
%
% Example:
%%% transparent_errorbar_fig(KCNB1,new_color_code(1,:),new_color_code_transparent(1,:),1,2,0,0)


%%
function transparent_errorbar_fig(cells,Cell_color_code,Cell_color_code_transparent,num_cond,mode,handle_visibility_legend,handle_visibility_dots)

    if mode == 1 % mean and td
        % y axis
        y_per_cells = table2array(cells);
        
        % x axis
        x_for_cell = zeros(1, length(y_per_cells)); x_for_cell(:) = num_cond; % create x-axis
        cell_mean = mean(y_per_cells); cell_std = std(y_per_cells); % calculate mean and std across each cell
        
        cells_y = cell_mean - cell_std:0.001:cell_mean + cell_std; % create y-axis vector for the length that should be transparent colored
        
        cells_x2 = zeros(1,length(cells_y)); cells_x2(:) = num_cond; % prolong for each y-value the x-vector with the number where on the x-axis the bar should be placed
        

        % plot trasparent line beind dots 
        plot(cells_x2,cells_y,'LineWidth',4,'Color',Cell_color_code_transparent,'HandleVisibility','off');
    
        % Plot the data points either with or without HandleVisibility in
        % legend
        if handle_visibility_dots == 0 
            plot(x_for_cell,y_per_cells,'.','Color',Cell_color_code,'MarkerSize',14,'HandleVisibility','off')
        elseif handle_visibility_dots == 1
            plot(x_for_cell,y_per_cells,'.','Color',Cell_color_code,'MarkerSize',14)
        end 

        % Plot mean of all data in black either with or without HandleVisibility in
        % legend
        if handle_visibility_legend == 0
            plot(num_cond,cell_mean,'MarkerSize',10,'Marker','o','Color','k','LineWidth',1.25,'HandleVisibility','off','LineStyle','none')
        elseif handle_visibility_legend == 1
            plot(num_cond,cell_mean,'MarkerSize',10,'Marker','o','Color','k','LineWidth',1.25,'LineStyle','none')

        end


    elseif mode == 2 % median and quantiles

        % y axis
        y_per_cells = table2array(cells);

        cell_quantiles = quantile(y_per_cells,[0.25 0.5 0.75]); % calculate 25%, 50% (median) and 75% IQR
        
        quantile_difference = cell_quantiles(1,3) - cell_quantiles(1,1);
        
        upper_outlier_threshold = cell_quantiles(1,3) + (1.5 * quantile_difference);
        lower_outlier_threshold = cell_quantiles(1,1) - (1.5 * quantile_difference);
        
 
        % x axis
        x_for_cell = zeros(1, length(y_per_cells)); x_for_cell(:) = num_cond;
        
        cells_y = cell_quantiles(1):0.001:cell_quantiles(3); % create y-axis vector for the length that should be transparent colored from 25% to 75% IQR
        
        cells_x2 = zeros(1,length(cells_y)); cells_x2(:) = num_cond; % prolong for each y-value the x-vector with the number where on the x-axis the bar should be placed
       
        % plot trasparent line beind dots 
        plot(cells_x2,cells_y,'LineWidth',4,'Color',Cell_color_code_transparent,'HandleVisibility','off');
       
        for i = 1:length(y_per_cells)
            if y_per_cells(i) > upper_outlier_threshold == 1|| y_per_cells(i) < lower_outlier_threshold == 1
                
                % Plot the data points either with or without HandleVisibility in
                % legend
                if handle_visibility_dots == 0
                    plot(x_for_cell,y_per_cells(i),'^','Color',Cell_color_code,'MarkerSize',10,'HandleVisibility','off','LineWidth',2)
                elseif handle_visibility_dots == 1
                    plot(x_for_cell,y_per_cells(i),'^','Color',Cell_color_code,'MarkerSize',10,'LineWidth',1)
                end

            else

                % Plot the data points either with or without HandleVisibility in
                % legend
                if handle_visibility_dots == 0
                    plot(x_for_cell,y_per_cells(i),'.','Color',Cell_color_code,'MarkerSize',14,'HandleVisibility','off')
                elseif handle_visibility_dots == 1
                    plot(x_for_cell,y_per_cells(i),'.','Color',Cell_color_code,'MarkerSize',14)
                end
            end
        end

        % Plot mean of all data in black either with or without HandleVisibility in
        % legend
        if handle_visibility_legend == 0
            plot(num_cond,cell_quantiles(2),'MarkerSize',10,'Marker','o','Color','k','LineWidth',1.25,'HandleVisibility','off','LineStyle','none')
        elseif handle_visibility_legend == 1
            plot(num_cond,cell_quantiles(2),'MarkerSize',10,'Marker','o','Color','k','LineWidth',1.25,'LineStyle','none')
        end

  
    end % end median calculation


end % end function