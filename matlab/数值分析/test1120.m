%% 拉格朗日差值(老师版本)
clear
clc

x = 0:2:24;
y = [12 9 9 10 18 24 28 27 25 20 18 15 13];

x1 = min(x):0.1:max(x);
y1 = lagrange(x,y,x1);
plot(x,y,'ko',x1,y1,'r-',lineWidth = 2)

function fx = lagrange(x0,y0,x)
    m = length(x);
    n = length(x0);
    for i = 1:m
        z = x(i);
        s = 0;
        for k = 1:n
            p = 1;
            for j = 1:n
                if j~=k
                    p = p * (z-x0(j))/(x0(k)-x0(j));
                end
            end
            s = p*y0(k)+s;
        end
        fx(i) = s;
    end
end


