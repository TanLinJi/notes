function [time,optDist,optPath,cMap] = test(map,ps,pe)
%%ACO 蚁群算法实现路径规划
% map:01矩阵地图； ps:起点坐标，eg:[0,0]；pe:终点坐标
% time: 调用此函数的cpu时间消耗；optDist:最短距离；optPath:最短路径；cMap:矩阵对应的颜色图
    T1 = cputime;
    %% 预备参数
    [rows,cols] = size(map);    % 地图尺寸
    nodeNum = rows * cols;      % 节点数量
    [obsR,obsC] = find(map==1); % 障碍物坐标
    obsID = sub2ind([rows,cols],obsR,obsC);     % 障碍物索引
    psID = sub2ind([rows,cols],ps(1),ps(2));    % 起点索引
    peID = sub2ind([rows,cols],pe(1),pe(2));    % 终点索引
    field = ones(rows,cols);    % 颜色矩阵标记，用于绘制地图，空地是1
    field(obsID) = 2;           % 标记障碍物为2   
    field(psID) = 3;            % 标记起点为3
    field(peID) = 4;            % 标记终点为4
    cMap = field;               % 传出参数
    if ismember(psID,obsID) || ismember(peID,obsID)...
            || psID>nodeNum || psID<1 ...
            || peID>nodeNum || peID<1
        % 起点终点的边界条件判断
        time = -999;
        optDist = -999;
        optPath = -999;
        return;
    end
    %% 算法初始化
    minDist = inf;      % 记录最短距离
    minIter = 0;        % 最短距离对应的那次迭代
    minAnt = 0;         % 最短距离对应的那只蚂蚁

    iterNum = 50;       % 迭代次数
    antNum = 50;        % 每次迭代派出的蚂蚁数量
    D = GetDist(map);   % 八邻域距离矩阵
    path = cell(iterNum,antNum);    % 记录每代每只蚂蚁的搜索路径
    dist = zeros(iterNum,antNum);   % 记录每代每只蚂蚁的路径长度
    tau = 2*ones(nodeNum);          % 初始化信息素矩阵
    aplha = 1.2;        % 信息素重要程度因子
    beta = 4;           % 启发式函数重要程度因子
    rho = 0.6;          % 信息素挥发因子
    Q = 2;              % 信息素增强系数
    eta = zeros(nodeNum,1);         % 各个节点启发式函数值（节点i到终点的距离的倒数），是表征从节点i转移到终点的期望值
    for i = 1:rows
        for j = 1:cols
            index = sub2ind([rows,cols],i,j);
            if ismember(index,obsID)
                % 如果该节点为障碍物，则期望值为0；
                continue;     
            end   
            eta(index) = 1/norm([i-pe(1),i-pe(1)],2);
        end
    end

    %% 算法主体搜索
    for i = 1:iterNum
        for j = 1:antNum
            
            % 状态初始化
            nowID = psID;      % 蚂蚁所处的节点设置为起点
            tempPath = nowID;  % 暂时存放这只蚂蚁的搜索路径
            tempDist = 0;      % 暂时存放这只蚂蚁的搜索长度,tempdist记录了搜索路径中，每相邻节点之间的距离
            tabu = ones(nodeNum,1);     % 禁忌表，标记下一步允许访问的城市（1允许，0禁止）
            tabu(nowID) = 0;   % 当前节点不允许再被访问
            ND = D;            % 准备更新距离矩阵

            % 寻找下一步节点
            neigborID = [               % 八个邻接点的编号(顺序不能改，和getDist函数的位置对应的)
                nowID - rows - 1;
                nowID - 1;
                nowID + rows - 1;
                nowID - rows;
                nowID + rows;
                nowID - rows + 1;
                nowID + 1;
                nowID + rows + 1;
                ];
            neigborDist = ND(nowID,:);  % 取出当前节点的八个领域节点的距离
            tabu(neigborID(neigborDist==inf)) = 0;  % 将八个领域节点中不可达的节点编号对应的禁忌表标记为0 
            nextID = neigborID(neigborDist~=inf);   % 下一步可以访问的节点编号
            nextNum = length(nextID);   % 下一步可以访问的节点个数
            if isempty(nextNum) 
                %% TODO
                % 每代的每只蚂蚁都在起点，这个应该是不可能的，除非起点在死胡同里边
            end

            % for k = 1:nextNum
            %     switch tempID(k)
            %         case 1
            %             nextID(k) = nodeID - rows - 1;
            %             break;
            %         case 2
            %             nextID(k) = nodeID - 1;
            %             break;
            %         case 3
            %             nextID(k) = nodeID + rows - 1;
            %             break;
            %         case 4
            %             nextID(k) = nodeID - rows;
            %             break;
            %         case 5
            %             nextID(k) = nodeID + rows;
            %             break;
            %         case 6
            %             nextID(k) = nodeID - rows + 1;
            %             break;
            %         case 7
            %             nextID(k) = nodeID + 1;
            %             break;                    
            %         case 8
            %             nextID(k) = nodeID + rows + 1;
            %             break;
            %     end
            % end
            
            % 当蚂蚁达到终点或者陷入死胡同时停止
            while nowID ~= peID && nextNum > 0
                
                % 轮盘赌法选择下一个访问的城市
                p = zeros(nextNum,1);   % 访问各个邻接点的概率
                for m = 1:nextNum
                    p(m) = (tau(nowID,nextID(m))^aplha) * (eta(nextID(m))^beta);
                end
                p = p/sum(p);       % 概率归一化
                p = cumsum(p);      % 概率累加和（概率分布函数）
                p(end) = 1;         % 防止最后一位因为除数导致累加的时候达不到1，而是0.9999这样的数
                newIndex = find(p>=rand);   
                newNodeID = nextID(newIndex(1)); % 下一步访问的节点编号
                

                % 更新当前状态 
                tempPath = [tempPath newNodeID];            % 更新路径
                tempDist = [tempDist neigborDist(neigborID == newNodeID)];   % 更新路径长度 =====
                nowID = newNodeID;  % 更新当前访问节点

                % 更新nextID、nextNum、nextDist和禁忌表
                neigborID = [                  % 八个邻接点的编号(顺序不能改，和getDist函数的位置对应的)
                    nowID - rows - 1;
                    nowID - 1;
                    nowID + rows - 1;
                    nowID - rows;
                    nowID + rows;
                    nowID - rows + 1;
                    nowID + 1;
                    nowID + rows + 1;
                ];
                neigborDist = ND(nowID,:);              % 取出当前节点的八个领域节点的距离
                nextID = neigborID(neigborDist~=inf);   % 下一步可以访问的节点编号
                nextNum = length(nextID);               % 下一步可以访问的节点个数
                tabu(neigborID(neigborDist==inf)) = 0;  % 将八个领域节点中不可达的节点编号对应的禁忌表标记为0
                tabu(nowID) = 0;    % 标记禁忌表中对应位置为0，也就是已经访问过
                for m = 1:nodeNum
                    if tabu(m) == 0
                        ND(m,:) = inf;
                    end
                end
            end

            % 更新本只蚂蚁的搜索信息
            path{i,j} = tempPath;
            dist(i,j) = tempDist(end);
            if tempPath(end) == peID && dist(i,j) < minDist
                minIter = i;
                minAnt = j;
                minDist = dist(i,j);
            end

            % 更新信息素
            deltaTau = zeros(nodeNum);
            tempDist = [tempDist(1) tempDist(2:end)-tempDist(1:(end-1))];   % 把tempPath恢复成两个节点间的距离，不再是累加和(tempPath中第一个元素是0)
            for n = 1:length(tempPath)-1
                deltaTau(tempPath(n),tempPath(n+1)) = Q*(tempDist(n+1)/dist(i,j));
            end
            tau = (1-rho)*tau + deltaTau;
        end
    end
    T2 = cputime;
    time = T2 - T1;
    optPath = path{minIter,minAnt};
    optDist = dist(minIter,minAnt);
end

function D = GetDist(map)
%% 根据每个节点构建其下一步可通行区域（八领域搜索）
    [rows,cols] = size(map);
    D = zeros(numel(map),8);
    nextPos = [
        -1,-1;   % 1 左上
        -1, 0;   % 2 上
        -1, 1;   % 3 右上
         0,-1;   % 4 左
         0, 1;   % 5 右
         1,-1;   % 6 左下
         1, 0;   % 7 下
         1, 1];  % 8 右下
    for i = 1:rows
        for j = 1:cols
            ind = sub2ind([rows,cols],i,j);
            if map(i,j) == 1
                % 如果该点是障碍物，则所有邻节点均不可达
                D(ind,:) = inf;
                continue;
            end
            for k = 1:8
                x = i + nextPos(k,1);
                y = j + nextPos(k,2);
                if x > rows || x < 1 ...
                    || y > cols || y<1 ...
                    || map(x,y) == 1
                    % 超过边界，该邻接点不可达
                    % 有一个邻接点是障碍物，则该邻接点不可达
                    D(ind,k) = inf;
                    continue;
                else
                    D(ind,k) = norm([x-i,y-j],2);
                end
            end
        end
    end
end
