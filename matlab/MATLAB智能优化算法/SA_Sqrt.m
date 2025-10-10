function result = SA_Sqrt(n)
    % 模拟退火算法
    % n是目标参数，求解根号n的近似值，
    T = 2000;    % 初试温度
    dT = 0.998;  % 退火系数
    eps = 1e-16; % 当温度降到这个值时就停止迭代
    x = 1;
    fx = target(x,n);
    while( T > eps )
        %% 退火过程
        dx = x + (randi(99999)*2 - 99999) * T;
        while dx<0
            dx = x + (randi(99999)*2 - 99999) * T;
        end
        dfx = target(dx,n);
        if dfx<fx
            x = dx;
            fx = dfx;
        elseif exp((fx-dfx)/T)*99999>randi(99999)
            x = dx;
            fx = dfx;
        end
       %% 降温
        T = T*dT;
    end
    result = x;
end

function fval = target(x,n)
    fval = abs(x^2 - n);
end


