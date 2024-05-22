% This script models the "Air Gap" sensor, while the air gap is present.

syms F f h d d1 d2 d1n d2n kt ks e1 e2 A L cb ce1 ce2 cm
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
%    e1: dielectric permittivity of polyimide+ air gap
%    e2: dielectric permittivity of polyimide (bottom)
%    A: Area of sensing element electrode
%    L: Inductance in sensing circuit
%   cb: base capacitance of sensing circuit
%  ce1: capacitance of element 1 (top)
%  ce2: capacitance of element 2 (bottom)
%   cm: capacitance as measured by circuit

% Total stiffness model, just the steel case and air (k=0)
kt = ks

% Sensor height
h = d1n + d2n

% Sensor deformation model, total displacement from total stiffness
d = F / kt

% Sensor element 1 displacement (same as total)
d1 = d

% Sensor element 2 displacement (static)
d2 = 0

% Sensor capacitance model, between electrode and case, top side
% https://phys.libretexts.org/Bookshelves/Electricity_and_Magnetism/Electricity_and_Magnetism_(Tatum)/05%3A_Capacitors/5.14%3A__Mixed_Dielectrics
ce1 = e1 * e2 * A / (e2 * (d1n - d1) + e1 * 0.25e-4)

% Other element, between electrode and case, bottom side
ce2 = e2 * A / (d2n - d2)

% Measured capacitance relation to cap network with parallel env cap
cm = cb + ce1 + ce2

% Sensor resonant frequency model
f = 1 / (2*pi*sqrt(L*cm))

df_dF = simplify(diff(f, F))
display(latex(df_dF))

A = 3.75e-4
e1 = 8.854e-12 * 1.0 % Air
e2 = 8.854e-12 * 3.2 % PI
d1n = 1.5e-4
d2n = 1.35e-4 % 100um of PI and 25um of soldermask and 10um of super glue
ks = 6.0e9
L = 18e-6 + 4e-6 % Board + estimated parasitic values
cb = 33e-12 + 1.5e-10 % Board + estimated parasitic values
F = [0:1e3:200e3];

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

subplot(4,1,3);
plot(cap_values);
title("Sensor Cap vs Force")

subplot(4,1,4);
plot(strain_values);
title("Sensor Strain vs Force")

sgtitle("Air Gap")
