
load KRSY20180327rec2-180327-111655.mat;

figure; plot(Ca)


sample_rate = 6000;
%onset = 31300; %% onset of stimulus
%onset = 275600;

onset = 40100;


baseline = mean(Ca((onset-(0.2*sample_rate)):onset));
adj_stimulus = Ca((onset-(2000)):(onset+(12000)))/baseline;
figure; plot(adj_stimulus, 'k')
S = downsample(adj_stimulus,10);
mat2clip(S)




%%Avg
baseline_toe1 = mean(Ca(12000:14000));
figure; plot(Ca/baseline_toe1, 'k'); set(gca, 'Xlim', [12000 21000]); set(gca, 'Ylim', [0.9 1.1]);
%hold on; plot([6666 6666 13332],[-.2 -.25 -.25],'k-','linewidth',2);


baseline_toe2 = mean(Ca(30000:32000));
figure; plot(Ca/baseline_toe2, 'k'); set(gca, 'Xlim', [30000 39000]); set(gca, 'Ylim', [0.9 1.1]);
hold on; plot([33000 33000 34500],[1 .95 .95],'k-','linewidth',2);


%%Down-sampled

down_Ca = downsample(Ca,20);
baseline_down_toe1 = mean(down_Ca(600:700));
figure; plot(down_Ca/baseline_down_toe1, 'k'); set(gca, 'Xlim', [600 1050]); set(gca, 'Ylim', [0.9 1.1]);
KRSYday4toe1 = down_Ca(600:1050)/baseline_down_toe1;

baseline_down_toe2 = mean(down_Ca(1500:1600));
figure; plot(down_Ca/baseline_down_toe2, 'k'); set(gca, 'Xlim', [1500 1950]); set(gca, 'Ylim', [0.9 1.1]);
KRSYday4toe2 = down_Ca(1500:1950)/baseline_down_toe2;

S = [KRSYday4toe1' KRSYday4toe2'];
mat2clip(S);
