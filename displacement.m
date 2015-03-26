close  all;
clc;
clear;

ct = (1:500)';
nam = 50;   %Numero de amostras a serem selecionadas entre os matches

for i = 2 : size(ct, 1)    
    Ia = strcat('frame', int2str(ct(i - 1)),'_video_ref.jpg');
    Ib = strcat('frame', int2str(ct(i)),'_video_ref.jpg');
    [mt1 mt2 T Iref Icam] = solve_rt(Ia, Ib, nam);
    
    if i == 2
        stx = T(1, 1);
        transl_ant = stx;
    else
        stx = [stx; transl_ant + T(1, 1)];
        transl_ant = transl_ant + T(1, 1);
    end
    
    frms = ct(2 : i);
    plot(frms, stx, '--o', 'LineWidth', 2, ...
                                  'MarkerEdgeColor','k', ...
                                  'MarkerFaceColor', 'g', 'MarkerSize', 3);
    
end




