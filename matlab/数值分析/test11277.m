%% 牛顿插值法（老师版本）
X = 0.2:0.2:1.4;     % X为已知数据点的横坐标
Y = [0.98 0.92 0.81 -0.36 0.38 0.45 0.99];    % y为已知数据点的纵坐标
% X = 0:2:24;
% Y = [12 9 9 10 18 24 28 27 25 20 18 15 13];
x = 0:0.01:1.5;    % x为插值点的x坐标
[A,y] = newtonzi(X,Y,x);


plot(X,Y,'g^',LineWidth=2)
hold on
plot(x,y,'r-',LineWidth=2)

function [A,y] = newtonzi(X,Y,x)
% A为差商表 y为各插值点的函数值
    n = length(X);
    m = length(x);
    for t = 1:m
        z = x(t);
        A = zeros(n);
        A(:,1) = Y';
        s = 0;
        % y = 0;
        % c1 = 1;
        for j = 2:n
            for i = j:n
                A(i,j) = (A(i,j-1)-A(i-1,j-1))/(X(i)-X(i-j+1));
            end
        end
        C = A(n,n);
        for k = 1:n
            p = 1;
            for j = 1: k-1
                p = p*(z-X(j));
            end
            s = s + A(k,k)*p;
        end
        ss(t) = s;
    end
    A = [X',A];
    y = ss;
end



