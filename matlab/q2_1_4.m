%Q2.1.4
close all;
clear all;

cv_cover = imread('../data/cv_cover.jpg');
cv_desk = imread('../data/cv_desk.png');


[locs1, locs2] = matchPics(cv_cover, cv_desk);
h_norm = computeH_norm(locs1, locs2);
h_ransac = computeH_ransac(locs1, locs2);

h = computeH(locs1, locs2);
locs1_3d = locs1;
locs1_3d(:, 3) = 1;

new_points = h * locs1_3d';
new_points(1,:) = new_points(1,:)./new_points(3,:);
new_points(2,:) = new_points(2,:)./new_points(3,:);
new_points = new_points';
new_points = new_points(:,1:2);

new_points_norm = h_norm * locs1_3d';
new_points_norm(1,:) = new_points_norm(1,:)./new_points_norm(3,:);
new_points_norm(2,:) = new_points_norm(2,:)./new_points_norm(3,:);
new_points_norm = new_points_norm';
new_points_norm = new_points_norm(:,1:2);

new_points_ransac = h_ransac * locs1_3d';
new_points_ransac(1,:) = new_points_ransac(1,:)./new_points_ransac(3,:);
new_points_ransac(2,:) = new_points_ransac(2,:)./new_points_ransac(3,:);
new_points_ransac = new_points_ransac';
new_points_ransac = new_points_ransac(:,1:2);

figure;
showMatchedFeatures(cv_cover, cv_desk, locs1, locs2, 'montage');
title('Showing all matches real');

figure;
showMatchedFeatures(cv_cover, cv_desk, locs1, new_points, 'montage');
title('Showing all matches new_points');

figure;
showMatchedFeatures(cv_cover, cv_desk, locs1, new_points_norm, 'montage');
title('Showing all matches new_points_norm');

figure;
showMatchedFeatures(cv_cover, cv_desk, locs1, new_points_ransac, 'montage');
title('Showing all matches new_points_ransac');
