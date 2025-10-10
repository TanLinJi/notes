clear
clc
T1 = cputime;
C = [
    % 各个城市坐标
    39.91, 116.39;   % 北京
    31.22, 121.48;   % 上海
    23.13, 113.27;   % 广州
    22.54, 114.06;   % 深圳
    30.67, 104.06;   % 成都
    34.27, 108.93;   % 西安
    31.98, 118.75;   % 南京
    39.92, 116.36;   % 天津
    28.71, 115.83;   % 南昌
    45.75, 126.63;   % 哈尔滨
    36.07, 120.38;   % 青岛
    38.04, 114.48;   % 石家庄
    29.59, 106.54;   % 重庆
    26.08, 119.30;   % 福州
    30.25, 120.16;   % 杭州
    28.19, 112.97;   % 长沙
    25.03, 102.73;   % 昆明
    35.68, 139.76;   % 东京
    37.56, 126.97;   % 首尔
    1.35, 103.82;    % 新加坡
    13.41, 103.86;   % 金边
    21.03, 105.85;   % 河内
    3.14, 101.69;    % 吉隆坡
    39.90, 32.85;    % 安卡拉
    37.97, 23.73;    % 雅典
    38.71, -9.14;    % 里斯本
    41.89, 12.50;    % 罗马
    52.52, 13.41;    % 柏林
    55.75, 37.62;    % 莫斯科
    48.86, 2.35;     % 巴黎
];

n = length(C);  % 获取城市的个数
T = 100 * n;    % 初始温度
L = 10;         % 马尔可夫链长度
K = 0.986;      % 降温系数

%%  构建城市坐标结构体
city = struct([]);
for i = 1:n
    city(i).x = C(i,1);     % 经度
    city(i).y = C(i,2);     % 纬度
end

%% 开始退火
% 统计迭代次数
count = 1;   
% 计算每次迭代后的总距离（第一次就是初始时，按照坐标的顺序计算的距离）
Dist(count) = GetDist(city,n); 
figure(1)
% 当温度无限趋于0度时停止迭代
while T > 0.01 
    % 每次降温 均进行多次迭代
    for i = 1:L
        % 计算原路线周游距离
        len1 = GetDist(city,n);
        % 产生随机扰动(随机交换两个城市的坐标)
        p1 = floor(1 + n * rand()); % rand函数产生一个0，1之间均匀分布的实数，包含0但不包含1
        p2 = floor(1 + n * rand()); % 因此这个表达式可以产生一个从1到n的随机数
        while (p1 == p2)
            p1 = floor(1 + n * rand()); 
            p2 = floor(1 + n * rand());
        end
        temp_city = city;
        % 交换第P1个城市和第P2个城市的坐标
        temp = temp_city(p1);
        temp_city(p1) = temp_city(p2);
        temp_city(p2) = temp;
        % 计算新路线的周游距离
        len2 = GetDist(temp_city,n);
        % 新、老路线的差值（相当于能量）
        delta = len2 - len1;
        if(delta<0)
            % 新路线的评估函数更小（记住，模拟退火算法相当于是一个求函数极小值的算法）
            city = temp_city;  % 更新原路线（变量里存放城市的顺序也就是访问城市的顺序）
        else
            % Metropolis接受准则（概率选择更差的解）
            if exp((len1-len2)/T) > rand()
                % 记住这个概率的公式，指数部分一定是要个负数，概率的值不可能超过1
                city = temp_city;
            end
        end
    end
    % 本次迭代结束，统计迭代次数加1
    count = count + 1; 
    % 将本次迭代的最优解放在len中
    Dist(count) = GetDist(city,n); 
    %% 本次退火结束，降温
    T = T * K;
    % 按照新的城市的顺序，把这些城市画出来
    for i = 1: n-1
        plot([city(i).x,city(i+1).x],[city(i).y,city(i+1).y],'o-',LineWidth=1.5,Color=[0.89 0.49 0.21]);
        hold on;
    end
    plot([city(n).x,city(1).x],[city(n).y,city(1).y],'o-',LineWidth=1.5,Color=[0.42 0.24 0.47]);
    title(['优化最短距离：', num2str(Dist(count))]);
    hold off
    pause(0.005); % 动态显示出每次的搜索结果
end
T2 = cputime;
figure(2)
plot(Dist,LineWidth=2,Color=[0.42 0.20 0.49])
xlabel("迭代次数")
ylabel("目标函数值")
title("适应度进化曲线","搜索时间："+(T2-T1)+" s")
%% 评估函数
function result = GetDist(city,n)
% 计算总的周游路径长度(评估函数)
% city是各个城市的坐标
    result = 0;
    for i = 1:n-1
        result = result + sqrt((city(i).x - city(i+1).x)^2 + (city(i).y - city(i+1).y)^2);
    end
    result = result + sqrt((city(n).x - city(1).x)^2 + (city(n).y - city(1).y)^2);
end