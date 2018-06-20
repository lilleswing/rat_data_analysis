
%%Import data and then name tones and responses based on what those columns
%%are named from behavioral text file.

tones = MEDPCIVD;
responses = VarName2;
tones(tones==0) = [];
responses(responses==0) = [];

tone_label = num2str(tones);
figure; plot(Ca); hold on; plot(trigger_pks_locs',num_points,'sr', 'MarkerSize',5,'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'none');
 hold on; plot(trigger_high_pks_locs',num_high_points,'sr', 'MarkerSize',5,'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'none');

num_points_Ca = 920*ones(1,length(trigger_pks_locs));

for i = 1:length(trigger_pks_locs)
    t = text(trigger_pks_locs(i)', num_points_Ca(i), {tone_label(i,:)});
end