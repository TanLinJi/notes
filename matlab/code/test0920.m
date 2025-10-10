% 创建一个示例的二维栅格地图
gridMap = [
    0, 0, 1, 0, 0;
    0, 0, 0, 1, 0;
    0, 1, 0, 1, 0;
    0, 0, 0, 0, 0;
];

startNode = 1;  % 起始节点索引
endNode = 20;  % 目标节点索引

[distances, paths] = Dijkstra(gridMap, startNode);

fprintf('起始节点到目标节点的最短距离为：%d\n', distances(endNode));
fprintf('最短路径为：%s%d\n', sprintf('%d -> ', paths{endNode}), endNode);

% 在地图上绘制路径规划结果
drawPathOnMap(gridMap, paths{endNode});
function [distances, paths] = Dijkstra(gridMap, startNode)
    numNodes = size(gridMap, 1) * size(gridMap, 2);
    distances = Inf(1, numNodes);
    visited = false(1, numNodes);
    paths = cell(1, numNodes);

    distances(startNode) = 0;

    while any(~visited)
        % 寻找当前未访问节点中距离起始节点最近的节点
        [~, currentNode] = min(distances .* ~visited);
        visited(currentNode) = true;

        % 将节点索引转换为行列坐标
        [row, col] = ind2sub(size(gridMap), currentNode);

        % 获取当前节点的邻居节点
        neighbors = getNeighbors([row, col], size(gridMap));

        % 更新当前节点的邻居节点的距离和路径信息
        for i = 1:size(neighbors, 1)
            neighbor = neighbors(i, :);
            neighborIndex = sub2ind(size(gridMap), neighbor(1), neighbor(2));

            if gridMap(neighbor(1), neighbor(2)) == 0
                newDistance = distances(currentNode) + 1;
                if newDistance < distances(neighborIndex)
                    distances(neighborIndex) = newDistance;
                    paths{neighborIndex} = [paths{currentNode}, currentNode];
                end
            end
        end
    end
end

function neighbors = getNeighbors(point, gridSize)
    row = point(1);
    col = point(2);

    % 定义相对邻居坐标的偏移量
    offsets = [-1, 0; 1, 0; 0, -1; 0, 1];

    neighbors = repmat(point, 4, 1) + offsets;
    invalidIdx = neighbors(:, 1) < 1 | neighbors(:, 1) > gridSize(1) | ...
        neighbors(:, 2) < 1 | neighbors(:, 2) > gridSize(2);
    neighbors(invalidIdx, :) = [];
end

function drawPathOnMap(gridMap, path)
    figure;
    colormap([1, 1, 1; 0, 0, 0]);
    imagesc(gridMap);
    hold on;

    for i = 1:length(path)-1
        current = path(i);
        next = path(i+1);
        [currentRow, currentCol] = ind2sub(size(gridMap), current);
        [nextRow, nextCol] = ind2sub(size(gridMap), next);

        plot([currentCol, nextCol], [currentRow, nextRow], 'r', 'LineWidth', 2);
    end

    hold off;
    axis equal;
    title('Path Planning Result');
end
