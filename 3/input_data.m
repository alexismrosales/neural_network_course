% Leyendo la información del input en fomato de matriz
% M: Matriz, R: Filas, L: Tamaño de columnas
function M  = getDataP(path, nameFile)
formatSpec = '%f';
route = append(path, '/',string(nameFile));
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
end

disp('Leyendo datos...');

data = getDataP('./data/', 'input_data.txt');
disp(data);

save('./data/data.mat', 'data');
