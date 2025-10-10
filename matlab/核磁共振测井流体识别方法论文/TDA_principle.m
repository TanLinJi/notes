%% TDA时域分析法原理
clc
clear

%% 第一部分 回波串
tw8k = xlsread("TW8000.csv");
tw3k = xlsread("TW1500.csv");

echoTime = tw8k(:,1);
tw8k = tw8k(:,2);
tw3k = tw3k(:,2);
twDiff = tw8k-tw3k;
xlswrite("TWDiff.csv",[echoTime twDiff])
figure(Color=[1 1 1])
plot(echoTime,tw8k,Color=[0.000, 0.447, 0.741],LineWidth=2)
hold on
plot(echoTime,tw3k,Color=[0.000, 0.600, 0.200],LineWidth=2)
hold on
plot(echoTime,twDiff,Color=[1.000, 0.549, 0.000],LineWidth=2)
legend("长等待时间","短等待时间","回波串差")
box off
set(gca,'xtick',[]);
set(gca,'ytick',[]);

%% 第二部分 PPT手绘

%% 第三部分
%%% 第一个椭圆
h2 = 5.5;     % x方向中心
k2 = 0;     % y方向中心
a2 = 0.8;      % x方向半轴长度
b2 = 3;      % y方向半轴长度
theta = linspace(0,pi,100);     % 限制角度范围 
% 根据角度计算椭圆上的点
x2 = h2 + a2 * cos(theta);
y2 = k2 + b2 * sin(theta);

fill(x2, y2, [1 0.549 0]);  % 使用 fill 函数填充椭圆上半部分1 0.549 0
hold on;
plot(x2, y2, 'k-', 'LineWidth', 2);  % 使用 plot 函数绘制椭圆边界线

%%% 第三个椭圆
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
axis off