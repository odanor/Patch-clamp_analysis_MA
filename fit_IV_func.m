%% Function to fit with either Gauss or Bolzmann function
%%% Author: Oda E. Riedesel
%%% Date: May 2023
%
% Function is fitting the I-V curves with either Bolzmann or Gauss
% function.
%
%
% - Input: 
%  IVmedian :  is a vector with the median values for the different cells that are included in the I-V curve
%  voltage_steps : x axis vector with the steps of voltages the data was
%  recroded with
%       voltage_steps = (-100:10:50)';  % set x ax
%       voltage_steps = (-90:10:40)';  % set x axis
%
%  Ionflag : choose with what the data should be fitted
%%%             1 = Bolzmann fit
%%%             2 = Gauss fit for sodium currents
%%%             3 = Bolzmann for potassium for the inactivation protocol
%%%                 with forced to maximum = 1
%%%             4 = Bolzmann forced to maximum = 1
%
% - Output: 
%   fitresult : fit in cfit format
%   gof2 : goodness-of-fit
%
% *** Notes *** 
%%% If something seems off run curveFitter and check manually
%%% Note that the exponential fits were re-located to the extra function
%%% exp_fit_taucalc.m


function [fitresult,gof2] = fit_IV_func(IVmedian,voltage_steps,Ionflag)
     if istable(IVmedian) == 1
            IVmedian = table2array(IVmedian); % convert the table into a matrix only for calculation reasons
    end 

    if size(voltage_steps,1) == 1
        voltage_steps = voltage_steps';
    end

    if Ionflag == 2
        %% sodium
        % fit with Gaussian model with two terms
        % get fit and goodness-of-fit statistics in the structure gof2.
        [fitresult,gof2] = fit(voltage_steps,IVmedian,'gauss2');
            
        figure 
        plot(voltage_steps,IVmedian) % plot the I-V curve template
        hold on
        plot(fitresult)
        hold off


    elseif Ionflag == 1
        %% potassium
        
        % A2+(A1-A2)/(1+exp((x-x0)/dx))  [0 500 8 16] Starpoint template
        % b = fittype('A2+(A1-A2)/(1+exp((x-x0)/dx))'); %Boltzmann
        % b1 = @(A1,A2, x0, dx, x)A2+(A1-A2)./(1+exp((x-x0)./dx));
        bman = @(baseline,gain,slope,midpoint,x)baseline + (gain ./ (1+exp(-slope .* (x-midpoint))));
            % Bolzmann equation as function

        [fitresult,gof2] = fit(voltage_steps,IVmedian,bman,'StartPoint',[0 1 0.5 30]);
        % get fit and goodness-of-fit statistics in the structure gof2.
        
        figure
        plot(voltage_steps,IVmedian) % plot the I-V curve template
        hold on
        plot(fitresult) % fit with Bolzmann model
        hold off 
        %[0 1 0.5 40] Starpoint template
        % plot the raw I-V curve and the fit over it to check how they
        % align

        %%%  k = 1/slope
   
    elseif Ionflag == 3 
        %% Boltzmann for (A2) inactivation protocol forced to 1
        bman = @(baseline,slope,midpoint,x)baseline + (1 ./ (1+exp(-slope .* (x-midpoint))));
        % Bolzmann equation as function

        [fitresult,gof2] = fit(voltage_steps,IVmedian,bman,'StartPoint',[-1 0.05 -60]);
        % get fit and goodness-of-fit statistics in the structure gof2.
        
        figure
        plot(voltage_steps,IVmedian) % plot the I-V curve template
        hold on
        plot(fitresult) % fit with Bolzmann model
        hold off 


elseif Ionflag == 4
        %% Boltzmann forced to maximum = 1
        
        % gain = 1;
        % A2+(A1-A2)/(1+exp((x-x0)/dx))  [0 500 8 16] Starpoint template
        % b = fittype('A2+(A1-A2)/(1+exp((x-x0)/dx))'); %Boltzmann
        % b1 = @(A1,A2, x0, dx, x)A2+(A1-A2)./(1+exp((x-x0)./dx));
        bman = @(baseline,slope,midpoint,x)baseline + (1 ./ (1+exp(-slope .* (x-midpoint))));
            % Bolzmann equation as function

        [fitresult,gof2] = fit(voltage_steps,IVmedian,bman,'StartPoint',[0 0.5 30]);
        % get fit and goodness-of-fit statistics in the structure gof2.
        
        figure
        plot(voltage_steps,IVmedian) % plot the I-V curve template
        hold on
        plot(fitresult) % fit with Bolzmann model
        hold off 
        %[0 1 0.5 40] Starpoint template
        % plot the raw I-V curve and the fit over it to check how they
        % align

 
    end % end of Ionflag if statement
end % end of function 

