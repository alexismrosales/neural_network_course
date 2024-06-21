load('./input_data/variables/data.mat')
% Función que crea al vector de pesos W y el bias b de forma aleatoria
% para iniciar el entrenamiento
function [W, b] = initializingWeightAndBias(size, neurons)
W = -1 + 2 * rand(neurons, size);
b = -1 + 2 * rand(neurons, 1);
end

function [W, b] = adaline(inputAndPrototypes, epochsLimit, errRange, maxErr, W, b)
% Inicializando la matriz de pesos con valores aleatorios
[num_rows, num_cols] = size(inputAndPrototypes);
epochs = 0;
% Iterando sobre el número de epócas
while(epochs <= epochsLimit)
    errEpoch = 0;
    % Realizando una epóca
    for i = 1:num_rows
        row = inputAndPrototypes(i, :);
        p = row(1:end-1);
        t = row(end);
        % Propagación hacia adelante
        a = purelin(W * p' + b);
        
        e = t - a;
        for j = 1:size(W, 1)
            W(j, :) = W(j, :) + 2 * errRange * e(j) * p;
            b(j) = b(j) + 2 * errRange * e(j);
        end
        errEpoch = errEpoch + sum(e.^2);
    end
    % Si el error promedio llega al error minímo dado por el usuario
    errEpoch = errEpoch / num_rows;
    if(errEpoch <= maxErr)
        disp('Se ha llegado al error mínimo...');
        break;
    end
    epochs = epochs + 1;
end
disp('W es:');
disp(W);
end


function plotting(W, b, inputAndPrototypeData, neurons)
figure;
% Coordenadas x e y de los puntos
x = inputAndPrototypeData(:, 1);
y = inputAndPrototypeData(:, 2);
class = inputAndPrototypeData(:, 3);

% Obteniendo los vectores de pesos y bias
vx = W(1);
vy = W(2);
if neurons >= 2
    vx2 = W(3);
    vy2 = W(4);
    if neurons >= 3
        vx3 = W(5);
        vy3 = W(6);
    end
end

% Graficar los puntos
hold on;
plot(x, y, 'o', 'MarkerSize', 10); % '10' es el tamaño del marcador

% Graficando los vectores de pesos desde el origen hasta (vx, vy)
quiver(0, 0, vx, vy, 0, 'r', 'LineWidth', 2, 'MaxHeadSize', 0.5);
if neurons >= 2
    quiver(0, 0, vx2, vy2, 0, 'b', 'LineWidth', 2, 'MaxHeadSize', 0.5);
    if neurons >= 3
        quiver(0, 0, vx3, vy3, 0, 'y', 'LineWidth', 2, 'MaxHeadSize', 0.5);
    end
end

% Graficar las fronteras de decisión
x_vals = linspace(-10, 10, 100);

% Calculando las fronteras de decisión que pasan por el origen y son perpendiculares a los vectores de pesos
y_vals = -(vx/vy) * x_vals; % Frontera de decisión para el primer vector de pesos
plot(x_vals, y_vals, 'r', 'LineWidth', 1);

if neurons >= 2
    y2_vals = -(vx2/vy2) * x_vals; % Frontera de decisión para el segundo vector de pesos
    plot(x_vals, y2_vals, 'b', 'LineWidth', 1);
    
    if neurons >= 3
        y3_vals = -(vx3/vy3) * x_vals; % Frontera de decisión para el tercer vector de pesos
        plot(x_vals, y3_vals, 'y', 'LineWidth', 1);
    end
end

% Añadir etiquetas de clase a los puntos
for i = 1:length(x)
    text(x(i), y(i), sprintf('\t\t%d', class(i)));
end

% Configuración del gráfico
axis equal;
xlim([-8, 8]); % Límites para el eje x
ylim([-8, 8]); % Límites para el eje y
xline(0, '-', 'Color', 'k'); % Línea vertical en x=0
yline(0, '-', 'Color', 'k'); % Línea horizontal en y=0

% Etiquetas de los ejes
xlabel('Eje X');
ylabel('Eje Y');

% Título del gráfico
title('Frontera de decisión');

% Añadir una cuadrícula
grid on;
end

function pass = test(W, b, test_set)
total_rows = size(test_set, 1);
pass = false;

for i = 1:total_rows
    row = test_set(i, :);
    p = row(1:end-1)';
    t = row(end);
    
    % Aplicar la red
    a = hardlim(W * p + b);
    
    % Determinar la clase predicha
    [~, predicted_class] = max(a);
    predicted_class = (predicted_class - 1) * 2; % Ajustar para que coincida con las clases 0, 2, 4, etc.
    
    % Verificar si la predicción es correcta
    %disp(['Target: ', num2str(t), ' | Predicted: ', num2str(predicted_class)]);
    
    if t ~= predicted_class
        pass = true;
    end
end
end

function main(M, T, epochs, classes)
% Variables dadas por el usuario
errRange = 0.000001;
epochsErr = 0.01;
% Juntando los targets en la matriz de inputs y colocandolos en la última columna
M = normalize(M(:, 1:end));
M = horzcat(M, T);
% Obtenemos los primeros datos sin los ultimos 3 vectores ya que son los vectores de prueba
inputAndPrototypeData = M(1:end-3, :);
% Obtenemos los vectores de entrada para el conjunto de entrenamiento
test_set = M(end-2:end, :);

% Inicializando los datos con valores aleatorios para comenzar el entrenamiento
[W, b] = initializingWeightAndBias(size(inputAndPrototypeData,2) - 1, classes/2);
[W, b] = adaline(inputAndPrototypeData, epochs, errRange, epochsErr, W, b);

pass = test(W, b , test_set);
disp('Los test han sido realizados')
limit = 5;
iterations = 0;
while (pass == false | iterations < limit)
    iterations = iterations + 1;
    disp('Los datos de prueba no pasaron el test, se hará un nuevo entrenamiento...');
    [W, b] = adaline(inputAndPrototypeData, epochs, errRange, epochsErr, W, b);
    pass = test(W, b, test_set);
end
if pass == true
    disp('Los datos han pasado la prueba');
end
plotting(W, b, inputAndPrototypeData, classes/2);
end

main(M, T, epochs, classes);
