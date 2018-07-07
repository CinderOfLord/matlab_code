%{
x = linspace(0 , 3 * pi);
z1 = sin(x);
z2 = sin(2 * x);
z3 = sin(3 * x);
y1 = zeros(size(x));
y3 = zeros(size(x));
y2 = y3 / 2;
plot3(x,y1,z1,x,y2,z2,x,y3,z3);
grid;
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');
title('sin(x),sin(2x),sin(3x)');
%}

%{
x = -7.5 : 0.5 : 7.5;
y = x;
[X,Y] = meshgrid(x,y);
R = sqrt(X .^ 2 + Y .^ 2) + eps;
Z = sin(R) ./ R;
subplot(1,2,1);
mesh(X,Y,Z);
subplot(1,2,2);
surf(X,Y,Z);
%}

%{
[X,Y,Z] = peaks;
subplot(2,2,1);
contour(Z,20);
subplot(2,2,2);
contour(X,Y,Z,20);
subplot(2,2,3);
contour3(Z,20);
subplot(2,2,4);
contour3(X,Y,Z,20);
%}

%{
[X,Y] = meshgrid(1:0.5:10,1:20);
Z = sin(X) + cos(Y);
C = X + Y;
surf(X,Y,Z,C);
colorbar;
%}

%{
x = -25 : 1.25 : 25;
y = -25 : 1.25 : 25;
[xx,yy] = meshgrid(x,y);
z = xx.^2 / 9 - yy.^ 2 / 4 + eps;
surfl(xx,yy,z);
%}


[X0,Y0,Z0] = sphere(30);
X = 2 * X0; Y = 2 * Y0; Z = 2 * Z0;
clf,subplot(1,2,1);
surf(X0,Y0,Z0);
shading interp
hold on, mesh(X,Y,Z),colormap(hot),hold off
hidden off
%axis equal,axis off
subplot(1,2,2);
surf(X0,Y0,Z0);
shading interp
hold on, mesh(X,Y,Z),colormap(hot),hold off
hidden on
%axis equal, axis off


%{
clc;clear; close all;

rpol=25/2000;

nthe=51;

npsi=51;

the=linspace(0,pi,nthe);

psi=linspace(0,2*pi,npsi);

% Matriculated;

[psi,the]=meshgrid(psi,the);

rpol=rpol*ones(size(the));

% Convert spherical coordinate to Cartesian Coordinate;

x_mm=rpol.*cos(the)*1000;                     % z in transformational relation;

y_mm=rpol.*sin(the).*cos(psi)*1000;           % x in transformational relation;

z_mm=rpol.*sin(the).*sin(psi)*1000;           % y in transformational relation;

tic 

fval=2*x_mm.^2+y_mm.^2-z_mm.^2;    %% this is a example !!;

toc

%% matrix ( x y z fval ) used to figure fval is color;

%% figure

figure('Renderer','zbuffer','Color',[1 1 1]);

surf(x_mm,y_mm,z_mm,fval);

shading interp;light;lighting gouraud;

colorbar

axis equal;

xlabel('x(mm)');ylabel('y(mm)');zlabel('z(mm)');
%}

%{
x=-200:5:200;
y=-200:5:200;
z=-200:5:200;
m=linspace(0,1,length(x));
for i=1:length(x);
plot3(x(i),y(i),z(i),'o','color',[m(i) 0 0])
hold on
end
%}

%{
[x,y,z,v] = flow;
p = patch(isosurface(x,y,z,v,-3));
isonormals(x,y,z,v,p)
p.FaceColor = 'red';
p.EdgeColor = 'none';
daspect([1 1 1])
view(3); 
axis tight
camlight 
%}

