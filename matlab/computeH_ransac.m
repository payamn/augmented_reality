function [ bestH2to1, inliers] = computeH_ransac( locs1, locs2)
%COMPUTEH_RANSAC A method to compute the best fitting homography given a
% calculate all combinations of 5
c_5 = combnk(1:length(locs1), 10);
n_iterations = min(size(c_5, 1), 1000);

locs1_3d = locs1;
locs1_3d(:, 3) = 1;
bestH2to1 = -1;
inliers =  0;
for i=1: n_iterations
    locs1_s = locs1(c_5(i,:),:);
    locs2_s = locs2(c_5(i,:),:);
    h = computeH_norm(locs1_s, locs2_s);
    new_points = h * locs1_3d';
    new_points(1,:) = new_points(1,:)./new_points(3,:);
    new_points(2,:) = new_points(2,:)./new_points(3,:);
    new_points = new_points';   
    new_points = new_points(:,1:2);
    dist = (new_points - locs2) .^ 2;
    dist = dist(:,1) + dist(:,2);
    dist = dist < 1;
    in_lier = sum(dist);
    if inliers <= in_lier
        bestH2to1 = h;
        inliers = in_lier;
    end
end
%list of matching points.

%Q2.2.3
end

