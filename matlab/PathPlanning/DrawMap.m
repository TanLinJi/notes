function DrawMap(map)
% DrawMap(map) 根据[0 1]矩阵map绘制二维栅格地图
% 1是障碍物 0是可通行

[m,n] = size(map);

% 获取障碍物坐标
[x,y] = find(map==1);
obsLoc = [x y];
for i = 0:m
    plot([0,n],[i,i],'k');
    hold on
end

for j = 0:n
    plot([j,j],[0,m],'k');
end
% 坐标轴设置
axis equal
axis off;
xlim([0,n]);
ylim([0,m]);

% 填充障碍物
[h,~] = size(obsLoc);
for i = 1:h
    temp = obsLoc(i,:);
    fill([temp(1)-1,temp(1),temp(1),temp(1)-1],...
        [temp(2)-1,temp(2)-1,temp(2),temp(2)],[0.25,0.25,0.25]);
end
end