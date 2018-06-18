function animate_FP_data_EG() %(handles)






%an = animatedline(Ca);

clear all
    clc
    h=animatedline;


start_stim = 850
test_end = 1000
end_stim = 2900
axis([850,2900,700,900]);
load('KRSY20180327rec2-180327-111655.mat')
filename = 'fp.gif';

Ca=downsample(Ca,30);

time=1:length(Ca);
y = double(Ca);

for k = (start_stim:test_end)
    figure; plot(y(k)); set(gca, 'Xlim', [850 2900]); set(gca, 'Ylim', [700 900]);
    addpoints(h,time(k),y(k));
    drawnow;
    %hold on
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if k == start_stim;
        imwrite(imind,cm,filename,'gif','Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
end

blah = 0;
