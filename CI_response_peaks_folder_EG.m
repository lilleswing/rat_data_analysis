function CI_response_peaks_EG()%(handles)
load mtlb
% javaaddpath('xmlbeans-2.3.0.jar');
% javaaddpath('poi-ooxml-schemas-3.8-20120326.jar');
% javaaddpath('stax-api-1.0.1.jar');
% javaaddpath('poi-ooxml-3.8-20120326.jar');
% javaaddpath('poi-3.8-20120326.jar');
% javaaddpath('dom4j-1.6.1.jar');

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
numsweeps=numtrials*numtones;
 
p = path;                                                                  % to restore the path afterwards
disp('Pick the folder with files to analyze');                            % display in command window info about what type of folder you should pick 
filestosort = uigetdir;                                                    % open folder selection dialog box
path(p, filestosort);                                                      % temporarily add random folder to the path to read things about it
tempp = path; 
d     = dir(filestosort); 
filelist = listdlg('PromptString', 'Pick files to sort: ', ...
                    'SelectionMode', 'multiple',...
                    'ListString', {d.name}); 

for list = 1:size(filelist,2)
   fname=[filestosort,'/',d(filelist(list)).name];
   input_all=abfload(fname); 
   input = input_all(:,6,:); % auditory trace


%figure; plot(input_all(:,6)); title('Trace 6');


    base_abs=abs(input(base_start:base_end,:));
    stim_abs=abs(input(stim_start:stim_end,:));


for sweep = 1:size(base_abs,2)
    rmsinput = rms(input(1:base_end,:,sweep));
    [base_pks, base_locs] = findpeaks(base_abs(:,sweep),'MinPeakHeight',rms_multiple*rmsinput);
    [stim_pks, stim_locs] = findpeaks(stim_abs(:,sweep),'MinPeakHeight',rms_multiple*rmsinput);
    %%num_points_base = 0.1*ones(1,length(base_locs));
    %%num_points_stim = 0.1*ones(1,length(stim_locs));
    %%figure; plot(input(base_start:base_end,:,sweep));
    %%hold on; plot(base_locs,num_points_base,'sr', 'MarkerSize',5,'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'none');
    %%hold on; plot([1,1667],[rmsinput,rmsinput]);
    %%figure; plot(input(stim_start:stim_end,:,sweep));
    %%hold on; plot(stim_locs,num_points_stim,'sr', 'MarkerSize',5,'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'none');
    %%hold on; plot([1,1667],[rmsinput,rmsinput]);
    base(sweep) = length(base_pks);
    stim(sweep) = length(stim_pks);
end

%%Normalize stimulus based on baseline values

stim_list(list,:) = stim;
base_list(list,:) = base;

stim_std_list(list) = std(stim);
base_std_list(list) = std(base);

stim_average_list(list) = mean(stim);
base_average_list(list) = mean(base);

stim_norm = stim_average_list/base_average_list;
stim_sub = stim_average_list - base_average_list;

name = d(filelist(list)).name;
filename(list) =  [convertCharsToStrings(name)];


%%determine if any tones elicit a response
[h(list),pval(list)]=ttest2(stim,base);

end

%x = (1:size(stim_average_list,2));
%clf
%shadedErrorBar(x,stim_average_list,{@mean,@std});

figure; plot(stim_average_list); set(gca, 'XTick', [1,2,3,4,5,6], 'XTickLabel', {'22','21', '20', '19', '18', '16'});
hold on; plot(base_average_list);

data=[stim_average_list' base_average_list' stim_std_list' base_std_list' h' pval'];
columnheader={'file', 'stm', 'base', 'stim std', 'base std', 'h', 'p'};
%mkdir(filestosort,'/CI_ACx_analysis');
truncname = strsplit(convertCharsToStrings(filestosort),'/');
truncname = convertStringsToChars(truncname(7));
truncname2 = regexprep(filestosort, 'Loc.*', '');
writename = [truncname2,'CI_ACx_analysis.xlsx'];
xlwrite(writename,columnheader,truncname,'A1');
xlwrite(writename,filename',truncname,'A2');
xlwrite(writename,data,truncname,'B2');



