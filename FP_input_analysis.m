function FP_input_analysis()%(handles)

load('KRSY20180327rec2-180327-111655.mat')

%load('TYRN20180611rec1-180611-170409.mat')

laser = input(:);

highlaser_low = find(laser(:,1)<0.1);
highlaser_high = find(laser(:,1)>0.08);
highlaser = intersect(highlaser_high, highlaser_low);
parsed_highlaser = highlaser;

for i=2:length(highlaser)
if highlaser(i)<(highlaser(i-1)+500)
parsed_highlaser(i)=0;
else
end
end


laserdiff = diff(parsed_highlaser);
start = [1; find(laserdiff>1)+1];
stop  = [find(laserdiff>1); numel(highlaser)-1];
stimsamp(:,1) = highlaser(start);
stimsamp(:,2) = highlaser(stop); 


num_points = 0.1*ones(1,length(stimsamp));



figure; plot(Ca,'k');
hold on; plot(input);
hold on; plot(stimsamp,num_points,'sr', 'MarkerSize',5,'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'none');
hold off;
test = 1;

output_dim =(stimsamp(1)-600:stimsamp(1)+900);
output = zeros(length(start),length(output_dim'));

%for KRSY20180328 rec1:
%rew = [stimsamp(3,:);stimsamp(8,:);stimsamp(10,:);stimsamp(12,:);stimsamp(14,:);stimsamp(17,:);stimsamp(22,:);stimsamp(25,:);stimsamp(29,:);stimsamp(31,:);stimsamp(34,:);stimsamp(37,:);stimsamp(41,:);stimsamp(49,:);stimsamp(51,:)]


figure; hold on;
for i=1:length(start)
baseline = mean(Ca((stimsamp(i)-300):stimsamp(i)));
output(i,:) = Ca(stimsamp(i)-600:stimsamp(i)+900)/baseline;
plot(output(i,:), 'k');
end
hold off;

%h = shadedErrorBar(output);
x = (1:size(output,2));
clf
shadedErrorBar(x,output,{@mean,@std});

mat2clip(output);

%figure; plot(Ca/baseline_toe1, 'k'); set(gca, 'Xlim', [12000 21000]); set(gca, 'Ylim', [0.9 1.1]);