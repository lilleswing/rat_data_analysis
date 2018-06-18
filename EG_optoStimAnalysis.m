function EG_optoStimAnalysis()

% these values are hardcoded right now - should/can change to interface
% with something like tuning_curve_wholecell_ABFv2
base_start = 0;      %handles.filedata.base_start;
base_end = 500;        % in ms 
base_dur = base_end-base_start; 
rms_multiple = 3;       % 
sample_rate = 33333;    %
old = 2;                                                                   % if old = 1 manually input when the laser pulsed; if old = 2 - will extract from the file

p = path;                                                                  % to restore the path afterwards
disp('Pick the folder with files to analyze');                            % display in command window info about what type of folder you should pick 
filestosort = uigetdir;                                                    % open folder selection dialog box
path(p, filestosort);                                                      % temporarily add random folder to the path to read things about it
tempp = path; 
d     = dir(filestosort); 
filelist = listdlg('PromptString', 'Pick files to sort: ', ...
                    'SelectionMode', 'single',...
                    'ListString', {d.name}); 

numfiles = numel(filelist); 
basesamp(:,1) = (base_start/1000)*sample_rate;  % convert base start time to base sample
basesamp(:,2) = (base_end/1000)*sample_rate;    % convert base end time to base sample end 

for k = 1:numfiles
    clear fname input base_abs stim_abs rmsinput base stim numsweep ...
        sigind indtodel
    fname=[filestosort,'/',d(filelist(k)).name];
    [input,si,h]=abfload(fname); 
    numsweeps = numel(input(1,1,:));
    
    if old == 1
        
%% *** things to potentially change (hardcoded) ******

        numpulses = 20;         % only REALLY important if old = 1
        freqpulses = 1;         % only really important if old = 1 (manually inputing stuff)
        stimdur = 10; % in ms 
%%
        input = input(:,:); 
        startstimtime = 500; % in time (ms)
        tottimestim = numpulses*freqpulses*1000; % in time (ms)
        stimstoptime = (startstimtime+tottimestim); % in time (ms)
        stimtimes(:,1) = linspace(startstimtime, stimstoptime, numpulses+1)'; % laser on; in time (ms) 
        stimtimes(end) = [];                                                  % delete the last one bc its fake
        stimtimes(:,2) = stimtimes+stimdur;                                   % laser off; in time (ms)
        stimsamp = (stimtimes./1000).*sample_rate;                            % convert from time to samples 
    elseif old == 2
        laser = input(:,3,:);
        laser = laser(:,:);
        highlaser = find(laser(:,1)>3);
        laserdiff = diff(highlaser); 
        start = [1; find(laserdiff>1)+1];
        stop  = [find(laserdiff>1); numel(highlaser)-1];
        stimsamp(:,1) = highlaser(start); 
        stimsamp(:,2) = highlaser(stop); 
        
        input = input(:,6,:); 
        input = input(:,:); 
        numpulses = numel(stimsamp(:,1)); 
        stimsampdiff = stimsamp(1,2) - stimsamp(1,1);
        stimdur = (stimsampdiff.*1000)./sample_rate;
    end 
    
basedivision = base_dur./stimdur; 
base_abs = abs(input(basesamp(:,1):basesamp(:,2),:));
rmsinput = rms(input);                                                % for DAM
basesampdur = length(base_abs); %(basesamp(1,2)-basesamp(1,1))+1;
rmsinput_base = repmat(rmsinput,basesampdur,1); 
base(:,1) = sum(base_abs>(rms_multiple*rmsinput_base)); 
base = base./basedivision;
for m = 1:numpulses
    clear stim_abs stimsampdur rmsinput_stim
    stim_abs      = abs(input(stimsamp(m,1):stimsamp(m,2),:)); 
    stimsampdur   = length(stim_abs);  
    rmsinput_stim = repmat(rmsinput,stimsampdur,1); 
    stim(:,m)     = sum(stim_abs>(rms_multiple*rmsinput_stim)); 
end  
    
figure;
set(gcf, 'Color', 'w'); 
errorbar(1:numpulses, mean(stim),std(stim), 'k'); 
plot(base(n,1), 'r.', 'MarkerSize', 15); 
xlabel('Number of pulses');  
set(gca, 'Box', 'Off'); 
title(d(filelist(k)).name);

% save the information 
data=[base stim];
mkdir(filestosort,'/tuning_analysis');
writename = [filestosort,'/tuning_analysis/',d(filelist(k)).name(1:8),'_tuningcurve.txt'];
dlmwrite(writename,data);
end
