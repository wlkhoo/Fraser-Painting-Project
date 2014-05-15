close all
clear all

load ../ReconstructPtsLeft.mat ReconstructPtsLeft
load ../ReconstructPtsMiddle.mat ReconstructPtsMiddle
load ../ReconstructPtsRight.mat ReconstructPtsRight
load ../ReconBonePts.mat ReconBonePts
% load ../ReconButterflyPts.mat ReconButterflyPts
% load ../ReconGlassPts.mat ReconGlassPts
% load ../ReconHandMirrorPts.mat ReconHandMirrorPts

load ../EpipolarPointsLeftMirror.mat EpipolarPointsLeftMirror
load ../EpipolarPointsMiddleMirror.mat EpipolarPointsMiddleMirror
load ../EpipolarPointsRightMirror.mat EpipolarPointsRightMirror
load ../bonePts.mat bonePts
% load ../butterflyPts.mat butterflyPts
% load ../glassPts.mat glassPts
% load ../handMirrorPts.mat handMirrorPts

%% setup
global IC Image focal offsetX offsetY
IC = [868.5843 526.8291];
focal = 2050.7;

Image = imread('../Fraser3WayVanitasOil.tif');
figure;
title('3-D Reconstruction');
xlabel('x');
ylabel('y');
axis ij;
hold on

offsetX = 3*size(Image,1);
offsetY = size(Image,2);
img = 255.*ones(3*size(Image,1), 5*size(Image,2), size(Image,3), 'uint8');

R_val = [0 40 0];
T_val = [0 0 0];

M_ext = zeros(3,4);
M_ext(1,:) = [cosd(R_val(2))*cosd(R_val(3)) -cosd(R_val(2))*sind(R_val(3)) cosd(R_val(1))*sind(R_val(2)) T_val(1)];
M_ext(2,:) = [-sind(R_val(1))*sind(R_val(2))*cosd(R_val(3))+cosd(R_val(1))*sind(R_val(3)) sind(R_val(1))*sind(R_val(2))*sind(R_val(3))+cosd(R_val(1))*cosd(R_val(3)) sind(R_val(1)) T_val(2)];
M_ext(3,:) = [cosd(R_val(1))*sind(R_val(2))*cosd(R_val(3))+sind(R_val(1))*sind(R_val(3)) -cosd(R_val(1))*sind(R_val(2))*sind(R_val(3))+sind(R_val(1))*cosd(R_val(3)) cosd(R_val(1))*cosd(R_val(2)) T_val(3)];

M_int = zeros(3,3);
M_int(1,:) = [-focal 0 IC(1)];
M_int(2,:) = [0 -focal IC(2)];
M_int(3,:) = [0 0 1];

M = M_int*M_ext;

PtsLeft = zeros(size(ReconstructPtsLeft));
PtsMid = zeros(size(ReconstructPtsMiddle(3:6,:)));
PtsRight = zeros(size(ReconstructPtsRight));
PtsBone = zeros(size(ReconBonePts));

for i=1:size(ReconstructPtsLeft,1),
    temp = M*[ReconstructPtsLeft(i,:) 1]';
    PtsLeft(i,:) = [IC(1)-(temp(1)/temp(3)) IC(2)-(temp(2)/temp(3)) focal];
end

for i=3:size(ReconstructPtsMiddle,1),
    temp = M*[ReconstructPtsMiddle(i,:) 1]';
    PtsMid(i-2,:) = [IC(1)-(temp(1)/temp(3)) IC(2)-(temp(2)/temp(3)) focal];
end

for i=1:size(ReconstructPtsRight,1),
    temp = M*[ReconstructPtsRight(i,:) 1]';
    PtsRight(i,:) = [IC(1)-(temp(1)/temp(3)) IC(2)-(temp(2)/temp(3)) focal];
end

for i=1:size(ReconBonePts,1),
    temp = M*[ReconBonePts(i,:) 1]';
    PtsBone(i,:) = [IC(1)-(temp(1)/temp(3)) IC(2)-(temp(2)/temp(3)) focal];
end

% image(Image);
% tri = delaunay(ReconBonePts(:,1), ReconBonePts(:,2), {'Qt','Qbb','Qc','Qz'});
% triplot(tri, IC(1)-ReconBonePts(:,1), IC(2)-ReconBonePts(:,2), 'g');
% 
% tri2 = delaunay(bonePts(:,1), bonePts(:,2), {'Qt','Qbb','Qc','Qz'});
% triplot(tri2, IC(1)-bonePts(:,1), IC(2)-bonePts(:,2), 'g');

img = textMapSq(img, PtsLeft, EpipolarPointsLeftMirror);
img = textMapSq(img, [PtsMid(1,:); PtsMid(4,:); PtsMid(3,:); PtsMid(2,:)], [EpipolarPointsMiddleMirror(3,:); EpipolarPointsMiddleMirror(6,:); EpipolarPointsMiddleMirror(5,:); EpipolarPointsMiddleMirror(4,:)]);
img = textMapSq(img, [PtsRight(4,:); PtsRight(1,:); PtsRight(2,:); PtsRight(3,:)], [EpipolarPointsRightMirror(4,:); EpipolarPointsRightMirror(1,:); EpipolarPointsRightMirror(2,:); EpipolarPointsRightMirror(3,:)]);

% img = textMapTri(img, PtsBone, bonePts); 

image(img);
zoom(2);
