function [H2to1] = computeH_norm(x1, x2)

%% Compute centroids of the points

centroid1 = mean(x1);
centroid2 = mean(x2);

%% Shift the origin of the points to the centroid
x1_c = x1 - centroid1;
x2_c = x2 - centroid2;

%% Normalize the points so that the average distance from the origin is equal to sqrt(2).
x1_c2 = x1_c.^2;
x2_c2 = x2_c.^2;
B_1 = sqrt(2) / (sum(sqrt(x1_c2(:,1) + x1_c2(:,2)))/(length(x1)));
B_2 = sqrt(2) / (sum(sqrt(x2_c2(:,1) + x2_c2(:,2)))/(length(x2)));

x1_norm = x1_c * B_1;
x2_norm = x2_c * B_2;

%% similarity transform 1
T1 = computeH(x1, x1_norm);
%% similarity transform 2
T2 = computeH(x2, x2_norm);

%% Compute Homography
H = computeH(x1_norm, x2_norm);

%% Denormalization
H2to1 = inv(T2)*H*T1;
