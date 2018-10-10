function [ H2to1 ] = computeH( x1, x2 )
%COMPUTEH Computes the homography between two sets of points
    n = size(x1, 1);
    h = [];
    for i=1:n
        p1x = x1(i, 1);
        p1y = x1(i, 2);
        p2x = x2(i, 1); 
        p2y = x2(i, 2);

        hx = [-p1x, -p1y, -1, 0, 0, 0, p1x*p2x, p1y*p2x, p2x];
        hy = [0, 0, 0, -p1x, -p1y, -1, p1x*p2y, p1y*p2y, p2y];
        h = [h; [hx; hy]];
    end
    [~, S, V] = svd(h);
    [m, i] = min(diag(S));
    h_svd = V(:,  i);
    H2to1 = reshape(h_svd, [3, 3])';
%     x1(:, 3) = 1;
%     x2(:, 3) = 1;
%     z = H2to1 * x1';
%     aa = x1'./z;
%     aa(1,:) = aa(1,:)./aa(3,:);
%     aa(2,:) = aa(2,:)./aa(3,:);
%     aa(3,:) = 1;
end
