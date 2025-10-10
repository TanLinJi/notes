function txt=GetVersion(x)
%% 获取mat文件的版本信息
% 参考自：https://cloud.tencent.com/developer/ask/sof/111901986
    fid=fopen(x);
    txt=char(fread(fid,[1,140],'*char'));
    txt=[txt,0];
    txt=txt(1:find(txt==0,1,'first')-1);
    endy_imag
end