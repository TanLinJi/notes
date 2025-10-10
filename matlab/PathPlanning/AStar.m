function [time,dist,cMap,optPath] = AStar(map,ps,pe)
    %ASTAR A*�㷨ʵ��·���滮
    %   map:��ͼ����ps:���,��[0 1]��pe:�յ㣬��[12,12]��
    T1 = cputime;
    %% ����Ԥ������
    [rows,cols] = size(map);
    [obsR,obsC] = find(map==1);     % �ϰ������꣨���Ǵ����ϵ����£�
    obsID = sub2ind([rows,cols],obsR,obsC);     % ���ϰ��������ת��Ϊ��������
    psID = sub2ind([rows,cols],ps(1),ps(2));    % ����������������
    peID = sub2ind([rows,cols],pe(1),pe(2));    % �յ��������������
    field = ones(rows, cols);       % field��map�Ķ�Ӧ����ɫ����(01������ɫ�����ӳ��)
    field(obsID) = 2;               % ����ϰ���Ϊ2(Cmap�е�2��ָ������ɫ)
    field(psID) = 3;                % ������Ϊ 3(Cmap�е�3��ָ������ɫ)
    field(peID) = 4;                % ����յ�Ϊ 4
    cMap = field;                   % ������ɫ����
    Fx = @(node,goalNode) norm(node - goalNode); % ����ʽ����

    % ����ڵ�ṹ 
    % pos:�ڵ�λ��  g:g(n)���� h:h(n)  f:f(n) parent:���ڵ�
    node = struct('pos',[],'g',[],'h',[],'f',[],'parent',[]);
    
    % �ڵ��б�
    openList = [];
    closeList = [];

    % ��ʼ�ڵ���Ϣ
    startNode = node;
    startNode.pos = ps;
    startNode.g = 0;
    startNode.h = Fx(startNode.pos,pe);
    startNode.f = startNode.g + startNode.h;
    startNode.parent = [];

    % Ŀ��ڵ���Ϣ
    goalNode = node;
    goalNode.pos = pe;
    goalNode.g = inf;
    goalNode.h = 0;
    goalNode.f = goalNode.g + goalNode.h;
    goalNode.parent = [];

    % open���ʼ��
    openList = [openList;startNode];

    % ���������·��
    path = [];
    
    % �㷨����ѭ��
    count = 0;      % ��¼��������
    while ~isempty(openList)
        % ѡ��fֵ(�ܴ���)��С�Ľڵ�Ϊ��һ�����ڵ�
        [~,idx] = min([openList.f]);
        nodeNow = openList(idx);    % ��ǰѡ�еĸ��ڵ�

        % ����Ѿ�����Ŀ��ڵ㣬���˳�ѭ��
        if isequal(nodeNow.pos,goalNode.pos)
            % ���λ��ˣ��õ�����·��
            while ~isempty(nodeNow.parent)
                path = [nodeNow.pos;path];
                nodeNow = nodeNow.parent;
            end
            path = [startNode.pos;path];
            break;
        end

        % �ѵ�ǰ�ڵ��open����ɾ�������뵽closed����
        openList(idx) = [];
        closeList = [closeList,nodeNow];

        % �������ھӽڵ�
        for i = -1:1
            for j = -1:1
                % �����Լ�
                if i==0 && j==0
                    continue;
                end
                % �����ڽӵ��λ��
                nextPos = nodeNow.pos + [i,j];
                % �����߽� ����
                if nextPos(1) < 1 || nextPos(1) > rows || nextPos(2) < 1 || nextPos(2) > cols
                    continue;
                end
                % �����ϰ��� ����
                if map(nextPos(1), nextPos(2)) == 1
                    continue;
                end
                % �Ѿ����ʹ� ����
                if any(arrayfun(@(node) isequal(node.pos, nextPos), closeList)) % ��ѧϰ����д�����ǳ�ţ��
                    continue;
                end
                % �����ڽӵ��gֵ
                nextG = nodeNow.g + norm([i,j]);
                % �ж��ڽӵ��Ƿ���open���У���δ���ʹ���
                nextNode = arrayfun(@(node) isequal(node.pos, nextPos), openList);  % �����NextNode���������������ϵ��ڽӵ㣬����һ����ʶ
                if any(nextNode)
                    % �����open����
                    nextNode = openList(nextNode); % ����������������ϵ��ڽӵ㣨struct�ṹ�ģ�
                    % ���ͨ���ڽӵ�ľ�����̣������·����
                    if nextG < nextNode.g
                        nextNode.g = nextG;
                        nextNode.f = nextNode.g + nextNode.h;
                        nextNode.parent = nodeNow;
                    end
                else
                    % �������open���У��ͼ��뵽open��
                    nextH = Fx(nextPos,pe);
                    nextNode = node;
                    nextNode.pos = nextPos;
                    nextNode.g = nextG;
                    nextNode.h = nextH;
                    nextNode.f = nextNode.g + nextNode.h;
                    nextNode.parent = nodeNow;
                    openList = [openList; nextNode];
                end
            end
        end
        count = count + 1;
    end
    %% �������
    
    optPath = sub2ind([rows,cols],path(:,1),path(:,2));
    dist = 0;
    for i = 2:length(path)
        dist = dist + norm([i,path(i,2)]-[i-1,path(i-1,2)]);
    end
    T2 = cputime;
    time = T2 - T1;
end
