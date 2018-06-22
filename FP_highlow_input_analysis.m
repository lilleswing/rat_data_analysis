%function FP_highlow_input_analysis()%(handles)


load('TYRN20180612rec2-180612-165444.mat')

% bandpass to 5 Hz via rec from Dayu

FL = 1017.25;                       %%Sampling rate
[b, a] = butter(4, 5/FL, 'low');
Lfilter = filtfilt(b, a, double(Ca));
figure; plot(Lfilter)



trigger = input(:);

%%Fnd all trigger points, high and low

for j=1:length(trigger)
    if trigger(j)<45
        trigger(j) = 0;
    else trigger(j) = trigger(j);
    end
end

[trigger_pks, trigger_pks_locs] = findpeaks(trigger);

%%Isolate only high trigger points

trigger_high = trigger;

for k=1:length(trigger_high)
    if trigger_high(k)<60
        trigger_high(k) = 0;
    else trigger_high(k) = trigger_high(k);
    end
end

[trigger_high_pks, trigger_high_pks_locs] = findpeaks(trigger_high);
num_high_points = 930*ones(1,length(trigger_high_pks_locs));

%%Remove high peaks from total list to get low peaks only

overlap = ismember(trigger_pks_locs, trigger_high_pks_locs);

for i=1:length(trigger_pks_locs)
    if overlap(i) == 1
        trigger_pks_locs(i) = 0;
    else
    end
end

trigger_pks_locs(trigger_pks_locs==0) = [];
num_points = 925*ones(1,length(trigger_pks_locs));

 figure; plot(input); hold on; plot(trigger_pks_locs',num_points,'sr', 'MarkerSize',5,'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'none');
 hold on; plot(trigger_high_pks_locs',num_high_points,'sr', 'MarkerSize',5,'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'none');

