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

h=round(floor(secondes/60^2)); %时部分去秒数除以3600向下取整后四舍五入
reste=mod(secondes,60^2);%reste为秒数除以3600的余数

m=round(floor(reste/60));%分部分用余数除以60向下取整后四舍五入
s=floor(mod(reste,60));%秒数部分取余数除以60的余数然后向下取整

sms=s+(secondes-h*3600-m*60-s);%sms取值为秒数部分和差值（输入秒数和时分秒计算的秒数）的和

time=[h m sms];

dim=length(secondes); %dim取值为秒数的长度
bla=blanks(dim)'; %bla返回值为dim个空格

hou=char(ones(1,dim)'*'h');%产生一个dim*1的元素都为h的矩阵hou
min=char(ones(1,dim)'*'m');%产生一个dim*1的元素都为m的矩阵min
sec=char(ones(1,dim)'*'s');%产生一个dim*1的元素都为s的矩阵char


str=[num2str(h) hou bla num2str(m) min bla num2str(s) sec];