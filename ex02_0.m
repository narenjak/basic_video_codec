video = VideoReader('F:\sem2\DrVahedian\01\output_video.avi');
grayeFrames = uint8(zeros(video.Height, video.Width, 5));

for i = 1: 5
    temp= read(video, 30+i); %با 30 جمع کردم چون فریم های اول چیزی برای تغییر نداشت
    temptogray = rgb2gray(temp);
    grayeFrames(:,:,i) = temptogray(:,:);
end

figure();
for i = 1:5
    subplot(3,3,i);
    imshow(grayeFrames(:,:,i));
end


%coding:
%block size = 8
blockSize = 8;
%Quntization
Q = 8;
numBrow = floor(video.Height / blockSize);
numBcol = floor(video.Width / blockSize);
%first frame 
blocks = uint8(zeros(video.Height, video.Width));
Iframe= grayeFrames(:,:,1);
for row=1:numBrow
    for col=1:numBcol
        row_start = (row - 1) * blockSize + 1;
        row_end = row * blockSize;
        col_start = (col - 1) * blockSize + 1;
        col_end = col * blockSize;
        %save block:
        block = double(Iframe(row_start:row_end, col_start:col_end));
        %calculate dct:
        dct = dct2(block);
        %quantize
        quntize = int8(ceil(dct/Q));
        %zigzag:
        zigzag = Szigzag(quntize);
        %runlength:
        rl = Srunlength(zigzag);
        %save(['rle_block_for_Iframe', num2str(row),'_',num2str(col), '.mat'], "rl");
        % disp(rl);
        % disp(zigzag);
        % decoding:
        % inverse runlength:
        irl = Sirunlength(rl);
        % disp(irl);
        izigzag= Sizigzag(irl,blockSize,blockSize);
        % disp(izigzag);
        iquntize = izigzag*Q;
        idct = idct2(iquntize);
        blocks(row_start:row_end, col_start:col_end) = int8(idct);
    end
end

% for Iframes:
figure();
imshow(blocks);


% for other frames:
% send p 
% 4 because we have 4 frames should be calculate P
blocks_coded   = uint8(zeros(video.Height,video.Width,4));
blocks_Pframes = uint8(zeros(video.Height,video.Width,4));

for frm=2:5
    frm_p = grayeFrames(:,:,frm) - grayeFrames(:,:,frm-1);
    for row=1:numBrow
        for col=1:numBcol
            row_start = (row - 1) * blockSize + 1;
            row_end = row * blockSize;
            col_start = (col - 1) * blockSize + 1;
            col_end = col * blockSize;
            block = double(frm_p(row_start:row_end, col_start:col_end));
            dct = dct2(block);
            quntize = int8(ceil(dct/Q));
            zigzag = Szigzag(quntize);
            rl = Srunlength(zigzag);
            save(['rle_block_for_Pframe_',num2str(frm),'_', num2str(row),'-',num2str(col), '.mat'], "rl");
            irl = Sirunlength(rl);
            izigzag= Sizigzag(irl,blockSize,blockSize);
            iquntize = izigzag*Q;
            idct = idct2(iquntize);
            blocks_Pframes(row_start:row_end, col_start:col_end, frm-1) = int8(idct);
        end
    end
    blocks_coded(:,:,frm-1) = blocks_Pframes(:,:, frm-1) + grayeFrames(:,:, frm-1);
end

figure();
for i = 1:4
    subplot(3,3,i);
    imshow(blocks_coded(:,:,i));
end

figure();
for i = 1:4
    subplot(3,3,i);
    imshow(blocks_Pframes(:,:,i));
end
    
