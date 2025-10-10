clc
clear

A = 10;       % 源强密度
miu = 0.15;
m = 1000;     % 布点数

r = linspace(0,200,m);
dr = r(2)-r(1);

theta = linspace(0,2*pi,m);
dtheta = theta(2)-theta(1);

fia = linspace(0,pi,m);
dfia = fia(2)-fia(1);

fx = 0;
for i = 1 : length(r)
    rr = r(i);
    suma = 0;
    for j = 1:length(fia)
        sumb = 0;
        jj = fia(j);
        for k = 1:length(theta)
              sumb = sumb + (A/(4*pi))*exp(-miu*rr)*sin(jj)*dtheta;
        end
        suma = suma + sumb*dfia;
    end
    fx = fx + suma*dr;
end


fx % 解析解
real = (A/miu)*(1-exp(-miu*max(r))) % 数值解