clear
close all
clc

T1 = cputime;
%% 初始化参数
NP = 100;    % 种群数量（染色体数目，一个染色体就相当于是一个个体）
L = 20;     % 二进制位串长度
Pc = 0.8;   % 交叉概率
Pm = 0.05;  % 变异概率
G = 500;    % 最大遗传次数
Xs = 10;    % 搜索上限
Xx = 0;     % 搜索下限（这个是随自变量的取值范围确定的，我们已经知道了函数的取值范围）
f = randi([0,1],NP,L);  % 随机获得初始种群（种群里有NP个个体，每个个体的基因位数为L,用0,1模拟二进制）
trace = zeros(1,G); % 历代最优适应度
%% 遗传算法主体
for k = 1:G
    Fit = zeros(1,NP);  % 种群中每个个体的适应度
    x = zeros(1,NP);    % 存放二进制数对应的十进制数,我把它定义为虚表现型（注意这个并不是真正的解集，还需要做一个映射）

    %%% 将二进制解码为定义域内的十进制（让二进制和十进制一一对应起来）
    for i = 1:NP
        U = f(i,:); % （基因型）U存放的就是一个个体的基因(一串二进制位，这里是用01模拟的)
        m = 0;      % （伪表现型）这是U对应的十进制
        % m = bin2dec(char('0'+ U)); 可以用这句话直接实现进制的转换
        for j = 1:L
            m = U(j)*2^(j-1) + m;
        end
        % （实表现型）将十进制转换为对应的表现型（x）
        % 这段代码的实际含义是将通过随机0，1序列转换而来的十进制数，与定义域内的数一一对应起来，
        % 否则通过随机0，1序列转换而来的十进制数根本没有实际含义，无法和定义域里联系起来
        % 但是这个定义的法则是通过这个公式确定的，有什么具体其他规范吗？或者其他的定义法则
        x(i) = Xx + m*(Xs-Xx)/(2^L - 1);   % 将二进制对应的十进制数映射到定义域中（请记住这种映射的方法）
        Fit(i) = GetFit(x(i));  % 计算这个个体的适应度
    end
    maxFit = max(Fit);  % 找到最大的适应度值
    minFit = min(Fit);  % 找到最小的适应度值
    rr = find(Fit == max(Fit));  % 找到最大适应度值对应的个体编号
    % 最优个体的基因
    % 因为最大适应度值可能不止一个，可能有多个最大值，因此用rr(1)取第一个最大值对应的个体
    fBest = f(rr(1),:);   % 最优个体的基因型
    xBest = x(rr(1));     % 最优个体的实表现型
    Fit = (Fit-minFit)/(maxFit-minFit); % 将适应度做归一化处理(请记住这种归一化的方法)

    %%% 基于轮盘赌的复制操作
    sumFit = sum(Fit);
    fitValue = Fit./sumFit;         % 求每个个体的适应度值占总的适应度值的百分比
    fitvalue = cumsum(fitValue);    % 适应度值的累加和
    ms = sort(rand(NP,1));
    fiti = 1;   % 记录当前适应度的索引（在轮盘赌选择的过程中，fiti 用于追踪当前适应度的位置）
    newi = 1;   % 记录新个体的索引（轮盘赌选择的过程中，newi 用于确定新种群中的位置，即确定新个体的存放位置。）
    while newi <= NP
        if(ms(newi) < fitvalue(fiti))
            nf(newi,:) = f(fiti,:);
            newi = newi + 1;
        else
            fiti = fiti + 1;
        end
    end
    %%% 基于概率的交叉操作(不懂请画图理解)
    for i = 1:2:NP % i是奇数号染色体
        if rand < Pc
            q = randi([0,1],1,L); % 随机生成一个交换flag(为1的位置对应的基因型之间进行交换)
            for j = 1:L
                if q(j) == 1
                    % 交换等位基因
                    temp = nf(i+1,j);
                    nf(i+1,j) = nf(i,j);
                    nf(i,j) = temp;
                end
            end
        end
    end
    %%% 基于概率的变异操作
    i = 1;
    while i <= round(NP*Pm)
        h = randi([1,NP],1,1);   % 在种群中随机选一个染色体来变异
        for j = 1:round(L*Pm)
            g = randi([1,L],1,1);% 随机选取一个需要变异的基因数
            nf(h,g) = ~nf(h,g);  % 将染色体nf中第h个个体的第g个基因取反，就是变异了
        end
        i = i + 1;
    end
    f = nf; 
    f(1,:) = fBest;    % 保留最优个体在新种群中
    trace(k) = maxFit; % 历代最优适应度
end

T2 = cputime;
timeConsume = T2 -T1;
%% 适应度进化曲线
figure(Color=[1 1 1])
% subplot(2,1,1)
plot(trace,LineWidth=2,Color=[0.56 0 0.56]);
xlabel("迭代次数",FontName="黑体",FontWeight="bold",FontSize=15);
ylabel("目标函数值",FontName="黑体",FontWeight="bold",FontSize=15);
title("适应度进化曲线","CPU时间消耗: "+timeConsume + 's',FontName="黑体",FontWeight="bold",FontSize=12);

%% 做出原始图像
x = 0:0.01:10;
y = x + 10*sin(5*x) + 7*cos(4*x);
 figure(Color=[1 1 1])
% subplot(2,1,2)
plot(x,y,lineWidth=2);
ylim([min(y)-1,max(y)+1]);
xlabel("x",FontName="Times new Roman"...
    ,FontAngle="italic",FontWeight="bold",FontSize=15);
ylabel("f(x)",FontName="Times new Roman"...
    ,FontAngle="italic",FontWeight="bold",FontSize=15);
title("f(x)=x+10sin(5x)+7cos(4x)",FontName="Times new Roman"...
    ,FontAngle="italic",FontWeight="bold",FontSize=15);
hold on
z = abs(y - max(trace));
x = x(z == min(z));
plot(x(1),max(trace),'r*');

%% 适应度函数
function result = GetFit(x)
    % 这里选择的适应度函数就是目标函数（实际上适应度函数要求为一个非负的函数）
    result = x + 10*sin(5*x) + 7*cos(4*x);
end