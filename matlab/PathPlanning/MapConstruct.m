%% 用于构建随机的地图

mapSize = 102;

% 创建全为0的矩阵
map = zeros(mapSize);

% 设置边缘为1
map([1, end], :) = 1;
map(:, [1, end]) = 1;

% 生成30个随机大小的正方形和长方形
numObstacles = 30;

for i = 1:numObstacles
    if rand() > 0.5 % 随机选择正方形或长方形
        % 生成正方形
        sideLength = randi([3, 15]); % 随机边长
        obstacle = ones(sideLength);
    else
        % 生成长方形
        length1 = randi([3, 15]); % 随机长度1
        length2 = randi([3, 15]); % 随机长度2
        obstacle = ones(length1, length2);
    end
    
    % 随机放置障碍物
    rowPos = randi([1, mapSize - size(obstacle, 1) + 1]);
    colPos = randi([1, mapSize - size(obstacle, 2) + 1]);
    map(rowPos:rowPos+size(obstacle, 1)-1, colPos:colPos+size(obstacle, 2)-1) = obstacle;
end

% 显示地图
figure;
imshow(map, 'InitialMagnification', 'fit', 'Colormap', [1 1 1; 0 0 0]);

title('Occupancy Grid Map');
xlabel('X-axis');
ylabel('Y-axis');