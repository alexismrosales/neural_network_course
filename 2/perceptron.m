load('./input_data/variables/data.mat')
% Función que crea al vector de pesos W y el bias b de forma aleatoria
% para iniciar el entrenamiento
function [W, b] = initializingWeightAndBias(size, neurons)
W = -1 + 2 * rand(neurons, size);
b = -1 + 2 * rand(1, 1);
end

function [newW, newB] = perceptron_network(inputAndPrototypes, epochs, W, b, numNeurons)
counterOfEpochs = 0;
total_rows = size(inputAndPrototypes, 1);

while (counterOfEpochs < epochs)
  for i = 1:total_rows
    row = inputAndPrototypes(i, :);
    p = row(1:end-1)';
    t = row(end);
    
    % Crear el vector objetivo para codificación one-hot
    target = -ones(numNeurons, 1);
    target(floor(t/2) + 1) = 1;
    
    % Aplicar la red neuronal a cada vector de entrada
    a = hardlim(W * p + b);
    
    % Calculando el error
    e = target - a;
    
    % Actualizar el peso y el sesgo
    W = W + e * p';
    b = b + e;
  end
  counterOfEpochs = counterOfEpochs + 1;
end

newW = W;
newB = b;
end

function pass = test(W, b, test_set)
total_rows = size(test_set, 1);
pass = true;

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
    pass = false;
  end
end
end

function plotting(W, inputAndPrototypeData, neurons)
figure;
% Coordenadas x e y de los puntos
x = inputAndPrototypeData(:,1);
y = inputAndPrototypeData(:,2);
vx = W(1);
vy = W(2);
if(neurons >= 2)
  vx2 = W(3);
  vy2 = W(4);
  if(neurons >= 3)
    vx3 = W(5);
    vy3 = W(6);
  end
end
class = inputAndPrototypeData(:,3);
% Obteniendo la recta perpendicular al vector
m1 = vy/vx;
m2 = -1/m1;

x_vals = linspace(-10,10,100);
y_vals = m2 * x_vals;



% perpendicular del la tercera neurona



% Graficando la recta
hold on;
plot(x_vals, y_vals, 'r', 'LineWidth', 1);
if(neurons >= 2)
  % perpendicular del la segunda neurona
  m1_2 = vy2/vx2;
  m2_2 = -1/m1_2;
  
  x2_vals = linspace(-10,10,100);
  y2_vals = m2_2 * x_vals;
  plot(x2_vals, y2_vals, 'b', 'LineWidth', 1);
  if(neurons >= 3)
    % perpendicular del la tercera neurona
    m1_3 = vy3/vx3;
    m2_3 = -1/m1_3;
    
    x3_vals = linspace(-10,10,100);
    y3_vals = m2_3 * x_vals;
    
    plot(x3_vals, y3_vals, 'y', 'LineWidth', 1);
    
  end
  
end

% Graficar los puntos
plot(x, y, 'o', 'MarkerSize', 10); % '10' es el tamaño del marcador

% Graficando el vector
%hold on;
%quiver(0, 0, vx, vy, 0, 'r', 'LineWidth', 1);

hold on;
for i = 1:size(x)
  text(x(i),y(i),sprintf('\t\t%d',class(i)));
end

axis equal
xlim([-8,8]); % Límites para el eje x
ylim([-8,8]); % Límites para el eje y
axis equal
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

function changedVectors = reorderRows(M)
random_index = randperm(size(M, 1));
changedVectors = M(random_index, :);
end
function main(M, T, epochs, classes)
% Juntando los targets en la matriz de inputs y colocandolos en la última columna
M = horzcat(M, T);
% Obtenemos los primeros datos sin los ultimos 3 vectores ya que son los vectores de prueba
disp(M);
inputAndPrototypeData = M(1:end-3, :);
% Obtenemos los vectores de entrada para el conjunto de entrenamiento
test_set = M(end-2:end, :);
% Inicializando los datos con valores aleatorios para comenzar el entrenamiento
[W, b] = initializingWeightAndBias(size(inputAndPrototypeData,2) - 1, classes/2);
[W, ~] = perceptron_network(inputAndPrototypeData, epochs, W, b, classes/2);

disp('Primer entrenamiento completado...');
pass = test(W, b , test_set);
disp('Los test han sido realizados')
limit = 5;
iterations = 0;
while (pass == true | iterations < limit)
  iterations = iterations + 1;
  inputAndPrototypeData = reorderRows(inputAndPrototypeData);
  disp('Los datos de prueba no pasaron el test, se hará un nuevo entrenamiento...');
  [W, b] = perceptron_network(inputAndPrototypeData, epochs, W, b, classes/2);
  pass = test(W, b, test_set);
end
disp('Los datos de prueba han pasado el test...');
disp(W);
plotting(W, inputAndPrototypeData, classes/2);
end
main(M, T, epochs, classes);
