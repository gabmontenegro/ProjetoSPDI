function [] = create_img_frames_from_video(folder_video, video_in, in_Frame, end_Frame)

video_obj = VideoReader(fullfile(folder_video, '\', video_in));
frames_video_in = read(video_obj, [in_Frame end_Frame]);

mkdir(folder_video, sprintf('frames_%s', video_in(1:(length(video_in)-4))));

folder_frames = fullfile(folder_video, sprintf('frames_%s', video_in(1:(length(video_in)-4))), '\');
aux = 0;
for n = in_Frame:end_Frame
    aux = aux +1;
    imName = sprintf('frame%d_video_%s.jpg', n, video_in(1:(length(video_in)-4)));
    imwrite(frames_video_in(:, :, :, aux),strcat(folder_frames,imName));
end