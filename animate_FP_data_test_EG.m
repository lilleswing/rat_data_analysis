function animate_FP_data_test_EG() %(handles)






%an = animatedline(Ca);

clear all
    clc
    %h=animatedline;


   

start_stim = 25000;
test_end = 30000;
end_stim = 87000;

load('KRSY20180327rec2-180327-111655.mat')

Ca=downsample(Ca,10);


dwnsmple = 10; 
time=1:length(Ca);
y = double(Ca);

figure;

axis([25000/dwnsmple 87000/dwnsmple 700 900])
hold;
hPlot = scatter(NaN,NaN,'.','k');

MM(test_end/dwnsmple) = struct('cdata',[],'colormap',[]);
for k = start_stim/dwnsmple:test_end/dwnsmple;
    %x = time(k)
    %y_list = y(k)
    set(hPlot,'XData',time(start_stim/dwnsmple:k),'YData',y(start_stim/dwnsmple:k));
    MM(k-(start_stim/dwnsmple)+1) = getframe(gcf);  
end

blah = 0;
