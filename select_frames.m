clc;
clear;
close all;

folder_r = 'C:\Users\Dovahkiin\Documents\PFC - PDI\Projeto de PDI\matlab\siftDemoV4\Framesref\';
folder_w = 'C:\Users\Dovahkiin\Documents\PFC - PDI\Projeto de PDI\matlab\siftDemoV4\frames\';
nam = 80;
j = 0;
numFrames = 8630;

for i = 4200 : numFrames
     Ia = strcat(folder_r, 'frame', int2str(i - 1),'_video_ref.jpg');
     Ib = strcat(folder_r, 'frame', int2str(i),'_video_ref.jpg');
     [mt1 mt2 T Iref Icam] = solve_rt(Ia, Ib, nam);
     
     if (abs(T(1, 1)) >= 0.5)
        j = j + 1;
        Im = imread(Ib, 'jpg');
        pth = strcat(folder_w, 'frame', int2str(j),'_video_ref.jpg');
        imwrite(Im, pth, 'jpg');
    end
end

