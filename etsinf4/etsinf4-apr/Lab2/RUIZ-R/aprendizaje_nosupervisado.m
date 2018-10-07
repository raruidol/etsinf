addpath('~/asigDSIC/ETSINF/apr/p2/BNT');
addpath(genpathKPM('~/asigDSIC/ETSINF/apr/p2/BNT'));

grafo          = [ 0 1 ; 0 0];
nodosDiscretos = [1];
tallaNodos     = [2 2];
redB           = mk_bnet(grafo, tallaNodos, 'discrete', nodosDiscretos);
redB.CPD{1}    = tabular_CPD(redB, 1);
redB.CPD{2}    = gaussian_CPD(redB,2);

datosApr = load('./data/gaus2D/gauss2Dtr.data', '-ascii');

training                = cell(2, length(datosApr));
training(2,:)           = num2cell(datosApr', 1);
motor                   = jtree_inf_engine(redB);
maxIter                 = 15;
epsilon                 = 1e-100;
[redB2, logVer, motor2] = learn_params_em(motor, training, maxIter, epsilon);

K1 = cell(3,1); K2 = K1;
K1{1} = 1;      K2{1} = 2;
% Generar 75 muestras de cada clase
NM = 75
for i=1:NM
    muestra1         = sample_bnet(redB2, 'evidence', K1);
    muestra2         = sample_bnet(redB2, 'evidence', K2);
    muestras(i,:)    = muestra1{2}';
    muestras(i+NM,:) = muestra2{2}';
end

figure
subplot(2,1,1);
etiqsApr = load('./data/gaus2D/gauss2Dtr.labels', '-ascii');
plot(datosApr(etiqsApr==1,1), datosApr(etiqsApr==1,2), 'x', ...
datosApr(etiqsApr==2,1), datosApr(etiqsApr==2,2), 'o');
axis([-4 5 -4 4])
subplot(2,1,2);
plot(muestras(1:NM,1),    muestras(1:NM,2),    'x', ...
muestras(NM:2*NM,1), muestras(NM:2*NM,2), 'o');
axis([-4 5 -4 4])