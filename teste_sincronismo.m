clear;
clc; close all;
hold off;
%Etapa 1: Localizar retorno
%Etapa 2: Verificar o extremo correspondente no modelo
%Etapa 3: Rodar juntos modelo x referencia

folder_v = 'C:\Users\Dovahkiin\Documents\PFC - PDI\Projeto de PDI\Videos\sing-amb-part01\sing-amb-part01\';
vid = 'obj-sing-amb-part01-video01.avi';
videoref = VideoReader(vid);

numFrames = get(videoref, 'NumberOfFrames');

ct = (1:numFrames)';
nam = 100;   %Numero de amostras a serem selecionadas entre os matches

stx = []; 
frms = [];

translacao_acc = 0;
direcao_anterior = 0;
direcao_atual = 0;
cont_inv = 0;
conf_inv = 0;
obsv = [];
fr_aux = [];
fr_anterior = ct(4179);
for i = 4180 : size(ct, 1)    
    Ia = read(videoref, fr_anterior);
    Ib = read(videoref, i);
    [mt1 mt2 T Iref Icam] = solve_rt_on(Ia, Ib, nam);
    
    fprintf(strcat('Verificar: i: ', int2str(i), '; Frame : ', int2str(ct(i)), '\n'));
    
    if abs(T(1, 1)) >= 0.6
        
        direcao_anterior = direcao_atual;
        direcao_atual = sign(T(1, 1));
        
        if (direcao_anterior == 0)
            direcao_anterior = direcao_atual;
        elseif (direcao_anterior ~= direcao_atual)
            fprintf('Sinal Mudança de Sentido\n');
            if (conf_inv == 0)
                conf_inv = conf_inv + 1;
                fr_aux = [ct(i)];
                translacao_aux = abs(T(1, 1));
            else
                fprintf('Falsa Mudança de Sentido\n');
                conf_inv = 0;
                fr_aux = [];
                translacao_aux = 0;
            end
        elseif (conf_inv > 0) && (conf_inv <= 6)
             conf_inv = conf_inv + 1;
             fr_aux = [fr_aux; ct(i)];
             translacao_aux = translacao_aux + abs(T(1, 1));
        elseif (conf_inv > 6)
                 fprintf('Retorno Confirmado\n');
                 cont_inv = cont_inv + 1;
                 
                 frms = [fr_anterior; fr_aux];
                 stx = [0; translacao_aux];
                 translacao_acc = translacao_aux;
        end
        
        subplot(1,2,1);
        imshow(Ia), title(int2str(fr_anterior));
        subplot(1,2,2);
        imshow(Ib), title(int2str(ct(i)));
        
        if (cont_inv < 1) && (conf_inv == 0)
            fr_anterior = ct(i);
        elseif (cont_inv == 1)
            break;
        end 
        
    end

end
    
fprintf(strcat('Retorno no frame ', int2str(fr_anterior)))