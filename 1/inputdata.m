% Leyendo información del peso de la matriz W
% Para ingresar las matrices se ingresan los vectores p1 ... pn
% Línea 1: Ingrese S (numero de vectores de entrada)
% Línea 2 .. línea n : Ingrese los vectores de entrada por Línea
% INGRESE LOS VALORES DE W1, ... , R a WS, ... , R de forma transpuesta
function [M , S, R] = getDataM(path, nameFile)
formatSpec = '%f';
route = append('./data/',path, '/',nameFile);
fileWeight = fopen(route,'r+');

if fileWeight == -1
  error('Error al abrir el archivo w.txt')
end

weightData = fscanf(fileWeight,formatSpec);
fclose(fileWeight);

% Obteniendo el número de vectores (S)
rows = weightData(1);
weightData(1) = [];
cols = length(weightData) / rows;

temp = reshape(weightData, cols, rows);

M = temp';
S = rows;
R = length(weightData) / rows;
end

function vector = getData(path,nameFile)
formatSpec = '%f';
route = append('./data/',path, '/',nameFile);
file = fopen(route,'r+');

if(file == -1)
  error(append('Error al abrir el archivo ', nameFile));
end
% Guardando los valores en un vector
vector = fscanf(file, formatSpec);
fclose(file);
disp(vector);
end


function main()

experiment = input('Ingrese el número de experimento del que desea cargar los datos: \n');
experiment = num2str(experiment);
[W, S, R] = getDataM(experiment,'w.txt');
b = getData(experiment,'b.txt');
format shortE
e = getData(experiment,'e.txt');
p = getData(experiment,'p.txt');

% En caso que haya un valor incorrecto de p
if(length(p) ~= R)
  error(append('Error, Verifique que R coincida con el numero de valores de p'));
end
% En caso que haya un valor incorrecto b
if(length(b) ~= S)
  error('Verifique que S coincida con el numero de valores de b');
end

disp('Matriz W:');
disp(W);
disp('S : ')
disp(S);
disp('R : ')
disp(R);
disp('b : ')
disp(b);
disp('e : ')
disp(e);
disp('p : ')
disp(p);

% Guardando las variables
save('./data/inputdata.mat', 'W', 'S', 'b', 'e',  'p', 'R');
end

main();
