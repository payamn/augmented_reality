% Your solution to Q2.1.5 goes here!


%% Read the image and convert to grayscale, if necessary
cv_cover = imread('../data/cv_cover.jpg');
if (ndims(cv_cover) == 3)
        cv_cover = rgb2gray(cv_cover);
end

%% Compute the features and descriptors
feature1_FEAST = detectFASTFeatures(cv_cover);
feature1_SURF = detectSURFFeatures(cv_cover);

[desc_main_FEAST, locst_main_FEAST]  = computeBrief(cv_cover, feature1_FEAST.Location);
[desc_main_SURF, locst_main_SURF]  = extractFeatures(cv_cover, feature1_SURF.Location);
histogram_rot_FEAST = zeros(37, 1);
histogram_rot_SURF = zeros(37, 1);
image_counter = 1;
figure('name', 'images matched');
for i = 0:36
    %% Rotate image
    rot_cover = imrotate(cv_cover, i*10);
    
    %% Compute features and descriptors
    feature_rotate_FEAST = detectFASTFeatures(rot_cover);
    feature_rotate_SURF = detectSURFFeatures(rot_cover);

    [desc_rot_FEAST, locst_rot_FEAST]  = computeBrief(rot_cover, feature_rotate_FEAST.Location);
    [desc_rot_SURF, locst_rot_SURF]  = extractFeatures(rot_cover, feature_rotate_SURF.Location);
    
    %% Match features
    indexPairs_FEAST = matchFeatures(desc_main_FEAST , desc_rot_FEAST , 'MatchThreshold', 70, 'MaxRatio', 0.67);
    indexPairs_SURF = matchFeatures(desc_main_SURF, desc_rot_SURF, 'MatchThreshold', 70, 'MaxRatio', 0.67);
    

    
    %% Update histogram
    histogram_rot_SURF(i+1) = length(indexPairs_SURF);
    histogram_rot_FEAST(i+1) = length(indexPairs_FEAST);
        
    locst_main_paired_FEAST = locst_main_FEAST(indexPairs_FEAST(:,1),:);
    locst_main_paired_SURF = locst_main_SURF(indexPairs_SURF(:,1),:);

    locst_rot_paired_FEAST = locst_rot_FEAST(indexPairs_FEAST(:,2),:);
    locst_rot_paired_SURF = locst_rot_SURF(indexPairs_SURF(:,2),:);
    
    if mod(i, 8) ==0
        subplot(5,2,image_counter);
        showMatchedFeatures(cv_cover, rot_cover, locst_main_paired_SURF, locst_rot_paired_SURF, 'montage');
        title(strcat('Showing all matches ', string(i*10), " degree  SURF"));
        subplot(5,2,5+image_counter);
        showMatchedFeatures(cv_cover, rot_cover, locst_main_paired_FEAST, locst_rot_paired_FEAST, 'montage');
        title(strcat('Showing all matches ', string(i*10), " degree  FEAST"));
        image_counter = image_counter +1;
    end
end
%% Display histogram

figure('name','Histogram');
subplot(2,2,1)
bar([0:10:360], histogram_rot_FEAST);
set(gca,'xtick',[0:10:360]);
set(gca, 'ytick', [0:30:max(histogram_rot_FEAST)]);
xlabel("Degree");
ylabel("Matched features");
title('Bar FEAST')  

subplot(2,2,2)
hist(histogram_rot_FEAST,100);
set(gca,'xtick',[0:20:max(histogram_rot_FEAST)]);
xlabel("Matched features");
ylabel("Number of degree with that matched features");
title('Histogram FEAST')  

subplot(2,2,3)
bar([0:10:360], histogram_rot_SURF);
set(gca,'xtick',[0:10:360]);
set(gca, 'ytick', [0:30:max(histogram_rot_SURF)]);
xlabel("Degree");
ylabel("Matched features");
title('Bar SURF')  

subplot(2,2,4)
hist(histogram_rot_SURF,100);
set(gca,'xtick',[0:20:max(histogram_rot_SURF)]);
xlabel("Matched features");
ylabel("Number of degree with that matched features");
% set(gca, 'ytick', [0:35]);
title('Histogram SURF')  
