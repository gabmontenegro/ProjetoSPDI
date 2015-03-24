function [mt1 mt2 T Iref Icam] = solve_rt(im1, im2, nam)

% Ia = imread('frame1_video_ref.jpg');
% Ib = imread('frame50_video_ref.jpg');

Ia = imread(im1);
Ib = imread(im2);

[nmat, locs_ref, locs_cam, Iref, Icam] = match(Ia, Ib);

M0 = [locs_ref(:, 1), locs_ref(:, 2)];
M1 = [locs_cam(:, 1), locs_cam(:, 2)];

ic = 0;
T1 = mean(M0 - M1);
T = [0, 0];
it = 0;
while (ic < nam) && (it < 50)
    %selecionar amostras
    [u v] = ransac_amostra(4, M0, M1, T1);
    T = T + sum(u - v);
    
    if (ic == 0)
        mt1 = u;
        mt2 = v;
    else
        mt1 = [mt1; u];
        mt2 = [mt2; v];
    end    
    ic = ic + 4;
    it = it + 1;
end

T = (1 / (4 * ic)) * T;
T = mean([T; T1]);

end