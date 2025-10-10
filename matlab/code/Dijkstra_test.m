%% 对Dijkstra算法的修改
clc;
clear;
close all;

%% 初始算参数
Graph_Complex;
[rows,cols] = size(G);
ps = [2,2];   % 起点
pe = [99,98]; % 终点
[obsR,obsC] = find(G==1);
obs = [obsR,obsC];        % 障碍物坐标（这是从左上到右下）
obsID = sub2ind([rows,cols],obsR,obsC);    % 障碍物坐标的线性索引
psID = sub2ind([rows,cols],ps(1),ps(2));   % 起点坐标的线性索引
peID = sub2ind([rows,cols],pe(1),pe(2));   % 终点坐标的线性索引
field = ones(rows, cols); % field是一个全1矩阵
field(obsID) = 2;         % field中所有障碍物都标记为2
field(psID) = 3;          % 标记起点为3
field(peID) = 4;          % 标记终点为4
S = [psID, 0];            % S表，已找到最短路径的节点(最开始只包含起点)
U(:,1) = 1:rows*cols;     % U表，尚未找到最短路径节点
U(:,2) = inf; 
U(psID,:) = [];           % 将起点从U表中删除
nextNodes = GetNextNodes(rows, cols, psID, field);  % 当前节点的八个邻接点及距离信息
for i = 1:8
    % 根据八个邻接点初始化U集合
    next = nextNodes(i,1);
    if ~isinf(next)
        idx = find(U(:,1) == next);
        U(idx,2) = nextNodes(i,2);
    end
end

% 根据八个邻接点初始化路径表
for i = 1:rows*cols
    path{i,1} = i;
end
for i = 1:8
    next =  nextNodes(i,1);
    if ~isinf(nextNodes(i,2))
        path{next,2} = [psID,next];
    end
end
%% 算法主体
while ~isempty(U)
    % 找到U集合中离当前节点具有最短路径的点加入到S集合中并从U中删除
    [minDist, idx] = min(U(:,2));
    pe = U(idx, 1);  % 更新当前最短路径节点
    S(end+1,:) = [pe, minDist]; 
    U(idx,:) = [];   

    % 寻找当前节点的八个邻接点
    nextNodes = GetNextNodes(rows, cols, pe, field);

    % 更新路径表path
    for i = 1:8
        next = nextNodes(i,1);
        if ~isinf(next)  && ~ismember(next, S(:,1))
            % next中为inf的是超过边界的，不考虑
            % next中已经在S集合中的，不考虑
            idx_U = find(next == U(:,1));   
            cost = nextNodes(i,2); 
            if minDist + cost < U(idx_U, 2)
                U(idx_U, 2) = minDist + cost;
                path{next, 2} = [path{pe, 2}, next];  % 更新最优路径
            end
        end
    end
end

optPath = path{peID,2};
[bestx,besty] = ind2sub([rows,cols],optPath);
cor = [bestx' besty'];
dist = 0;
for i = 2:length(cor)
    dist = dist + norm([i,cor(i,2)]-[i-1,cor(i-1,2)]);
end
%% 绘制最优路径的折线图
cmap = [
    1 1 1   % 白色 空地
    0 0 0   % 黑色 障碍物
    1 0 0   % 红色 起点
    0 1 0   % 绿色 终点
    ];
colormap(cmap);
image(1.5,1.5,field);

% 设置栅格属性
grid on;
hold on;
set(gca,'xtick',1:cols+1,'ytick',1:rows+1,'xticklabel',[],'yticklabel',[]);
axis image;
[plotr,plotc] = ind2sub([rows,cols],optPath);
plot(plotc+0.5,plotr+0.5,'LineWidth',2.5);

%% 求子节点
function nextNodes = GetNextNodes(rows,cols,nodeID,field)
% 获取节点索引为NodeIndex在大小为rows*cols的颜色矩阵field中的邻接点
% nextNodes中存放邻接点索引和对应的代价
    [row,col] = ind2sub([rows,cols],nodeID);       % 将线性索引转换为下标
    nextNodes = inf(8,2);    
    pos = [-1,1;0,1;1,1;-1,0;1,0;-1,-1;0,-1;1,-1]; % 可以移动的八个位置
    for i = 1:8
        % 父节点有效移动范围
        % if 条件是边界判断，不超过边界才行
        if 0 < row+pos(i,1) && row+pos(i,1) <= rows && 0 < col+pos(i,2) && col+pos(i,2) <= cols
            nextPos = [row+pos(i,1),col+pos(i,2)];
            index = sub2ind([rows,cols], nextPos(1),nextPos(2));
            nextNodes(i,1) = index;
            if field(nextPos(1), nextPos(2)) ~= 2
                cost = norm(nextPos - [row,col]);  % 计算两个点之间的距离(1范数？)   
                nextNodes(i,2) = cost;  
            end
        end
    end
end