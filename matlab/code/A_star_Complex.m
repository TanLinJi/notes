clear,clc
tic
%% �����ͼ����
Graph_Easy;
Pstart = [2, 2];
Pend = [15, 15];
%% ��ʼ����
% ����ʽ����
Fx = @(pos) norm(pos - Pend);

% A*�㷨
[path, count] = AStarGrid(G, Pstart, Pend, Fx);
%% ��ͼ����
figure;
imagesc(G);
colormap(flipud(gray));
hold on;
for i = 1:size(path, 1)-1
    plot([path(i,2), path(i+1,2)], [path(i,1), path(i+1,1)], 'g', 'LineWidth', 2);
end
title('A*�㷨·������ͼ�����ӵ�ͼ��');
grid on;
for i = 1:size(G, 1)
    plot([0.5, size(G, 2)+0.5], [i-0.5, i-0.5], 'k', 'LineWidth', 1);
end
for j = 1:size(G, 2)
    plot([j-0.5, j-0.5], [0.5, size(G, 1)+0.5], 'k', 'LineWidth', 1);
end
hold off;

%% ����ƽ������·������
sLen = zeros(count, 1);
for i = 1:count
    [~, sLen(i)] = AStarGrid(G, Pstart, Pend, Fx);
end
meanSLen = mean(sLen);

%% ��ʱ������
toc
%% A*�㷨����
function [path, count] = AStarGrid(map, start, goal, Fx)
%% ��ʼ������
node.pos = [];
node.g = [];
node.h = [];
node.f = [];
node.parent = [];
[rows, cols] = size(map);

% �ڵ��б�
openList = [];
closedList = [];

% �����յ�ڵ�
pStart = node;
pStart.pos = start;
pStart.g = 0;
pStart.h = FX(start);
pStart.f = pStart.g + pStart.h;
pStart.parent = [];

Pend = node;
Pend.pos = goal;
Pend.g = Inf;
Pend.h = 0;
Pend.f = Inf;
Pend.parent = [];

% �������ڵ�
openList = [openList; pStart];

% A*�㷨��ѭ��
count = 0;
while ~isempty(openList)
    % ѡ��fֵ��С�Ľڵ�
    [~, idx] = min([openList.f]);
    currentNode = openList(idx);

    % �����յ�
    if isequal(currentNode.pos, Pend.pos)
        path = []; % ���·��
        while ~isempty(currentNode.parent)
            path = [currentNode.pos; path]; 
            currentNode = currentNode.parent;
        end
        path = [pStart.pos; path];
        return;
    end

    % ��open�����Ƴ���ǰ�ڵ�
    openList(idx) = [];

    % ����close��
    closedList = [closedList, currentNode];

    % �����ھӽڵ�
    for i = -1:1
        for j = -1:1
            % ������ǰ�ڵ�
            if i == 0 && j == 0
                continue;
            end
            % �����ھӽڵ��λ��
            neighborPos = currentNode.pos + [i, j];
            % ������Χ
            if neighborPos(1) < 1 || neighborPos(1) > rows || neighborPos(2) < 1 || neighborPos(2) > cols
                continue;
            end
            % �ϰ���
            if map(neighborPos(1), neighborPos(2)) == 1
                continue;
            end
            % �Ѿ���close����
            if any(arrayfun(@(node) isequal(node.pos, neighborPos), closedList))
                continue;
            end
            % �����ڽڵ��gֵ
            neighborG = currentNode.g + norm([i, j]);
            % �����ڽڵ��Ƿ��Ѿ���open�б���
            neighborNode = arrayfun(@(node) isequal(node.pos, neighborPos), openList);
            if any(neighborNode)
                neighborNode = openList(neighborNode);
                % ����·��
                if neighborG < neighborNode.g
                    neighborNode.g = neighborG;
                    neighborNode.f = neighborG + neighborNode.h;
                    neighborNode.parent = currentNode;
                end
            else
                % ����open��
                neighborH = Fx(neighborPos);
                neighborNode = node;
                neighborNode.pos = neighborPos;
                neighborNode.g = neighborG;
                neighborNode.h = neighborH;
                neighborNode.f = neighborG + neighborH;
                neighborNode.parent = currentNode;
                openList = [openList, neighborNode];
            end
        end
    end
    count = count + 1;
end

% ��������ͬ
path = [];
end
