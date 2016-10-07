function tdk_capture(varargin)

if nargin < 1
	%use open dialog
   [fileName, pathName] = uigetfile( {'*.mat'},  'Choose MAT File');

	if fileName == 0
		error('ERRP:IO:tdk_capture:Nofilename','No MAT File Provided')
	else
		fileName = fullfile(pathName, fileName);
	end
else
	%make sure we have full aht
	[pathName fileName fileExt] = fileparts(varargin{1});
	
	if isempty(pathName); pathName = pwd;end
	fileName  = fullfile(pathName, [fileName fileExt]);
end

[pathName fileName fileExt] = fileparts(fileName);
hdrFile  = fullfile(pathName, [fileName '.vhdr']);
hdrFile
SavePath = [pathName '/chunk'];

load(fileName);
if ~isfield(D.other.CRC, 'score')
 	fprint('There is no score data on the %s',filename);
 	return;
end

%load('tandakun.mat');
scoreData = D.other.CRC.score{1};

time = [D.other.info.hour];
slidBegin = ceil(time(3));
beg     =   slidBegin - time(3);
tdeb    =   round(beg*D.Fsample);
temps   =   tdeb:1:D.Nsamples;

scoreTemp = [scoreData(1) scoreData];
scoreChange = scoreData(1:end)-scoreTemp(1:end-1);
windLength = D.Fsample*D.other.CRC.score{3};%seconds on each window
scoreChangeCount = find(scoreChange ~= 0);
scoreChangeIndex = [0 (scoreChangeCount-1)*windLength size(temps,2)];
scoreStageIndex = [scoreData(scoreChangeCount-1) scoreData(end)];
scoreChunk = length(scoreChangeIndex);

stageStr = {'awake' 'stage1' 'stage2' 'stage3' 'stage4' 'REM' 'MT' 'unscore' };
stageCnt = zeros(1,8);
eegData = bva_loadeeg(hdrFile);

mkdir('Chunk');
cd('.\Chunk');
mkdir('awake');
mkdir('stage1');
mkdir('stage2');
mkdir('stage3');
mkdir('stage4');
mkdir('REM');
mkdir('MT');
mkdir('unscore');
for i = 1:scoreChunk-1
	stageData = eegData(:,temps(scoreChangeIndex(i)+1:scoreChangeIndex(i+1)));
	k = stageStr{scoreStageIndex(i)+1};
	switch k
		case 'awake'
			stageCnt(1) = stageCnt(1) + 1;
			save([SavePath '\awake\'  num2str(stageCnt(1))],'stageData');
		case 'stage1'
			stageCnt(2) = stageCnt(2) + 1;
			save([SavePath '\stage1\'  num2str(stageCnt(2))],'stageData');
		case 'stage2'
			stageCnt(3) =stageCnt(3) + 1;
			save([SavePath '\stage2\'  num2str(stageCnt(3))],'stageData');
		case 'stage3'
			stageCnt(4) = stageCnt(4) + 1;
			save([SavePath '\stage3\'  num2str(stageCnt(4))],'stageData');
		case 'stage4'
			stageCnt(5) = stageCnt(5) + 1;
			save([SavePath '\stage4\'  num2str(stageCnt(5))],'stageData');
		case 'REM'
			stageCnt(6) = stageCnt(6) + 1;
			save([SavePath '\REM\'  num2str(stageCnt(6))],'stageData');	
		case 'MT'
			stageCnt(7) = stageCnt(7) + 1;
			save([SavePath '\MT\'  num2str(stageCnt(7))],'stageData');			
		otherwise
			stageCnt(8) = stageCnt(8) + 1;
			save([SavePath '\unscore\'  num2str(stageCnt(8))],'stageData');
	end
end

function eeg = bva_loadeeg(hdrFile)

%bva_loadeeg - load continous eeg from  Brain Vision Data Exchange File 
%
% function [eeg] = bva_loadeeg(header)
%
% Load Brain Vision data exchange file data. 
% 
%
% Input:
%	file = Brain Vision Data HeaderFile (.vhdr)
%
% Output:
%	eeg = continuous EEG data
%
% requires: bva_readheader.m
%
% see also: ERRP/io
%

% Copyright (C) 2008-2012 Stefan Schinkel, HU Berlin
% http://people.physik.hu-berlin.de/~schinkel/
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

% $Log$
if nargin < 1
	%use open dialog
   [fileName, pathName] = uigetfile( {'*.vhdr'},  'Choose Header File');

	if fileName == 0
		error('ERRP:IO:bva_readheader:NoHeaderFile','No Header File Provided')
	else
		hdrFile = fullfile(pathName, fileName);
	end
else
	%make sure we have full aht
	[pathName fileName fileExt] = fileparts(hdrFile);
	
	if isempty(pathName); pathName = pwd;end
	hdrFile  = fullfile(pathName, [fileName fileExt]);
end

hdrFile


% read meta data
[fs label meta ] = bva_readheader(hdrFile);
nChans = numel(label);

% assemble eegFile name and check if exists
if exist(fullfile(pathName, meta.eegFile),'file')
	eegFile = fullfile(pathName, meta.eegFile);
elseif exist(fullfile(pathName, lower( meta.eegFile )),'file');
	eegFile = fullfile(pathName, lower( meta.eegFile ));
else
	error('ERRP:io:bva_loadeeg','Couldn''t find find .eeg file');
end


% make sure we read binary data
if strcmpi(meta.DataFormat, 'ascii')
	error('Reading ASCII is not implemented. Yet.')  
end;

% extract data format, determins bytesPerSample
switch lower(meta.DataType)
    case 'int_16',        binformat = 'int16'; bytesPerSample = 2;
    case 'uint_16',       binformat = 'uint16'; bytesPerSample = 2;
    case 'ieee_float_32', binformat = 'float32'; bytesPerSample = 4;
    otherwise, error('Unsupported binary format');
end

% open file
fp = fopen(eegFile,'r');
%seek to file end and get position in byte (total bytes in file)
fseek(fp, 0, 'eof');
totalBytes =  ftell(fp);

% number of Frames 
nFrames =  totalBytes / (bytesPerSample * nChans);

%pre-allocate memory
eeg = single( zeros(nChans,nFrames) );

% Read data
switch lower(meta.DataOrientation)
    case 'multiplexed'
		frewind(fp);                
		eeg = fread(fp, [nChans, nFrames], [binformat '=>float32']);
		fclose(fp);
    case 'vectorized'
		error('Reading vectorized binary is not Not implemented')
    otherwise
		error('Not implemented')
end

%scale data
eeg = eeg .* repmat(meta.scaleFactor',1,size(eeg,2));

function [fs label meta] = bva_readheader(varargin)

%bva_readheader - read BVA Header File and extract sampling rate and channels
%
% function [fs label meta] = bva_readheader(file)
%
% Read Brain Vision Header File and return sampling rate, channel
% labels and various other info to caller. 
%
% Input:
%	file = Brain Vision Data HeaderFile (.vhdr)
%
% Output:
%	fs = sampling rate
%	label = electrode labels
%	meta = other info (required for bva_loadeeg.m)
%
% requires: 
%
% see also: ERRP/io
%

% Copyright (C) 2008-2012 Stefan Schinkel, HU Berlin
% http://people.physik.hu-berlin.de/~schinkel/
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

% $Log$

%% debug settings
debug = 0;
if debug;warning('on','all');else warning('off','all');end

%% check number of input arguments
error(nargchk(0,1,nargin))

%% check number of out arguments
error(nargoutchk(0,4,nargout))

%% check && assign input
varargin{2} = [];

if ~isempty(varargin{1}),
	file = varargin{1};
else
	%use open dialog
   [filename, pathname] = uigetfile( {'*.vhdr'},  'Choose Header File');

	if filename == 0
		error('ERRP:IO:bva_readheader:NoHeaderFile','No Header File Provided')
	else
		file = fullfile(pathname, filename);
	end
end

%open fp (for reading)
fp = fopen(file);

if fp == -1
	error('ERRP:IO:bva_readheader:FileNotReadable','Couldn''t read header file')
end

% read the whole file as one cell array
raw={};
while ~feof(fp)
    raw = [raw; {fgetl(fp)}];
end
fclose(fp);

% Remove comments and empty lines
raw(strmatch(';', raw)) = [];
raw(cellfun('isempty', raw) == true) = [];

% Find sections
sections = [strmatch('[', raw)' length(raw) + 1];
for section = 1:length(sections) - 1

    % Convert section name
    fieldname = lower(char(strread(raw{sections(section)}, '[%s', 'delimiter', ']')));
    fieldname(isspace(fieldname) == true) = [];

    % Fill structure with parameter value pairs
    switch fieldname
        case {'commoninfos' 'binaryinfos'}
            for line = sections(section) + 1:sections(section + 1) - 1
                [parameter, value] = strread(raw{line}, '%s%s', 'delimiter', '=');
                hdr.(fieldname).(char(parameter)) = char(value);
            end
        case {'channelinfos' 'coordinates' 'markerinfos'}
            for line = sections(section) + 1:sections(section + 1) - 1
                [parameter, value] = strread(raw{line}, '%s%s', 'delimiter', '=');
                hdr.(fieldname)(str2double(parameter{1}(3:end))) = value;
            end
        case 'comment'
            hdr.(fieldname) = raw(sections(section) + 1:sections(section + 1) - 1);
    end
end


% slice out what we need 

% 1st sampling rate
fs = 1000/ str2num(hdr.commoninfos.SamplingInterval) * 1000;

% 2nd label and chan and the scaleFactor for later on
label = {};
scale  = [];
for iChan = 1:size(hdr.channelinfos,2)
	[t scale(iChan)] =  strread(hdr.channelinfos{iChan},'%s%*s%f%*s','delimiter',',');
	label{iChan} = t{1};
end


% info for loading data
meta.eegFile = hdr.commoninfos.DataFile;
meta.DataFormat = hdr.commoninfos.DataFormat;
meta.DataType = hdr.binaryinfos.BinaryFormat;
meta.DataOrientation = hdr.commoninfos.DataOrientation;
meta.scaleFactor  = ones(size(scale));% sacle: tandakun modify 


