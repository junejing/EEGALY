function N2_process_chunk = N2_process_chunk(Dmeg,Begpts,Endpts, flags)
% N2_chunk = crc_N2_chunk(Dmeg,Begpts,Endpts, flags)
%
% Chunks MEEG object Dmeg with start at Begpts and stop at Endpts, both of 
% these expressed in "time points".
% 'flags' is a structure with several optional fields:
% flags
%   .overwr   : previous chunks are overwritten [1] or not [0, def.]
%   .numchunk : fix the chunk index, useful when overwriting. Ortherwise 
%               the index is incremented from already existing files on disk
%               The default value is 1
%   .prefix   : filename prefic, 'chk' by default
%   .clockt   : use the clocktime [1] or not [0, def.]
% All default values are defined in crc_defaults.m
%
% The chunked data file is written on disk, and its filename returned.
flags_def = crc_get_defaults('chk');
flags = crc_check_flag(flags_def,flags);
% Identifying file chunk number, overwriting or not
numchk = flags.numchunk;
filename='N2_chunk';
mkdir(path(Dmeg),'N2_chunk');
mkdir(path(Dmeg),'N2_chunk_mat');
filepath1=path(Dmeg);
filepath = strcat(filepath1,'\N2_chunk');
filepath2=strcat(filepath1,'\N2_chunk_mat');
if ~flags.overwr
    while exist(fullfile( ...
                filepath,[flags.prefix,num2str(numchk),'_n2_' fname(Dmeg)]),'file')
        numchk=numchk+1;
    end
end
prefix = [flags.prefix,num2str(numchk),'_n2_'];
N2_process_chunk = fullfile(Dmeg.path,[prefix Dmeg.fname]);
if numchk<10
    prefix2=['0',num2str(numchk)];
else
    prefix2=num2str(numchk);
end

prefix2=fullfile(Dmeg.path,[prefix2 '.mat']);
% if Begpts==1      
%     winsize = median([Dmeg.CRC.score{3,:}]);
%     Begpts = 1;                                                              
%     lastwin = ceil(Endpts/(fsample(Dmeg)*winsize));
%     Endpts = lastwin*winsize*fsample(Dmeg); 
% else
%     try
%         winsize = median([Dmeg.CRC.score{3,:}]);
% 
%         firstwin =floor(Begpts/(fsample(Dmeg)*winsize))+1;          
%         Begpts = (firstwin   )*winsize*fsample(Dmeg)+1;       %%%%%%将firstwin-1改为firstwin时，窗口没有延时，
% 
%         lastwin = ceil(Endpts/(fsample(Dmeg)*winsize));
%         Endpts = lastwin*winsize*fsample(Dmeg);          
%     end
% end
Dcopy = clone(Dmeg,N2_process_chunk,[Dmeg.nchannels Endpts-Begpts+1 1]);%%%经过这一步产生一个DAT文件

%==========================================================================
% DIRTY CODE :
% getting rid of offset in orginal data file.
% This should actually be part of the clone function or at least handled
% somewhere in the object definition and methods...
% => have to use the structure form
% DO NOT DO THIS AT HOME. :-)
Dcs = struct(Dcopy);
Dcs.data.y.offset = 0;
Dcopy = meeg(Dcs);
%==========================================================================
winsize = median([Dmeg.CRC.score{3,:}]);
firstwin = ceil(Begpts/(fsample(Dmeg)*winsize));
lastwin = ceil(Endpts/(fsample(Dmeg)*winsize));
try

    for nsc=1:size(Dmeg.CRC.score,2)
        Dcopy.CRC.score{1,nsc} = Dmeg.CRC.score{1,nsc}(firstwin:lastwin);       %%%%%%%firstwin+1
        Dcopy.CRC.score{4,nsc} = [1/fsample(Dmeg) (Endpts-Begpts-1)/fsample(Dmeg)];

        tmp = Dmeg.CRC.score{5,nsc}-Begpts/fsample(Dmeg);
        idxkept = find(~all((tmp<0) + (tmp>(Endpts-Begpts)/fsample(Dmeg)),2));
        tmp = tmp(idxkept,:);
        tmp(tmp<0) = 1/fsample(Dmeg);
        tmp(tmp>(Endpts-Begpts)/fsample(Dmeg)) = (Endpts-Begpts+1)/fsample(Dmeg);
        Dcopy.CRC.score{5,nsc} = tmp;
        
        if size(Dmeg.CRC.score,1)==8 ...
                && ~isempty(Dmeg.CRC.score{8,nsc})
            if ~isempty(idxkept)
                Dcopy.CRC.score{8,nsc} = {Dmeg.CRC.score{8,nsc}{idxkept}};
            else
                Dcopy.CRC.score{8,nsc} = {};
            end
        end

        tmp = Dmeg.CRC.score{6,nsc}-Begpts/fsample(Dmeg);
        idxkept = find(~all((tmp<0) + (tmp>(Endpts-Begpts)/fsample(Dmeg)),2));
        tmp = tmp(idxkept,:);
        tmp(tmp<0) = 1/fsample(Dmeg);
        tmp(tmp>(Endpts-Begpts)/fsample(Dmeg)) = (Endpts-Begpts+1)/fsample(Dmeg);
        Dcopy.CRC.score{6,nsc}=tmp;

        tmp = Dmeg.CRC.score{7,nsc}-Begpts/fsample(Dmeg);
        idxkept = find(~all((tmp<0) + (tmp>(Endpts-Begpts)/fsample(Dmeg)),2));
        tmp = tmp(idxkept,:);
        tmp(tmp<0) = 1/fsample(Dmeg);
        tmp(tmp>(Endpts-Begpts)/fsample(Dmeg)) = (Endpts-Begpts+1)/fsample(Dmeg);
        Dcopy.CRC.score{7,nsc}=tmp;
    end
end

% Limit size of data chunk loaded in memory in one step.
Maxmem = crc_get_defaults('mem.maxmemload'); % Maxmem in byte

% Assuming data are in 32 bits/ 4 bytes
Maxelts = floor(Maxmem/(nchannels(Dmeg)*4));
Nmbchk  = ceil((Endpts-Begpts)/Maxelts);

% Update structure and save file
% handling the starting time information if available
if flags.clockt
    hour = Dcopy.info.hour;
    date = Dcopy.info.date;

    timeshift = ...
        datenum(double([0 0 0 crc_time_converts(Begpts/fsample(Dmeg))]));
    newbeg = datevec(datenum(double([date hour])) + timeshift);

    Dcopy.info.hour = newbeg(4:6);
    Dcopy.info.date = newbeg(1:3);
end

% Not too sure about his about handling the events/trials !!!!
% Should check with a file with loads of events...
Ev = Dcopy.events;
l_keep = []; % Look for events within the new file
for mm=1:numel(Ev)
    Ev(mm).time = Ev(mm).time - Begpts/fsample(Dmeg);
    if Ev(mm).time>=0 && Ev(mm).time<(Endpts-Begpts)/fsample(Dmeg)
        l_keep = [l_keep mm];
    end
end
Dcopy = events(Dcopy,1,Ev(l_keep));

for ii=1:Nmbchk   
    ch_data = Dmeg(:,(Begpts+Maxelts*(ii-1)): ...
                        min([Begpts+Maxelts*ii-1 nsamples(Dmeg) Endpts]));
    Dcopy(:,Maxelts*(ii-1)+(1:size(ch_data,2))) = ch_data;
end

filepath=path(Dmeg);
filepath = strcat(filepath,'\N2_chunk');
save(Dcopy) ;     %%%%%%%%%%%%%%%在后面加上分号，就不会显示ans=1；
b=Dcopy(:,:,1);
save(prefix2,'b');
movefile(N2_process_chunk,filepath);
movefile(prefix2,filepath2);
datFile=strcat(N2_process_chunk(1:end-4),'.dat');
movefile(datFile,filepath);


