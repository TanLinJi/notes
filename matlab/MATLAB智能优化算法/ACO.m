clear
close all
clc

m = 50;    % 蚂蚁数量
aplha = 1; % 信息素重要程度
beta = 5;  % 启发式函数重要程度
Rho = 0.1; % 信息素挥发因子
G = 200;   % 最大迭代次数
Q = 1200;  % x信息素增加强度系数
C = [      % 31个省会城市的经纬度
    116.4074, 39.9042;  % 北京
    121.4737, 31.2304;  % 上海
    113.2644, 23.1291;  % 广州
    113.9438, 35.3030;  % 郑州
    126.5349, 45.8038;  % 哈尔滨
    87.6168, 43.8256;   % 乌鲁木齐
    114.0661, 51.9259;  % 呼和浩特
    117.2010, 39.0842;  % 太原
    108.9480, 34.2632;  % 西安
    112.5655, 37.8610;  % 鄂尔多斯
    126.7030, 45.7590;  % 哈密
    103.8343, 36.0611;  % 兰州
    118.7674, 32.0415;  % 合肥
    114.4159, 43.4682;  % 沈阳
    114.5025, 38.0455;  % 石家庄
    117.1902, 39.1256;  % 天津
    120.1551, 30.2741;  % 杭州
    106.5507, 29.5647;  % 重庆
    114.2985, 30.5843;  % 武汉
    114.0661, 32.5815;  % 南昌
    118.7969, 32.0581;  % 南京
    121.5091, 25.0443;  % 台北
    117.1498, 36.6683;  % 济南
    104.0668, 30.5728;  % 成都
    112.9794, 28.2135;  % 长沙
    111.7088, 27.6150;  % 贵阳
    113.2644, 40.1290;  % 呼伦贝尔
    114.3564, 30.5811;  % 长江三峡
    109.6283, 18.2824;  % 海口
    125.3235, 43.8171;  % 吉林
    106.7339, 26.6894;  % 昆明
];
%% 第一步 蚁群算法相关变量初始化
n = size(C,1);   % n是城市的个数
D = zeros(n,n);  % D是城市间的距离矩阵(之前有一个更好的方法)
for i = 1:n 
    for j = 1:n
        if i~=j
            D(i,j) = sqrt((C(i,1) - C(j,1))^2 + (C(i,2) - C(j,2))^2);  % 两个点之间的范式距离
        else
            D(i,j) = eps;  %%  2.2204e-16，表示无穷小
        end
        D(j,i) = D(i,j);
    end
end
Eta = 1./D;           % eta为启发式因子，通常设置为距离的倒数
Tau = ones(n,n);      % tau为信息素矩阵
Tabu = zeros(m,n);    % 禁忌表，用于记录各代中m只蚂蚁的路径
NC = 1;               % 迭代计数器
R_best = zeros(G,n);  % 各代最佳路线
L_best = inf.*ones(G,1);% 各代最佳路线的长度
%% 开始迭代
figure(1);
while NC<=G
    %% 第二步 将m只蚂蚁随机的放到n个城市上
    Randpos = [];
    for i = 1:(ceil(m/n))
        Randpos = [Randpos,randperm(n)];
    end
    Tabu(:,1) = (Randpos(1,1:m))';
    %% 第三步 将m只蚂蚁都按概率的选择下一座城市进行访问，完成各自的周游
    for j = 2:n
        for i = 1:m
            visited  = Tabu(i,1:(j-1));     % 已访问的城市
            J = zeros(1,(n-j+1));           % 待访问的城市
            P = J;              % 待访问的城市的选择概率分布
            Jc = 1;
            for k=1:n
                if isempty(find(visited == k, 1))
                    J(Jc) = k;
                    Jc = Jc + 1;
                end
            end
            %%%%%  计算待选城市的概率  %%%%%
            for k = 1:length(J)
                P(k) = (Tau(visited(end),J(k))^aplha) * (Eta(visited(end),J(k))^beta);
            end
            P = P/sum(P);
            %%%%%  按概率选择访问的下一个城市   %%%%%%rqegqergqeggge
            Pcum = cumsum(P);
            Select = find(Pcum >= rand);
            to_visit = J(Select(1));
            Tabu(i,j) = to_visit;
        end
    end
    if NC >= 2
        Tabu(1,:) = R_best(NC-1,:);
    end
    %% 第四步  记录本次迭代的最佳路线
    L = zeros(m,1);
    for i = 1:m
        Rho = Tabu(i,:);
        for j = 1:(n-1)
            L(i) = L(i) + D(Rho(j),Rho(j+1));
        end
        L(i) = L(i) + D(Rho(1),Rho(n));
    end
    L_best(NC) = min(L);
    pos = find(L == L_best(NC));
    R_best(NC,:)  = Tabu(pos(1),:);
    %% 第五步  更新信息素
    Delta_Tau = zeros(n,n);
    for i = 1 : m
        for j = 1:(n-1)
            Delta_Tau(Tabu(i,j),Tabu(i,j+1)) = Delta_Tau(Tabu(i,j),Tabu(i,j+1))+Q/L(i);
        end
        Delta_Tau(Tabu(i,n),Tabu(i,1)) = Delta_Tau(Tabu(i,n),Tabu(i,1))+Q/L(i);
    end
    Tau = (1-Rho).*Tau + Delta_Tau;
    %% 第六步  禁忌表清零
    Tabu = zeros(m,n);
    %% 做出历代最优路线图
    for i=1:n-1
        plot([C(R_best(NC,i),1),C(R_best(NC,i+1),1)],[C(R_best(NC,i),2),C(R_best(NC,i+1),2)],'ro-');
        hold on;
    end
    plot([C(R_best(NC,n),1),C(R_best(NC,1),1)],[C(R_best(NC,n),2),C(R_best(NC,1),2)],'ro-');
    title(['优化最短距离i:',num2str(L_best(NC))]);
    hold off;
    pause(0.005);
    NC = NC + 1;
end
%% 第七步 输出结果
Pos = find(L_best == min(L_best));      %% 最佳路线
Shotest_Route = R_best(Pos(1),:);
Shotest_Length = L_best(Pos(1));
figure(2);
plot(L_best);
xlabel("迭代次数")
ylabel("目标函数值")
title('适应度曲线')
