function plot_MUA_laser_EG()%(handles)
load mtlb

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

%numsweeps=numtrials*numtones;

fname=[filestosort,'/',d(filelist).name];
input_all=abfload(fname); 
%input = input_all(:,7,:); % auditory trace
%input_2 = input_all(:,6,:); % LC trace
figure; plot(input_all(:,6)); title('Trace 6');
figure; plot(input_all(:,3)); title('Trace 3');

laser = input_all(:,3,:);
laser = laser(:,:);

LC = input_all(:,6,:);
LC = LC(:,:);

xlabelling = linspace(0,3,16);
xchange = linspace(0,100000,16);



highlaser = find(laser(:,1)>3);
laserdiff = diff(highlaser);
start = [1; find(laserdiff>1)+1];
stop  = [find(laserdiff>1); numel(highlaser)-1];
stimsamp(:,1) = highlaser(start);
stimsamp(:,2) = highlaser(stop); 

num_points = 0.25*ones(1,length(stimsamp));

figure; plot(LC(:,3),'k'); set(gca, 'Xtick', xchange); set(gca,'XTickLabel',xlabelling);set(gca, 'Ylim', [-0.4 0.4])
hold on; plot(stimsamp,num_points,'sr', 'MarkerSize',5,'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'none');
title('Light Evoked Activity','fontsize', 12, 'fontname', 'Arial');ylabel('mV','fontsize', 12, 'fontname', 'Arial');xlabel('Time (ms)','fontsize', 12, 'fontname', 'Arial');
set(gca,'fontsize', 12, 'fontname', 'Arial');
hold on; plot([6666 6666 13332],[-.2 -.25 -.25],'k-','linewidth',2);



%plot(mean(laser'));
%time_input = (input_all(:,7,:)/1000)*sample_rate;
%figure; plot(test)

%basesamp(:,1) = (base_start/1000)*sample_rate;
