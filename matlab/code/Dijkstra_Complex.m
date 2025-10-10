clc;
clear;
close all;
%% 计时器
tic
%% 数据预处理部分
Graph_Complex;
[rows,cols] = size(G);
pStart = [2,2]; % 起点
pEnd = [99,98]; % 终点
[x,y] = find(G==1);
obs = [x,y];    % 障碍物坐标（这是从左上到右下）
field = ones(rows, cols); % field是一个全1矩阵
obsR = obs(:,1);  % 所有障碍物的横坐标
obsC = obs(:,2);  % 所有障碍物的纵坐标
obsID = sub2ind([rows,cols],obsR,obsC);             % 将障碍物的坐标转换为线性索引
startID = sub2ind([rows,cols],pStart(1),pStart(2)); % 起点坐标的线性索引
goalID = sub2ind([rows,cols],pEnd(1),pEnd(2));      % 终点坐标的线性索引
field(obsID) = 2; % field中所有障碍物都标记为2
field(startID) = 3;         % 标记起点为3
field(goalID) = 4;          % 标记终点为4

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
%% Dijkstra算法主体
U(:,1) = (1: rows*cols)';
U(:,2) = inf; 
S = [startID, 0];
U(startID,:) = [];

nextNodes = Dijkstra_NextNodes(rows, cols, startID, field);

% 八邻域搜索
for i = 1:8
    next = nextNodes(i,1);
    if ~isinf(next)
        idx = find(U(:,1) == next);
        U(idx,2) = nextNodes(i,2);
    end
end

% path第一列存放点的索引，第二列存放父节点到子节点的可达路径
for i = 1:rows*cols
    path{i,1} = i;
end
for i = 1:8
    next =  nextNodes(i,1);
    if ~isinf(nextNodes(i,2))
        path{next,2} = [startID,next];
    end
end

while ~isempty(U)
    [dist_min, idx] = min(U(:,2));
    pEnd = U(idx, 1);  
    S(end+1,:) = [pEnd, dist_min]; 
    U(idx,:) = [];   

    % 新节点开始求最短路径
    nextNodes = Dijkstra_NextNodes(rows, cols, pEnd, field);

    % 更新子节点距离
    for i = 1:8
        next = nextNodes(i,1);
        if ~isinf(next)  && ~ismember(next, S(:,1))
            idx_U = find(next == U(:,1));   
            cost = nextNodes(i,2); 
            if dist_min + cost < U(idx_U, 2)
                U(idx_U, 2) = dist_min + cost;
                path{next, 2} = [path{pEnd, 2}, next];  % 更新最优路径
            end
        end
    end
end

optPath = path{goalID,2};

%% 绘制最优路径的折线图
[plotr,plotc] = ind2sub([rows,cols],optPath);
plot(plotc+0.5,plotr+0.5,'LineWidth',2.5);
toc

%% 求子节点
function nextNodes = Dijkstra_NextNodes(rows,cols,nodeIndex,field)
    [row,col] = ind2sub([rows,cols],nodeIndex);    
    nextNodes = inf(8,2);    
    movePos = [-1,1;0,1;1,1;-1,0;1,0;-1,-1;0,-1;1,-1];  
    for i = 1:8
        % 父节点有效移动范围
        if 0 < row+movePos(i,1) && row+movePos(i,1) <= rows && 0 < col+movePos(i,2) && col+movePos(i,2) <= cols
            subscript = [row+movePos(i,1),col+movePos(i,2)];
            index = sub2ind([rows,cols], subscript(1),subscript(2));
            nextNodes(i,1) = index;
            if field(subscript(1), subscript(2)) ~= 2
                cost = norm(subscript - [row,col]);       
                nextNodes(i,2) = cost;                      % 更新信息表
            end
        end
    end
end