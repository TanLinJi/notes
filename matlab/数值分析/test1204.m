%% 二维
clc
clear 

x = 0:2:24;
y = [12 9 9 10 18 24 28 27 25 20 18 15 13];
x1 = 0:0.005:24;
y1 = interp1(x,y,x1,"nearest");
y2 = interp1(x,y,x1,"spline");
plot(x,y,'ko');
hold on 
plot(x1,y1,'r-',LineWidth=2);
hold on 
plot(x1,y2,'g-',LineWidth=2);
legend('data',"nearest","spline")

%% 三维
clc
clear