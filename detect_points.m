%folder_videos - diret�rio onde est�o todos os v�deos
%f_frame_ref - n�mero do frame que se deseja iniciar o v�deo de refer�ncia
%l_frame_ref - n�mero do �ltimo frame que se deseja do v�deo de refer�ncia
%video_in - nome do v�deo de teste, apenas o nome sem extens�o
%threshold - limiar da detec��o dos pontos
%sync - representa a distancia entre os frames dos dois v�deos
%exemplo de como executar: detect_points(folder_videos, 500, 2000, video_whitejar_pos1_string, 50, 212);

function [] = detect_points (folder_videos, f_frame_ref, l_frame_ref, video_in, threshold, sync)

f_frame_test = f_frame_ref-sync; 
folder_frame_ref = fullfile(folder_videos,'frames_ref-sing-amb-part02-video01-reference');
n_ref = f_frame_ref;
n_test = f_frame_test;
%mkdir(folder_videos, 'deteccao');
for n=1:l_frame_ref-f_frame_ref 
    
    frame_ref = imread(fullfile(folder_frame_ref, sprintf('frame%d_video_ref-sing-amb-part02-video01-reference.jpg',n_ref)));
    frame_test = imread(fullfile(folder_videos, strcat('frames_',video_in(1:(length(video_in)-4))), sprintf('frame%d_video_%s.jpg',n_test, video_in(1:(length(video_in)-4)))));
    n_ref = n_ref + 1;
    n_test = n_test + 1;
    
    %verifica��o da imagem para saber se ela � rgb, caso seja ela �
    %transformada para escala de cinza
    if(size(frame_ref,3) == 3)
        frame_ref_gray = rgb2gray(frame_ref);
    else frame_ref_gray = frame_ref;
    end

    if(size(frame_test,3) == 3)
        frame_test_gray = rgb2gray(frame_test);
    else frame_test_gray = frame_test;
    end

    sub_matrix = frame_test_gray - frame_ref_gray;
    [l, c] = size(sub_matrix);
    num = 0;
    for i=1:l
        for j=1:c
            if(sub_matrix(i,j) > abs(threshold))
                %plot(i,j,'rs');
                %cada vez que a diferen�a de ilumina��o variar acima do
                %treshold as coordenadas desse pontos s�o salvas em x e y
                num = num+1;
                
                x(num) = i; 
                y(num) = j; 
            end
        end
    end
    
    
    red = uint8([255 0 0]);  
    markerInserter = vision.MarkerInserter('Shape','Circle','BorderColor','Custom','CustomBorderColor',red);
    RGB = repmat(frame_test_gray,[1 1 3]); 
    Pts = int32([y' x']);
    im_with_detection = step(markerInserter, RGB, Pts); %criando a imagem com os pontos detectados
    %imwrite(im_with_detection,fullfile(folder_videos,'deteccao',sprintf('frame%d.jpg', n)));
    imshow(im_with_detection);
end


