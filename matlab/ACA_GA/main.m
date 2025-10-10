clear
clc
close all

%% 数据准备

load map.mat  % 地图矩阵
map = map(2:49,2:49); % 去除边界
len = size(map,1); % 地图维数

%% 参数定义
ant = 50;    % 蚂蚁数量
iteration = 50; % 迭代次数
start = 1;   % 起点编号
dest = len * len; % 终点编号
alpha = 1;   % 信息素重要程度
beta = 7;    % 启发式因子重要程度
rho = 0.3;   % 信息素蒸发系数
Q = 1;       % 信息素增加强度系数
pher=0.6.*ones(len,len); % 初始化信息素矩阵
for i = 1 : len
    for j = 1 : len
        if map(i,j)==1
            pher(i,j) = 0; 
        end
    end
end
dist = zeros(len*len,len*len); % 初始化距离矩阵
bestRoute = cell(iteration,1); % 各代最佳路径
bestDist = zeros(iteration,1); % 各代最佳路径长度
distAvg = zeros(iteration,1);  % 各代平均路径长度
%% 其他算法参数

mikl = inf;
mik=0;
mile=0;
% 格式化地图矩阵
D=GetNewD(G);
pixNum=size(D,1);
pixLen=1;
% 格式化终点坐标
% ex是横坐标，ey是纵坐标
Ex=pixLen*(mod(PEnd,GLen)-0.5);
if Ex==-0.5
    Ex=GLen-0.5;
end
Ey=pixLen*(GLen+0.5-ceil(PEnd/GLen));
%% 构造启发式信息
EA=zeros(pixNum);
for i=1:pixNum
    ix=pixLen*(mod(i,GLen)-0.5);
    if ix==-0.5
        ix=GLen-0.5;
    end
    iy=pixLen*(GLen+0.5-ceil(i/GLen));
    if i~=PEnd
        EA(i)=1/((ix-Ex)^2+(iy-Ey)^2)^0.5;
    else
        EA(i)=100;
    end
end
% 爬行路线和爬行距离
antPath = cell(iterNum,antNum);
pathLen = zeros(iterNum,antNum);

%% 算法主体
for k=1:iterNum
    for m=1:antNum
        % 状态初始化
        W = pStart;
        Path=pStart;
        PLkm=0;
        TABU=ones(pixNum);
        TABU(pStart)=0;
        ND=D;
        % 寻找可行点
        nw=ND(W,:);
        nw1=find(nw);
        for j=1:length(nw1)
            if TABU(nw1(j))==0
                nw(nw1(j))=0;
            end
        end
        ky=find(nw);
        kyn=length(ky);    %可行个数
        % 当蚂蚁未遇到食物或者陷入死胡同停止
        while W~=PEnd && kyn>=1
            % 轮盘赌法
            P=zeros(kyn);
            for i=1:kyn
                P(i)=(pher(W,ky(i))^alpha)*((EA(ky(i)))^beta);
            end
            sumP=sum(P);
            P=P/sumP;
            Pcum(1)=P(1);
            for i=2:kyn
                Pcum(i)=Pcum(i-1)+P(i);
            end
            St=find(Pcum>=rand);
            toVt=ky(St(1));
            % 更新状态
            Path=[Path,toVt];
            PLkm=PLkm+ND(W,toVt);
            W=toVt;
            for kk=1:pixNum
                if TABU(kk)==0
                    ND(W,kk)=0;
                    ND(kk,W)=0;
                end
            end
            %删除已访问节点
            TABU(W)=0;
            nw=ND(W,:);
            nw1=find(nw);
            for j=1:length(nw1)
                if TABU(nw1(j))==0
                    nw(j)=0;
                end
            end
            ky=find(nw);
            kyn=length(ky);%可选节点的个数
        end
        % 记下每一代每一只蚂蚁的觅食路线和路线长度
        antPath{k,m}=Path;
        if Path(end)==PEnd
            pathLen(k,m)=PLkm;
            if PLkm<mikl
                mink=k;mile=m;mikl=PLkm;
            end
        else
            pathLen(k,m)=0;
        end
    end
    % 更新信息素
    pherCh=zeros(pixNum,pixNum);%更新量初始化
    for m=1:antNum
        if pathLen(k,m)
            rt=antPath{k,m};
            ts=length(rt)-1;
            PL_km=pathLen(k,m);
            for s=1:ts
                x=rt(s);
                y=rt(s+1);
                pherCh(x,y)=pherCh(x,y)+Q/PL_km;
                pherCh(y,x)=pherCh(y,x)+Q/PL_km;
            end
        end
    end
    % 填充信息素
    pher=(1-rho).*pher+pherCh;
end

%% 地图绘制部分
sign=1;
if sign==1
    %绘收敛曲线
    minPL=zeros(iterNum);
    for i=1:iterNum
        PLK=pathLen(i,:);
        Nonzero=find(PLK);
        if isempty(Nonzero)
            continue;
        end
        PLKPLK=PLK(Nonzero);
        minPL(i)=min(PLKPLK);
    end
    figure(1)
    avgLength = mean(minPL(:,1));
    plot(minPL(:,1))
    hold on
    grid on
    title('收敛曲线');
    xlabel('迭代次数');
    ylabel('搜索路径长度');

    %绘爬行图
    figure(2)
    axis([0,GLen,0,GLen])
    for i=1:GLen
        for j=1:GLen
            if G(i,j)==1
                x1=j-1;y1=GLen-i;
                x2=j;y2=GLen-i;
                x3=j;y3=GLen-i+1;
                x4=j-1;y4=GLen-i+1;
                fill([x1,x2,x3,x4],[y1,y2,y3,y4],[0.2,0.2,0.2]);
                hold on
            else
                x1=j-1;y1=GLen-i;
                x2=j;y2=GLen-i;
                x3=j;y3=GLen-i+1;
                x4=j-1;y4=GLen-i+1;
                fill([x1,x2,x3,x4],[y1,y2,y3,y4],[1,1,1]);
                hold on
            end
        end
    end
    hold on
    rt=antPath{mink,mile};
    LENROUT=length(rt);
    Rx=rt;
    Ry=rt;
    for ii=1:LENROUT
        Rx(ii)=pixLen*(mod(rt(ii),GLen)-0.5);
        if Rx(ii)==-0.5
            Rx(ii)=GLen-0.5;
        end
        Ry(ii)=pixLen*(GLen+0.5-ceil(rt(ii)/GLen));
    end
    plot(Rx,Ry)
end
%绘各代蚂蚁爬行图
plotif2=0;
if plotif2==1
    figure(3)
    axis([0,GLen,0,GLen])
    for i=1:GLen
        for j=1:GLen
            if G(i,j)==1
                x1=j-1;y1=GLen-i;
                x2=j;y2=GLen-i;
                x3=j;y3=GLen-i+1;
                x4=j-1;y4=GLen-i+1;
                fill([x1,x2,x3,x4],[y1,y2,y3,y4],[0.2,0.2,0.2]);
                hold on
            else
                x1=j-1;y1=GLen-i;
                x2=j;y2=GLen-i;
                x3=j;y3=GLen-i+1;
                x4=j-1;y4=GLen-i+1;
                fill([x1,x2,x3,x4],[y1,y2,y3,y4],[1,1,1]);
                hold on
            end
        end
    end
    for k=1:iterNum
        PLK=pathLen(k,:);
        minPLK=min(PLK);
        pos=find(PLK==minPLK);
        m=pos(1);
        rt=antPath{k,m};
        LENROUT=length(rt);
        Rx=rt;
        Ry=rt;
        for ii=1:LENROUT
            Rx(ii)=pixLen*(mod(rt(ii),GLen)-0.5);
            if Rx(ii)==-0.5
                Rx(ii)=GLen-0.5;
            end
            Ry(ii)=pixLen*(GLen+0.5-ceil(rt(ii)/GLen));
        end
        plot(Rx,Ry)
        hold on
    end
end

toc
%% 初始地图
function D=GetNewD(G)
llen=size(G,1);
D=zeros(llen*llen,llen*llen);
for i=1:llen
    for j=1:llen
        if G(i,j)==0
            for m=1:llen
                for n=1:llen
                    if G(m,n)==0
                        im=abs(i-m);jn=abs(j-n);
                        if im+jn==1||(im==1&&jn==1)
                            D((i-1)*llen+j,(m-1)*llen+n)=(im+jn)^0.5;
                        end
                    end
                end
            end
        end
    end
end
end


function Dist = GetDist(map)
    len = size(map,1);
    Dist = zeros(len*len,len*len);
    for i = 1 : len
        for j = 1 : len
            if map(i,j) == 0
                for m = 1 : len
                    for n = 1 : len
                        if map(m,n) == 0
end
