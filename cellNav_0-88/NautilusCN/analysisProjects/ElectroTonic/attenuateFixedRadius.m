function[V] = attenuateFixedRadius(d,props)



%%
% http://www.columbia.edu/cu/biology/courses/w3004/Lecture5.pdf

resistivity = 2000; %resistivity = resistance of cm^3
Rm = 2000; %ohms cm^2
radius = .1; %radius in um
Vo = 1;

a = radius/10000; %radius in centimeters
x = d/10000; %distance in centimeters
ra = resistivity/(pi*a^2); %axial resitance 
rm = Rm/(2*pi*a); %membrane resistance
lc = sqrt(rm/ra); %length constant = sqrt of membrane resistance/axial resistance
V = Vo * exp(-x/lc);
