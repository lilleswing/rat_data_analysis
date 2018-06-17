function tuninganalysis_KM_EG_IS()%(handles)

% these values are hardcoded right now - should/can change to interface
% with something like tuning_curve_wholecell_ABFv2

numtones = 7;          %handles.filedata.numtones;
numtrials = 6;          % number of trials for each tone          %handles.filedata.numtrials;
base_start = 5000;  % sample number to start baseline     %handles.filedata.base_start;
base_end = 10000;    % sample number to stop baseline    %handles.filedata.base_end;
stim_start = 13333;  % sample number to start stimulation     %handles.filedata.stim_start; 
stim_end = 18333;    % sample number to stop stimulation    %handles.filedata.stim_end;
stimdur = stim_start - stim_end; 
% play around with this value to pick "number" of spikes - general
% threshold
rms_multiple = 4;   % THIS IS IMPORTANT
sample_rate = 33333;    %handles.filedata.sample_rate;
% tonestouse = 1;         %handles.filedata.freqselect;
 

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
fname=[filestosort,'\',d(filelist).name];
input_all=abfload(fname); 
input = input_all(:,7,:); % auditory trace
%input_2 = input_all(:,6,:); % LC trace
figure; plot(input_all(:,6)); title('Trace 6');
figure; plot(input_all(:,7)); title('Trace 7');

% if tonestouse == 1
%     freq = [16000;32000;11314;45255;8000;5657;9514;19027;22627;64000;4000];
% elseif tonestouse == 2
freq= [8000;2000;16000; 500; 4000; 32000; 1000];
% else
%     [freqfilename,freqpathname] = uigetfile('*.txt','Select text file to load','');
%     freqfname=[freqpathname,freqfilename];
%     freq = importdata(freqfname);
%     prompt = {'First frequency:'};
%     startfreq = inputdlg(prompt); 
%     startind = find(freq == startfreq, 1, 'first'); 
%     freq = freq(startind:(startind+numtones)); 
% end

base_abs=abs(input(base_start:base_end,:));
stim_abs=abs(input(stim_start:stim_end,:));
rmsinput=rms(input(:,:));
rmsinput=repmat(rmsinput,length(base_abs),1);

base=sum(base_abs>(rms_multiple*rmsinput));
stim=sum(stim_abs>(rms_multiple*rmsinput));

numsweeps = numtones.*numtrials;
stim=reshape(stim(1:numsweeps),numtones,numtrials)';
base=reshape(base(1:numsweeps),numtones,numtrials)';

% determine if any tones elicit a response
[h,p]=ttest2(stim,base);

%sort baseline and stim matrices
stim_sort=[freq (stim)'];
[stim_sort,i]=sortrows(stim_sort,1);
stim_sort(:,1) = [];
stim_sort = stim_sort';

base_sort=[freq (base)'];
[base_sort,i]=sortrows(base_sort,1);
base_sort(:,1) = [];
base_sort = base_sort';

%find the maximum response
freq=[freq mean(stim)' mean(base)'];
[freq,i]=sortrows(freq,1);
[val,maxind]=max(freq(:,2));
BF=freq(maxind);



unresp_ind = find(h == 0);
resp_ind = find(h == 1);

%plotting routines

figure;
plot(freq(:,1),freq(:,2),'-o', 'Color',[50/255, 205/255. 50/255]);
hold on;
plot(freq(:,1),freq(:,3),'k-o');
% if isempty(resp_ind) == 0 
%     plot(freq(i(resp_ind),1), freq(i(resp_ind),2), 'b*'); 
% end

% if tonestouse == 1
% xlim([3000 64000]); 
% set(gca, 'XTick', [4000, 8000, 16000, 32000, 64000],...
%     'XTickLabel', {'4', '8', '16', '32', '64'}); 
% elseif tonestouse == 2 
    xlim([500 32000]);
    set(gca, 'XTick', [500, 1000, 2000, 4000, 8000, 16000, 32000], ...
        'XTickLabel', {'.5', '1', '2', '4', '8', '16', '32'}, ...
        'XScale', 'log'); 
% end
xlabel('Frequency (kHz)');


data=[freq(:,1) p' mean(stim_sort)' std(stim_sort)' std(stim_sort)'/sqrt(numtrials) mean(base_sort)' std(stim_sort)' std(stim_sort)'/sqrt(numtrials) mean(stim_sort)'./mean(base_sort)'];
extra_info = [rms_multiple BF];
columnheader={'Frequency', 'T-Test p-value', 'AUC Stimulus', 'AUC STD Stim', 'AUC SEM Stim', 'AUC Baseline', 'AUC STD Base' ,'AUC SEM base' ,'Stim/Base Normalize'};
data=sortrows(data,1);
%data_headers = cell(8,9);
%data_headers = [columnheader; data];
mkdir(filestosort,'/tuning_analysis');
writename = [filestosort,'/tuning_analysis/',d(filelist).name(1:end-4),'_tuningcurve.xls'];
%csvwrite(writename,data_headers);
%csvwrite(writename,data,'-append'); 
xlswrite(writename,columnheader,'Sheet1','A2');
xlswrite(writename,extra_info,'Sheet1','A1');
xlswrite(writename,data,'Sheet1','A3');

