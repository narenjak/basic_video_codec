video = VideoReader('F:\sem2\DrVahedian\02\output_video.avi');
grayeFrames = uint8(zeros(video.Height, video.Width, 3));

for i = 1: 3
    temp= read(video, 30+i); %با 30 جمع کردم چون فریم های اول چیزی برای تغییر نداشت
    temptogray = rgb2gray(temp);
    grayeFrames(:,:,i) = temptogray(:,:);
end

% figure();
% for i = 1:5
%     subplot(3,3,i);
%     imshow(grayeFrames(:,:,i));
% end


%coding:

%block size = 8
blockSize = 8;
%Quntization
Q = 8;

numBrow = floor(video.Height / blockSize);
numBcol = floor(video.Width / blockSize);

%first frame 
first_frame = uint8(zeros(video.Height, video.Width));
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
        % save(['rle_block_for_Iframe', num2str(row),'_',num2str(col), '.mat'], "rl");
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
        first_frame(row_start:row_end, col_start:col_end) = int8(idct);
    end
end

% for Iframes:
% figure();
% imshow(first_frame);

% for other frames:
% send p 
%this time, just for 2 and 3
% 2 because we have 2 frames should be calculate P

blocks_coded   = uint8(zeros(video.Height,video.Width,2));
blocks_Pframes = uint8(zeros(video.Height,video.Width,2));

search_range = 4;
z = struct('motion_vectors', zeros(ceil(video.Height/blockSize) * ceil(video.Width/blockSize), 2), ...
    'block_indices', zeros(ceil(video.Height/blockSize) * ceil(video.Width/blockSize), 2));
for frm=2:3
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
            irl = Sirunlength(rl);
            izigzag= Sizigzag(irl,blockSize,blockSize);
            iquntize = izigzag*Q;
            idct = idct2(iquntize);
            blocks_Pframes(row_start:row_end, col_start:col_end, frm-1) = int8(idct);   
        end
    end
    blocks_coded(:,:,frm-1) = blocks_Pframes(:,:, frm-1) + grayeFrames(:,:, frm-1);
    z = SmotionEstimation(blocks_coded(:,:,frm-1), grayeFrames(:,:,1), blockSize, search_range);
end

% numberOfFrame = 2;
final_info = struct('motion_vectors', zeros(ceil(video.Height/blockSize) * ceil(video.Width/blockSize), 2), ...
    'block_indices', zeros(ceil(video.Height/blockSize) * ceil(video.Width/blockSize), 2), ...
    'blocks_CoDec', uint8(zeros(blockSize,blockSize)));
% 'blocks_CoDec', uint8(zeros(blockSize,blockSize,numberOfFrame)));

% for frm=1:2
    for i=1:video.Height/blockSize*video.Width/blockSize
        final_info.motion_vectors(i, :) = z.motion_vectors(i,:);
        final_info.block_indices(i, :)= z.block_indices(i,:);
    end
% end
% for frm=1:2
    for i = 1:blockSize:video.Height-blockSize+1
        for j = 1:blockSize:video.Width-blockSize+1
            final_info.blocks_CoDec(i:i+blockSize-1,j:j+blockSize-1,:)=blocks_Pframes(i:i+blockSize-1,j:j+blockSize-1);
        end
    end
% end

% figure();
% for i = 1:2
%     subplot(2,2,i);
%     imshow(blocks_coded(:,:,i));
% end
% 
% figure();
% for i = 1:2
%     subplot(2,2,i);
%     imshow(blocks_Pframes(:,:,i));
% end

save(['final_info', '.mat'], "final_info");
        
disp(final_info);
