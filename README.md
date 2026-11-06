# CubeSat Inertial Parameter Identification - MATLAB Project

MATLAB implementation associated with the two-stage inertial-parameter identification study.

## Main entry point

```matlab
generate_final_article_results
```

This runs the BASE campaign and the BASE+CubeSat campaigns for InnoCube, TPA-1, SOURCE, and M3Sat.

## Renamed source files

| Previous filename | New filename |
|---|---|
| `generar_resultados_articulo_final.m` | `generate_final_article_results.m` |
| `ejecutar_campana.m` | `run_identification_campaign.m` |
| `experimento_base_cubesat_reporte.m` | `base_cubesat_experiment_report.m` |
| `experimento_base_cubesat.m` | `base_cubesat_experiment.m` |
| `sim_plataforma.m` | `simulate_platform.m` |
| `prueba_balanceo_plataforma.m` | `platform_balancing_test.m` |
| `est_inercia.m` | `estimate_inertia_parameters.m` |
| `agregar_cubesat_a_plataforma.m` | `add_cubesat_to_platform.m` |
| `parametros_actuadores_torques.m` | `actuator_torque_parameters.m` |
| `parametros_plataforma.m` | `platform_parameters.m` |
| `ode_plataforma.m` | `platform_dynamics_ode.m` |
| `est_plataforma.m` | `estimate_platform_parameters.m` |
| `parametros_cubesat.m` | `cubesat_parameters.m` |
| `extraer_parametros_cubesat.m` | `extract_cubesat_parameters.m` |

## Notes

- Primary MATLAB function names were renamed together with their source files.
- All internal calls to those primary functions were updated.
- Generated result folders and generated output filenames were also renamed to English.
- Numerical parameters and algorithmic behavior were not intentionally modified.

## Updated notes from the previous package

FINAL PI + MULTICUBESAT PACKAGE (corrected v2)

Run:
    generate_final_article_results.m

This is the final package used for the article, including:
- initial PI balancing;
- BASE + InnoCube + TPA-1 + SOURCE + M3Sat campaigns;
- second excitation using moving masses and a reaction wheel;
- 10P and 7P estimation;
- generation of the four main figures;
- LaTeX/CSV tables;
- results_macros.tex;
- v2 corrections for LaTeX line breaks and kg m^2 units.

IMPORTANT:
The InnoCube, TPA-1, SOURCE, and M3Sat parameter files contain
third-party information. Keep the repository PRIVATE until the corresponding
permissions to redistribute these data have been obtained.
