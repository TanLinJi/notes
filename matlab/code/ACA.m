clc,clear

%% 初始化
Graph_Easy;
Pstart = 1;    % 起点  
Pend = 50;     % 终点 
%% 蚁群算法相关参数
m = 30;                     % 蚂蚁数量
n = size(nodes,1);          % 节点数量
alpha = 1;       
beta = 5;           
rho = 0.1;    
Q = 1;        % 常数
iter = 1;     % 迭代次数初值
iterMax = 200;        % 最大迭代次数 
rtBest = cell(iterMax,1);       % 各代最佳路径       
LenBest = zeros(iterMax,1);     % 各代最佳路径的长度  
LenAve = zeros(iterMax,1);      % 各代路径的平均长度

% nodes的第四列存放信息素，第五列存放挥发因子
deltaTau = nodes(:,1:2);
for i = 1:size(nodes,1)
    nodes{i,4} = ones(1, length(nodes{i,3}));  
    nodes{i,5} = 1./nodes{i,3};            
    deltaTau{i,3} = zeros(1, length(nodes{i,3}));
end

%% 算法主体
while iter <= iterMax  
    route = cell(0);
    %%  逐个蚂蚁路径选择
    for i = 1:m
        neibr = cell(0);
        node_step = Pstart;
        path = node_step;
        dist = 0;
        while ~ismember(Pend, path) 
            % 寻找邻接点         
            neibr = nodes{node_step,2};

            % 删除已经访问过的邻接点
            idx = [];
            for k = 1:length(neibr)
                if ismember(neibr(k), path)
                    idx(end+1) =  k;
                end
            end
            neibr(idx) = [];
            
            % 判断是否能继续前进
            if isempty(neibr)
                neibr = cell(0);
                node_step = Pstart;
                path = node_step;
                dist = 0;
                continue
            end 
            
            % 计算下一节点的访问概率
            P = neibr;
            for k=1:length(P)
                P(2,k) = nodes{node_step, 4}(k)^alpha * ...
                    nodes{node_step, 5}(k)^beta;
            end
            P(2,:) = P(2,:)/sum(P(2,:));
            
            % 轮盘赌法
            Pc = cumsum(P(2,:));
            Pc = [0, Pc];
            randnum = rand;
            for k = 1:length(Pc)-1
                if randnum > Pc(k) && randnum < Pc(k+1)
                    target_node = neibr(k);
                end
            end
            
            % 计算单步距离
            idx_temp = find(nodes{node_step, 2} == target_node);
            dist = dist + nodes{node_step, 3}(idx_temp);
            
            % 更新下一步的目标节点及路径集合            
            node_step = target_node;
            path(end+1) = node_step;         
                       
        end
        
        % 存放第i只蚂蚁数据
        Length(i,1) = dist;
        route{i,1} = path;
    end
    
    %% 当前蚂蚁中的最短距离
    if iter == 1
        [minLen,minID] = min(Length);
        LenBest(iter) = minLen;
        LenAve(iter) = mean(Length);
        rtBest{iter,1} = route{minID,1};
    else
        [minLen,minID] = min(Length);
        LenBest(iter) = min(LenBest(iter - 1),minLen);
        LenAve(iter) = mean(Length);
        if LenBest(iter) == minLen
            rtBest{iter,1} = route{minID,1};
        else
            rtBest{iter,1} = rtBest{iter-1,1};
        end
    end
    
    %% 更新信息素
    Delta_Tau = deltaTau;    
    for i = 1:m
        for j = 1:length(route{i,1})-1
            node_start_temp = route{i,1}(j);
            node_end_temp = route{i,1}(j+1);
            idx =  find(Delta_Tau{node_start_temp, 2} == node_end_temp);
            Delta_Tau{node_start_temp,3}(idx) = Delta_Tau{node_start_temp,3}(idx) + Q/Length(i);
        end
        
    end

    for i = 1:size(nodes, 1)
        nodes{i, 4} = (1-rho) * nodes{i, 4} + Delta_Tau{i, 3};
    end
    
    % 更新迭代次数
    iter = iter + 1;
end


%% 绘图部分
figure
plot(1:iterMax,LenBest,'b',1:iterMax,LenAve,'r')
legend('最短距离','平均距离')
xlabel('迭代次数')
ylabel('距离')
title('各代最短距离与平均距离(简单地图)')

% 最优路径
[dist_min, idx] = min(LenBest);
path_opt = rtBest{idx,1};
