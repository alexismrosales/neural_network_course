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

% T: Vector de targets, S: Número de clases
function T = getDataT(path, nameFile)
  formatSpec = '%f';
  route = append(path, '/', nameFile);
  file = fopen(route, 'r+');
  if(file == -1)
    error(append('Error al abrir el archivo ', nameFile));
  end
  % Guardando los valores en un vector
  T = fscanf(file, formatSpec);
  fclose(file);
end

function main()
  experiment = input('Ingrese el número de experimento a realizar: ');
  example = input('Ingrese 1 si desea el ejemplo 1, 2 para el ejemplo 2');
  epochs = input('Ingrese el número de épocas a realizar (Máximo de 100)');

  if(epochs > 100)
    error('El número de épocas debe ser menor a 100');
  end

  path = append('./input_data', '/', string(experiment), '/', string(example));
  savePath = append('./input_data/variables/', 'data.mat');
  % Obteniendo matriz de datos de entrada p
  M = getDataP(path, 'input_p.txt')';
  % Obteniendo los targets
  T = getDataT(path, 'target.txt');
  % Obteniendo el numero total de clases
  classes = getDataT(path, 'classes.txt');

  disp('Datos de entrada:');
  disp(M);

  disp('Targets:');
  disp(T);

  disp('Epocas:');
  disp(epochs);

  save(savePath, 'M', 'T', 'epochs', 'classes');
end


main()
