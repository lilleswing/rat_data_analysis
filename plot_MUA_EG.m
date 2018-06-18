function plot_MUA_EG()%(handles)
load mtlb

sample_rate = 100000;    %handles.filedata.sample_rate;
 

p = path;                                                                  % to restore the path afterwards
disp('Pick the folder with files to analyze');                            % display in command window info about what type of folder you should pick 
filestosort = uigetdir;                                                    % open folder selection dialog box
path(p, filestosort);                                                      % temporarily add random folder to the path to read things about it
tempp = path; 
d     = dir(filestosort); 
filelist = listdlg('PromptString', 'Pick files to sort: ', ...
                    'SelectionMode', 'single',...
                    'ListString', {d.name}); 

%numsweeps=numtrials*numtones;
fname=[filestosort,'/',d(filelist).name];
input_all=abfload(fname); 
%input = input_all(:,7,:); % auditory trace
%input_2 = input_all(:,6,:); % LC trace
figure; plot(input_all); title('Trace');
%figure; plot(input_all(:,3)); title('Trace 3');


LC = input_all;



xlabelling = linspace(0,3,16);
xchange = linspace(0,100000,16);






figure; plot(LC,'k'); set(gca, 'Xtick', xchange); set(gca,'XTickLabel',xlabelling);
title('Light Evoked Activity','fontsize', 12, 'fontname', 'Arial');ylabel('mV','fontsize', 12, 'fontname', 'Arial');xlabel('Time (ms)','fontsize', 12, 'fontname', 'Arial');
set(gca,'fontsize', 12, 'fontname', 'Arial');set(gca, 'Ylim', [-1.5 1.5])
hold on; plot([750000 750000 1250000],[-0.75 -1.25 -1.25],'k-','linewidth',2);



%plot(mean(laser'));
%time_input = (input_all(:,7,:)/1000)*sample_rate;
figure; plot(test)

%basesamp(:,1) = (base_start/1000)*sample_rate;