%% 利用蚁群算法（ACO)求解函数的最小值
% f(x,y) = 20*(x^2 - y^2)^2 - (1-y)^2 - 3*(1+y)^2 + 0.3;

clear
clc
m = 20;     % 蚂蚁数量
G = 200;    % 最大迭代次数
rho = 0.8;  % 信息素蒸发程度
p0 = 0.2;   % 转移概率常数
xMax = 5;   % 搜索x的最大值
xMin = -5;  % 搜索x的最小值
yMax = 5;   % 搜索y的最大值
yMin = -5;  % 搜索y的最小值
X = zeros(m,2);     % m只蚂蚁的初始位置
tau = zeros(m,1);   % 每只蚂蚁的适应度值（函数值）
trace = zeros(G,1); % 每代蚂蚁的最优适应度
for i = 1:m
    X(i,1) = (xMin + (xMax - xMin)*rand);
    X(i,2) = (yMin + (yMax - yMin)*rand);
    tau(i) = GetTau(X(i,1),X(i,2));
end
step = 1;           % 局部搜索步长
P = zeros(G,m);     % 每代中各只蚂蚁的状态转移概率
for NC = 1:G
    lambda = 1/NC;  % ?
    [Tau_best,BestIndex] = min(tau);  % Tau_best：最小的函数值；BestIndex：最小的函数值对应的蚂蚁编号
    %% 计算状态转移概率（根据当前这代蚂蚁中最优的适应度值更新本代蚂蚁中的状态转移概率） 
    for i = 1:m
        P(NC,i) = (Tau_best-tau(i))/Tau_best;
    end
    %% 更新每只的位置
    for i = 1:m
        if P(NC,i) < p0
            % 局部搜索
            temp1 = X(i,1) + (2*rand-1)*step*lambda;
            temp2 = X(i,2) + (2*rand-1)*step*lambda;
        else
            % 全局搜索
            temp1 = X(i,1) + (xMax-xMin)*(rand-0.5);
            temp2 = X(i,2) + (xMax-xMin)*(rand-0.5);
        end
        %% 边界处理
        if temp1 < xMin
            temp1 = xMin;
        end
        if temp1 > xMax 
            temp1 = xMax;
        end
        if temp2 < yMin
            temp2 = yMin;
        end
        if temp2 < yMax
            temp2 = yMax;
        end
        %% 判断蚂蚁当前位置的状态是否更优
        if GetTau(temp1,temp2) < GetTau(X(i,1),X(i,2))
            X(i,1) = temp1;
            X(i,2) = temp2;
        end
    end
    %% 更新信息素
    for i = 1:m
        tau(i) = (1-rho)*tau(i) + GetTau(X(i,1),X(i,2));
    end
    [value,index] = min(tau);
    trace(NC) = GetTau(X(index,1),X(index,2));
end
[minValue,minIndex] = min(tau);
minX = min(minIndex,1);
minY = min(minIndex,2);
figure(color=[1 1 1])
plot(trace,LineWidth=2,Color=[1, 0.6, 0]);
title("适应度进化曲线")
xlabel('搜索次数')
ylabel("适应度值")

%% 绘图
figure(color=[1 1 1])
X = -5:0.1:5;
Y = -5:0.1:5;
N = length(X);
for i = 1:N
    for j = 1:N
        Z(i,j) = 20*(X(i)^2 - Y(j)^2)^2 - (1-Y(j))^2 - 3*(1+Y(j))^2 + 0.3;
    end
end
colormap parula
mesh(X,Y,Z)
xlabel("x");
ylabel("y");
hold on
scatter3(minX, minY, GetTau(minX,minY), 50, 'r', 'filled'); 
hold off;
%% 适应度函数
function fxy = GetTau(x,y)
    fxy = 20*(x^2 - y^2)^2 - (1-y)^2 - 3*(1+y)^2 + 0.3;
end
