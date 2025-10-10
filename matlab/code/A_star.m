clc
clear
close all
%% 计时器
% t = clock;
%% 数据准备部分
Graph_Easy;  %nodes节点
[m,n] = size(G);
Pstrat = [1,1]; %起点
Pend = [m,n];  %终点
[x,y] = find(G==1);
obsLoc = [x y]; %障碍物坐标
%% 绘图部分
for i = 0:m
    plot([0,n],[i,i],'k');
    hold on
end

for j = 0:n
    plot([j,j],[0,m],'k');
end
% 坐标轴设置部分
axis equal
xlim([0,n]);
ylim([0,m]);

% 填充障碍物
[h,w] = size(obsLoc);
for i = 1:h
    temp = obsLoc(i,:);
    fill([temp(1)-1,temp(1),temp(1),temp(1)-1],...
        [temp(2)-1,temp(2)-1,temp(2),temp(2)],[0.6,0.6,0.6]);
end

%% 算法主体
% 初始化close表
closeList = Pstrat;
closeListPath = {Pstrat,Pstrat};
closeListCost = 0;
child_nodes = child_nodes_cal(Pstrat,m,n,obsLoc,closeList);

% 初始化open表
openList = child_nodes;
for i = 1:size(openList,1)
    openListPath{i,1} = openList(i,:);
    openListPath{i,2} = [Pstrat;openList(i,:)];
end
for i = 1:size(openList, 1)
    g = norm(Pstrat - openList(i,1:2));
    h = abs(Pend(1) - openList(i,1)) + abs(Pend(2) - openList(i,2));
    f = g + h;
    openListCost(i,:) = [g, h, f];
end

%% 开始搜索
% 在open表中搜索代价最小的节点
[~, min_idx] = min(openListCost(:,3))
parent_node = openList(min_idx,:);
flag = 1;
while flag
    child_nodes = child_nodes_cal(parent_node,  m, n, obsLoc, closeList);
    for i = 1:size(child_nodes,1)
        child_node = child_nodes(i,:);
        [in_flag,openList_idx] = ismember(child_node, openList, 'rows');
        g = openListCost(min_idx, 1) + norm(parent_node - child_node);
        h = abs(child_node(1) - Pend(1)) + abs(child_node(2) - Pend(2));
        f = g+h;

        if in_flag
            if g < openListCost(openList_idx,1)
                openListCost(openList_idx, 1) = g;
                openListCost(openList_idx, 3) = f;
                openListPath{openList_idx,2} = [openListPath{min_idx,2}; child_node];
            end
        else
            openList(end+1,:) = child_node;
            openListCost(end+1, :) = [g, h, f];
            openListPath{end+1, 1} = child_node;
            openListPath{end, 2} = [openListPath{min_idx,2}; child_node];
        end
    end

    % 从open表中移除移动代价最小的节点到close表
    closeList(end+1,: ) =  openList(min_idx,:);
    closeListCost(end+1,1) =   openListCost(min_idx,3);
    closeListPath(end+1,:) = openListPath(min_idx,:);
    openList(min_idx,:) = [];
    openListCost(min_idx,:) = [];
    openListPath(min_idx,:) = [];

    % 再次搜索
    [~, min_idx] = min(openListCost(:,3));
    parent_node = openList(min_idx,:);

    % 判断是否搜索到终点
    if parent_node == Pend
        closeList(end+1,: ) =  openList(min_idx,:);
        closeListCost(end+1,1) =   openListCost(min_idx,1);
        closeListPath(end+1,:) = openListPath(min_idx,:);
        flag = 0;
    end
end

% %% 计时
% time = etime(clock,t);
%
% fid = fopen('timeConsume_A_star.txt','a+');
%
% fprintf(fid,'%.20f\n',time);
% fclose(fid);

%% 画路径
path_opt = closeListPath{end,2};
path_opt(:,1) = path_opt(:,1)-0.5;
path_opt(:,2) = path_opt(:,2)-0.5;
plot(path_opt(:,1), path_opt(:,2), 'b');
title("A*算法路径搜索图（简单地图）")