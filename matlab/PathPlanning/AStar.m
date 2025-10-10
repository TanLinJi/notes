function [time,dist,cMap,optPath] = AStar(map,ps,pe)
    %ASTAR A*算法实现路径规划
    %   map:地图矩阵；ps:起点,如[0 1]；pe:终点，如[12,12]；
    T1 = cputime;
    %% 数据预处理部分
    [rows,cols] = size(map);
    [obsR,obsC] = find(map==1);     % 障碍物坐标（这是从左上到右下）
    obsID = sub2ind([rows,cols],obsR,obsC);     % 将障碍物的坐标转换为线性索引
    psID = sub2ind([rows,cols],ps(1),ps(2));    % 起点坐标的线性索引
    peID = sub2ind([rows,cols],pe(1),pe(2));    % 终点坐标的线性索引
    field = ones(rows, cols);       % field是map的对应的颜色矩阵(01矩阵到颜色矩阵的映射)
    field(obsID) = 2;               % 标记障碍物为2(Cmap中第2行指定的颜色)
    field(psID) = 3;                % 标记起点为 3(Cmap中第3行指定的颜色)
    field(peID) = 4;                % 标记终点为 4
    cMap = field;                   % 传出颜色矩阵
    Fx = @(node,goalNode) norm(node - goalNode); % 启发式函数

    % 定义节点结构 
    % pos:节点位置  g:g(n)代价 h:h(n)  f:f(n) parent:父节点
    node = struct('pos',[],'g',[],'h',[],'f',[],'parent',[]);
    
    % 节点列表
    openList = [];
    closeList = [];

    % 起始节点信息
    startNode = node;
    startNode.pos = ps;
    startNode.g = 0;
    startNode.h = Fx(startNode.pos,pe);
    startNode.f = startNode.g + startNode.h;
    startNode.parent = [];

    % 目标节点信息
    goalNode = node;
    goalNode.pos = pe;
    goalNode.g = inf;
    goalNode.h = 0;
    goalNode.f = goalNode.g + goalNode.h;
    goalNode.parent = [];

    % open表初始化
    openList = [openList;startNode];

    % 搜索的最短路径
    path = [];
    
    % 算法主体循环
    count = 0;      % 记录迭代次数
    while ~isempty(openList)
        % 选择f值(总代价)最小的节点为下一个父节点
        [~,idx] = min([openList.f]);
        nodeNow = openList(idx);    % 当前选中的父节点

        % 如果已经到达目标节点，则退出循环
        if isequal(nodeNow.pos,goalNode.pos)
            % 依次回退，得到搜索路径
            while ~isempty(nodeNow.parent)
                path = [nodeNow.pos;path];
                nodeNow = nodeNow.parent;
            end
            path = [startNode.pos;path];
            break;
        end

        % 把当前节点从open表中删除并加入到closed表中
        openList(idx) = [];
        closeList = [closeList,nodeNow];

        % 遍历其邻居节点
        for i = -1:1
            for j = -1:1
                % 跳过自己
                if i==0 && j==0
                    continue;
                end
                % 计算邻接点的位置
                nextPos = nodeNow.pos + [i,j];
                % 超出边界 跳过
                if nextPos(1) < 1 || nextPos(1) > rows || nextPos(2) < 1 || nextPos(2) > cols
                    continue;
                end
                % 碰见障碍物 跳过
                if map(nextPos(1), nextPos(2)) == 1
                    continue;
                end
                % 已经访问过 跳过
                if any(arrayfun(@(node) isequal(node.pos, nextPos), closeList)) % 请学习这种写法，非常牛犇
                    continue;
                end
                % 计算邻接点的g值
                nextG = nodeNow.g + norm([i,j]);
                % 判断邻接点是否在open表中（尚未访问过）
                nextNode = arrayfun(@(node) isequal(node.pos, nextPos), openList);  % 这里的NextNode并不是真正意义上的邻接点，而是一个标识
                if any(nextNode)
                    % 如果在open表中
                    nextNode = openList(nextNode); % 这里才是真正意义上的邻接点（struct结构的）
                    % 如果通过邻接点的距离更短，则更新路径表
                    if nextG < nextNode.g
                        nextNode.g = nextG;
                        nextNode.f = nextNode.g + nextNode.h;
                        nextNode.parent = nodeNow;
                    end
                else
                    % 如果不在open表中，就加入到open表
                    nextH = Fx(nextPos,pe);
                    nextNode = node;
                    nextNode.pos = nextPos;
                    nextNode.g = nextG;
                    nextNode.h = nextH;
                    nextNode.f = nextNode.g + nextNode.h;
                    nextNode.parent = nodeNow;
                    openList = [openList; nextNode];
                end
            end
        end
        count = count + 1;
    end
    %% 输出参数
    
    optPath = sub2ind([rows,cols],path(:,1),path(:,2));
    dist = 0;
    for i = 2:length(path)
        dist = dist + norm([i,path(i,2)]-[i-1,path(i-1,2)]);
    end
    T2 = cputime;
    time = T2 - T1;
end
