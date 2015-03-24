%Selecionar posicao 4 amostras aleatórias da la lista de matches
function [am1 am2] = ransac_amostra(corr_req, M0, M1, T)
    
    corr_num = size(M0, 1);
    % Random number generation

    medt = abs([T; T; T; T]);
    teste = 0;
    it = 0;
    while (teste == 0) && (it < 500)

        stream = RandStream('mt19937ar','seed',sum(100*clock));
        randomvector = rand(stream,1,4);

        % Choosing the correspondences (positions)
        selected_indices = ceil(corr_num * randomvector);
        indices = selected_indices(1 : corr_req);
        
        u = [M0(indices(1), :); M0(indices(2), :); M0(indices(3), :); M0(indices(4), :)];
        v = [M1(indices(1), :); M1(indices(2), :); M1(indices(3), :); M1(indices(4), :)];
        
        %Desvio de translacao até 20%
        w = ((abs(u - v) - medt) ./ medt) > 0.2;
        
        %Para verificar se pontos são colineares
        Mt1 = [u(1, 1), u(2, 1), u(3, 1); u(1, 2), u(2, 2), u(3, 2); 1, 1, 1];
        Mt2 = [u(1, 1), u(2, 1), u(4, 1); u(1, 2), u(2, 2), u(4, 2); 1, 1, 1];
        Mt3 = [u(1, 1), u(3, 1), u(4, 1); u(1, 2), u(3, 2), u(4, 2); 1, 1, 1];
        Mt4 = [u(2, 1), u(3, 1), u(4, 1); u(2, 2), u(3, 2), u(4, 2); 1, 1, 1];
        
        %Para verificar desvio angular de cada ponto ; até 5 graus
        vd = abs(atand((v(:, 2) - u(:, 2)) ./ (v(:, 1) - u(:, 1))));
        t = (vd > 5);
        
        
        %Verificar outliers 
        if (det(Mt1) ~= 0) && (det(Mt2) ~= 0) && (det(Mt3) ~= 0) && (det(Mt4) ~= 0) && ...
                 (mean(w(:, 1)) == 0) && (mean(w(:, 2)) == 0) && (mean(t) == 0)
            
            teste = 1;
            
        end
        
        it = it + 1;
    end

    am1 = u;
    am2 = v;
    
    if teste == 0
        fprintf('Maximo de Interacoes em ransac_amostra\n');
        %exit;
    end
end

%%