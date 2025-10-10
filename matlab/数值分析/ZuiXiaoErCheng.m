clc
clear 
data = [
2.5429      9.876085         17.970403 
2.6929      11.023087        19.138746 
2.8429      11.860284        20.490715 
2.689       11.724286        21.502094 
2.539       10.676236        20.585508 
2.389       9.638451         19.233117 
2.218       9.352144         20.180587 
2.368       10.217659        21.210135 
2.518       11.279694        22.246466 
2.047       8.818177         20.480557 
2.197       9.862490         21.493779 
2.347       10.832047        22.631408 
1.876       8.410507         20.529499 
2.026       9.274176         21.806613 
2.176       10.215604        22.641293];

midu = data(:,1);
RIN = data(:,2);
RC = data(:,3);
beta0 = [0 0.5 2];
x = [RIN RC];
dat = nlinfit(x,midu,@fun1,beta0);
smd = dat(1).*log(RIN) - dat(2).*log(RC) + dat(3);
ero = midu - smd;
dat0 = [2.6656 1.9285 2.0357];
yanz = dat0(1).*log(RIN) - dat0(2).*log(RC) + dat0(3);
ero1 = yanz - midu;
plot(midu,midu,'kh-',midu,yanz,'ro');

legend('密度线','校正密度')
dd = [midu smd];
save dd.txt dd -ascii


function yy = fun1(bt,x)
    a = bt(1);
    b = bt(2);
    c = bt(3);
    x1 = x(:,1);
    x2 = x(:,2);
    yy = a.*log(x1) - b.*log(x2) + c;
end