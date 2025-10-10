clear
clc

%% ����׼������
Graph_Complex; % ��ߴ���е�ͼ��ά��ͼG(����һ��01����)

len=length(G);
% ��ʼ����Ϣ�ؾ���
tau=ones(len*len,len*len);  % =====================
tau=8.*tau;
iterNum = 60;                 
ant = 30; 
% ���������յ�
psID = 1 ;        
peID = 2300;
%% �����㷨����
alpha = 1.2; % ��Ϣ����Ҫ�̶�             
beta = 4;    % ����ʽ������Ҫ�̶�      
rho = 0.55;  % ��Ϣ������ϵ�� 
Q = 50;      % ��ֻ�����ܹ�һ���������ܹ�Я������Ϣ������
minDis = inf;
minIter=0;
minAnt=0;
% ��ʽ����ͼ����
D=GetNewD(G);
pixNum=size(D,1);
pixLen=1;
% ��ʽ���յ�����
% ex�Ǻ����꣬ey��������
Ex=pixLen*(mod(peID,len)-0.5);
if Ex==-0.5
    Ex=len-0.5;
end
Ey=pixLen*(len+0.5-ceil(peID/len));
%% ��������ʽ��Ϣ(ÿ������ڵ�ľ���)
% �����Ͻ�Ϊ����ԭ�㣬������y�ᣬ������x�ᣬ���������0.5
eta=zeros(pixNum,1);      % ============================  ԭ���������� eta=zeros(pixNum); 
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
% ����·�ߺ����о���
antPath = cell(iterNum,ant); 
pathLen = zeros(iterNum,ant);

%% �㷨����
for k=1:iterNum
    for m=1:ant
       % ״̬��ʼ��
        nodeID = psID;           
        tempPath=psID;        
        tempDist=0;                
        tabu=ones(pixNum,1); % ============================      ԭ����������  tabu=ones(pixNum); 
        tabu(psID)=0;   
        ND=D;              
       % Ѱ�ҿ��е�
        nw=ND(nodeID,:);
        nw1=find(nw);
        for j=1:length(nw1)
            if tabu(nw1(j))==0
                nw(nw1(j))=0;
            end
        end
        ky=find(nw);
        kyn=length(ky);    %���и���
        % ������δ����ʳ�������������ֹͬͣ
        while nodeID~=peID && kyn>=1
           % ���̶ķ�
            P=zeros(kyn,1); % ============================      ԭ����������  P=zeros(kyn);
            for i=1:kyn
                P(i)=(tau(nodeID,ky(i))^alpha)*((eta(ky(i)))^beta);
            end
            sumP=sum(P);
            P=P/sumP;       % ���к��ϱ�һ�� �ϲ�Ϊ p = p/(sum(p)); 
            Pcum(1)=P(1);
            for i=2:kyn
                Pcum(i)=Pcum(i-1)+P(i);
            end
            St=find(Pcum>=rand);
            nextNode=ky(St(1)); 
           % ����״̬
            tempPath=[tempPath,nextNode];
            tempDist=tempDist+ND(nodeID,nextNode);
            nodeID=nextNode;
            for kk=1:pixNum
                if tabu(kk)==0
                    ND(nodeID,kk)=0;
                    ND(kk,nodeID)=0;
                end
            end
            %ɾ���ѷ��ʽڵ�
            tabu(nodeID)=0;
            nw=ND(nodeID,:);
            nw1=find(nw);
            for j=1:length(nw1)
                if tabu(nw1(j))==0
                    nw(nw1(j))=0;    %% ??���ϱ߲�һ��nw(nw1(j))=0;============= nw(j)=0;
                end
            end
            ky=find(nw);
            kyn=length(ky);%��ѡ�ڵ�ĸ���
        end
        % ����ÿһ��ÿһֻ���ϵ���ʳ·�ߺ�·�߳���
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
    % ������Ϣ��
    pherCh=zeros(pixNum,pixNum);%��������ʼ��
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
    % �����Ϣ��
    tau=(1-rho).*tau+pherCh;
end

%% ��ͼ���Ʋ���
sign=1;
if sign==1
    %����������
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
    title('��������');
    xlabel('��������');
    ylabel('����·������'); 
    
    %������ͼ
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
%�������������ͼ
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

%% ��ʼ�������
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

