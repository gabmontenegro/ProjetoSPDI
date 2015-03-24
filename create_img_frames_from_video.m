function [] = createImgFramesFromVideo(videoin, nFrames)

% videoRef = VideoReader('sing-amb-part02\ref-sing-amb-part02-video01-reference.avi');
videoObj = VideoReader(videoin);
frames_videoRef = read(videoObj, [1 nFrames]);

for n=1:nFrames
    imName = sprintf('frame%d_video_ref.jpg',n);
    imwrite(frames_videoRef(:,:,:,n), imName);
end