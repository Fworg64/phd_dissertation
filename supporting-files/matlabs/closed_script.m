% This script models the "Air Gap" sensor, after the air gap has been
% crushed out, and both the flexPCB and case deform from the input force.

syms F f h d d1 d2 d1n d2n kt ks kpi1 kpi2 e A L cb ce1 ce2 cm
%    F: input force
%    f: resonant frequency
%    h: nominal total sensor height
%    d: total sensor displacement from nominal
%   d1: element 1 (top) displacement from nominal
%   d2: element 2 (bottom) displacement from nominal
%  d1n: nominal distance for top element between electrode and case
%  d2n: nominal distance for bottom element b/w electrode and case
%   kt: total stiffness of sensor
%   ks: stiffness of steel walls
% kpi1: stiffness of element 1 (top)
% kp12: stiffness of element 2 (bottom)
%    e: dielectric permittivity of polyimide
%    A: Area of sensing element electrode
%    L: Inductance in sensing circuit
%   cb: base capacitance of sensing circuit
%  ce1: capacitance of element 1 (top)
%  ce2: capacitance of element 2 (bottom)
%   cm: capacitance as measured by circuit

% Total stiffness model, sensor case parallel to series polyimide elements
kt = ks + (1/kpi1 + 1/kpi2)^(-1)

% Sensor height
h = d1n + d2n

% Sensor deformation model, total displacement from total stiffness
d = F / kt

% Sensor element 1 displacement
d1 = d / (1 + kpi2/kpi1)

% Sensor element 2 displacement
d2 = d / (1 + kpi1/kpi2)

% Sensor capacitance model, between electrode and case, top side
ce1 = e * A / (d1n - d1)

% Other element, between electrode and case, bottom side
ce2 = e * A / (d2n - d2)

% Measured capacitance relation to cap network with parallel env cap
cm = cb + ce1 + ce2

% Sensor resonant frequency model
f = 1 / (2*pi*sqrt(L*cm))

% Make derivative managable for printing, glob spring constants
% k1 = kt (1 + kpi2/kpi1)
% k2 = kt (1 + kpi1/kpi2)
syms f2 k1 k2
f2 = subs(f, d1, F/k1);
f2 = subs(f2, d2, F/k2)
df2_dF = simplify(diff(f2, F))
display(latex(df2_dF))

df_dF = simplify(diff(f, F))
display(latex(df_dF))

A = 3.75e-4
e = 8.854e-12 * 3.2
d1n = 0.15e-4
d2n = 0.23e-4 % 100um of PI and 25um of soldermask and 10um of super glue
ks = 6.0e9
kpi1 = 3.0e5 * 2.9e-3 / d1n
kpi2 = 7.0e5 * 2.9e-3 / d2n
L = 18e-6 + 4e-6
cb = 33e-12 + 1.5e-10
F = [0.0:1.0e3:200.0e3];

cap_values = subs(cm);
freq_values = subs(f);
sensitivity_values = subs(df_dF);
strain_values = subs(d/h);
newtons_per_hertz_sensitivity_values = 1.0 ./ sensitivity_values;


figure();
subplot(4,1,1);
plot(newtons_per_hertz_sensitivity_values);
title("Newton per Hertz vs Force")

subplot(4,1,2);
plot(freq_values);
title("Frequency vs Force")

sgtitle("Closed Area")

subplot(4,1,3);
plot(cap_values);
title("Sensor Cap vs Force")

subplot(4,1,4);
plot(strain_values);
title("Sensor Strain vs Force")
