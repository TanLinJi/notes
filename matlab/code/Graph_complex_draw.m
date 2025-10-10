clc;
clear;
close all;
%% ������ɫMAPͼ
cmap = [1 1 1; ...       % 1-��ɫ-�յ�
    0 0 0; ...           % 2-��ɫ-�ϰ�
    1 0 0; ...
    1 1 0;...
    1 0 1;...
    0 1 0; ...
    0 1 1];
colormap(cmap);

%% ����դ���ͼ����
Graph_Complex;%�����ͼ����
[rows,cols] = size(G);

% ����դ���ͼȫ�򣬲���ʼ���հ�����
field = ones(rows,cols);

% �ϰ���
obsNum = sum(sum(G));  % �ϰ������
[x,y] = find(G==1);
obsIndex = sub2ind(size(G),x,y);
field(obsIndex) = 2;  % ��̬�ϰ�

% ���������յ�
startPos = 1;
goalPos = rows*cols;
field(startPos) = 4;  % ����ʼ������Ϊ4����ɫ
field(goalPos) = 5;   % ���յ�����Ϊ5��Ʒ��ɫ

%% ����դ��ͼ
image(1.5,1.5,field);
grid on;
set(gca,'gridline','-','gridcolor','k','linewidth',2,'GridAlpha',0.5);
set(gca,'xtick',1:cols+1,'ytick',1:rows+1);
axis image; %���õȱ�������