function SNodes = child_nodes_cal(fNode, m, n, obs, closeList)
%% 搜索子节点的函数
SNodes = [];
field = [1,1; n,1; n,m; 1,m];

% 邻接点1
SNode = [fNode(1)-1, fNode(2)+1];
if inpolygon(SNode(1), SNode(2), field(:,1), field(:,2))
    if ~ismember(SNode, obs, 'rows')
        SNodes = [SNodes; SNode];
    end
end

% 邻接点2
SNode = [fNode(1), fNode(2)+1];
if inpolygon(SNode(1), SNode(2), field(:,1), field(:,2))
    if ~ismember(SNode, obs, 'rows')
        SNodes = [SNodes; SNode];
    end
end

% 邻接点3
SNode = [fNode(1)+1, fNode(2)+1];
if inpolygon(SNode(1), SNode(2), field(:,1), field(:,2))
    if ~ismember(SNode, obs, 'rows')
        SNodes = [SNodes; SNode];
    end
end

% 邻接点4
SNode = [fNode(1)-1, fNode(2)];
if inpolygon(SNode(1), SNode(2), field(:,1), field(:,2))
    if ~ismember(SNode, obs, 'rows')
        SNodes = [SNodes; SNode];
    end
end

% 邻接点5
SNode = [fNode(1)+1, fNode(2)];
if inpolygon(SNode(1), SNode(2), field(:,1), field(:,2))
    if ~ismember(SNode, obs, 'rows')
        SNodes = [SNodes; SNode];
    end
end

% 邻接点6
SNode = [fNode(1)-1, fNode(2)-1];
if inpolygon(SNode(1), SNode(2), field(:,1), field(:,2))
    if ~ismember(SNode, obs, 'rows')
        SNodes = [SNodes; SNode];
    end
end

% 邻接点7
SNode = [fNode(1), fNode(2)-1];
if inpolygon(SNode(1), SNode(2), field(:,1), field(:,2))
    if ~ismember(SNode, obs, 'rows')
        SNodes = [SNodes; SNode];
    end
end

% 邻接点8
SNode = [fNode(1)+1, fNode(2)-1];
if inpolygon(SNode(1), SNode(2), field(:,1), field(:,2))
    if ~ismember(SNode, obs, 'rows')
        SNodes = [SNodes; SNode];
    end
end

%% 去除存在于close表中的节点
delNo = [];
for i = 1:size(SNodes, 1)
    if ismember(SNodes(i,:), closeList , 'rows')
        delNo(end+1,:) = i;
    end
end
SNodes(delNo, :) = [];
