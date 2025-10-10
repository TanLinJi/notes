function [time,dist,cMap,optPath] = Dijksrta(map,ps,pe)
%DIJKSRTA Dijkstra实现路径规划
%   map:地图矩阵；ps:起点,如[0 1]；pe:终点，如[12,12]；
T1 = cputime;

%% 数据预处理部分
[rows,cols] = size(map);
[obsR,obsC] = find(map==1); % 障碍物坐标（这是从左上到右下）
obs  = [obsR,obsC];
obsID = sub2ind([rows,cols],obsR,obsC);     % 将障碍物的坐标转换为线性索引
psID = sub2ind([rows,cols],ps(1),ps(2));    % 起点坐标的线性索引
peID = sub2ind([rows,cols],pe(1),pe(2));    % 终点坐标的线性索引
field = ones(rows, cols);   % field是map的对应的颜色矩阵(01矩阵到颜色矩阵的映射)
field(obsID) = 2;           % 标记障碍物为2(Cmap中第2行指定的颜色)
field(psID) = 3;            % 标记起点为 3(Cmap中第3行指定的颜色)
field(peID) = 4;            % 标记终点为 4
cMap = field;               % 传出颜色矩阵
%% 参数初始化
path = cell(rows*cols,2);   % 路径表 （第一列存放点的索引，第二列存放父节点到对应索引的节点的可达路径）
S = [psID, 0];              % S:最短路径节点集合
U = zeros(rows*cols,2);     % U:未确定最短路径节点集合
U(:,1) = 1:rows*cols;   
U(:,2) = inf; 
U(psID,:) = [];             % 将起点从U集合中删除
nextNodes = GetNextNodes(rows, cols, psID, field);   % 邻接点信息

% 更新U集合
for i = 1:8
    next = nextNodes(i,1);  % 下一个位置索引
    if ~isinf(next)
        idx = find(U(:,1) == next); % U中的索引并不是和next索引是对应的，因为可能U中的元素是逐渐减少的
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

optPath = path{peID,2}; % optpath存放的是点的线性索引
[bestx,besty] = ind2sub([rows,cols],optPath);
cor = [bestx' besty'];
dist = 0;
for i = 2:length(cor)
    dist = dist + norm([i,cor(i,2)]-[i-1,cor(i-1,2)]);
end

T2 = cputime;
time = T2 - T1;
end

%% 八邻域搜索
function nextNodes = GetNextNodes(rows,cols,nodeIndex,field)
% 获取节点索引为NodeIndex在大小为rows*cols的颜色矩阵field中的邻接点
% nextNodes中存放邻接点索引和对应的代价
    [row,col] = ind2sub([rows,cols],nodeIndex);         % 将线性索引转换为下标    
    nextNodes = inf(8,2);      
    pos = [-1,1;0,1;1,1;-1,0;1,0;-1,-1;0,-1;1,-1];      % 可以移动的八个位置
    for i = 1:8
        % 父节点有效移动范围
        % if 条件是边界判断，不超过边界才行
        if 0 < row+pos(i,1) && row+pos(i,1) <= rows && 0 < col+pos(i,2) && col+pos(i,2) <= cols
            nextPos = [row+pos(i,1),col+pos(i,2)];
            index = sub2ind([rows,cols], nextPos(1),nextPos(2));
            nextNodes(i,1) = index;
            if field(nextPos(1), nextPos(2)) ~= 2
                cost = norm(nextPos - [row,col]);       % 计算两个点之间的距离(1范数？)       
                nextNodes(i,2) = cost;                  
            end
        end
    end
end
