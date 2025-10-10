%% 长短TW下测量的回波数据
x1 = 0.01:0.001:100;
y1  = log2(x1);
plot(x1,y1);
hold on
x2 = 1:0.001:1.99;
y2  = zeros(1,length(x2))*log2(10);
plot(x2,y2)

%%  三维网格绘制代码（成功）
% 创建一个新图形窗口
figure(Color=[1 1 1]);

% 定义整体魔方的大小
cubeSize = 10;

% 定义每个小立方体的大小和颜色
smallCubeSize = cubeSize / 10;
smallCubeColor = [1 1 1]; % 灰色

% 定义线的宽度
lineWidth = 2;

% 循环绘制小立方体
for x = 1:10
    for y = 1:10
        for z = 1:10
            % 计算每个小立方体的位置
            x_pos = x * smallCubeSize;
            y_pos = y * smallCubeSize;
            z_pos = z * smallCubeSize;
            
            % 使用patch函数创建小立方体
            vertices = [
                0, 0, 0;
                smallCubeSize, 0, 0;
                smallCubeSize, smallCubeSize, 0;
                0, smallCubeSize, 0;
                0, 0, smallCubeSize;
                smallCubeSize, 0, smallCubeSize;
                smallCubeSize, smallCubeSize, smallCubeSize;
                0, smallCubeSize, smallCubeSize
            ];
            
            % 偏移小立方体的位置
            vertices = vertices + [x_pos, y_pos, z_pos];

            faces = [
                1, 2, 3, 4;
                5, 6, 7, 8;
                1, 2, 6, 5;
                2, 3, 7, 6;
                3, 4, 8, 7;
                4, 1, 5, 8
            ];
            
            patch('Vertices', vertices, 'Faces', faces, 'FaceColor', smallCubeColor, 'EdgeColor', 'k', 'LineWidth', lineWidth);
        end
    end
end

% 隐藏坐标轴
axis off;

% 设置图形属性
view(3);

% 设置纵横比为等比例
daspect([1, 1, 1]);

% 设置图像分辨率属性
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'PaperSize', [8, 8]);

% 保存图像
print(gcf, 'cuboid.jpg', '-djpeg', '-r300'); % 设置图像分辨率

%% CPMG自旋回波串的原理图（成功）
mu = 0;

sigma1 = 0.99;
sigma2 = 0.92;
sigma3 = 0.859;
sigma4 = 0.79;
sigma5 = 0.72;

x1 = linspace(-5*sigma1, 5*sigma1, 1000);
x2 = linspace(-5*sigma2, 5*sigma2, 1000);
x3 = linspace(-5*sigma3, 5*sigma3, 1000);
x4 = linspace(-5*sigma4, 5*sigma4, 1000);
x5 = linspace(-4.5*sigma5, 4.55*sigma5, 1000);

v1 = normpdf(x1, mu, sigma1);
v2 = normpdf(x2, mu, sigma2);
v3 = normpdf(x3, mu, sigma3);
v4 = normpdf(x4, mu, sigma4);
v5 = normpdf(x5, mu, sigma5);

x1 = x1 + 32;
x2 = x2 + 24;
x3 = x3 + 16;
x4 = x4 + 8;
x5 = x5 + 1;


% v6 = [max(v1),max(v2),max(v3),max(v4),max(v5)];
% index1 = find(v1 == v6(1));
% index2 = find(v2 == v6(2));
% index3 = find(v3 == v6(3));
% index4 = find(v4 == v6(4));
% index5 = find(v5 == v6(5));
% x6 = [x1(index1(1)),x2(index2(1)),x3(index3(1)),x4(index4(1)),x5(index5(1))];

fx = @(x) -2.6083e-06.*x.^3 + 0.00018386.*x.^2 + -0.0081816.*x + 0.56159;  %% 根据x6,v6拟合出来的公式
x7 = [x5,x4,x3,x2,x1];
v7 = fx(x7);
figure('Color', [1 1 1]);

plot(x1, v1, 'LineWidth', 5, 'Color', [0 0.6 0.2], 'DisplayName', '\sigma = 0.99');
hold on
plot(x2, v2, 'LineWidth', 5, 'Color', [0 0.6 0.2], 'DisplayName', '\sigma = 0.92');
hold on
plot(x3, v3, 'LineWidth', 5, 'Color', [0 0.6 0.2], 'DisplayName', '\sigma = 0.85');
hold on
plot(x4, v4, 'LineWidth', 5, 'Color', [0 0.6 0.2], 'DisplayName', '\sigma = 0.79');
hold on
plot(x5, v5, 'LineWidth', 5, 'Color', [0 0.6 0.2], 'DisplayName', '\sigma = 0.72');
hold on
plot(x7,v7,'k-','LineWidth',5,'Color',[0.850 0.325 0.098])
hold on

axis off

%% 差谱法原理图（第一部分，已经完成）
%%% 第一个椭圆
h1 = 4;     % x方向中心
k1 = 0;     % y方向中心
a1 = 3;      % x方向半轴长度
b1 = 2;      % y方向半轴长度
theta = linspace(0,pi,100);     % 限制角度范围

% 根据角度计算椭圆上的点
x1 = h1 + a1 * cos(theta);
y1 = k1 + b1 * sin(theta);

% 绘制第一个椭圆
figure(Color=[1 1 1])
fill(x1, y1, [0 0.447 0.741]);  % 使用 fill 函数填充椭圆上半部分
hold on;
plot(x1, y1, 'k-', 'LineWidth', 2);  % 使用 plot 函数绘制椭圆边界线
hold on
xline(0,LineWidth=2);
% xline(0.5,LineWidth=2,Color=[0.824 0.71 0.106]);
% xline(3.5,LineWidth=2,Color=[0.824 0.71 0.106]);
% xline(6.5,LineWidth=2,Color=[0.824 0.71 0.106]);
% xline(9.5,LineWidth=2,Color=[0.824 0.71 0.106]);
yline(0,LineWidth=2);
axis equal;       % 保持坐标轴比例相等
ax = gca; % 获取当前坐标轴对象
ax.XAxis.TickLength = [0 0]; % 隐藏X轴刻度线
ax.YAxis.TickLength = [0 0]; % 隐藏Y轴刻度线
set(gca,'xtick',[]);
set(gca,'ytick',[]);
box off

%%% 第二个椭圆
h2 = 5.5;     % x方向中心
k2 = 0;     % y方向中心
a2 = 0.8;      % x方向半轴长度
b2 = 1.86;      % y方向半轴长度

% 根据角度计算椭圆上的点
x2 = h2 + a2 * cos(theta);
y2 = k2 + b2 * sin(theta);

fill(x2, y2, [0 0.6 0.2]);  % 使用 fill 函数填充椭圆上半部分
hold on;
plot(x2, y2, 'k-', 'LineWidth', 2);  % 使用 plot 函数绘制椭圆边界线


%%% 第三个椭圆
h3 = 8;     % x方向中心
k3 = 0;     % y方向中心
a3 = 0.6;    % x方向半轴长度
b3 = 3;      % y方向半轴长度

% 根据角度计算椭圆上的点
x3 = h3 + a3 * cos(theta);
y3 = k3 + b3 * sin(theta);

fill(x3, y3, [1 0.549 0]);  % 使用 fill 函数填充椭圆上半部分
hold on;
plot(x3, y3, 'k-', 'LineWidth', 2);  % 使用 plot 函数绘制椭圆边界线
xline(10,Color=[1 1 1])

%% 差谱法原理图（第二部分）
clear 
close all
clc
figure(Color=[1 1 1])
x1 = 1:0.1:5000;
y1 = log2(x1(1:20000));
y2 = ones(1,length(x1)-length(y1))*y1(end) - 0.0001;
y = [y1 y2];
plot(x1+30,y,lineWidth=2,Color=[0 0.447 0.741]);
hold on
z1 = log(x1)+1.9;
plot(x1+50,z1,LineWidth=2,Color=[0 0.600 0.200]);
hold on
p1 = log(x1)./log(2)-2.5;
plot(x1-40,p1,LineWidth=2,Color=[1 0.549 0.000]);
legend('1','2','3')

ax = gca; % 获取当前坐标轴对象
ax.TickDir = 'out'; % 刻度线朝外
ax.XAxis.TickLength = [0 0]; % 隐藏X轴刻度线
ax.YAxis.TickLength = [0 0]; % 隐藏Y轴刻度线
set(gca,'xtick',[]);
set(gca,'ytick',[]);
box off
xline(41,LineWidth=2)
yline(4,LineWidth=2)

%% 差谱法原理图
%%% 第一个椭圆
h1 = 4;     % x方向中心
k1 = 0;     % y方向中心
a1 = 3;      % x方向半轴长度
b1 = 2;      % y方向半轴长度
theta = linspace(0,pi,100);     % 限制角度范围

% 根据角度计算椭圆上的点
x1 = h1 + a1 * cos(theta);
y1 = k1 + b1 * sin(theta);

% 绘制第一个椭圆
figure(Color=[1 1 1])
fill(x1, y1, [0 0.447 0.741]);  % 使用 fill 函数填充椭圆上半部分
hold on;
plot(x1, y1, 'k-', 'LineWidth', 2);  % 使用 plot 函数绘制椭圆边界线
hold on
xline(0,LineWidth=2);
xline(0.5,LineWidth=2,Color=[0.824 0.71 0.106]);
xline(3.5,LineWidth=2,Color=[0.824 0.71 0.106]);
xline(6.5,LineWidth=2,Color=[0.824 0.71 0.106]);
xline(9.5,LineWidth=2,Color=[0.824 0.71 0.106]);
yline(0,LineWidth=2);
axis equal;       % 保持坐标轴比例相等
ax = gca; % 获取当前坐标轴对象
ax.XAxis.TickLength = [0 0]; % 隐藏X轴刻度线
ax.YAxis.TickLength = [0 0]; % 隐藏Y轴刻度线
set(gca,'xtick',[]);
set(gca,'ytick',[]);
box off

%%% 第二个椭圆
h2 = 5.5;     % x方向中心
k2 = 0;     % y方向中心
a2 = 0.8;      % x方向半轴长度
b2 = 3;      % y方向半轴长度

% 根据角度计算椭圆上的点
x2 = h2 + a2 * cos(theta);
y2 = k2 + b2 * sin(theta);

fill(x2, y2, [0 0.6 0.2]);  % 使用 fill 函数填充椭圆上半部分
hold on;
plot(x2, y2, 'k-', 'LineWidth', 2);  % 使用 plot 函数绘制椭圆边界线


%%% 第三个椭圆
h3 = 8;     % x方向中心
k3 = 0;     % y方向中心
a3 = 0.6;      % x方向半轴长度
b3 = 4;      % y方向半轴长度

% 根据角度计算椭圆上的点
x3 = h3 + a3 * cos(theta);
y3 = k3 + b3 * sin(theta);

fill(x3, y3, [1 0.549 0]);  % 使用 fill 函数填充椭圆上半部分
hold on;
plot(x3, y3, 'k-', 'LineWidth', 2);  % 使用 plot 函数绘制椭圆边界线


