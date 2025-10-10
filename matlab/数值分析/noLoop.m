clc
clear

A = 4.5;       % 源强密度
miu = 0.15;
m = 600;       % 区间个数

h = 2;          % 地层厚度
zMin = 0;       % 探测起点
zMax = zMin + h;% 探测终点
rMin = 0.2;
rMax = 2;    %最大探测区域
tMin = 0;
tMax = 2*pi;

r = linspace(rMin,rMax,m);
dr = r(2)-r(1);

z = linspace(zMin,zMax,m);
dz = z(2)-z(1);

theta = linspace(tMin,tMax,m);
dtheta = theta(2)-theta(1);

fx = 0;
for i = 1 : length(theta)
    sumA = 0;
    for j = 1:length(z)
        sumB = 0;
        for k = 1:length(r)
            sumB = A/(4*pi*(r(k)^2 + z(j)^2))*exp(-miu*sqrt(r(k)^2 + z(j)^2))*r(k)*dr;
        end
        sumA = sumA + sumB*dz;
    end
    fx = fx + sumA*dtheta;
end


fx % 解析解
% real = (A/miu)*(1-exp(-miu*max(r))) % 数值解

