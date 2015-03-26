function [] = create_img_frames_from_video(folder_video, video_in, nFrames)

video_obj = VideoReader(strcat(folder_video, video_in));
frames_video_in = read(video_obj, [1 nFrames]);

mkdir(folder_video, sprintf('frames_%s', video_in));

folder_frames = fullfile(folder_video, sprintf('frames_%s', video_in), '\');

for n = 1:nFrames
    imName = sprintf('frame%d_video_%s.jpg', n, video_in(1 length(video_in)-4)));
    imwrite(frames_video_in(:, :, :, n),strcat(folder_frames,imName));
end