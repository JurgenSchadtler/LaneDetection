clc
close all
clear all

video = VideoReader('lane.mp4');
while hasFrame(video)
    img = readFrame(video);
    h_im = imshow(img);
    e = imellipse(gca,[308.692307692308 281.428571428572 424.307692307692 191.642857142857]);
    BW = createMask(e,h_im);
    BW(:,:,2) = BW;
    BW(:,:,3) = BW(:,:,1);
    ROI = img;
    ROI(BW == 0) = 0;
    ROI = rgb2gray(ROI);
    ROI = imgaussfilt(ROI,1);
    BW = im2bw(ROI,0.5);
    %BW = edge(BW,'Sobel');
    [H,T,R] = hough(BW);
    P = houghpeaks(H,5,'threshold',0.1*max(H(:)));
    x = T(P(:,2));
    y = R(P(:,1));
    plot(x,y,'s','color','black');
    lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',7);
    imshow(img), hold on
    max_len = 0;
    for k = 1:length(lines)
       xy = [lines(k).point1; lines(k).point2];
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');
       len = norm(lines(k).point1 - lines(k).point2);
       if ( len > max_len)
          max_len = len;
          xy_long = xy;
       end
    end    
    pause(1/video.FrameRate);
end


