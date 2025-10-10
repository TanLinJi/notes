clear 
close all
clc
tic
%t = clock;
%% ��ͼ��Ϣ
Graph_Easy;

%% �㷨��ʼ��
S = [1,0];
U(:,1) = 2:50;
U(1,2) = 3;
U(2:end,2) = inf; %��ʼʱ������ڵ㶼���ɴĬ�������

%% ����·���ĳ�ʼ��
path_opt = cell(50,2);
path_opt(1,:) = {1,1}; %��ʼʱ��ֻ��1�Žڵ㣬1->1

path_temp = cell(50,2);
path_temp(1,:) = {1,1};
path_temp(2,:) = {2,[1,2]};

%% �㷨����
while ~isempty(U)
    [dist_min,node_index] = min(U(:,2));
    node_min = U(node_index,1);
    S(end+1,:) = [node_min,dist_min];
    U(node_index,:) = [];
    path_opt(node_min,:) = path_temp(node_min,:);
    
    %% �ҵ���ǰ��С����ڵ�������ڽӵ�
    for i = 1:length(nodes{node_min,2})
        % ��Ҫ�жϵĽڵ�
        node_temp = nodes{node_min,2}(i);
        % �ҵ�����U��node_temp������ֵ
        i_index_temp = find(U(:,1) == node_temp);
        % �ж��Ƿ����
        if ~isempty(i_index_temp)
            new_len = dist_min + nodes{node_min,3}(i);
            old_len = U(i_index_temp,2);
            if  new_len < old_len 
                U(i_index_temp,2) = new_len;
                %������ʱ����·��
                path_temp{node_temp,1} = node_temp;
                path_temp{node_temp,2} = [path_opt{node_min,2},node_temp];
            end
        end
    end
end

len = S(find(S(:,1)==50),2);
fprintf('·�����ȣ�%d\n',len);
fprintf('����·��Ϊ��\n')
for i = 1:length(path_opt{50,2})-1
    fprintf("%d->",path_opt{50,2}(i));
end
fprintf('50\n');

%% ��ʱ����
toc
% time = etime(clock,t);
% 
% fid = fopen('timeConsume_Dijkstra.txt','a+');
% 
% fprintf(fid,'%.20f\n',time);
% fclose(fid);