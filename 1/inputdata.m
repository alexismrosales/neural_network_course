
% Leyendo información del peso de la matriz W 
% Para ingresar las matrices se ingresan los vectores p1 ... pn 
% Línea 1: Ingrese n (numero de vectores de entrada)
% Línea 2 .. línea n : Ingrese los vectores de entrada por línea
function W = getDataW(nameFile)
  formatSpec = '%f';
  route = append('./data/',nameFile);
  fileWeight = fopen(route,'r+'); 

  if fileWeight == -1
    error('Error al abrir el archivo w.txt')
  end

  weightData = fscanf(fileWeight,formatSpec);
  fclose(fileWeight);

  rows = weightData(1);
  weightData(1) = [];
  cols = length(weightData) / rows;

  W = reshape(weightData, cols, rows);
  disp(W')
end

function vector = getData(nameFile)
  formatSpec = '%f';
  route = append('./data/',nameFile);
  file = fopen(route,'r+');

  if(file == -1)
    error(append('Error al abrir el archivo ', nameFile));
  end

  vector = fscanf(file, formatSpec);
  fclose(file);
  disp(vector);
end
W = getDataW('w.txt');
b = getData('b.txt');
e = getData('e.txt');
p = getData('p.txt');

