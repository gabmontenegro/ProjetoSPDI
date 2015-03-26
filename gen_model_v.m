close  all;
clc;
clear;

ct = (4200:8632)';
nam = 100;   %Numero de amostras a serem selecionadas entre os matches

folder = 'C:\Users\Dovahkiin\Documents\PFC - PDI\Projeto de PDI\matlab\siftDemoV4\Framesref\';

stx = [];
translacao_acc = 0;
frms = [];
direcao_anterior = 0;
direcao_atual = 0;
cont_inv = 0;
conf_inv = 0;
obsv = [];
fr_aux = [];
f = figure;
fr_anterior = ct(1);
for i = 2 : size(ct, 1)    
    Ia = strcat(folder, 'frame', int2str(fr_anterior),'_video_ref.jpg');
    Ib = strcat(folder, 'frame', int2str(ct(i)),'_video_ref.jpg');
    [mt1 mt2 T Iref Icam] = solve_rt(Ia, Ib, nam);
    
    fprintf(strcat('Verificar: i: ', int2str(i), '; Frame : ', int2str(ct(i)), '\n'));
    
    if abs(T(1, 1)) >= 0.6
        
        direcao_anterior = direcao_atual;
        direcao_atual = sign(T(1, 1));
        
        if (direcao_anterior == 0)
            direcao_anterior = direcao_atual;
        elseif (direcao_anterior ~= direcao_atual)
            fprintf('Sinal Mudança de Sentido\n');
            if (conf_inv == 0)
                conf_inv = 1;
                fr_aux = [ct(i)];
                translacao_aux = abs(T(1, 1));
            else
                fprintf('Falsa Mudança de Sentido\n');
                conf_inv = 0;
                fr_aux = [];
                translacao_aux = 0;
            end
            
        elseif (conf_inv == 1)
                 fprintf('Mudança de Sentido Confirmada\n');
                 cont_inv = cont_inv + 1;
                 conf_inv = 0;
                 
                 if (cont_inv < 2)
                    frms = [fr_anterior; fr_aux];
                    stx = [0; translacao_aux];
                    translacao_acc = translacao_aux;
                 end
        end
        
        obsv = [obsv; ct(i), T(1, 1), translacao_acc + abs(T(1, 1)), cont_inv, conf_inv ...
                                                    direcao_anterior, direcao_atual];
                                                
        if (cont_inv < 2) && (conf_inv == 0)
                 
                translacao_acc = translacao_acc + abs(T(1, 1));
                stx = [stx; translacao_acc];
                frms = [frms; ct(i)];
                id_fr = (1 : size(frms, 1))';
                
                fr_anterior = ct(i);
                
                plot(id_fr, stx, '--o', 'LineWidth', 2, ...
                                          'MarkerEdgeColor','k', ...
                                          'MarkerFaceColor', 'g', 'MarkerSize', 3);
                fprintf(strcat('Adicionado: i: ', int2str(i), '; Frame : ', int2str(ct(i)), '\n'));
        elseif (cont_inv == 2)
            break;
        end
        
        
    end
    
    
end
    
print(f, '-djpeg', 'grafico_desl.jpg');
%Estimar modelo por Regressao Linear
e = regress(stx, id_fr);

plot(id_fr, stx, 'r'); 
hold on; 

posicao = e * (id_fr - 1);
plot(id_fr, posicao, 'g');
print(f, '-djpeg', 'grafico_model.jpg');
dtmodel = [id_fr, frms, posicao];
dlmwrite('referencia.txt', dtmodel, '\t');
dlmwrite('observ.txt', obsv, '\t');