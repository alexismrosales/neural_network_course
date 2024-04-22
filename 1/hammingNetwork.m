load('./data/inputdata.mat');

% checkUniqueNeuron(v). La función representa la condición número uno
% para terminar la recurrencia es que solo una neurona sea mayor a cero
% y todas las demás cero.
function single =  checkSingleActiveOutput(v)
single = false;
for i = 1:length(v)
    if(v(i) > 0)
        if(single)
            single = false;
            break;
        else
            single = true;
        end
    end
end
end

% coincidence(v1,v2). La función representa la segunda condición que sucede
% cuando la primera iteración que cumpla la condición número uno sea igual a
% la segunda iteración.
function coincidence = findCoincidence(v1,v2)
if v1 == v2
    coincidence = true;
else
    coincidence = false;
end
end

% Posslin(n). Simulación de función Poslin(n)
function a = posslin(n)
n(n < 0) = 0;
a = n;
end


% a2 = iteration(o, W2). Sea a2 el valor del cálculo de a2(t+1)
% Supongamos que o = a2(t)
function a = computeA2(o , W2)
n = W2 * o;
a = posslin(n);
end

% HammingNetwork(W1, b, e, p). Función principal
function a2Values = HammingNetwork(W1, b, e , p, S)
a2Values = [];

% Feedfoward layer
% Primera capa
%   Generando el valor de n
n = W1 * p + b ;
%   Función Purelin(n)
a1 = n;
% Recurrent Layer
% Segunda capa
%   Asignando a2(0) = a(0)
a2 = a1;
a2Values = horzcat(a2Values, a2);
%   Creando W2 con epsilon
%     Creando matriz SxS, con -epsilon
W2 = ones(S) * -1 * e;
%     Llenando la diagonal con -1
W2(logical(eye(size(W2)))) = 1;

%     Representa a2(1) = posslin(W2 a(0))
last = posslin(W2 * a2); % a2(1) = a2()
% Variable que servira para contar ciertas iteraciones
it100 = 0;

% El blucle terminara cuando se cumplan las primera dos condiciones
while true
  actual = computeA2(last, W2);
  % Si se cumplen las dos condiciones se rompera el bucle
  if (findCoincidence(last, actual) && checkSingleActiveOutput(actual)) || it100 == 100  % ------IMPORTANTE REMOVER SI NO SE DESEAN HACER UN MÁXIMO DE 100 ITERACIONES
    break;
  else
    % Agregnado los vectores a la lista de valores de a2
    a2Values = horzcat(a2Values, actual);
    last = actual;
    it100 = it100 + 1;
  end
end
% Añadiendo el ultimo valor
a2Values = horzcat(a2Values, actual);
end

function main(W, b, e, p, S)
% Obteniendo la información
a2Values = HammingNetwork(W, b, e, p, S);
disp(a2Values);
% Asignando los valores a graficar
x_coords = 1:length(a2Values(1, :));
y_coords = a2Values';

% Graficando los datos
figure;
plot(x_coords, y_coords, '-o');
xlabel('Tiempo');
ylabel('Neuronas');

grid on;
end

main(W, b, e, p, S);
