clear,clc
tic
%% 导入地图数据
Graph_Easy;
Pstart = [2, 2];
Pend = [15, 15];
%% 开始调用
% 启发式函数
Fx = @(pos) norm(pos - Pend);

% A*算法
[path, count] = AStarGrid(G, Pstart, Pend, Fx);
%% 作图部分
figure;
imagesc(G);
colormap(flipud(gray));
hold on;
for i = 1:size(path, 1)-1
    plot([path(i,2), path(i+1,2)], [path(i,1), path(i+1,1)], 'g', 'LineWidth', 2);
end
title('A*算法路径搜索图（复杂地图）');
grid on;
for i = 1:size(G, 1)
    plot([0.5, size(G, 2)+0.5], [i-0.5, i-0.5], 'k', 'LineWidth', 1);
end
for j = 1:size(G, 2)
    plot([j-0.5, j-0.5], [0.5, size(G, 1)+0.5], 'k', 'LineWidth', 1);
end
hold off;

%% 计算平均搜索路径长度
sLen = zeros(count, 1);
for i = 1:count
    [~, sLen(i)] = AStarGrid(G, Pstart, Pend, Fx);
end
meanSLen = mean(sLen);

%% 计时器结束
toc
%% A*算法主体
function [path, count] = AStarGrid(map, start, goal, Fx)
%% 初始化数据
node.pos = [];
node.g = [];
node.h = [];
node.f = [];
node.parent = [];
[rows, cols] = size(map);

% 节点列表
openList = [];
closedList = [];

% 起点和终点节点
pStart = node;
pStart.pos = start;
pStart.g = 0;
pStart.h = FX(start);
pStart.f = pStart.g + pStart.h;
pStart.parent = [];

Pend = node;
Pend.pos = goal;
Pend.g = Inf;
Pend.h = 0;
Pend.f = Inf;
Pend.parent = [];

% 加入起点节点
openList = [openList; pStart];

% A*算法主循环
count = 0;
while ~isempty(openList)
    % 选择f值最小的节点
    [~, idx] = min([openList.f]);
    currentNode = openList(idx);

    % 到达终点
    if isequal(currentNode.pos, Pend.pos)
        path = []; % 存放路径
        while ~isempty(currentNode.parent)
            path = [currentNode.pos; path]; 
            currentNode = currentNode.parent;
        end
        path = [pStart.pos; path];
        return;
    end

    % 从open表中移除当前节点
    openList(idx) = [];

    % 加入close表
    closedList = [closedList, currentNode];

    % 遍历邻居节点
    for i = -1:1
        for j = -1:1
            % 跳过当前节点
            if i == 0 && j == 0
                continue;
            end
            % 计算邻居节点的位置
            neighborPos = currentNode.pos + [i, j];
            % 超出范围
            if neighborPos(1) < 1 || neighborPos(1) > rows || neighborPos(2) < 1 || neighborPos(2) > cols
                continue;
            end
            % 障碍物
            if map(neighborPos(1), neighborPos(2)) == 1
                continue;
            end
            % 已经在close表中
            if any(arrayfun(@(node) isequal(node.pos, neighborPos), closedList))
                continue;
            end
            % 计算邻节点的g值
            neighborG = currentNode.g + norm([i, j]);
            % 查找邻节点是否已经在open列表中
            neighborNode = arrayfun(@(node) isequal(node.pos, neighborPos), openList);
            if any(neighborNode)
                neighborNode = openList(neighborNode);
                % 更新路径
                if neighborG < neighborNode.g
                    neighborNode.g = neighborG;
                    neighborNode.f = neighborG + neighborNode.h;
                    neighborNode.parent = currentNode;
                end
            else
                % 加入open表
                neighborH = Fx(neighborPos);
                neighborNode = node;
                neighborNode.pos = neighborPos;
                neighborNode.g = neighborG;
                neighborNode.h = neighborH;
                neighborNode.f = neighborG + neighborH;
                neighborNode.parent = currentNode;
                openList = [openList, neighborNode];
            end
        end
    end
    count = count + 1;
end

% 进入死胡同
path = [];
end
