%% isolateContent.m
%  Isolate regions of interest in an image and outputs coordinates.
%  v1.0 (c) 2018 wongchoonjie@gmail.com
%
%  Syntax:
%  areaInterest = isolateContent(imgArr, [imgBright, plotBool]);
%
%  imgArr        =  as produced by imread [HxWx(RGB)]
%  imgBright     =  true if image is dark-on-bright, false if b-on-d
%                   (default:true)
%  plotBool      =  draw out images to show the regions returned
%                   (default: false)
%
%  areaInterest  =  [x1,x2,y1,y2] coordinates of all regions found

function areaInterest = isolateContent(imgArr, imgBright, plotBool)
    
    % by default, expect dark on bright images
    if ~exist('imgBright','var')
        imgBright = true;
    end
    
    % by default, do not draw debug images
    if ~exist('plotBool','var')
        plotBool = false;
    end
    
    % img info
    img_w = size(imgArr,2);
    img_h = size(imgArr,1);
    
    
    % convert image to black/white (2-D array)
    img_bw = convertBinaryImg(imgArr, imgBright);

    
    % search for all areas of interest
    areaInterest = [0,0,0,0]; % preallocate - to be removed

    for y = 1:img_h % for each vertical pixel
        for x = 1:img_w % for each horizontal pixel

            [touched,x1,x2,y1,y2] = enlargeInterest(x,x,y,y,img_bw);

            % if that spot is coloured and area of interest is found
            if touched

                % if the area of interest was not already found
                if sum(sum(areaInterest == [x1 x2 y1 y2],2) == 4) == 0
                    % record it
                    areaInterest = [areaInterest; x1 x2 y1 y2];
                end

            end

        end
    end

    % remove first row [0 0 0 0]
    areaInterest = areaInterest(2:end,:);
    
    
    % plot if required
    if plotBool
        
        % convert 2D image data to 3D suitable for image
        figure;
        image( repmat(~img_bw, [1 1 3]) )
        daspect([1 1 1]);
        
        % plot all isolated area of interest
        hold on;
        for i=1:size(areaInterest,1)
            plotInterest(areaInterest(i,:));
        end
        
    end
    

end

% Read an image and convert it to binary colour (black/white)
function img_bw = convertBinaryImg(imgArr, imgBright)
    
    % convert RGB values to binary
    img_binArr = imbinarize(imgArr);
    
    % img_bw contains 0 for boring area, 1 for interested areas
    % if background is bright, img_binArr=1, need to flip
    if imgBright
        img_binArr = ~img_binArr;
    end
    
    % convert to black and white
    img_bw = img_binArr(:,:,1) | img_binArr(:,:,2) | img_binArr(:,:,3);
    
end



% %% Plot area of interest
% 
% for i = 1:size(areaInterest,1)
%     plotInterest(areaInterest(i,1), areaInterest(i,2), areaInterest(i,3), areaInterest(i,4));
% end


%% FUNCTIONS

% Isolate coloured areas
% Pass in coordinate of a pixel (x1=x2, y1=y2). Returns touched=false if
% pixel is not coloured. Returns touched=true and x1,x2,y1,y2 if otherwise.
function [touched,x1,x2,y1,y2] = enlargeInterest(x1,x2,y1,y2,img_bw)
    
    % y1 -------------- 
    %    |            |
    %    |            |
    %    |            |
    %    |            |
    %    |x1          |x2
    % y2 -------------- 
    
    % ... borders touch coloured pixels? if so, enlarge, else, return.
    touched = false;
    
    if y1 > y2
        warning('Check usage of y1 and y2. Expected: y1 <= y2.');
    end
    
    % top border
    for x = x1:x2
        if img_bw(y1,x) == 1
            if y1 > 1 % if y1 not at boundary, otherwise array out of bound
                y1 = y1 - 1;
                touched = true;
                break;
            end
        end
    end
    % bottom border
    for x = x1:x2
        if img_bw(y2,x) == 1
            if y2 < size(img_bw,1)
                y2 = y2 + 1;
                touched = true;
                break;
            end
        end
    end
    
    if x1 > x2
        warning('Check usage of x1 and x2. Expected: x1 <= x2.');
    end
    
    % left border
    for y = y1:y2
        if img_bw(y,x1) == 1
            if x1 > 1
                x1 = x1 - 1;
                touched = true;
                break;
            end
        end
    end
    % right border
    for y = y1:y2
        if img_bw(y,x2) == 1
            if x2 < size(img_bw,2)
                x2 = x2 + 1;
                touched = true;
                break;
            end
        end
    end
    
    % if not ended, run recursively
    if touched
        [~,x1,x2,y1,y2] = enlargeInterest(x1,x2,y1,y2,img_bw);
    end
    
    % return the values
end


% Plot an area of interest given the coordinates
function plotInterest(areaInterest)
    
    x1 = areaInterest(1);
    x2 = areaInterest(2);
    y1 = areaInterest(3);
    y2 = areaInterest(4);

    % y1 -------------- 
    %    |            |
    %    |            |
    %    |            |
    %    |            |
    %    |x1          |x2
    % y2 -------------- 
    
    hold on;
    plot([x1 x1], [y1 y2], 'color', [1 0 0], 'LineWidth', 0.5);
    plot([x2 x2], [y1 y2], 'color', [1 0 0], 'LineWidth', 0.5);
    plot([x1 x2], [y1 y1], 'color', [1 0 0], 'LineWidth', 0.5);
    plot([x1 x2], [y2 y2], 'color', [1 0 0], 'LineWidth', 0.5);

end