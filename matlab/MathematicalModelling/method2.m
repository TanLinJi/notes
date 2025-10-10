clear
close all
clc

%% 数据读取
imgNum = length(dir("附件1\*.bmp"));
imgs = cell(imgNum,1);
imgs{1,1} = imread("附件1\000.bmp");
imgs{2,1} = imread("附件1\001.bmp");
imgs{3,1} = imread("附件1\002.bmp");
imgs{4,1} = imread("附件1\003.bmp");
imgs{5,1} = imread("附件1\004.bmp");
imgs{6,1} = imread("附件1\005.bmp");
imgs{7,1} = imread("附件1\006.bmp");
imgs{8,1} = imread("附件1\007.bmp");
imgs{9,1} = imread("附件1\008.bmp");
imgs{10,1} = imread("附件1\009.bmp");
imgs{11,1} = imread("附件1\010.bmp");
imgs{12,1} = imread("附件1\011.bmp");
imgs{13,1} = imread("附件1\012.bmp");
imgs{14,1} = imread("附件1\013.bmp");
imgs{15,1} = imread("附件1\014.bmp");
imgs{16,1} = imread("附件1\015.bmp");
imgs{17,1} = imread("附件1\016.bmp");
imgs{18,1} = imread("附件1\017.bmp");
imgs{19,1} = imread("附件1\018.bmp");


%% 图像二值化
for i = 1:imgNum
    % 利用graythresh计算阈值，将其归一化至范围[0,1]
    level = graythresh(imgs{i,1});
    % 使用阈值将图像转换为二值图像（1代表亮，0代表暗）
    imgs{i,1} = imbinarize(imgs{i,1},level);
end

%% 寻找第一张碎片和最后一张碎片
% 方法：第一张碎片的左边空白最多，最后一张碎片的右边空白最多
for i = 1:imgNum
    [len,wid] = size(imgs{i,1});
    % 把每张图片0,1值全部投影到第一行
    for j = 1:wid
        imgs{i,1}(1,j) = sum(imgs{i,1}(:,j));
    end
    imgs{i,1}(2:end,:) = [];
end