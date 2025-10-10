clear
close all
clc
%% 数据读取
% imread是读取灰度值的文件，255表示最亮
x1 = imread("附件1\000.bmp");
x2 = imread("附件1\001.bmp");
x3 = imread("附件1\002.bmp");
x4 = imread("附件1\003.bmp");
x5 = imread("附件1\004.bmp");
x6 = imread("附件1\005.bmp");
x7 = imread("附件1\006.bmp");
x8 = imread("附件1\007.bmp");
x9 = imread("附件1\008.bmp");
x10 = imread("附件1\009.bmp");
x11 = imread("附件1\010.bmp");
x12 = imread("附件1\011.bmp");
x13 = imread("附件1\012.bmp");
x14 = imread("附件1\013.bmp");
x15 = imread("附件1\014.bmp");
x16 = imread("附件1\015.bmp");
x17 = imread("附件1\016.bmp");
x18 = imread("附件1\017.bmp");
x19 = imread("附件1\018.bmp");



%% 存放到一个三位数组img中
% img = ones(19,1980,72);
% img(1,:,:) = x1;
% img(2,:,:) = x2;
% img(3,:,:) = x3;
% img(4,:,:) = x4;
% img(5,:,:) = x5;
% img(6,:,:) = x6;
% img(7,:,:) = x7;
% img(8,:,:) = x8;
% img(9,:,:) = x9;
% img(10,:,:) = x10;
% img(11,:,:) = x11;
% img(12,:,:) = x12;
% img(13,:,:) = x13;
% img(14,:,:) = x14;
% img(15,:,:) = x15;
% img(16,:,:) = x16;
% img(17,:,:) = x17;
% img(18,:,:) = x18;
% img(19,:,:) = x19;

%% 或者把所有x(i)放在一起，i是每个碎纸片第一列的起始序号
% x(i) = 72*(i-1) + 1
imgs = [x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19];
images = imgs;
%% 数值01化
[len,width] = size(images);
for i = 1:len
    for j = 1:width
        if imgs(i,j) > 255
            images(i,j) = 1;
        else
            images(i,j) = 0;
        end
    end
end
%% one是imgs中每一列中1的个数
one = zeros(1,width);
for k = 1:width
    one(k) = length(find(images(:,k) == 1));
end
%% 找出第一张和最后一张图片
xx = zeros(1,19); % xx中存放的是每张图片第一列中为1的个数
yy = zeros(1,19); % yy中存放的是每张图片最后一列中为1的个数
for i = 1:19
    xx(i) = one(72*(i-1) + 1);
    yy(i) = one(72*i);
end
% 要注意附件中的编号是从0开始
y1 = find(xx == max(xx)); % y1是第一张图片的编号
y19 = find(yy == max(yy)); % y19是最后一张图片的编号
swap(imgs,1,y1);
swap(imgs,19,y19);
%% 显示图片

imshow(imgs);

%% 将第x张照片和第y张照片交换
function swap(imgs,x,y)
% imgs是所有图片组成的矩阵，将第x张照片和第y张照片交换
    temp = imgs(:,(72*(x-1)+1):72*x);
    imgs(:,(72*(x-1)+1):72*x) = imgs(:,(72*(y-1)+1):72*y);
    imgs(:,(72*(y-1)+1):72*y) = temp;
end