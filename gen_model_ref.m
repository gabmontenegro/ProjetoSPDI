function dtmodel = gen_model_ref(folder, dmin, ct, nam, n_ret, ns)
%n_ret: Quantos retornos vão ser considerados; Deve ser 1 ou 2
%       No video de referencia, como a câmera já começa em um extremo,
%       n_ret = 1; No Video de teste, q havia um retorno e a câmera voltava
%       para o outro extremo, foi usado n_ret = 2
%ns: Número de amostras para confirmar mudança de sentido da câmera;
%dmin: menor deslocamento a ser considerado; frames com deslocamento menor
%são ignorados. Usado 0.6 para gerar o modelo
%ct = (1:3246)'; %Intervalo de frames ; indicados no nome do arquivo
%nam = 100;   %Numero de amostras a serem selecionadas entre os matches
%folder = 'C:\Users\Dovahkiin\Documents\MATLAB\siftDemoV4\frames_ref_sel\';

if n_ret == 1
    stx = [0]; 
    frms = [1];
elseif nret == 2
    stx = []; 
    frms = [];
end

translacao_acc = 0;
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
    
    if abs(T(1, 1)) >= dmin
        
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
        elseif (conf_inv > 0) && (conf_inv <= ns)
             conf_inv = conf_inv + 1;
             fr_aux = [fr_aux; ct(i)];
             translacao_aux = translacao_aux + abs(T(1, 1));
        elseif (conf_inv > 6)
                 fprintf('Retorno Confirmado\n');
                 cont_inv = cont_inv + 1;
                 
                 if n_ret == 2
                    conf_inv = 0;     % Para o video que ja começa em um
                            %extremo, só haverá uma mudança que é a final
                 
                     if (cont_inv < 2)
                        frms = [fr_anterior; fr_aux];
                        stx = [0; translacao_aux];
                        translacao_acc = translacao_aux;
                     end
                 end
        end
        
        obsv = [obsv; ct(i), T(1, 1), translacao_acc + abs(T(1, 1)), cont_inv, conf_inv ...
                                                    direcao_anterior, direcao_atual];
                                                
        if (cont_inv < n_ret) && (conf_inv == 0)
                   
                translacao_acc = translacao_acc + abs(T(1, 1));
                stx = [stx; translacao_acc];
                frms = [frms; ct(i)];
                id_fr = (1 : size(frms, 1))';
                
                fr_anterior = ct(i);
                
                plot(frms, stx, '--o', 'LineWidth', 2, ...
                                          'MarkerEdgeColor','k', ...
                                          'MarkerFaceColor', 'g', 'MarkerSize', 3);
                hold on;
                e = regress(stx, frms);
                posicao = e * (id_fr - 1);
                plot(id_fr, posicao, 'r');
                hold on;
                posicao = e * (frms - 1);
                plot(frms, posicao, 'b');
                fprintf(strcat('Adicionado: i: ', int2str(i), '; Frame : ', int2str(ct(i)), '\n'));
                
        elseif (cont_inv == n_ret)
            break;
        end
        
        
    end

    
end
    
print(f, '-djpeg', 'grafico_desl.jpg');
% Estima o modelo por Regressao Linear
e1 = regress(stx, frms);
e2 = regress(stx, id_fr);

plot(frms, stx, 'r'); 
hold on; 
posicao1 = e1 * (id_fr - 1);
posicao2 = e2 * (id_fr - 1);
plot(id_fr, posicao1, 'g');
hold on;
plot(id_fr, posicao2, 'b');

print(f, '-djpeg', 'grafico_model.jpg');
dtmodel = [id_fr, posicao1, frms, stx, posicao2];
dlmwrite('e.txt', [e1, e2], '\t');
dlmwrite('referencia.txt', dtmodel, '\t');
dlmwrite('observ.txt', obsv, '\t');

end
