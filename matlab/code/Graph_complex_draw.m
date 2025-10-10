clc;
clear;
close all;
%% 构建颜色MAP图
cmap = [1 1 1; ...       % 1-白色-空地
    0 0 0; ...           % 2-黑色-障碍
    1 0 0; ...
    1 1 0;...
    1 0 1;...
    0 1 0; ...
    0 1 1];
colormap(cmap);

%% 构建栅格地图场景
Graph_Complex;%导入地图数据
[rows,cols] = size(G);

% 定义栅格地图全域，并初始化空白区域
field = ones(rows,cols);

% 障碍物
obsNum = sum(sum(G));  % 障碍物个数
[x,y] = find(G==1);
obsIndex = sub2ind(size(G),x,y);
field(obsIndex) = 2;  % 静态障碍

% 定义起点和终点
startPos = 1;
goalPos = rows*cols;
field(startPos) = 4;  % 将起始点设置为4，黄色
field(goalPos) = 5;   % 将终点设置为5，品红色

%% 绘制栅格图
image(1.5,1.5,field);
grid on;
set(gca,'gridline','-','gridcolor','k','linewidth',2,'GridAlpha',0.5);
set(gca,'xtick',1:cols+1,'ytick',1:rows+1);
axis image; %设置等比坐标轴