function binaryMatrix = createTable(bits)
% Las combinaciones posibles son 2^bits
combinations = 2^bits;
% Alocamos la memoria necesaria
binaryMatrix = zeros(combinations, bits + 1);
for i = 0:combinations-1
    binaryNumber = dec2bin(i, bits) - '0'; % Convierte la cadena a un array de números
    binaryMatrix(i+1, 1:bits) = binaryNumber;
    binaryMatrix(i+1, end) = i;
end
end


function [W, resultsW, resultsErr] = adaline(data, epochsLimit, errRange, maxErr)
% Inicializando la matriz de pesos con valores aleatorios
[num_rows, num_cols] = size(data);

W = -1 + 2 * rand(1, num_cols-1);
resultsErr = [];
resultsW = [];
epochs = 0;
% Iterando sobre el número de epócas
while(epochs <= epochsLimit)
    errEpoch = 0;
    % Realizando una epóca
    for i = 1:num_rows
        row = data(i, :);
        p = row(1:end-1);
        t = row(end);
        % Propagación hacia adelante
        a = W * p';
        e = t - a;
        W = W + 2 * errRange * e * p;
        errEpoch = errEpoch + e;
        resultsErr = [resultsErr; e];
        resultsW = [resultsW; W];
    end
    % Si el error promedio llega al error minímo dado por el usuario
    errEpoch = errEpoch / num_cols;
    if(errEpoch <= maxErr)
        disp('Se ha llegado al error mínimo...');
        break;
    end
    epochs = epochs + 1;
end
disp('W es:');
disp(W);
end

function test(data,W)
[num_rows, ~] = size(data);
disp('Se muestran los datos a continuación: ');
disp('Target | Resultado');
% Se realiza una epóca de verificación
for i = 1:num_rows
    row = data(i, :);
    p = row(1:end -1);
    t = row(end);
    a = W * p';
    fprintf(' %4.2f  |   %4.2f\n',t,a);
end
end

function drawPlot(resultsW, resultsErr)

% Se obtiene curvas a graficar, que es igual al número de columnas
numCurves = size(resultsW, 2);

figure;

% Grafica cada columna como una curva
for i = 1:numCurves
    plot(resultsW(:, i), 'DisplayName', ['Curva peso ' num2str(i)]);
    hold on;
end
plot(resultsErr, 'DisplayName', 'Curva error');
hold off;
legend show;
xlabel('Iteraciones');
ylabel('Pesos');
title('Gráfico de pesos por epócas');
end

function main()
bits = input('Introduzca el número de bits para la tabla de verdad: ');
table = createTable(bits);
%disp(table);
% Asignando valores de error y máximo de epócas
epochs = 200;
errRange = 0.1;
epochsErr = 0.001;
[W, resultsW, resultsErr] = adaline(table, epochs, errRange, epochsErr);
test(table, W);
drawPlot(resultsW, resultsErr);


end

main()

