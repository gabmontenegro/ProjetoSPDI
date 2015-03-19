function [tx ty H C] = ImgFramesSIFT(in,fim)

for i = in:fim
 [imVector, descriptors, locs] = sift(sprintf('frame%d_video_ref.jpg',i));

 C{1,1,i} = imVector;
 C{1,2,i} = descriptors;
 C{1,3,i} = locs;
end

for i = in:fim-1
A = cell2mat(C(1,3,i));
B = cell2mat(C(1,3,i+1));
[H(:,:,i)] = ransacfithomography_vgg(A(1:4,1:3)', B(1:4,1:3)',0.005);
end

for i = in:fim-2
    tx(i) = H(1,3,i) - H(1,3,i+1);
    ty(i) = H(2,3,i) - H(2,3,i+1);
end