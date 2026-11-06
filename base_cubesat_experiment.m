clear;
clc;
close all;

%% ================================================================
% experiment complete BASE + CUBESAT
%
% for change of CubeSat only modify the next line:
% ================================================================

nombre_cubesat = 'INNOCUBE';

% Opciones available:
% 'SOURCE'
% 'M3SAT'
% 'INNOCUBE'
% 'TPA1'


%% ================================================================
% parameters GENERALES
% ================================================================

P_base = platform_parameters();
A0 = actuator_torque_parameters();
C = cubesat_parameters(nombre_cubesat);

% Different noise realization in each run.
rng('shuffle');

fprintf('\n');
fprintf('=============================================================\n');
fprintf(' experiment BASE + CUBESAT\n');
fprintf(' Selected CubeSat: %s\n',C.nombre);
fprintf('=============================================================\n');

fprintf('\nCUBESAT PARAMETERS USED IN THE SIMULATION\n');
fprintf('mass = %.6f kg\n',C.M);
fprintf('r_G->CM in C axes [mm]:\n');
disp(1000*C.r_G_CM_C);
fprintf('r_CR->CM in BODY axes [mm]:\n');
disp(1000*C.r_CR_CM_B);
fprintf('J_CM in BODY axes [kg*m^2]:\n');
disp(C.J_CM_B);


%% ================================================================
% campaign 1 - platform BASE
% ================================================================

A_base = A0;
A_base.rCMz_obj = A0.rCMz_obj_base;

BASE = run_identification_campaign( ...
    P_base, ...
    A_base, ...
    'BASE' ...
);


%% ================================================================
% campaign 2 - platform + CUBESAT
% ================================================================

P_con_cubesat = add_cubesat_to_platform(P_base,C);

A_cubesat = A0;
A_cubesat.rCMz_obj = A0.rCMz_obj_cubesat;

fprintf('\n');
fprintf('=============================================================\n');
fprintf(' plant with CUBESAT MONTADO\n');
fprintf('=============================================================\n');
fprintf('M_total BASE          = %.6f kg\n',P_base.M_total);
fprintf('M_total BASE+CubeSat  = %.6f kg\n',P_con_cubesat.M_total);
fprintf('CM canonico true BASE [mm]:\n');
disp(1000*P_base.rCM0);
fprintf('CM canonico true BASE+CubeSat [mm]:\n');
disp(1000*P_con_cubesat.rCM0);
fprintf('rCMz target before the second estimation = %.3f mm\n', ...
    1000*A_cubesat.rCMz_obj);

CON_CUBESAT = run_identification_campaign( ...
    P_con_cubesat, ...
    A_cubesat, ...
    ['BASE_' C.id] ...
);


%% ================================================================
% CUBESAT PARAMETER EXTRACTION
% ================================================================

RESULTADO_CUBESAT = extract_cubesat_parameters( ...
    BASE, ...
    CON_CUBESAT, ...
    C ...
);


%% ================================================================
% save experiment complete
% ================================================================

nombre_archivo = [ ...
    'resultado_experimento_BASE_' ...
    C.id ...
    '.mat' ...
];

save( ...
    nombre_archivo, ...
    'nombre_cubesat', ...
    'C', ...
    'P_base', ...
    'P_con_cubesat', ...
    'A_base', ...
    'A_cubesat', ...
    'BASE', ...
    'CON_CUBESAT', ...
    'RESULTADO_CUBESAT' ...
);

fprintf('\nComplete experiment saved to:\n%s\n',nombre_archivo);
