load('./data/inputdata.mat');

% checkUniqueNeuron(v). La función representa la condición número uno
% para terminar la recurrencia es que solo una neurona sea mayor a cero
% y todas las demás cero.
function unique= checkUniqueNeuron(v)
unique = false;
for i = 1:length(v)
  if(v(i) > 0)
    if(unique)
      unique = false;
      break;
    else
      unique = true;
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
function [a2Values , output] = HammingNetwork(W1, b, e , p)
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
a2Values = vertcat(a2Values, a2);
%   Creando W2 con epsilon
W2 = [ 1, -1 * e ; -1 * e,  1];
last = posslin(W2 * a2); % a2(1) = a2()

it100 = 0;
% El blucle terminara cuando se cumplan las primera dos condiciones
while true
  actual = computeA2(last, W2);
  % Si se cumplen las dos condiciones se rompera el bucle
  if (findCoincidence(last, actual) && checkUniqueNeuron(actual)) || it100 == 100
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

output = "xd";

end

% Obteniendo la información
[a2Values, ~] = HammingNetwork(W, b, e, p);
disp(a2Values);
