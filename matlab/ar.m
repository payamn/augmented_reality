% Q3.3.1
book_vid = loadVid("../data/book.mov");
source_vid = loadVid("../data/ar_source.mov");
cv_img = imread('../data/cv_cover.jpg');
v = VideoWriter('../results/ar.avi');
open(v)

source_index = 1;
previous_h = -1;
for i = 1: length(book_vid)
    [locs1, locs2] = matchPics(cv_img, book_vid(i).cdata);
    [bestH2to1, inliar] = computeH_ransac(locs2, locs1);
    if inliar <= length(locs1)*0.90
        bestH2to1 = previous_h;
    else
        previous_h = bestH2to1;
    end
    
    % only happens if in the first couple of frames computeH couldnt find a good match so we
    % skip those frames
    if bestH2to1 == -1
        continue
    end
    scaled_hp_img = imresize(source_vid(source_index).cdata, [size(cv_img,1) size(cv_img,2)]);
    combined = compositeH(bestH2to1, scaled_hp_img, book_vid(i).cdata);
    writeVideo(v, combined)
    imshow(combined);
    if source_index < length(source_vid)
        source_index = source_index+ 1
    end
end
close(v)