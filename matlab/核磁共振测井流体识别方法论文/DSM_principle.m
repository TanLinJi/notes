%% DSM差谱法原理
%% 第一个椭圆
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
% xline(0,LineWidth=2);
% xline(0.5,LineWidth=2,Color=[0.824 0.71 0.106]);
% xline(3.5,LineWidth=2,Color=[0.824 0.71 0.106]);
% xline(6.5,LineWidth=2,Color=[0.824 0.71 0.106]);
% xline(9.5,LineWidth=2,Color=[0.824 0.71 0.106]);
% yline(0,LineWidth=2);
axis equal;       % 保持坐标轴比例相等
ax = gca;         % 获取当前坐标轴对象
ax.XAxis.TickLength = [0 0]; % 隐藏X轴刻度线
ax.YAxis.TickLength = [0 0]; % 隐藏Y轴刻度线
set(gca,'xtick',[]);
set(gca,'ytick',[]);
box off

%% 第二个椭圆
h2 = 5.5;     % x方向中心
k2 = 0;     % y方向中心
a2 = 0.8;      % x方向半轴长度
b2 = 3;      % y方向半轴长度

% 根据角度计算椭圆上的点
x2 = h2 + a2 * cos(theta);
y2 = k2 + b2 * sin(theta);

fill(x2, y2, [1 0.549 0]);  % 使用 fill 函数填充椭圆上半部分1 0.549 0
hold on;
plot(x2, y2, 'k-', 'LineWidth', 2);  % 使用 plot 函数绘制椭圆边界线


%% 第三个椭圆
h3 = 8;     % x方向中心
k3 = 0;     % y方向中心
a3 = 0.6;    % x方向半轴长度
b3 = 4;      % y方向半轴长度

% 根据角度计算椭圆上的点
x3 = h3 + a3 * cos(theta);
y3 = k3 + b3 * sin(theta);

fill(x3, y3, [0 0.6 0.2]);  % 使用 fill 函数填充椭圆上半部分
hold on;
plot(x3, y3, 'k-', 'LineWidth', 2);  % 使用 plot 函数绘制椭圆边界线
xlim([2 9])
ylim([0 7])
axis equal;       % 保持坐标轴比例相等
ax = gca;         % 获取当前坐标轴对象
ax.XAxis.TickLength = [0 0]; % 隐藏X轴刻度线
ax.YAxis.TickLength = [0 0]; % 隐藏Y轴刻度线
set(gca,'xtick',[]);
set(gca,'ytick',[]);
box off