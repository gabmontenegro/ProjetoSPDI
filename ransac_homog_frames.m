function [x1 x2 H] = ransac_homog_frames(dirFrame, firstFrame, lastFrame)
% close all;
% for i = firstFrame:lastFrame
%  [imVector, descriptors, locs] = sift(sprintf('%sframe%d_video_ref.jpg', dirFrame, i));
% 
%  C{1,1,i} = imVector;
%  C{1,2,i} = descriptors;
%  C{1,3,i} = locs;
% end

for i = firstFrame:lastFrame-1
    [num, x1, y1, x2, y2] = match(sprintf('%sframe%d_video_ref.jpg', dirFrame, i), sprintf('%sframe%d_video_ref.jpg', dirFrame, i+1));
% A = cell2mat(C(1,3,i));
% B = cell2mat(C(1,3,i+1));
    x2 = x2 - 1080;
    [H(:,:,i)] = ransacfithomography_vgg([x1; y1; ones(num, 1)'], [x2; y2; ones(num, 1)'], 0.01);
end

for i = firstFrame:lastFrame-2
    tx(i) = H(1,3,i) - H(1,3,i+1);
    ty(i) = H(2,3,i) - H(2,3,i+1);
end