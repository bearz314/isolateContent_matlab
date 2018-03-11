clear, clc, close all;

% Syntax:
% areaInterest = isolateContent(imgArr, [imgBright, plotBool]);
%
% imgArr        =  as produced by imread
% imgBright     =  true if image is dark-on-bright, false if b-on-d
%                  (default:true)
% plotBool      =  draw out images to show the regions returned
%                  (default: false)
%
% areaInterest  =  [x1,x2,y1,y2] coordinates of all regions found

%% SAMPLE 1
%  Coordinates of scatter plot can be calculated with further processing

imgArr = imread('sample_graph.png'); % return HxWx(RGB)
% figure; image(imgArr); % to know the coordinates to exclude axis
imgArr = imgArr(100:600,250:900,:);
areaInterest = isolateContent(imgArr, true, true);


%% SAMPLE 2
%  Low contrast image, shows the potential pitfall of script
%  To improve result, imbinarize yourself, and pass in as imgArr

imgArr = imread('sample_buttons.jpg'); % return HxWx(RGB)
areaInterest = isolateContent(imgArr, true, true);


%% SAMPLE 3
%  Bright-on-dark images

imgArr = imread('sample_bullets.jpg'); % return HxWx(RGB)
areaInterest = isolateContent(imgArr, false, true);