function tuninganalysis_peaks_EG()%(handles)
load mtlb

% these values are hardcoded right now - should/can change

numtones = 7;          %handles.filedata.numtones;
numtrials = 10;          % number of trials for each tone          %handles.filedata.numtrials;
base_start = 8333.5;  % sample number to start baseline     %handles.filedata.base_start;
base_end = 10000;    % sample number to stop baseline % 50 ms total   %handles.filedata.base_end;
stim_start = 13333;  % sample number to start stimulation % starts at tone onset: 400 ms    %handles.filedata.stim_start; 
stim_end = 14999.5;    % sample number to stop stimulation   %50 ms total %handles.filedata.stim_end;
stimdur = stim_start - stim_end; %sample number of stim duration
% play around with this value to pick "number" of spikes - general
% threshold
rms_multiple = 4;   % THIS IS IMPORTANT
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
%input_2 = input_all(:,6,:); % LC trace
%figure; plot(input_all(:,6)); title('Trace 6');
%figure; plot(input_all(:,7)); title('Trace 7');


freq= [8000;2000;16000; 500; 4000; 32000; 1000];        %frequency table




base_abs=abs(input(base_start:base_end,:));
stim_abs=abs(input(stim_start:stim_end,:));


for sweep = 1:size(base_abs,2)
    rmsinput = rms(input(:,:,sweep));
    [base_pks, base_locs] = findpeaks(base_abs(:,sweep),Fs,'MinPeakHeight',rms_multiple*rmsinput);
    [stim_pks, stim_locs] = findpeaks(stim_abs(:,sweep),Fs,'MinPeakHeight',rms_multiple*rmsinput);
    base(sweep) = length(base_pks);
    stim(sweep) = length(stim_pks);
end

%%Normalize stimulus based on baseline values

base_average = mean(base);
%stim_normalized = stim/base_average;


%Reshapse stimulus matrix based on tone presented
numsweeps = numtones.*numtrials;
stim=reshape(stim(1:numsweeps),numtones,numtrials)';

%base=reshape(base(1:numsweeps),numtones,numtrials)';


%%%%%%
% determine if any tones elicit a response
%[h,p]=ttest2(stim,base_average);

%sort baseline and stim matrices
stim_sort=[freq (stim)'];
[stim_sort,i]=sortrows(stim_sort,1);
stim_sort(:,1) = [];
stim_sort = stim_sort';



stim_sort_norm = stim_sort/base_average;

base_average_matrix = repmat(base_average,size(stim_sort,1), size(stim_sort,2));

stim_sort_subt = stim_sort - base_average_matrix;

%base_sort=[freq (base)'];
%[base_sort,i]=sortrows(base_sort,1);
%base_sort(:,1) = [];
%base_sort = base_sort';

%find the maximum response
freq=[freq mean(stim)'];
[freq,i]=sortrows(freq,1);
[val,maxind]=max(freq(:,2));
BF=freq(maxind);



%unresp_ind = find(h == 0);
%resp_ind = find(h == 1);

%plotting routines

figure;
plot(freq(:,1),freq(:,2),'-o', 'Color',[50/255, 205/255. 50/255]);

    xlim([500 32000]);
    set(gca, 'XTick', [500, 1000, 2000, 4000, 8000, 16000, 32000], ...
        'XTickLabel', {'.5', '1', '2', '4', '8', '16', '32'}, ...
        'XScale', 'log'); 
xlabel('Frequency (kHz)');




data=[freq(:,1) mean(stim_sort)' std(stim_sort)' std(stim_sort)'/sqrt(numtrials) mean(stim_sort_subt)' mean(stim_sort_norm)'];
extra_info = [rms_multiple BF base_average];
columnheader={'Frequency', 'AUC Stimulus', 'AUC STD Stim', 'AUC SEM Stim', 'AUC Subt Baseline', 'AUC Normalized'};
data=sortrows(data,1);

mkdir(filestosort,'/tuning_analysis');
writename = [filestosort,'/tuning_analysis/',d(filelist).name(1:end-4),'_tuningcurve.xls'];

xlswrite(writename,columnheader,'Sheet1','A2');
xlswrite(writename,extra_info,'Sheet1','A1');
xlswrite(writename,data,'Sheet1','A3');

