%% 牛顿插值法 （自己版本）
clc
clear

x = 0:2:24;
y = [12 9 9 10 18 24 28 27 25 20 18 15 13];
x1 = 0:0.1:24;
y1 = newtonInterpolation(x,y,x1);
plot(x,y,'k^',LineWidth=3,Color=[1 0.549 0])
hold on
plot(x1,y1,'r-',LineWidth=2,Color=[0 0.6 0.2])

function result = newtonInterpolation(x, y, x_input)
% x 原始节点横坐标
% y 原始节点纵坐标
% x_input 输入节点的横坐标
% result 输入节点的纵坐标 作为输出
    n = length(x);
    F = zeros(n, n);
    F(:, 1) = y';

    % 计算差商表
    for j = 2:n
        for i = 1:n-j+1
            F(i, j) = (F(i+1, j-1) - F(i, j-1))/(x(i+j-1)-x(i));
        end
    end

    result = F(1, 1);
    for j = 2:n
        term = F(1, j);
        for i = 1:j-1
            term = term .* (x_input - x(i));
        end
        result = result + term;
    end
end
