clear
clc

%% 数据准备部分
Graph_Complex; % 里边存放有地图二维地图G(它是一个01矩阵)

len=length(G);
% 初始化信息素矩阵
tau=ones(len*len,len*len);  % =====================
tau=8.*tau;
iterNum = 60;                 
ant = 30; 
% 定义起点和终点
psID = 1 ;        
peID = 2300;
%% 其他算法参数
alpha = 1.2; % 信息素重要程度             
beta = 4;    % 启发式因子重要程度      
rho = 0.55;  % 信息素蒸发系数 
Q = 50;      % 单只蚂蚁能够一次搜索中能够携带的信息素总量
minDis = inf;
minIter=0;
minAnt=0;
% 格式化地图矩阵
D=GetNewD(G);
pixNum=size(D,1);
pixLen=1;
% 格式化终点坐标
% ex是横坐标，ey是纵坐标
Ex=pixLen*(mod(peID,len)-0.5);
if Ex==-0.5
    Ex=len-0.5;
end
Ey=pixLen*(len+0.5-ceil(peID/len));
%% 构造启发式信息(每个距离节点的距离)
% 以右上角为坐标原点，向左是y轴，向下是x轴，点的中心是0.5
eta=zeros(pixNum,1);      % ============================  原来是这样的 eta=zeros(pixNum); 
for i=1:pixNum
    ix=pixLen*(mod(i,len)-0.5);
    if ix==-0.5
        ix=len-0.5;
    end
    iy=pixLen*(len+0.5-ceil(i/len));
    if i~=peID
        eta(i)=1/((ix-Ex)^2+(iy-Ey)^2)^0.5;
    else
        eta(i)=100;
    end
end
% 爬行路线和爬行距离
antPath = cell(iterNum,ant); 
pathLen = zeros(iterNum,ant);

%% 算法主体
for k=1:iterNum
    for m=1:ant
       % 状态初始化
        nodeID = psID;           
        tempPath=psID;        
        tempDist=0;                
        tabu=ones(pixNum,1); % ============================      原来是这样的  tabu=ones(pixNum); 
        tabu(psID)=0;   
        ND=D;              
       % 寻找可行点
        nw=ND(nodeID,:);
        nw1=find(nw);
        for j=1:length(nw1)
            if tabu(nw1(j))==0
                nw(nw1(j))=0;
            end
        end
        ky=find(nw);
        kyn=length(ky);    %可行个数
        % 当蚂蚁未遇到食物或者陷入死胡同停止
        while nodeID~=peID && kyn>=1
           % 轮盘赌法
            P=zeros(kyn,1); % ============================      原来是这样的  P=zeros(kyn);
            for i=1:kyn
                P(i)=(tau(nodeID,ky(i))^alpha)*((eta(ky(i)))^beta);
            end
            sumP=sum(P);
            P=P/sumP;       % 这行和上边一行 合并为 p = p/(sum(p)); 
            Pcum(1)=P(1);
            for i=2:kyn
                Pcum(i)=Pcum(i-1)+P(i);
            end
            St=find(Pcum>=rand);
            nextNode=ky(St(1)); 
           % 更新状态
            tempPath=[tempPath,nextNode];
            tempDist=tempDist+ND(nodeID,nextNode);
            nodeID=nextNode;
            for kk=1:pixNum
                if tabu(kk)==0
                    ND(nodeID,kk)=0;
                    ND(kk,nodeID)=0;
                end
            end
            %删除已访问节点
            tabu(nodeID)=0;
            nw=ND(nodeID,:);
            nw1=find(nw);
            for j=1:length(nw1)
                if tabu(nw1(j))==0
                    nw(nw1(j))=0;    %% ??和上边不一样nw(nw1(j))=0;============= nw(j)=0;
                end
            end
            ky=find(nw);
            kyn=length(ky);%可选节点的个数
        end
        % 记下每一代每一只蚂蚁的觅食路线和路线长度
        antPath{k,m}=tempPath;
        if tempPath(end)==peID
            pathLen(k,m)=tempDist;
            if tempDist<minDis
                minIter=k;
                minAnt=m;
                minDis=tempDist;
            end
        else
            pathLen(k,m)=0;
        end
    end
    % 更新信息素
    pherCh=zeros(pixNum,pixNum);%更新量初始化
    for m=1:ant
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
    tau=(1-rho).*tau+pherCh;
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
    axis([0,len,0,len])
    for i=1:len
        for j=1:len
            if G(i,j)==1
                x1=j-1;y1=len-i;
                x2=j;y2=len-i;
                x3=j;y3=len-i+1;
                x4=j-1;y4=len-i+1;
                fill([x1,x2,x3,x4],[y1,y2,y3,y4],[0.2,0.2,0.2]);
                hold on
            else
                x1=j-1;y1=len-i;
                x2=j;y2=len-i;
                x3=j;y3=len-i+1;
                x4=j-1;y4=len-i+1;
                fill([x1,x2,x3,x4],[y1,y2,y3,y4],[1,1,1]);
                hold on
            end
        end
    end
    hold on
    rt=antPath{minIter,minAnt};
    LENROUT=length(rt);
    Rx=rt;
    Ry=rt;
    for ii=1:LENROUT
        Rx(ii)=pixLen*(mod(rt(ii),len)-0.5);
        if Rx(ii)==-0.5
            Rx(ii)=len-0.5;
        end
        Ry(ii)=pixLen*(len+0.5-ceil(rt(ii)/len));
    end
    plot(Rx,Ry)
end
%绘各代蚂蚁爬行图
plotif2=0;
if plotif2==1
    figure(3)
    axis([0,len,0,len])
    for i=1:len
        for j=1:len
            if G(i,j)==1
                x1=j-1;y1=len-i;
                x2=j;y2=len-i;
                x3=j;y3=len-i+1;
                x4=j-1;y4=len-i+1;
                fill([x1,x2,x3,x4],[y1,y2,y3,y4],[0.2,0.2,0.2]);
                hold on
            else
                x1=j-1;y1=len-i;
                x2=j;y2=len-i;
                x3=j;y3=len-i+1;
                x4=j-1;y4=len-i+1;
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
            Rx(ii)=pixLen*(mod(rt(ii),len)-0.5);
            if Rx(ii)==-0.5
                Rx(ii)=len-0.5;
            end
            Ry(ii)=pixLen*(len+0.5-ceil(rt(ii)/len));
        end
        plot(Rx,Ry)
        hold on
    end
end

toc

%% 初始距离矩阵
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

