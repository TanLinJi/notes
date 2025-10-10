clc;
clear;
close all;
%% ��ʱ��
tic
%% ����Ԥ������
Graph_Complex;
[rows,cols] = size(G);
pStart = [2,2]; % ���
pEnd = [99,98]; % �յ�
[x,y] = find(G==1);
obs = [x,y];    % �ϰ������꣨���Ǵ����ϵ����£�
field = ones(rows, cols); % field��һ��ȫ1����
obsR = obs(:,1);  % �����ϰ���ĺ�����
obsC = obs(:,2);  % �����ϰ����������
obsID = sub2ind([rows,cols],obsR,obsC);             % ���ϰ��������ת��Ϊ��������
startID = sub2ind([rows,cols],pStart(1),pStart(2)); % ����������������
goalID = sub2ind([rows,cols],pEnd(1),pEnd(2));      % �յ��������������
field(obsID) = 2; % field�������ϰ��ﶼ���Ϊ2
field(startID) = 3;         % ������Ϊ3
field(goalID) = 4;          % ����յ�Ϊ4

cmap = [
    1 1 1   % ��ɫ �յ�
    0 0 0   % ��ɫ �ϰ���
    1 0 0   % ��ɫ ���
    0 1 0   % ��ɫ �յ�
    ];
colormap(cmap);
image(1.5,1.5,field);

% ����դ������
grid on;
hold on;
set(gca,'xtick',1:cols+1,'ytick',1:rows+1,'xticklabel',[],'yticklabel',[]);
axis image;
%% Dijkstra�㷨����
U(:,1) = (1: rows*cols)';
U(:,2) = inf; 
S = [startID, 0];
U(startID,:) = [];

nextNodes = Dijkstra_NextNodes(rows, cols, startID, field);

% ����������
for i = 1:8
    next = nextNodes(i,1);
    if ~isinf(next)
        idx = find(U(:,1) == next);
        U(idx,2) = nextNodes(i,2);
    end
end

% path��һ�д�ŵ���������ڶ��д�Ÿ��ڵ㵽�ӽڵ�Ŀɴ�·��
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

    % �½ڵ㿪ʼ�����·��
    nextNodes = Dijkstra_NextNodes(rows, cols, pEnd, field);

    % �����ӽڵ����
    for i = 1:8
        next = nextNodes(i,1);
        if ~isinf(next)  && ~ismember(next, S(:,1))
            idx_U = find(next == U(:,1));   
            cost = nextNodes(i,2); 
            if dist_min + cost < U(idx_U, 2)
                U(idx_U, 2) = dist_min + cost;
                path{next, 2} = [path{pEnd, 2}, next];  % ��������·��
            end
        end
    end
end

optPath = path{goalID,2};

%% ��������·��������ͼ
[plotr,plotc] = ind2sub([rows,cols],optPath);
plot(plotc+0.5,plotr+0.5,'LineWidth',2.5);
toc

%% ���ӽڵ�
function nextNodes = Dijkstra_NextNodes(rows,cols,nodeIndex,field)
    [row,col] = ind2sub([rows,cols],nodeIndex);    
    nextNodes = inf(8,2);    
    movePos = [-1,1;0,1;1,1;-1,0;1,0;-1,-1;0,-1;1,-1];  
    for i = 1:8
        % ���ڵ���Ч�ƶ���Χ
        if 0 < row+movePos(i,1) && row+movePos(i,1) <= rows && 0 < col+movePos(i,2) && col+movePos(i,2) <= cols
            subscript = [row+movePos(i,1),col+movePos(i,2)];
            index = sub2ind([rows,cols], subscript(1),subscript(2));
            nextNodes(i,1) = index;
            if field(subscript(1), subscript(2)) ~= 2
                cost = norm(subscript - [row,col]);       
                nextNodes(i,2) = cost;                      % ������Ϣ��
            end
        end
    end
end