%تبدیل ابعاد ویدئو دوم به ویدئو اول، چون برای  اضافه کردن فریم های فایل دوم
%به اول باید ابعادشان یکسان باشد

%ابعاد فایل اول و به تبع آن خروجی 960 در 400  باید اشد

video2 = VideoReader('F:\sem2\DrVahedian\sample_1280x720.avi');
% اطلاعات ابعاد فریم‌ها ویدیو دوم
video2Width = video2.Width;
video2Height = video2.Height;

% تبدیل ابعاد ویدیو دوم به 960در400
desiredWidth = 960;
desiredHeight = 400;

newVideoFrames = VideoWriter('F:\sem2\DrVahedian\sample_960x400.avi', 'Uncompressed AVI');

open(newVideoFrames);

while hasFrame(video2)
    frame = readFrame(video2);
    resizedFrame = imresize(frame, [desiredHeight, desiredWidth]);
    writeVideo(newVideoFrames, resizedFrame);
end

close(newVideoFrames);


% باز کردن ویدیو اول
video1 = VideoReader('F:\sem2\DrVahedian\sample_960x400_ocean_with_audio.avi');
disp(video1);
% باز کردن ویدیو دوم
video2 = VideoReader('sample_960x400.avi');
disp(video2);


% تعیین مشخصات ویدیو خروجی
outputVideo = VideoWriter('F:\sem2\DrVahedian\output_video.avi', 'Uncompressed AVI');
open(outputVideo);

% اضافه کردن تمام فریم‌های ویدیو اول به ویدیو خروجی
while hasFrame(video1)
    frame = readFrame(video1);
    writeVideo(outputVideo, frame);
end

% اضافه کردن تعدادی فریم از ویدیو دوم به ویدیو خروجی
numFrames = 677; %چون تعداد فریم های ویدئو دومم 677تا بود
for i = 1:numFrames
    frame = readFrame(video2);
    writeVideo(outputVideo, frame);
end

close(outputVideo);

%نوع اول
video = VideoReader('F:\sem2\DrVahedian\output_video.avi');
nFrames = 70; %همینطوری برای اینکه پردازش سنگین نشه
for i = 40:nFrames
    frame = readFrame(video);

    R = frame(:,:,1);
    G = frame(:,:,2);
    B = frame(:,:,3);

    figure;
    subplot(1, 3, 1); 
    imshow(R); 
    title('Red Channel');

    subplot(1, 3, 2); 
    imshow(G); 
    title('Green Channel');

    subplot(1, 3, 3); 
    imshow(B); 
    title('Blue Channel');
end


%نوع دوم
video = VideoReader('F:\sem2\DrVahedian\output_video.avi');
nFrames = 70; %همینطوری برای اینکه پردازش سنگین نشه
for i = 40:nFrames
    
    figure;

    frame = read(video,i);
    subplot(1, 3, 1); 
    frame(:,:,2)=0;
    frame(:,:,3)=0;
    imshow(frame); 
    title('Red Channel');

    frame = read(video,i);
    subplot(1, 3, 2); 
    frame(:,:,1)=0;
    frame(:,:,3)=0;
    imshow(frame); 
    title('Green Channel');

    frame = read(video,i);
    subplot(1, 3, 3); 
    frame(:,:,1)=0;
    frame(:,:,2)=0;
    imshow(frame);  
    title('Blue Channel');
end

video = VideoReader('F:\sem2\DrVahedian\output_video.avi');


while hasFrame(video)

    frame = readFrame(video);
    grayFrame = rgb2gray(frame);
    dctFrame = dct2(grayFrame);
    
    figure;
    imshow(dctFrame);
    drawnow;
end

Cb_frames = [];
Cr_frames = [];
Y_frames = [];

Cb_422 = [];
Cr_422 = [];
Y = [];

while hasFrame(video)

    frame = readFrame(video);

    YCbCr_frame = rgb2ycbcr(frame);

    Y_frame = YCbCr_frame(:, :, 1);
    Cb_frame = YCbCr_frame(:, :, 2);
    Cr_frame = YCbCr_frame(:, :, 3);

    Y = cat(3, Y, Y_frame);
    
    %4:2:2
    if mod(frameCount, 2) == 0
        Cb_422 = cat(3, Cb_422, Cb_frame);
        Cr_422 = cat(3, Cr_422, Cr_frame);
    end

    frameCount = frameCount + 1;
end

disp(size(Y));
disp(size(Cb_422));
disp(size(Cr_422));