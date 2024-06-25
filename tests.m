%% Script for the boxplotsfor the Master thesis
%%% Author: Oda E. Riedesel
%%% Date: 2024
%
% This script includes the calculation of all tests done for the Master
% thesis.
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
% *** Notes *** 
%%% The workspace saved after conducting the tests can be found online with
%%% the other raw data. For location see in the thesis.
%%%
%%%
% needed data :
% the structs of the data analysis of each transfected
% condition recorded at -30 mV is needed : 
%                                         KCNB1_pretest_struct.mat
%                                         KCNV2_struct.mat
%                                         KCNB1_KCNV2_struct.mat
%                                         CRY4_KCNB1_KCNV2_struct.mat
%                                         A3_pretest_struct.mat

%% V50
% Take out data to test from the structures

KCNB1_V50 = cell2mat(KCNB1_A3_struct.IV_fits(5,1:length(KCNB1_A3_struct.IV_fits)-2));
KCNV2_V50 = cell2mat(KCNV2_A3_struct.IV_fits(5,1:length(KCNV2_A3_struct.IV_fits)-2));
A3_V50 = cell2mat(A3_pretest_struct_mean.IV_fits(5,1:length(A3_pretest_struct_mean.IV_fits)-2));
KCNB1_KCNV2_V50 = cell2mat(KCNB1_KCNV2_A3_struct.IV_fits(5,1:length(KCNB1_KCNV2_A3_struct.IV_fits)-2));
CRY4_V50 = cell2mat(CRY4_A3_struct.IV_fits(5,1:length(CRY4_A3_struct.IV_fits)-2));

%% slope
% Take out data to test from the structures

KCNB1_slope = cell2mat(KCNB1_A3_struct.IV_fits(6,1:length(KCNB1_A3_struct.IV_fits)-2));
KCNV2_slope = cell2mat(KCNV2_A3_struct.IV_fits(6,1:length(KCNV2_A3_struct.IV_fits)-2));
A3_slope = cell2mat(A3_pretest_struct_mean.IV_fits(6,1:length(A3_pretest_struct_mean.IV_fits)-2));
KCNB1_KCNV2_slope = cell2mat(KCNB1_KCNV2_A3_struct.IV_fits(6,1:length(KCNB1_KCNV2_A3_struct.IV_fits)-2));
CRY4_slope = cell2mat(CRY4_A3_struct.IV_fits(6,1:length(CRY4_A3_struct.IV_fits)-2));


%% Kruskal-wallis test of V50 values of all conditions recorded at -30 mV holding potential without Cry4

% put values into variables
KCNB1_V50 = KCNB1_V50'; KCNB1_KCNV2_V50 = KCNB1_KCNV2_V50'; 
KCNV2_V50 = KCNV2_V50'; A3_V50 = A3_V50';

% put all variables into one vector to test
V50_test = [KCNB1_V50;KCNB1_KCNV2_V50;KCNV2_V50;A3_V50];

% get vector with the groups that are tested
test_groups = [repmat("KCNB1",1,5),repmat("KCNB1_KCNV2",1,6),repmat("KCNV2",1,4),repmat("Control",1,5)]';

%test 
[p,idk,stats] = kruskalwallis(V50_test,test_groups);


%% Post-hoc ranksum tests with alpha Bonferroni corretion without Cry4

alpha = 0.05; % set alpha border
groups = unique(test_groups); % exclude repitions of vector
p_vals = zeros(length(groups));
test_counter = 0;

% Perform pair-wise Wilcoxon rank sum tests
for i=1:length(groups)
    for j=i+1:length(groups)
        indexi = test_groups == groups(i);
        indexj = test_groups == groups(j);
        p_vals(i,j) = ranksum(V50_test(indexi),V50_test(indexj));
        test_counter = test_counter + 1;
    end
end

% Check which groups significantly differ and print info to command window
for i=1:length(groups)
    for j=i+1:length(groups)
        if p_vals(i,j) < (alpha/test_counter)
            sprintf("Significant difference between groups: %s and %s (%0.5f)", ...
                groups(i), groups(j), p_vals(i,j))
        end
    end
end

% get Bonferroni corrected alpha level
new_alpha = (alpha/test_counter_noo);

%% Kruskal-wallis test of V50 values of all conditions recorded at -30 mV holding potential with Cry4

% turn around the vectors to get columnvector
KCNB1_V50 = KCNB1_V50'; KCNB1_KCNV2_V50 = KCNB1_KCNV2_V50'; CRY4_V50 = CRY4_V50';
KCNV2_V50 = KCNV2_V50'; A3_V50 = A3_V50';

% put all variables into one vector to test
V50_test = [KCNB1_V50;KCNB1_KCNV2_V50;CRY4_V50;KCNV2_V50;A3_V50];

% get vector with the groups that are tested
test_groups = [repmat("KCNB1",1,5),repmat("KCNB1_KCNV2",1,6), ...
    repmat("CRY4",1,10),repmat("KCNV2",1,4),repmat("Control",1,5)]';

% exclude outlier from test : 
% test_groups = repmat("KCNB1",5,1);
% test_groups(6:11) = repmat("KCNB1_KCNV2",6,1);
% test_groups(12:21) = repmat("CRY4",10,1);

%test 
[p,idk,stats] = kruskalwallis(V50_test,test_groups);


%% Post-hoc ranksum tests with alpha Bonferroni corretion with Cry4

alpha = 0.05; % set alpha border
groups = unique(test_groups); % exclude repitions of vector
p_vals = zeros(length(groups));
test_counter = 0;

% Perform pair-wise Wilcoxon rank sum tests
for i=1:length(groups)
    for j=i+1:length(groups)
        indexi = test_groups == groups(i);
        indexj = test_groups == groups(j);
        p_vals(i,j) = ranksum(V50_test(indexi),V50_test(indexj));
        test_counter = test_counter + 1;
    end
end

% Check which groups significantly differ and print info to command window
for i=1:length(groups)
    for j=i+1:length(groups)
        if p_vals(i,j) < (alpha/test_counter)
            sprintf("Significant difference between groups: %s and %s (%0.5f)", ...
                groups(i), groups(j), p_vals(i,j))
        end
    end
end

% get Bonferroni corrected alpha level
new_alpha = (alpha/test_counter_noo);

%% test Effectsize of the found significant difference


[p,h,stats]=ranksum(CRY4_V50,KCNB1_KCNV2_V50,'method','approximate');
effect_size = stats.zval/sqrt(16);



%% Kruskal-wallis test of the slope values of all conditions recorded at -30 mV holding potential without Cry4

% turn around the vectors to get columnvector
KCNB1_slope = KCNB1_slope'; KCNB1_KCNV2_slope = KCNB1_KCNV2_slope';
KCNV2_slope = KCNV2_slope'; A3_slope = A3_slope';

% put all variables into one vector to test
slope_test = [KCNB1_slope;KCNB1_KCNV2_slope;KCNV2_slope;A3_slope];

% get vector with the groups that are tested
test_groups = [repmat("KCNB1",1,5),repmat("KCNB1_KCNV2",1,6),repmat("KCNV2",1,4),repmat("Control",1,5)]';

%test 
[p_slope,idk_slope,stats_slope] = kruskalwallis(slope_test,test_groups);

%% Kruskal-wallis test of the slope values of all conditions recorded at -30 mV holding potential

% turn around the vectors to get columnvector
KCNB1_slope = KCNB1_slope'; KCNB1_KCNV2_slope = KCNB1_KCNV2_slope'; CRY4_slope= CRY4_slope';
KCNV2_slope = KCNV2_slope'; A3_slope = A3_slope';

% put all variables into one vector to test
slope_test = [KCNB1_slope;KCNB1_KCNV2_slope;CRY4_slope;KCNV2_slope;A3_slope];

% get vector with the groups that are tested
test_groups = [repmat("KCNB1",1,5),repmat("KCNB1_KCNV2",1,6), ...
    repmat("CRY4",1,10),repmat("KCNV2",1,4),repmat("Control",1,5)]';

%test 
[p_slope,idk_slope,stats_slope] = kruskalwallis(slope_test,test_groups);


%% Kruskal-wallis test of the tau values of all conditions recorded at -30 mV holding potential without Cry4
% at a voltage change of +30 mV 


% put values into variables from struct
tau1 = cell2mat([KCNV2_A3_struct.exponential_fit_values(4,:)'; ...
    KCNB1_A3_struct.exponential_fit_values(4,:)'; ...
    KCNB1_KCNV2_A3_struct.exponential_fit_values(4,:)']); % tau slow

tau2 = cell2mat([KCNV2_A3_struct.exponential_fit_values(5,:)'; ...
    KCNB1_A3_struct.exponential_fit_values(5,:)'; ... 
    KCNB1_KCNV2_A3_struct.exponential_fit_values(5,:)']); % tau fast


% create test groups
test_groups = [repmat("KCNV2",1,4), ...
    repmat("KCNB1",1,5),repmat("KCNV2_KCNB1",1,6)];

% test both values
[p_tau_1,idk_tau_1,stats_tau_1] = kruskalwallis(tau1,test_groups);
[p_tau_2,idk_tau_2,stats_tau_2] = kruskalwallis(tau2,test_groups);

%% Kruskal-wallis test of the tau values of all conditions recorded at -30 mV holding potential with Cry4
% at a voltage change of +30 mV 


% put values into variables from struct 
tau1 = cell2mat([CRY4_A3_struct.exponential_fit_values(4,:)'; ...
    KCNV2_A3_struct.exponential_fit_values(4,:)'; ...
    KCNB1_A3_struct.exponential_fit_values(4,:)'; ...
    KCNB1_KCNV2_A3_struct.exponential_fit_values(4,:)']); % tau slow

tau2 = cell2mat([CRY4_A3_struct.exponential_fit_values(5,:)'; ...
    KCNV2_A3_struct.exponential_fit_values(5,:)'; ...
    KCNB1_A3_struct.exponential_fit_values(5,:)'; ... 
    KCNB1_KCNV2_A3_struct.exponential_fit_values(5,:)']); % tau fast


% create test groups
test_groups = [repmat("CRY4",1,10),repmat("KCNV2",1,4), ...
    repmat("KCNB1",1,5),repmat("KCNV2_KCNB1",1,6)];

% test both values
[p_tau_1,idk_tau_1,stats_tau_1] = kruskalwallis(tau1,test_groups);
[p_tau_2,idk_tau_2,stats_tau_2] = kruskalwallis(tau2,test_groups);

%% Post-hoc tests for tau fast (tau2)

alpha = 0.05;  % set alpha border
groups = unique(test_groups);  % exclude repitions of vector
p_vals = zeros(length(groups)); %create vector for p-values
test_counter = 0;

% Perform pair-wise Wilcoxon rank sum tests
for i=1:length(groups)
    for j=i+1:length(groups)
        indexi = test_groups == groups(i);
        indexj = test_groups == groups(j);
        p_vals(i,j) = ranksum(tau2(indexi),tau2(indexj));
        test_counter = test_counter + 1;
    end
end

% Check which groups significantly differ and print info to command window
for i=1:length(groups)
    for j=i+1:length(groups)
        if p_vals(i,j) < (alpha/test_counter)
            sprintf("Significant difference between groups: %s and %s (%0.5f)", ...
                groups(i), groups(j), p_vals(i,j))
        end
    end
end

% get Bonferroni corrected alpha level
new_alpha = (alpha/test_counter_noo);

%% Post-hoc tests for tau fast (tau2) Kv8.2 and Kv2.1/Kv8.2/Cry4 without outlier of Cry4


tau2 = cell2mat([CRY4_A3_struct.exponential_fit_values(5,[1:2,4:end])'; ...
    KCNV2_A3_struct.exponential_fit_values(5,:)']); % tau fast


% create test groups
test_groups = [repmat("CRY4",1,9),repmat("KCNV2",1,4)];

alpha = 0.05;  % set alpha border
groups = unique(test_groups);  % exclude repitions of vector
p_vals = zeros(length(groups)); %create vector for p-values
test_counter = 0;


% Perform pair-wise Wilcoxon rank sum tests
for i=1:length(groups)
    for j=i+1:length(groups)
        indexi = test_groups == groups(i);
        indexj = test_groups == groups(j);
        p_vals(i,j) = ranksum(tau2(indexi),tau2(indexj));
        test_counter = test_counter + 1;
    end
end

% Check which groups significantly differ and print info to command window
for i=1:length(groups)
    for j=i+1:length(groups)
        if p_vals(i,j) < (alpha/test_counter)
            sprintf("Significant difference between groups: %s and %s (%0.5f)", ...
                groups(i), groups(j), p_vals(i,j))
        end
    end
end

% get Bonferroni corrected alpha level
new_alpha = (alpha/test_counter_noo);

% check effect size
[p,h,stats]=ranksum(tau2(indexi),tau2(indexj),'method','approximate');
effect_size = stats.zval/sqrt(13);


%% Without outlier

% re-order vectors and remove outlier
tau2_noo = tau2([1:2,4:end]);
test_groups_noo = test_groups([1:2,4:end]);
[p_tau_2_noo,idk_tau_2_noo,stats_tau_2_noo] = ...
    kruskalwallis(tau2_noo,test_groups_noo);

%% Post-hoc tests witout outlier with Bonferroni corrected alpha level

alpha = 0.05;
groups_noo = unique(test_groups_noo);
p_vals_noo = zeros(length(groups));
test_counter_noo = 0;

% Perform pair-wise Wilcoxon rank sum tests
for i=1:length(groups_noo)
    for j=i+1:length(groups_noo)
        indexi = test_groups_noo == groups_noo(i);
        indexj = test_groups_noo == groups_noo(j);
        p_vals_noo(i,j) = ranksum(tau2_noo(indexi),tau2_noo(indexj));
        test_counter_noo = test_counter_noo + 1;
    end
end

% Check which groups significantly differ and print info to command window
for i=1:length(groups_noo)
    for j=i+1:length(groups_noo)
        if p_vals_noo(i,j) < (alpha/test_counter_noo)
            sprintf("Significant difference between groups: %s and %s (%0.5f)", ...
                groups_noo(i), groups_noo(j), p_vals_noo(i,j))
        end
    end
end

% get Bonferroni corrected alpha level
new_alpha = (alpha/test_counter_noo);

%% Kruskal-wallis test of the current amplitude of all conditions recorded at -30 mV holding potential 
% without Cry4

% get the amplitude values from each struct
KCNB1_amp_30 = table2array(KCNB1_A3_struct.mean_currents_normalized(14,:));  
KCNV2_amp_30 = table2array(KCNV2_A3_struct.mean_currents_normalized(14,:));  
KCNB1_KCNV2_amp_30 = table2array(KCNB1_KCNV2_A3_struct.mean_currents_normalized(14,:));  
pretest_amp_30 = table2array(A3_pretest_struct_mean.mean_currents_normalized(14,:));  

% put all variables into one vector to test
current_amp_test = [KCNV2_amp_30, KCNB1_amp_30, KCNB1_KCNV2_amp_30, pretest_amp_30];
    
% get vector with the groups that are tested
test_groups = [repmat("KCNV2",1,4), ...
    repmat("KCNB1",1,5),repmat("KCNV2_KCNB1",1,6),repmat("Control",1,5)];

% test
[p_amplitude,idk_amplitude,stats_amplitude] = ...
    kruskalwallis(current_amp_test,test_groups);

%% Kruskal-wallis test of the current amplitude of all conditions recorded at -30 mV holding potential
% with Cry4

% get the amplitude values from each struct
KCNB1_amp_30 = table2array(KCNB1_A3_struct.mean_currents_normalized(14,:));  
KCNV2_amp_30 = table2array(KCNV2_A3_struct.mean_currents_normalized(14,:));  
KCNB1_KCNV2_amp_30 = table2array(KCNB1_KCNV2_A3_struct.mean_currents_normalized(14,:));  
CRY4_amp_30 = table2array(CRY4_A3_struct.mean_currents_normalized(14,:));  
pretest_amp_30 = table2array(A3_pretest_struct_mean.mean_currents_normalized(14,:));  

% put all variables into one vector to test
current_amp_test = [CRY4_amp_30, KCNV2_amp_30, KCNB1_amp_30, KCNB1_KCNV2_amp_30, pretest_amp_30];
    
% get vector with the groups that are tested
test_groups = [repmat("CRY4",1,10),repmat("KCNV2",1,4), ...
    repmat("KCNB1",1,5),repmat("KCNV2_KCNB1",1,6),repmat("Control",1,5)];

% test
[p_amplitude,idk_amplitude,stats_amplitude] = ...
    kruskalwallis(current_amp_test,test_groups);



%% -80 mV current amplitude

% get the amplitude values at +30 mV voltage change
KCNB1_amp_30_IA = table2array(KCNB1_C5_struct_peak.A_peak_front_normalized(14,:));  
KCNV2_amp_30_IA = table2array(KCNV2_C5_struct_peak.A_peak_front_normalized(14,:));  
KCNB1_KCNV2_amp_30_IA = table2array(KCNB1_KCNV2_C5_struct_peak.A_peak_front_normalized(14,:));  
CRY4_amp_30_IA = table2array(CRY4_C5_struct_peak.A_peak_front_normalized(14,:));  
pretest_amp_30_IA = table2array(C5_pretest_struct_peak.A_peak_front_normalized(14,:));  


% get the amplitude values at +30 mV voltage change
KCNB1_amp_30_IK = table2array(KCNB1_C5_struct_mean.mean_currents_normalized(14,:));  
KCNV2_amp_30_IK = table2array(KCNV2_C5_struct_mean.mean_currents_normalized(14,:));  
KCNB1_KCNV2_amp_30_IK = table2array(KCNB1_KCNV2_C5_struct_mean.mean_currents_normalized(14,:));  
CRY4_amp_30_IK = table2array(CRY4_C5_struct_mean.mean_currents_normalized(14,:));  
pretest_amp_30_IK = table2array(C5_pretest_struct_mean.mean_currents_normalized(14,:));  

% turn around the vectors to get columnvector
KCNB1_amp_30_IA = KCNB1_amp_30_IA'; KCNV2_amp_30_IA = KCNV2_amp_30_IA'; KCNB1_KCNV2_amp_30_IA = KCNB1_KCNV2_amp_30_IA';
CRY4_amp_30_IA = CRY4_amp_30_IA'; pretest_amp_30_IA = pretest_amp_30_IA';

KCNB1_amp_30_IK = KCNB1_amp_30_IK'; KCNV2_amp_30_IK = KCNV2_amp_30_IK'; KCNB1_KCNV2_amp_30_IK = KCNB1_KCNV2_amp_30_IK';
CRY4_amp_30_IK = CRY4_amp_30_IK'; pretest_amp_30_IK = pretest_amp_30_IK';


% put all variables into one vector to test
IA_test = [KCNB1_amp_30_IA;KCNV2_amp_30_IA;KCNB1_KCNV2_amp_30_IA;CRY4_amp_30_IA;pretest_amp_30_IA];

IK_test = [KCNB1_amp_30_IK;KCNV2_amp_30_IK;KCNB1_KCNV2_amp_30_IK;CRY4_amp_30_IK;pretest_amp_30_IK];

% create test groups
test_groups = [repmat("KCNB1",1,7),repmat("KCNV2",1,4),repmat("KCNV2_KCNB1",1,4),repmat("CRY4",1,4),...
    repmat("Control",1,8)];


% test both values
[p_IA,idk_IA,stats_IA] = kruskalwallis(IA_test,test_groups);
[p_IK,idk_IK,stats_IK] = kruskalwallis(IK_test,test_groups);

%% -80 mV V50

% get the V50 values from each struct
KCNB1_V50_IA = cell2mat(KCNB1_C5_struct_peak.IV_fits(5,1:length(KCNB1_C5_struct_peak.IV_fits)-2));
KCNV2_V50_IA = cell2mat(KCNV2_C5_struct_peak.IV_fits(5,1:length(KCNV2_C5_struct_peak.IV_fits)-2));
C5_V50_IA = cell2mat(C5_pretest_struct_peak.IV_fits(5,1:length(C5_pretest_struct_peak.IV_fits)-2));
KCNB1_KCNV2_V50_IA = cell2mat(KCNB1_KCNV2_C5_struct_peak.IV_fits(5,1:length(KCNB1_KCNV2_C5_struct_peak.IV_fits)-2));
CRY4_V50_IA = cell2mat(CRY4_C5_struct_peak.IV_fits(5,1:length(CRY4_C5_struct_peak.IV_fits)-2));

% get the V50 values from each struct
KCNB1_V50_IK = cell2mat(KCNB1_C5_struct_mean.IV_fits(5,1:length(KCNB1_C5_struct_mean.IV_fits)-2));
KCNV2_V50_IK = cell2mat(KCNV2_C5_struct_mean.IV_fits(5,1:length(KCNV2_C5_struct_mean.IV_fits)-2));
C5_V50_IK = cell2mat(C5_pretest_struct_mean.IV_fits(5,1:length(C5_pretest_struct_mean.IV_fits)-2));
KCNB1_KCNV2_V50_IK = cell2mat(KCNB1_KCNV2_C5_struct_mean.IV_fits(5,1:length(KCNB1_KCNV2_C5_struct_mean.IV_fits)-2));
CRY4_V50_IK = cell2mat(CRY4_C5_struct_mean.IV_fits(5,1:length(CRY4_C5_struct_mean.IV_fits)-2));


% change the vector diretion
KCNB1_V50_IA = KCNB1_V50_IA'; KCNV2_V50_IA = KCNV2_V50_IA'; KCNB1_KCNV2_V50_IA = KCNB1_KCNV2_V50_IA';
CRY4_V50_IA = CRY4_V50_IA'; C5_V50_IA = C5_V50_IA';

KCNB1_V50_IK = KCNB1_V50_IK'; KCNV2_V50_IK = KCNV2_V50_IK'; KCNB1_KCNV2_V50_IK = KCNB1_KCNV2_V50_IK';
CRY4_V50_IK = CRY4_V50_IK'; C5_V50_IK = C5_V50_IK';


% put all variables into one vector to test
IA_test = [KCNB1_V50_IA;KCNV2_V50_IA;KCNB1_KCNV2_V50_IA;CRY4_V50_IA;C5_V50_IA];

IK_test = [KCNB1_V50_IK;KCNV2_V50_IK;KCNB1_KCNV2_V50_IK;CRY4_V50_IK;C5_V50_IK];

% create test groups
test_groups = [repmat("KCNB1",1,7),repmat("KCNV2",1,4),...
    repmat("KCNV2_KCNB1",1,4),repmat("CRY4",1,4),repmat("Control",1,8)];

% test both values
[p_IA,idk_IA,stats_IA] = kruskalwallis(IA_test,test_groups);
[p_IK,idk_IK,stats_IK] = kruskalwallis(IK_test,test_groups);



%% -80 mV slope

% get the Vc values from each struct
KCNB1_slope_IA = cell2mat(KCNB1_C5_struct_peak.IV_fits(6,1:length(KCNB1_C5_struct_peak.IV_fits)-2));
KCNV2_slope_IA = cell2mat(KCNV2_C5_struct_peak.IV_fits(6,1:length(KCNV2_C5_struct_peak.IV_fits)-2));
C5_slope_IA = cell2mat(C5_pretest_struct_peak.IV_fits(6,1:length(C5_pretest_struct_peak.IV_fits)-2));
KCNB1_KCNV2_slope_IA = cell2mat(KCNB1_KCNV2_C5_struct_peak.IV_fits(6,1:length(KCNB1_KCNV2_C5_struct_peak.IV_fits)-2));
CRY4_slope_IA = cell2mat(CRY4_C5_struct_peak.IV_fits(6,1:length(CRY4_C5_struct_peak.IV_fits)-2));

% get the Vc values from each struct
KCNB1_slope_IK = cell2mat(KCNB1_C5_struct_mean.IV_fits(6,1:length(KCNB1_C5_struct_mean.IV_fits)-2));
KCNV2_slope_IK = cell2mat(KCNV2_C5_struct_mean.IV_fits(6,1:length(KCNV2_C5_struct_mean.IV_fits)-2));
C5_slope_IK = cell2mat(C5_pretest_struct_mean.IV_fits(6,1:length(C5_pretest_struct_mean.IV_fits)-2));
KCNB1_KCNV2_slope_IK = cell2mat(KCNB1_KCNV2_C5_struct_mean.IV_fits(6,1:length(KCNB1_KCNV2_C5_struct_mean.IV_fits)-2));
CRY4_slope_IK = cell2mat(CRY4_C5_struct_mean.IV_fits(6,1:length(CRY4_C5_struct_mean.IV_fits)-2));


% change the vector diretion
KCNB1_slope_IA = KCNB1_slope_IA'; KCNV2_slope_IA = KCNV2_slope_IA'; KCNB1_KCNV2_slope_IA = KCNB1_KCNV2_slope_IA';
CRY4_slope_IA = CRY4_slope_IA'; C5_slope_IA = C5_slope_IA';

KCNB1_slope_IK = KCNB1_slope_IK'; KCNV2_slope_IK = KCNV2_slope_IK'; KCNB1_KCNV2_slope_IK = KCNB1_KCNV2_slope_IK';
CRY4_slope_IK = CRY4_slope_IK'; C5_slope_IK = C5_slope_IK';


% put all variables into one vector to test
IA_test = [KCNB1_slope_IA;KCNV2_slope_IA;KCNB1_KCNV2_slope_IA;CRY4_slope_IA;C5_slope_IA];

IK_test = [KCNB1_slope_IK;KCNV2_slope_IK;KCNB1_KCNV2_slope_IK;CRY4_slope_IK;C5_slope_IK];

% create test groups
test_groups = [repmat("KCNB1",1,7),repmat("KCNV2",1,4),...
    repmat("KCNV2_KCNB1",1,4),repmat("CRY4",1,4),repmat("Control",1,8)];

% test both values
[p_IA,idk_IA,stats_IA] = kruskalwallis(IA_test,test_groups);
[p_IK,idk_IK,stats_IK] = kruskalwallis(IK_test,test_groups);















