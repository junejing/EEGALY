function magnifier(mask, FPS)
% MAGNIFIER - GUI demonstration of a real time magnifier
% MAGNIFIER(mask, FPS) displays a default cartoon image and a magnifier whose
% window shape is specified by mask. The value of mask can be one of the 
% following:
%  'circle' - an unsmoothed circular window
%  'gaussian' - a gaussian window saturated in the center (default)
%  all other values - a square window
% FPS specifies the frame rate measured in frame/second. By default, its
% value is 30;
%% Data Verification
if nargin < 2
    FPS = 20; % The frame rate
end
if nargin < 1
    mask = 'gaussian';
end

%% Read the picture
load('ali.mat','img_rgb');
img_rgb = double(img_rgb)./255;
size_img = size(img_rgb);

%% Define Constants
MagPower = 2;       % Magnifying Power
MagRadius = 100;    % The Radius of the Magnifier
PreMagRadius = MagRadius./MagPower; % The radius of the image to be magnified


%% Create Figure and Axes 
close all;

% Sizes of Figures and Axes
MainAxesSize = size_img([2,1]);
MainFigureSize = MainAxesSize;
MainFigureInitPos = [300 50];
MainAxesInitPos = [0 0];

% Open Figures and Axes
MainFigureHdl = figure('Name', 'Magnifier Demo v0.01', ...
    'NumberTitle' ,'off', ...
    'Units', 'pixels', ...
    'Position', [MainFigureInitPos, MainFigureSize], ...
    'MenuBar', 'figure', ...
    'Renderer', 'opengl',...
    'WindowButtonMotionFcn', @stl_magnifier_WindowButtonMotionFcn);
MainAxesHdl = axes('Parent', MainFigureHdl, ...
    'Units', 'normalized',...
    'Position', [MainAxesInitPos, 1-MainAxesInitPos.*2], ...
    'color', [0 0 0], ...
    'XLim', [1 MainAxesSize(1)], ...
    'YLim', [1 MainAxesSize(2)], ...
    'YDir', 'reverse', ...
    'NextPlot', 'add', ...
    'Visible', 'on');

%% Create the image and the mask

% The main background image object
img_hdl = image(0,0,img_rgb); 

% The magnified image object
mag_img_hdl = image(0,0,[],'Parent',MainAxesHdl);
mag_img = img_rgb(1:PreMagRadius*2+1,1:PreMagRadius*2+1,:);

% The mask image
if strcmp(mask, 'circle')
    [x y] = meshgrid(-PreMagRadius:PreMagRadius);
    mask_img = double((x.^2+y.^2)<=PreMagRadius.^2);
elseif strcmp(mask, 'gaussian')
    [x y] = meshgrid(-PreMagRadius:PreMagRadius);
    sigma = PreMagRadius./4;
    mask_img = 16*exp(-(x.^2+y.^2)./(2*sigma.^2));
    mask_img(mask_img > 1) = 1;
else
    mask_img = ones(PreMagRadius.*2+1,PreMagRadius.*2+1);
end

% Initialize the image object
set(mag_img_hdl, 'CData',mag_img, 'AlphaData', mask_img);

%% Let's roll!
alreadyDrawn = 0;
start_time = tic;

%% WindowButtonMotion Function for the Figure
    function stl_magnifier_WindowButtonMotionFcn(obj,event)
        cur_time = toc(start_time);
        curFrameNo = floor(cur_time.*FPS);
        
        % If this frame has not been draw yet
        if alreadyDrawn < curFrameNo
            
            mag_pos = get(obj,'CurrentPoint');
            mag_pos(2) = MainAxesSize(2) - mag_pos(2)+1;
            % The size of the part of the image to be magnified
            % The range has to be cropped in case it is outside the
            % image.
            mag_x = mag_pos(1)+[-PreMagRadius PreMagRadius];
            mag_x_cropped = min(max(mag_x, 1),size_img(2));
            mag_y = mag_pos(2)+[-PreMagRadius PreMagRadius];
            mag_y_cropped = min(max(mag_y, 1),size_img(1));
            % Take the magnified part of the image
            mag_img([mag_y_cropped(1):mag_y_cropped(2)]-mag_pos(2)+PreMagRadius+1,...
                [mag_x_cropped(1):mag_x_cropped(2)]-mag_pos(1)+PreMagRadius+1,:) = ...
                img_rgb(mag_y_cropped(1):mag_y_cropped(2),...
                mag_x_cropped(1):mag_x_cropped(2),:);
            
            % Show the image as twice its actual size
            set(mag_img_hdl, 'CData', mag_img, ...
            'XData', mag_pos(1)+[-MagRadius MagRadius], ...
            'YData', mag_pos(2)+[-MagRadius MagRadius]);
        
            % Update the object
            drawnow;
            alreadyDrawn = curFrameNo;
        end
    end
end