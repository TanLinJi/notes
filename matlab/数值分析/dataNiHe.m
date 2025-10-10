data = [
2.8513   2.248056303
2.7765   3.262076849
2.683    4.323635032
2.5895   5.144133177
2.496    5.683774343
2.4025   6.319431333
2.309    6.516481349
2.2155   6.743834478
2.122    6.977369195
2.0285   7.057606114
1.935    6.977369195
1.8415   6.743834478
1.748    6.516481349
1.6545   6.319431333
1.561    5.683774343
1.4675   5.144133177
1.374    4.323635032
1.2805   3.262076849
1.187    2.248056303];
x = data(:,1);
y = data(:,2);
%% 一次拟合
dat = polyfit(x,y,1);
y1 = dat(1).*x + dat(2);
%% 二次拟合
dat2 = polyfit(x,y,2);
y2 = dat2(1).*x.*x + dat2(2).*x + dat2(3);
%% 三次拟合
dat3 = polyfit(x,y,3);
y3 = dat3(1).*(x.^3) + dat3(2).*(x.^2) + dat3(3).*x + dat3(4);
%% n次拟合
n = 10;
datn = polyfit(x,y,n);
yn = 0;
for i = 1:n+1
    yn1 = datn(i).*(x.^(n+1-i));
    yn = yn1 + yn;
end
%% 绘图
plot(x,y,'o',MarkerFaceColor='b',MarkerSize=7);
hold on
plot(x,y1,LineWidth=2,Color=[0 0.447 0.741]);
hold on
plot(x,y2,LineWidth=2,Color=[0 0.6 0.2]);
hold on
plot(x,y3,LineWidth=2,Color=[1 0.549 0]);
hold on 
plot(x,yn,'k-',LineWidth=2);
legend("密度线",'线性拟合','二次拟合','三次拟合','n次拟合');
dd = [x y];
save dd.txt dd -ascii