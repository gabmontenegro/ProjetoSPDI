function [tx ty H C] = ransac_homog_frames(dirFrame, firstFrame, lastFrame)
clc;

for i = firstFrame:lastFrame
 [imVector, descriptors, locs] = sift(sprintf('%sframe%d_video_ref.jpg', dirFrame, i));

 C{1,1,i} = imVector;
 C{1,2,i} = descriptors;
 C{1,3,i} = locs;
end

for i = firstFrame:lastFrame-1
A = cell2mat(C(1,3,i));
B = cell2mat(C(1,3,i+1));
[H(:,:,i)] = ransacfithomography_vgg(A(1:4,1:3)', B(1:4,1:3)',0.005);
end

for i = firstFrame:lastFrame-2
    tx(i) = H(1,3,i) - H(1,3,i+1);
    ty(i) = H(2,3,i) - H(2,3,i+1);
end