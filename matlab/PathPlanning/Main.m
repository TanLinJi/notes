clear
clc
clear
close all

%% 数据准备
Map;             % Map.mat 导入地图map
% PStart = [1,1];  % 起点坐标
PStart = [2,2];  % 起点坐标
% PDest = [99,98]; % 终点坐标
PDest = [47,49]; % 终点坐标map1
% PDest = [9,9]; % 终点坐标map
%% Dijkstra算法
% time:时间消耗; dist:搜索距离sda
[cpuTime,dist,cMap,optPath] = Dijksrta(map3,PStart,PDest);
title = "Dijkstra算法";
MapDraw(cMap,optPath,title,cpuTime,dist)

%% AStar算法
[cpuTime,dist,cMap,optPath] = AStar(map3,PStart,PDest);
title = "AStar算法";
MapDraw(cMap,optPath,title,cpuTime,dist)

%% 蚁群算法
[cpuTime,dist,cMap,optPath] = test(map1,PStart,PDest);
title = "ACO算法";
MapDraw(cMap,optPath,title,cpuTime,dist)

