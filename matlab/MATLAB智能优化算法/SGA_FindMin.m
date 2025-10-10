%% 基于君主方案的遗传算法应用实例——求解函数的最小值
clear
close all
clc

T1 = cputime;

%% 相关参数定义
D = 10;     % 基因数目
NP = 100;   % 染色体数目(种群大小)
G = 1000;   % 最大遗传代数
Xs = 20;    % 搜索上限(实表现型)
Xx = -20;   % 搜索下限(实表现型)
f = rand(D,NP)*(Xs-Xx) + Xx;    % 随机初始化种群(矩阵中的每一列是一个染色体)
nf = zeros(D,NP);   % 子种群
Pc = 0.8;   % 交叉概率
Pm = 0.101; % 变异概率
FIT = zeros(1,NP);  % 种群中每个个体的适应度
trace = zeros(1,G); % 历代最优适应度值
%% 将种群按照适应度升序排序的顺序生成一个排序好的新种群
for np = 1:NP
    FIT(np) = GetFit(f(:,np));
end
[SortFit,index] = sort(FIT);
Sortf = f(:,index); % 这个就是按照适应度大小排好序的种群

%% 遗传算法主体
for gen = 1:G
    %%% 采用君主方案选择交叉操作
    Emper = Sortf(:,1);     % 君主染色体
    NoPoint = round(D*Pc);  % 每次交叉的等位基因的个数
    PoPoint = randi([1 D],NoPoint,NP/2);   % 每次交叉的等位基因的位置
    nf = Sortf;     % 更新子种群
    for i = 1:NP/2
        nf(:,2*i-1) = Emper;
        % nf(:,2*i) = Sortf(:,2*i); % 可以省去？
        for k = 1:NoPoint
            nf(PoPoint(k,i),2*i-1) = nf(PoPoint(k,i),2*i);
            nf(PoPoint(k,i),2*i) = Emper(PoPoint(k,i));
        end
    end

    %%%  变异操作
    for m = 1:NP
        for n = 1:D
            r = rand;
            if Pm > r
                nf(n,m) = rand*(Xs-Xx) + Xx;    % 因为没有编码，所以直接对表现型变异
            end
        end
    end

    %%% 子种群按照适应度升序排序
    for np = 1:NP
        NFIT(np) = GetFit(nf(:,np));
    end
    [NSortFit,Index] = sort(NFIT);
    NSortf = nf(:,Index);

    %%% 产生新种群
    f1 = [Sortf,NSortf];            % 将子代和父代合并
    FIT1 = [SortFit,NSortFit];      % 将子代和父代的适应度值合并
    [SortFIT1,Index] = sort(FIT1);  % 适应度升序排列
    Sortf1 = f1(:,Index);           % 按适应度排列个体
    SortFIT = SortFIT1(1:NP);       % 提取前NP个适应度值
    Sortf = Sortf1(:,1:NP);         % 提取前NP个个体(保证种群总数不变)
    trace(gen) = SortFIT(1);        % 历代最优适应度值
end
Bestf = Sortf(:,1)      % 最优个体
trace(end)              % 最优值
%% 绘图
T2 = cputime;
timeConsume = T2 - T1;
figure(Color=[1 1 1])
plot(trace,LineWidth=2)
xlabel('迭代次数')
ylabel('目标函数值')
title('适应度进化曲线')
hold on
yline(0,LineWidth=1.2,Color=[1 0 0])
%% 适应度函数
function result = GetFit(x)
    result = sum(x.^2);
end