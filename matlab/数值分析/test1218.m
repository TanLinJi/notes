clc
clear

A = 4.5;       % 源强密度
miu = 0.15;
m = 200;       % 区间个数
h = 40;        % 地层厚度
rMin = 0.2;
rMax = 2;      % 最大探测区域
tMin = 0;
tMax = 2*pi;

r = linspace(rMin,rMax,m);
dr = r(2)-r(1);

theta = linspace(tMin,tMax,m);
dtheta = theta(2)-theta(1);

zz = -100:1:50;

fx = zeros(1,length(zz));
for p = 1:length(zz)
    zMin = zz(p);
    zMax = zMin + h;
    z = linspace(zMin,zMax,m);
    dz = z(2)-z(1);
    for i = 1 : length(theta)
        sumA = 0;
        for j = 1:length(z)
            sumB = 0;
            for k = 1:length(r)
                sumB = (A/(4*pi*(r(k)^2 + z(j)^2)))*exp(-miu*sqrt(r(k)^2 + z(j)^2))*r(k)*dr;
            end
            sumA = sumA + sumB*dz;
        end
        fx(p) = fx(p) + sumA*dtheta;
    end
end

fx % 精确解
plot(fx,zz,LineWidth=2,Color=[1.000, 0.271, 0.000])


