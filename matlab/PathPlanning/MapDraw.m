function MapDraw(field,optPath,name,cputime,dist)
%MAPDRAW MapDraw用于绘制地图和最优路径
%   field是颜色矩阵，optMath是最优路径(线性索引)
%   field中的数字就代表cmap中的函数，第一行就是白色
figure(Color=[1 1 1]) % 设置背景色为白色
[rows,cols] = size(field);
cmap = [
    1 1 1   % 1 白色 空地
    0 0 0   % 2 黑色 障碍物
    1 0 0   % 3 红色 起点
    0 1 0   % 4 绿色 终点
    ];
colormap(cmap); 
image(1.5,1.5,field);

% 设置栅格属性
grid on;
hold on;
set(gca,'xtick',1:cols+1,'ytick',1:rows+1,'xticklabel',[],'yticklabel',[]);
axis image;

[plotr,plotc] = ind2sub([rows,cols],optPath);
plot(plotc+0.5,plotr+0.5,'LineWidth',2.5);  
title(name)
xlabel("路径长度："+dist+"   ||  "+"CPU时间消耗："+cputime)
end

