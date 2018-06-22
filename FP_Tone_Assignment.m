
%%Import data and then name tones and responses based on what those columns
%%are named from behavioral text file.

tones = CMEDPC;
responses = VarName5;
tones(tones==0) = [];
responses(responses==0) = [];

compiled_tones = [trigger_pks_locs tones];
compiled_resp = [trigger_pks_locs responses];


output_dim = (trigger_pks_locs(1)-600:trigger_pks_locs(1)+900);
output = zeros(length(tones),length(output_dim'));

for ii=1:length(tones)
    if tones(ii) == 4000
        %trigger_pks_locs(j) 
        baseline = mean(Ca((trigger_pks_locs(ii)-300):trigger_pks_locs(ii)));
        output(ii,:) = Ca(trigger_pks_locs(ii)-600:trigger_pks_locs(ii)+900)/baseline;
    else
    end
end


tone_label = num2str(tones);
figure; plot(Ca); hold on; plot(trigger_pks_locs',num_points,'sr', 'MarkerSize',5,'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'none');
 hold on; plot(trigger_high_pks_locs',num_high_points,'sr', 'MarkerSize',5,'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'none');

num_points_Ca = 920*ones(1,length(trigger_pks_locs));

for i = 1:length(trigger_pks_locs)
    t = text(trigger_pks_locs(i)', num_points_Ca(i), {tone_label(i,:)});
end