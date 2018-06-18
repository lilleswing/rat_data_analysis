clear all
    clc
    


start_stim = 850;
test_end = 1000;
end_stim = 2900;

load('KRSY20180327rec2-180327-111655.mat')


Ca=downsample(Ca,30);

time=1:length(Ca);
y = double(Ca);

h=animatedline;
%h = plot(NaN,NaN,'k');
axis([850,2900,700,900]);


for k = (start_stim:end_stim)
    addpoints(h, time(k),y(k));
    drawnow limitrate;
    %hold on
    frame(k-start_stim+1) = getframe(1);
    %im = frame2im(frame);
    %[imind,cm] = rgb2ind(im,256);
    %if k == start_stim;
    %    imwrite(imind,cm,filename,'gif','Loopcount',inf);
    %else 
    %    imwrite(imind,cm,filename,'gif','WriteMode','append');
    %end
end

myvideo = VideoWriter('FP_framerate.avi');
myvideo.FrameRate = 35;
open(myvideo);
writeVideo(myvideo, frame);
close(myvideo);


