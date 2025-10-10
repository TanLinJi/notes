clc,clear

%% ��ʼ��
Graph_Easy;
Pstart = 1;    % ���  
Pend = 50;     % �յ� 
%% ��Ⱥ�㷨��ز���
m = 30;                     % ��������
n = size(nodes,1);          % �ڵ�����
alpha = 1;       
beta = 5;           
rho = 0.1;    
Q = 1;        % ����
iter = 1;     % ����������ֵ
iterMax = 200;        % ���������� 
rtBest = cell(iterMax,1);       % �������·��       
LenBest = zeros(iterMax,1);     % �������·���ĳ���  
LenAve = zeros(iterMax,1);      % ����·����ƽ������

% nodes�ĵ����д����Ϣ�أ������д�Żӷ�����
deltaTau = nodes(:,1:2);
for i = 1:size(nodes,1)
    nodes{i,4} = ones(1, length(nodes{i,3}));  
    nodes{i,5} = 1./nodes{i,3};            
    deltaTau{i,3} = zeros(1, length(nodes{i,3}));
end

%% �㷨����
while iter <= iterMax  
    route = cell(0);
    %%  �������·��ѡ��
    for i = 1:m
        neibr = cell(0);
        node_step = Pstart;
        path = node_step;
        dist = 0;
        while ~ismember(Pend, path) 
            % Ѱ���ڽӵ�         
            neibr = nodes{node_step,2};

            % ɾ���Ѿ����ʹ����ڽӵ�
            idx = [];
            for k = 1:length(neibr)
                if ismember(neibr(k), path)
                    idx(end+1) =  k;
                end
            end
            neibr(idx) = [];
            
            % �ж��Ƿ��ܼ���ǰ��
            if isempty(neibr)
                neibr = cell(0);
                node_step = Pstart;
                path = node_step;
                dist = 0;
                continue
            end 
            
            % ������һ�ڵ�ķ��ʸ���
            P = neibr;
            for k=1:length(P)
                P(2,k) = nodes{node_step, 4}(k)^alpha * ...
                    nodes{node_step, 5}(k)^beta;
            end
            P(2,:) = P(2,:)/sum(P(2,:));
            
            % ���̶ķ�
            Pc = cumsum(P(2,:));
            Pc = [0, Pc];
            randnum = rand;
            for k = 1:length(Pc)-1
                if randnum > Pc(k) && randnum < Pc(k+1)
                    target_node = neibr(k);
                end
            end
            
            % ���㵥������
            idx_temp = find(nodes{node_step, 2} == target_node);
            dist = dist + nodes{node_step, 3}(idx_temp);
            
            % ������һ����Ŀ��ڵ㼰·������            
            node_step = target_node;
            path(end+1) = node_step;         
                       
        end
        
        % ��ŵ�iֻ��������
        Length(i,1) = dist;
        route{i,1} = path;
    end
    
    %% ��ǰ�����е���̾���
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
    
    %% ������Ϣ��
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
    
    % ���µ�������
    iter = iter + 1;
end


%% ��ͼ����
figure
plot(1:iterMax,LenBest,'b',1:iterMax,LenAve,'r')
legend('��̾���','ƽ������')
xlabel('��������')
ylabel('����')
title('������̾�����ƽ������(�򵥵�ͼ)')

% ����·��
[dist_min, idx] = min(LenBest);
path_opt = rtBest{idx,1};
