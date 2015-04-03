% Localiza o ponto de retorno da câmera.
% Retorna os valores dos índices do primeiro e do último frame onde foi 
% sinalizado.

function dt_sinc = locate_return(vid, fr_in)

% Lê o vídeo de referência
videoref = VideoReader(vid);

numFrames = get(videoref, 'NumberOfFrames');

ct = (1:numFrames)';
nam = 100;   % Número de amostras a serem selecionadas entre os matches

stx = []; 
frms = [];

direcao_anterior = 0;
direcao_atual = 0;
cont_inv = 0;
conf_inv = 0;
obsv = [];
fr_aux = [];
fr_anterior = ct(fr_in);
for i = (fr_in + 1) : size(ct, 1)    
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

if (cont_inv == 0)
    frms = [0];
    stx = [0];
    fprintf('Não houve Retorno ou não foi Confirmado\n');
elseif (cont_inv == 1)
    fprintf(strcat('Retorno no frame ', int2str(fr_anterior)));
end

dt_sinc = [frms, stx];

end
