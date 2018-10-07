addpath('~/asigDSIC/ETSINF/apr/p2/BNT');
addpath(genpathKPM('~/asigDSIC/ETSINF/apr/p2/BNT'));
N=5;
P=1;
F=2;
C=3;
R=4;
D=5;
grafo = zeros(N,N);
grafo(P,C) = 1;
grafo(F,C) = 1;
grafo(C,[R, D]) = 1;

nodosDiscretos = 1:N;
tallaNodos = [2 2 2 3 2];
redB = mk_bnet(grafo, tallaNodos, 'discrete', nodosDiscretos);


redB.CPD{P} = tabular_CPD(redB,P, [0.1 0.9]);

redB.CPD{F} = tabular_CPD(redB,F, [0.3 0.7]);

redB.CPD{C} = tabular_CPD(redB,C, [0.08 0.05 0.03 0.001 0.92 0.95 0.97 0.999]);

redB.CPD{R} = tabular_CPD(redB,R, [0.7 0.1 0.2 0.1 0.1 0.8]);

redB.CPD{D} = tabular_CPD(redB,D, [0.65 0.3 0.35 0.7]);

motor = jtree_inf_engine(redB);

evidencia = cell(1,N);
evidencia{C} = 1;

[explMasProb, logVer] = calc_mpe(motor, evidencia);
explMasProb
logVer

[motor, logVerosim] = enter_evidence(motor, evidencia);
m = marginal_nodes(motor,C,1);
m.T
