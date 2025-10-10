%% 分段插值（分段线性插值、分段抛物线插值、分段低次插值）
% 可以避免龙格现象
% 适用于点数非常密的时候

%% 龙格现象
function longge()
    x = -5:0.01:5;
    y = 1./(1+x.^2);
    x0 = -5:5:5;
    y0 = 1./(1+x0.^2);
    xx0 = -5:0.01:5;
    yy0 = lagrange(x0,y0,xx0);
    x1 = -5:2.5:5;
    y1 = 1./(1+x1.^2);
    xx1 = -5:0.01:5;
    yy1 = lagrange(x1,y1,xx1);
    x2 = -5:1.25:5;
    y2 = 1./(1+x2.^2);
    xx2 = -5:0.01:5;
    yy2 = lagrange(x2,y2,xx2);
    x3 = -5:1:5;
    y3 = 1./(1+x3.^2);
    xx3 = -5:0.01:5;
    yy3 = lagrange(x3,y3,xx3);
    plot(x,y,'k-',x0,y0,'g-',xx0,yy0,'r-',xx1,yy1,'k-',xx2,yy2,'r*',xx3,yy3,'b-');
    
end

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