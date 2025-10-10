function SNodes = child_nodes_cal(fNode, m, n, obs, closeList)
%% �����ӽڵ�ĺ���
SNodes = [];
field = [1,1; n,1; n,m; 1,m];

% �ڽӵ�1
SNode = [fNode(1)-1, fNode(2)+1];
if inpolygon(SNode(1), SNode(2), field(:,1), field(:,2))
    if ~ismember(SNode, obs, 'rows')
        SNodes = [SNodes; SNode];
    end
end

% �ڽӵ�2
SNode = [fNode(1), fNode(2)+1];
if inpolygon(SNode(1), SNode(2), field(:,1), field(:,2))
    if ~ismember(SNode, obs, 'rows')
        SNodes = [SNodes; SNode];
    end
end

% �ڽӵ�3
SNode = [fNode(1)+1, fNode(2)+1];
if inpolygon(SNode(1), SNode(2), field(:,1), field(:,2))
    if ~ismember(SNode, obs, 'rows')
        SNodes = [SNodes; SNode];
    end
end

% �ڽӵ�4
SNode = [fNode(1)-1, fNode(2)];
if inpolygon(SNode(1), SNode(2), field(:,1), field(:,2))
    if ~ismember(SNode, obs, 'rows')
        SNodes = [SNodes; SNode];
    end
end

% �ڽӵ�5
SNode = [fNode(1)+1, fNode(2)];
if inpolygon(SNode(1), SNode(2), field(:,1), field(:,2))
    if ~ismember(SNode, obs, 'rows')
        SNodes = [SNodes; SNode];
    end
end

% �ڽӵ�6
SNode = [fNode(1)-1, fNode(2)-1];
if inpolygon(SNode(1), SNode(2), field(:,1), field(:,2))
    if ~ismember(SNode, obs, 'rows')
        SNodes = [SNodes; SNode];
    end
end

% �ڽӵ�7
SNode = [fNode(1), fNode(2)-1];
if inpolygon(SNode(1), SNode(2), field(:,1), field(:,2))
    if ~ismember(SNode, obs, 'rows')
        SNodes = [SNodes; SNode];
    end
end

% �ڽӵ�8
SNode = [fNode(1)+1, fNode(2)-1];
if inpolygon(SNode(1), SNode(2), field(:,1), field(:,2))
    if ~ismember(SNode, obs, 'rows')
        SNodes = [SNodes; SNode];
    end
end

%% ȥ��������close���еĽڵ�
delNo = [];
for i = 1:size(SNodes, 1)
    if ismember(SNodes(i,:), closeList , 'rows')
        delNo(end+1,:) = i;
    end
end
SNodes(delNo, :) = [];
