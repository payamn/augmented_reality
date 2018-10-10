function [ locs1, locs2] = matchPics( I1, I2 )

%MATCHPICS Extract features, obtain their descriptors, and match them!

%% Convert images to grayscale, if necessary
if (ndims(I1) == 3)
        I1 = rgb2gray(I1);
end

if (ndims(I2) == 3)
        I2 = rgb2gray(I2);
end

%% Detect features in both images
feature1 = detectFASTFeatures(I1);
feature2 = detectFASTFeatures(I2);

%% Obtain descriptors for the computed feature locations
[desc1, locst1]  = computeBrief(I1, feature1.Location);
[desc2, locst2]  = computeBrief(I2, feature2.Location);

%% Match features using the descriptors
indexPairs = matchFeatures(desc1, desc2, 'MatchThreshold', 90, 'MaxRatio', 0.67);
locs1 = locst1(indexPairs(:,1),:);
locs2 = locst2(indexPairs(:,2),:);

end

