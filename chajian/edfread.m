clear;
 close all;
[FileName,PathName] = uigetfile('*.edf','Select the data file');
FullFileName=strcat(PathName,FileName);
fh=fopen(FullFileName,'r');
Fcon=fread(fh);%read the whole file in a vector of n*1 byte 


Fversion=char(Fcon(1:8)');
FLPI=char(Fcon(9:88)');
FLRI=char(Fcon(89:168)');
RstaDate=char(Fcon(169:176)');%% dd.mm.yy
RstaTime=char(Fcon(177:184)');%% hh.mm.ss
NumheadByte=str2num(char(Fcon(185:192)'));%%number of bytes in header record
Freserve=char(Fcon(193:236)');
NumRec=str2num(char(Fcon(237:244)')); %%number of data records   
SecDdur=str2num(char(Fcon(245:252)')); %%duration of a data record, in seconds
NumSig=str2num(char(Fcon(253:256)'));  %%number of signals (ns) in data record
Begintemp=257;
NsLabel=char(Fcon(Begintemp:Begintemp+NumSig*16-1)');%%%ns * label (e.g. EEG FpzCz or Body temp)
Begintemp=Begintemp+NumSig*16;
NsTraType=char(Fcon(Begintemp:Begintemp+NumSig*80-1)');%% ns * transducer type (e.g. AgAgCl electrode)
Begintemp=Begintemp+NumSig*80;
NsPhyDim=char(Fcon(Begintemp:Begintemp+NumSig*8-1)');%% ns * physical dimension (e.g. uV or degreeC)
Begintemp=Begintemp+NumSig*8;
NsPhyMin=str2num(char(Fcon(Begintemp:Begintemp+NumSig*8-1)'));%% ns * physical minimum (e.g. -500 or 34)
Begintemp=Begintemp+NumSig*8;
NsPhyMax=str2num(char(Fcon(Begintemp:Begintemp+NumSig*8-1)'));%% ns * physical maximum (e.g. 500 or 40) 
Begintemp=Begintemp+NumSig*8;
NsDigMin=str2num(char(Fcon(Begintemp:Begintemp+NumSig*8-1)'));%% ns * digital minimum (e.g. -2048)
Begintemp=Begintemp+NumSig*8;
NsDigMax=str2num(char(Fcon(Begintemp:Begintemp+NumSig*8-1)'));%%ns * digital maximum (e.g. 2047)
Begintemp=Begintemp+NumSig*8;
NsPreFil=char(Fcon(Begintemp:Begintemp+NumSig*80-1)');%%ns * prefiltering (e.g. HP:0.1Hz LP:75Hz)
Begintemp=Begintemp+NumSig*80;
NsNrSam=str2num(char(Fcon(Begintemp:Begintemp+NumSig*8-1)'));%%ns * nr of samples in each data record
Begintemp=Begintemp+NumSig*8;
NsRes=char(Fcon(Begintemp:Begintemp+NumSig*32-1)');%ns * reserved
Dataresol=(NsPhyMax-NsPhyMin)./(NsDigMax-NsDigMin);
Begintemp=Begintemp+NumSig*32-1;

if(NumheadByte~=Begintemp)
    error('read error');
end
SamRec=sum(NsNrSam);
fseek(fh,Begintemp,'bof');
DataAll=fread(fh,SamRec*NumRec,'short');
fclose(fh);
DataAll=reshape(DataAll,[],NumRec);


kblock=10;
Dtemp=DataAll(:,kblock);

s=0;
figure,
for k=1:NumSig
     sigshow=Dtemp(s+1:s+NsNrSam(k))*Dataresol(k);
     s=s+NsNrSam(k);
     t=[(kblock-1)*SecDdur:SecDdur/NsNrSam(k):kblock*SecDdur-SecDdur/NsNrSam(k)];
     subplot(NumSig,1,k),plot(t,sigshow);
end





