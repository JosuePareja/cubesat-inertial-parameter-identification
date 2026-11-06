function C = cubesat_parameters(nombre)
%CUBESAT_PARAMETERS
% Database of CubeSats used in the simulation.
%
% Usage:
% C = cubesat_parameters('INNOCUBE');
% C = cubesat_parameters('TPA1');
% C = cubesat_parameters('SOURCE');
% C = cubesat_parameters('M3SAT');
%
% Axis convention used in the experiment:
%
% Y_C+ = Y_B+
% Z_C+ = X_B+
% X_C+ = -Z_B+
%
% Therefore:
%
% [x_B y_B z_B]' = [z_C y_C -x_C]'
%
% and:
%
% J_B = R_BC*J_C*R_BC'
%
% The common mounting position is:
%
% r_CR->G_B = [0 0 62]' mm
%
% IMPORTANT NOTE ON THE REPORTED TENSORS:
% Based on the information currently collected, it has not been confirmed for all
% CubeSats whether the reported tensor is referred exactly to the CM or to the
% geometric center G. To allow the simulation to run, this file
% uses the reported tensor as J_CM. This assumption is recorded in
% C.tensor_referencia_modelo and should be reviewed once the source is confirmed.
%
% SOURCE and M3Sat do not have reported products of inertia in the available
% data. To generate the numerical simulation ground truth,
% zero products are used, but they are NOT treated as original known
% values during the final comparison.

    if nargin < 1 || isempty(nombre)
        error('The CubeSat name must be specified.');
    end

    R_BC = [ ...
         0, 0, 1; ...
         0, 1, 0; ...
        -1, 0, 0 ...
    ];

    clave = upper(regexprep(char(string(nombre)),'[^A-Za-z0-9]',''));

    C = struct;
    C.R_BC = R_BC;
    C.r_CR_G_B = [0;0;62e-3];
    C.tensor_referencia_modelo = 'CM';
    C.tensor_referencia_fuente_confirmada = false;

    switch clave

        case 'SOURCE'

            C.id = 'SOURCE';
            C.nombre = 'SOURCE';
            C.M = 5.02;

            C.r_G_CM_C = 1e-3*[ ...
                 0.30; ...
                -8.47; ...
                 0.43 ...
            ];

 % Reported diagonal values in C axes.
 % The products of inertia are not available.
            C.J_reportado_C = 1e-3*[ ...
                52.56, NaN,   NaN; ...
                  NaN, 10.09, NaN; ...
                  NaN, NaN, 52.45 ...
            ];

            C.J_modelo_C = 1e-3*diag([52.56,10.09,52.45]);
            C.productos_inercia_reportados = false;

        case {'M3SAT','M3'}

            C.id = 'M3SAT';
            C.nombre = 'M3Sat';
            C.M = 4.56;

            C.r_G_CM_C = 1e-3*[ ...
                -1.96; ...
               -12.53; ...
                 1.79 ...
            ];

            C.J_reportado_C = 1e-3*[ ...
                16.73, NaN,  NaN; ...
                  NaN, 0.52, NaN; ...
                  NaN, NaN, 16.96 ...
            ];

            C.J_modelo_C = 1e-3*diag([16.73,0.52,16.96]);
            C.productos_inercia_reportados = false;

        case {'INNOCUBE','INNO'}

            C.id = 'INNOCUBE';
            C.nombre = 'InnoCube';
            C.M = 4.20;

            C.r_G_CM_C = 1e-3*[ ...
                -6.83; ...
                -9.92; ...
                 5.66 ...
            ];

 % Reported tensor in C axes.
            C.J_reportado_C = 1e-3*[ ...
                189,  38, -12; ...
                 38,  34, -39; ...
                -12, -39, 188 ...
            ];

            C.J_modelo_C = C.J_reportado_C;
            C.productos_inercia_reportados = true;

        case {'TPA1','TPA'}

            C.id = 'TPA1';
            C.nombre = 'TPA-1';
            C.M = 4.50;

            C.r_G_CM_C = 1e-3*[ ...
                 1.60; ...
                -2.60; ...
                 0.70 ...
            ];

            C.J_reportado_C = 1e-3*[ ...
                42.43, -0.29,  0.03; ...
                -0.29,  5.61, -0.37; ...
                 0.03, -0.37, 42.18 ...
            ];

            C.J_modelo_C = C.J_reportado_C;
            C.productos_inercia_reportados = true;

        otherwise

            error([ ...
                'CubeSat desconocido: %s. Opciones: ', ...
                'SOURCE, M3SAT, INNOCUBE, TPA1.' ...
            ],nombre);

    end

 % =============================================================
 % TRANSFORMATION TO THE PLATFORM BODY AXES
 % =============================================================

    C.r_G_CM_B = C.R_BC*C.r_G_CM_C;
    C.r_CR_CM_B = C.r_CR_G_B + C.r_G_CM_B;

    C.J_CM_B = C.R_BC*C.J_modelo_C*C.R_BC';

    I3 = eye(3);
    r = C.r_CR_CM_B;

    C.J_CR_B = C.J_CM_B + ...
        C.M*((r'*r)*I3-r*r');

    C.S_CR_B = C.M*C.r_CR_CM_B;

 % Reported version transformed to B, retaining NaN where the source
 % does not provide products of inertia.
    if C.productos_inercia_reportados
        C.J_reportado_B = C.R_BC*C.J_reportado_C*C.R_BC';
    else
        JrepB = nan(3);
 % Only the principal/diagonal moments are comparable.
        JrepB(1,1) = C.J_reportado_C(3,3);
        JrepB(2,2) = C.J_reportado_C(2,2);
        JrepB(3,3) = C.J_reportado_C(1,1);
        C.J_reportado_B = JrepB;
    end

 % Mask of parameters actually reported for comparisons.
    C.mascara_J_C = isfinite(C.J_reportado_C);
    C.mascara_J_B = isfinite(C.J_reportado_B);

    C.nota_tensor = [ ...
        'Para la simulacion se interpreta el tensor reportado como J_CM. ', ...
        'Confirmar el punto de referencia del tensor antes de usar los ', ...
        'resultados como validacion experimental definitiva.' ...
    ];

end
