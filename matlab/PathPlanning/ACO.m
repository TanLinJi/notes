function [time,distance,cMap,optPath] = ACO(map,ps,pe)
    %ACO 蚁群算法实现路径规划
    %   map:地图矩阵；ps:起点,如[0 1]；pe:终点，如[12,12]；
    T1 = cputime;
    %% 数据预处理部分
    [rows,cols] = size(map);
    [obsR,obsC] = find(map==1);     % 障碍物坐标（这是从左上到右下）
    nodeNum = rows*cols;            % 问题规模大小(节点个数)
    obsID = sub2ind([rows,cols],obsR,obsC);    % 将障碍物的坐标转换为线性索引
    psID = sub2ind([rows,cols],ps(2),ps(1));   % 起点坐标的线性索引
    peID = sub2ind([rows,cols],pe(2),pe(1));   % 终点坐标的线性索引
    if ismember(psID,obsID) || ismember(peID,obsID)...
            || psID>nodeNum || psID<1 ...
            || peID>nodeNum || peID<1
        % 如果起点坐标或者终点坐标在障碍物上，起点坐标或终点坐标超过边界索引，则直接返回
        time = 9999;
        distance = 9999;
        cMap = 9999;
        optPath = 9999;
        return;
    end
    field = ones(rows, cols);       % field是map的对应的颜色矩阵(01矩阵到颜色矩阵的映射) 可通行节点是1
    field(obsID) = 2;               % 标记障碍物 2(Cmap中第2行指定的颜色)
    field(psID) = 3;                % 标记起点为 3(Cmap中第3行指定的颜色)
    field(peID) = 4;                % 标记终点为 4
    cMap = field;                   % 传出颜色矩阵 

    %% 算法参数初始化
    minDist = inf;    % 存放的是最短路径长度
    minIter = 0;      % 最短路径对应的那次迭代
    minAnt = 0;       % 最短路径对应的那次迭代中的那只蚂蚁
    iterNum = 50;     % 迭代次数
    antNum = 60;      % 蚁群数量
    D = GetDist(map);       % D是各个点之间的距离矩阵(八领域距离---每一行最多只有8个有效数，为0的是不可访问的)
    path = cell(iterNum,antNum);    % 存放每一代的每一只蚂蚁的爬行路径
    dist = zeros(iterNum,antNum);   % 各代蚂蚁爬行距离
    tau = 2*ones(nodeNum);  % 初始化信息素矩阵
    alpha = 1.2;      % 信息素重要程度因子
    beta = 4;         % 启发式函数重要程度因子
    rho = 0.52;       % 信息素蒸发系数
    Q = 1;            % 信息增强系数（单只蚂蚁能够一次搜索中能够携带的信息素总量）

    % 构建启发式函数信息
    eta = zeros(nodeNum,1); % 表征蚂蚁从城市i转移到终点的期望程度（取为距离的倒数）
    for i = 1:nodeNum
        if i==peID || ismember(i,obsID)
            % 障碍物或者就是终点，距离设置为无穷大(99999),则无穷大分之一为0
            eta(i) = 0;
        else
            [x,y] = ind2sub([rows,cols],i);
            eta(i) = 1/sqrt((pe(1)-x)^2+(pe(2)-y)^2);
        end
    end


    % =============以上都是列为主序的=======
    %% 算法主体
    for k = 1:iterNum
        for m = 1:antNum
            %%  状态初始化
            nodeID = psID;      % 当前蚂蚁所在位置   
            tempPath = psID;    % 爬行路径(存放的是节点编号)
            tempDist = 0;       % 爬行距离(存放的是这只蚂蚁本次周游总共的距离)
            tabu = ones(nodeNum,1); % 禁忌表，标记下一步允许爬行的城市（1是允许，0是禁止）
            tabu(psID) = 0;     % 标记起点不允许再次访问
            ND = D;             % 准备更新距离矩阵

            %%  寻找可行点
            nw = ND(nodeID,:);  % 取出当前蚂蚁所在位置距所有城市的距离（八领域）
            nw1 = find(nw);     % nw1中是可访问城市的编号
            % 这个循环可以不要==========================================================
            for j = 1:length(nw1)
                % 如果在该城市在禁忌表中标记为0，则说明下一步不会再访问该城市，因此将nw对应城市也标记为0
                if tabu(nw1(j)) == 0
                    nw(nw1(j)) = 0;
                end
            end
            ky = find(nw);      % ky中是真正可以访问的城市的编号了
            kyn = length(ky);   % 可以访问的城市的个数

            %% 当蚂蚁达到终点(找到食物)或陷入死胡同时停止
            while nodeID~=peID && kyn>0

                % 轮盘赌法选择下一个访问的城市
                p = zeros(kyn,1);       % 各个可以访问城市的概率
                for i = 1:kyn
                    p(i) = (tau(nodeID,ky(i))^alpha)*(eta(ky(i))^beta); 
                end
                p = p./(sum(p));
                pcum = cumsum(p);       % 累计和 （注意和原来代码的区别）
                st = find(pcum>=rand); 
                if isempty(st)
                    break;
                end
                nextNodeID = ky(st(1)); % 下一个访问的城市编号

                % 更新当前状态
                tempPath = [tempPath nextNodeID];
                tempDist = tempDist + ND(nodeID,nextNodeID);
                nodeID = nextNodeID;    % 更新节点编号
                for t = 1:nodeNum
                    if tabu(t) == 0
                        % 根据当前节点更新距离矩阵
                        ND(nodeID,t) = 0;
                        ND(t,nodeID) = 0;
                    end
                end
                
                % 删除已访问节点
                tabu(nodeID) = 0;   % 在禁忌表中标记未0，就不可再访问了
                nw = ND(nodeID,:);  
                nw1 = find(nw);     % nw1中是可访问城市的编号
                for j = 1:length(nw1)
                    if tabu(nw1(j)) == 0
                        nw(nw1(j)) = 0;
                    end
                end
                ky = find(nw);      % ky中是真正可以访问的城市的编号了
                kyn = length(ky);   % 可以访问的城市的个数
            end

            % 更新搜索路径和搜索长度
            path{k,m} = tempPath;
            if tempPath(end) == peID
                % 找到终点，判断是不是最短路径
                dist(k,m) = tempDist;
                if tempDist < minDist
                    minDist = tempDist;
                    minAnt = m;
                    minIter = k;
                end
            else
                % 没有找到，就标记距离为0
                dist(k,m) = inf;
            end

            % 更新信息素
            deltaTau = zeros(nodeNum);
            for r = 1:antNum
                if dist(k,r) 
                    route = path{k,r};
                    totalNode = length(route)-1;    % 总共周游的节点个数
                    totalDist = dist(k,r);          % 周游的总距离
                    for s = 1:totalNode
                        x = route(s);
                        y = route(s+1);
                        deltaTau(x,y) = deltaTau(x,y) + Q/totalDist;
                        deltaTau(y,x) = deltaTau(y,x) + Q/totalDist;
                    end
                end
            end
            tau = (1-rho)*tau + deltaTau;
        end
    end


    %% 输出参数
    % optPath要求是列为主序的线性索引
    % distance = min(min(dist));  % 最短距离
    % minIndex = find(dist==distance);
    distance = dist(minIter,minAnt);
    optPath = path{minIter,minAnt};
    % optPath = path{minIndex(1)};
    [x,y] = ind2sub([rows,cols],optPath);
    optPath = sub2ind([rows,cols],y,x);
    T2 = cputime;
    time = T2-T1;
end

%% 为每个节点构建八领域的距离矩阵
function D = GetDist(map)
    [rows,cols] = size(map);
    D = zeros(rows*cols,rows*cols); %% 0表示不可达
    for i = 1:rows
        for j = 1:cols
            if map(i,j) == 0
                pos = [-1 1; 0 1; 1 1; -1 0; 1 0; -1 -1; 0 -1; 1 -1];
                for m = 1:8
                    if i+pos(m,1)<1 || j+pos(m,2)<1 || i+pos(m,1)>rows || j+pos(m,2)>cols
                        continue;
                    end
                    if map(i+pos(m,1),j+pos(m,2)) == 0
                        if pos(m,1)==0 || pos(m,2)==0
                            D((i-1)*rows+j,(i+pos(m,1)-1)*rows+j+pos(m,2)) = 1;
                        else
                            D((i-1)*rows+j,(i+pos(m,1)-1)*rows+j+pos(m,2)) = sqrt(2);
                        end
                    end
                end
            end
        end
    end
end
