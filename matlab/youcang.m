%%  生成数据点(图8)
rng(42); % 设置随机数种子，以保证结果可重复
total_points = 1000; % 总数据点数
percent_in_interval = 0.6; % [0, 2] 之间的百分比

% 生成 [0, 2] 之间的数据点
points_in_interval = round(total_points * percent_in_interval);
x_interval = rand(1, points_in_interval) * 2;

% 生成剩余的数据点
points_outside_interval = total_points - points_in_interval;
x_outside_interval = 2 + rand(1, points_outside_interval) * 1.8;

% 合并两部分数据点
x = [x_interval, x_outside_interval];

% 打乱数据点的顺序
x = x(randperm(total_points));
% y = x + 随机噪声
y = x + 0.1 * randn(1, total_points);

x1 = x(1:50);
y1 = y(1:50);
x2 = x(101:150);
y2 = y(101:150);
x3 = x(201:250);
y3 = y(201:250);

% 显示前 10 个数据点
figure(Color=[1 1 1]);
plot(x1,y1,'r*')
hold on
plot(x2,y2,'bo')
hold on
plot(x3,y3,'gp')
xlim([1 4]);
ylim([1 4]);
ax = gca; % 获取当前坐标轴对象
ax.TickDir = 'out'; % 刻度线朝外
ax.XAxis.TickLength = [0 0]; % 隐藏X轴刻度线
ax.YAxis.TickLength = [0 0]; % 隐藏Y轴刻度线

%% 图9(a)
x = 0:0.1:1;
y = 0:0.1:1;
x1 = [0.52 0.67 0.72];
y1 = [0.47 0.60 0.42];
x2 = [3 5 7];
y2 = [1.5 5.1 6.9];

figure(Color=[1 1 1],Position=[100, 100, 500, 430])

plot(x, y, Color=[0.8 0.6 0])
hold on

plot(x1, y1,'r*')
xlim([0.1 1]);
ylim([0.1 1]);
xticks([0.1 1]);
yticks([0.1 1]);
% 在每个点的下方添加文本
text(x1(1), y1(1)-0.05, '1-27', 'Color', 'blue', 'FontSize', 10, 'HorizontalAlignment', 'center');
text(x1(2), y1(2)-0.05, '2-21', 'Color', 'blue', 'FontSize', 10, 'HorizontalAlignment', 'center');
text(x1(3), y1(3)-0.05, '1-16', 'Color', 'blue', 'FontSize', 10, 'HorizontalAlignment', 'center');
ax = gca; % 获取当前坐标轴对象
ax.TickDir = 'out'; % 刻度线朝外
ax.XAxis.TickLength = [0 0]; % 隐藏X轴刻度线
ax.YAxis.TickLength = [0 0]; % 隐藏Y轴刻度线

%% 图9(b)
x = 1:0.1:10;
y = 1:0.1:10;
x1 = [3 5 7];
y1 = [1.5 5 6.9];

figure(Color=[1 1 1],Position=[100, 100, 500, 430])

plot(x, y, Color=[0.8 0.6 0])
hold on

plot(x1, y1,'r*')
xlim([1 10]);
ylim([1 10]);
xticks([1 10]);
yticks([1 10]);
% 在每个点的下方添加文本
text(x1(1), y1(1)-0.3, '1-16', 'Color', 'blue', 'FontSize', 10, 'HorizontalAlignment', 'center');
text(x1(2), y1(2)-0.3, '2-21', 'Color', 'blue', 'FontSize', 10, 'HorizontalAlignment', 'center');
text(x1(3), y1(3)-0.3, '1-27', 'Color', 'blue', 'FontSize', 10, 'HorizontalAlignment', 'center');
ax = gca; % 获取当前坐标轴对象
ax.TickDir = 'out'; % 刻度线朝外
ax.XAxis.TickLength = [0 0]; % 隐藏X轴刻度线
ax.YAxis.TickLength = [0 0]; % 隐藏Y轴刻度线
