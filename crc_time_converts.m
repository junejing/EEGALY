function [time str] = crc_time_converts(secondes)
% FORMAT [time str] = crc_time_converts(secondes)
% Turn duration expressed in seconds into hours, minutes and seconds
%
% Input
% seconds - duration to convert
%
% Output
% time    - 1x3 vector [hour, min, sec]
% str     - same but expressed as a string
%__________________________________________________________________
% Copyright (C) 2009 Cyclotron Research Centre

% Written by Y. Leclercq & C. Phillips, 2008.
% Cyclotron Research Centre, University of Liege, Belgium
% $Id$

if size(secondes,1)<size(secondes,2)
    secondes=secondes';
end

h=round(floor(secondes/60^2)); %ʱ����ȥ��������3600����ȡ������������
reste=mod(secondes,60^2);%resteΪ��������3600������

m=round(floor(reste/60));%�ֲ�������������60����ȡ������������
s=floor(mod(reste,60));%��������ȡ��������60������Ȼ������ȡ��

sms=s+(secondes-h*3600-m*60-s);%smsȡֵΪ�������ֺͲ�ֵ������������ʱ���������������ĺ�

time=[h m sms];

dim=length(secondes); %dimȡֵΪ�����ĳ���
bla=blanks(dim)'; %bla����ֵΪdim���ո�

hou=char(ones(1,dim)'*'h');%����һ��dim*1��Ԫ�ض�Ϊh�ľ���hou
min=char(ones(1,dim)'*'m');%����һ��dim*1��Ԫ�ض�Ϊm�ľ���min
sec=char(ones(1,dim)'*'s');%����һ��dim*1��Ԫ�ض�Ϊs�ľ���char


str=[num2str(h) hou bla num2str(m) min bla num2str(s) sec];