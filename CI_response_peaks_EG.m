function CI_response_peaks_EG()%(handles)
load mtlb

% these values are hardcoded right now - should/can change to interface
% with something like tuning_curve_wholecell_ABFv2

numtones = 1;          %handles.filedata.numtones;
numtrials = 20;          % number of trials for each tone          %handles.filedata.numtrials;
base_start = 8333;  % sample number to start baseline     %handles.filedata.base_start;
base_end = 10000;    % sample number to stop baseline % 50 ms total   %handles.filedata.base_end;
stim_start = 13550;  % sample number to start stimulation % starts at tone onset: 400 ms    %handles.filedata.stim_start; 
stim_end = 15217;    % sample number to stop stimulation   %50 ms total %handles.filedata.stim_end;
stimdur = stim_start - stim_end; %sample number of stim duration
% play around with this value to pick "number" of spikes - general
% threshold
rms_multiple = 3;   % THIS IS IMPORTANT
sample_rate = 33333;    %handles.filedata.sample_rate;
 
p = path;                                                                  % to restore the path afterwards
disp('Pick the folder with files to analyze');                            % display in command window info about what type of folder you should pick 
filestosort = uigetdir;                                                    % open folder selection dialog box
path(p, filestosort);                                                      % temporarily add random folder to the path to read things about it
tempp = path; 
d     = dir(filestosort); 
filelist = listdlg('PromptString', 'Pick files to sort: ', ...
                    'SelectionMode', 'single',...
                    'ListString', {d.name}); 

                
numsweeps=numtrials*numtones;
fname=[filestosort,'/',d(filelist).name];
input_all=abfload(fname); 
input = input_all(:,6,:); % auditory trace

%figure; plot(input_all(:,6)); title('Trace 6');



base_abs=abs(input(base_start:base_end,:));
stim_abs=abs(input(stim_start:stim_end,:));


for sweep = 1:size(base_abs,2)
    rmsinput = rms(input(1:base_end,:,sweep));
    [base_pks, base_locs] = findpeaks(base_abs(:,sweep),'MinPeakHeight',rms_multiple*rmsinput);
    [stim_pks, stim_locs] = findpeaks(stim_abs(:,sweep),'MinPeakHeight',rms_multiple*rmsinput);
    num_points_base = 0.1*ones(1,length(base_locs));
    num_points_stim = 0.1*ones(1,length(stim_locs));
    figure; plot(input(base_start:base_end,:,sweep));
    hold on; plot(base_locs,num_points_base,'sr', 'MarkerSize',5,'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'none');
    hold on; plot([1,1667],[rmsinput,rmsinput]);
    figure; plot(input(stim_start:stim_end,:,sweep));
    hold on; plot(stim_locs,num_points_stim,'sr', 'MarkerSize',5,'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'none');
    hold on; plot([1,1667],[rmsinput,rmsinput]);
    base(sweep) = length(base_pks);
    stim(sweep) = length(stim_pks);
end

%%Normalize stimulus based on baseline values

stim_average = mean(stim);
base_average = mean(base);

stim_norm = stim_average/base_average;
stim_sub = stim_average - base_average;

%%determine if any tones elicit a response
[h,p]=ttest2(stim,base);



data=[freq(:,1) mean(stim_sort)' std(stim_sort)' std(stim_sort)'/sqrt(numtrials) mean(stim_sort_subt)' mean(stim_sort_norm)'];
%extra_info = [rms_multiple BF base_average];
%columnheader={'Frequency', 'AUC Stimulus', 'AUC STD Stim', 'AUC SEM Stim' 'AUC Subt Baseline' 'AUC Normalized'};
%data=sortrows(data,1);

%mkdir(filestosort,'/tuning_analysis');
%writename = [filestosort,'/tuning_analysis/',d(filelist).name(1:end-4),'_tuningcurve.xls'];

%xlswrite(writename,columnheader,'Sheet1','A2');
%xlswrite(writename,extra_info,'Sheet1','A1');
%xlswrite(writename,data,'Sheet1','A3');

