clear
clc
x = 1:6;
y = [8 9 10 15 35 40];
plot(x,y,'-*b');
hold on
xx = min(x):0.01:max(x);
yy = interp1(x,y,xx,"pchip");  %以三次函数方式进行差值'
plot(xx,yy,'-r')
legend("平滑前","平滑后",Location= "northwest")
hold off

%% 使用mesh函数(绘制网格图)
x = -2:0.1:2;
y = -2:0.1:2;
[X,Y] = meshgrid(x,y);  % 生成网格数据，X，Y都是21*21的矩阵
Z = X.*exp(-X.^2 - Y.^2);
mesh(X,Y,Z)
%% 使用surf函数
x = -2:0.1:2;
y = -2:0.1:2;
[X,Y] = meshgrid(x,y);  % 生成二维网格数据，X，Y都是41*41的矩阵，（X(1),Y(1)）就是图中第一个点的坐标
Z = X.*exp(-X.^2 - Y.^2);
subplot(2,2,1)
surf(X,Y,Z)
colorbar
axis square
subplot(2,2,4)
mesh(X,Y,Z) % 边颜色因 Z 指定的高度而异。Z的值相当于指定了高度了，颜色随高度变化
colorbar
axis square
%% 
x = -9999999:10:9999999;
y = x.^3;
plot(x,y,LineWidth=2);
hold on 
xline(0,LineWidth=2);
yline(0,LineWidth=2);
axis square