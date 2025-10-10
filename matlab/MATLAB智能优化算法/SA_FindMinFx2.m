clear
close all
clc

T1 = cputime;
xmax = 5;
xmin = -5;
ymax = 5;
ymin = -5;
L = 20;     % 马尔科夫链长度
dt = 0.98;  % 降温系数
S = 0.02;   % 步长因子
T = 200;    % 初始温度
TZ = 1e-8;  % 容差
Tmin = 0.01;% 最低温度
P = 0;      % Metropolis接受准则中接受的点的个数
PreX = rand*(xmax - xmin) + xmin;   % （设置初始x的位置）上一个搜索的x值
PreY = rand*(ymax - ymin) + ymin;   % （设置初始y的位置）上一个搜索的y值
PreBestX = PreX;    % 上一个最优秀的x值
PreBestY = PreY;    % 上一个最优秀的y值
PreX = rand*(xmax - xmin) + xmin;   % 上一个搜索的x值
PreY = rand*(ymax - ymin) + ymin;   % 上一个搜索的y值
BestX = PreX;       % 最优秀的X值
BestY = PreY;       % 最优秀的y值
trace = [];         % 用于记录历代最优解的函数值
deta = abs(eval(BestX,BestY) - eval(PreBestX,PreBestY));    % 上一次最小值和这次最小值的差的绝对值
while (deta>TZ) && (T>0.01)
    % 在当前温度下迭代L次数
    for i = 1: L
        % 在当前点附件随机的选取下一点
        P = 0;
        while P==0
            NextX = PreX + S*(rand*(xmax-xmin) + xmin);
            NextY = PreY + S*(rand*(ymax-ymin) + ymin);
            if (NextX >= xmin && NextX <= xmax && NextY >= ymin && NextY <= ymax)
                P = 1;
            end
        end

        % 判断选取的这个(x,y)对应的函数值是否比上一个选出来的最优值更优秀
        if(eval(NextX,NextY)<eval(BestX,BestY))
            % 保留上一个最优解
            PreBestX = BestX;
            PreBestY = BestY;
            % 更新最优解
            BestX = NextX;
            BestY = NextY;
        end

        % Metropolis接受准测 接受过程
        if(eval(NextX,NextY) < eval(PreX,PreY))
            % 当前解更优秀，接受新解
            PreX = NextX;
            PreY = NextY;
            P = P +1;
        else
            % 当前解更差，概率接受更差的解
            P1 = exp((eval(PreX,PreY)-eval(NextX,NextY))/T); % 接受的概率
            if P1 > rand
                PreX = NextX;
                PreY = NextY;
                P = P + 1;
            end
        end
        trace = [trace eval(BestX,BestY)];
    end
    deta = abs(eval(BestX,BestY) - eval(PreBestX,PreBestY));
    % 本次退火过程结束，温度下降
    T = T * dt;
end
T2 = cputime;
timeConsume = T2 - T1;
%% 绘图适配值最优化曲线
figure(1)
disp("最小值点在：")
BestX
BestY
disp("最小值为：")
eval(BestX,BestY)
plot(trace,LineWidth=1.5,Color=[0.68 0.52 0.96])
xlabel("迭代次数")
ylabel("目标函数值")
title("适配值最优化曲线","时间消耗：" + timeConsume )
%% 做出函数图像
figure(2)
x = -5:0.01:5;
y = -5:0.01:5;
N = length(x);
for i = 1 : N
    for j = 1 : N
        z(i,j) = 5*cos(x(i)*y(j)) + x(i)*y(j) + y(j)^3;
    end
end
colormap('hsv')
mesh(x,y,z)
grid on
xlabel('x')
ylabel('y')
zlabel('f(x,y)')
hold on 
plot3(BestY,BestX,eval(BestX,BestY),'k^',MarkerSize=5,LineWidth=2)
% text(BestY,BestX,eval(BestX,BestY), '最小值点', 'FontSize', 10, 'HorizontalAlignment', 'left');
%% 评估函数（目标函数）
function result = eval(x,y)
    result = 5 * cos(x*y) + x*y + y^3;
end
 