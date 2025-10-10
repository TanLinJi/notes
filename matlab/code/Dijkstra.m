clear 
close all
clc
tic
%t = clock;
%% 地图信息
Graph_Easy;

%% 算法初始化
S = [1,0];
U(:,1) = 2:50;
U(1,2) = 3;
U(2:end,2) = inf; %初始时到另外节点都不可达，默认无穷大

%% 最优路径的初始化
path_opt = cell(50,2);
path_opt(1,:) = {1,1}; %初始时，只有1号节点，1->1

path_temp = cell(50,2);
path_temp(1,:) = {1,1};
path_temp(2,:) = {2,[1,2]};

%% 算法主体
while ~isempty(U)
    [dist_min,node_index] = min(U(:,2));
    node_min = U(node_index,1);
    S(end+1,:) = [node_min,dist_min];
    U(node_index,:) = [];
    path_opt(node_min,:) = path_temp(node_min,:);
    
    %% 找到当前最小距离节点的所有邻接点
    for i = 1:length(nodes{node_min,2})
        % 需要判断的节点
        node_temp = nodes{node_min,2}(i);
        % 找到集合U中node_temp的索引值
        i_index_temp = find(U(:,1) == node_temp);
        % 判断是否更新
        if ~isempty(i_index_temp)
            new_len = dist_min + nodes{node_min,3}(i);
            old_len = U(i_index_temp,2);
            if  new_len < old_len 
                U(i_index_temp,2) = new_len;
                %更新暂时最优路径
                path_temp{node_temp,1} = node_temp;
                path_temp{node_temp,2} = [path_opt{node_min,2},node_temp];
            end
        end
    end
end

len = S(find(S(:,1)==50),2);
fprintf('路径长度：%d\n',len);
fprintf('最优路径为：\n')
for i = 1:length(path_opt{50,2})-1
    fprintf("%d->",path_opt{50,2}(i));
end
fprintf('50\n');

%% 计时部分
toc
% time = etime(clock,t);
% 
% fid = fopen('timeConsume_Dijkstra.txt','a+');
% 
% fprintf(fid,'%.20f\n',time);
% fclose(fid);