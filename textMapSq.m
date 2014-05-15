function newImg = textMapSq(img, ReconPts, EpiPts)

global IC Image focal offsetX offsetY

H = homography2d(ReconPts', EpiPts');
[line1, line2, line3, line4] = sqBoundPts(round(ReconPts(:,1:2)));

[Y, I] = sort(ReconPts(:,2), 'descend');
if I(1) == 1
    if I(3) == 4
        startVec = [line3; flipud(line2)];
        endVec = [flipud(line4); line1];
    elseif I(3) == 3
        startVec = [line3; flipud(line2); line1];
        endVec = flipud(line4);
    end
elseif I(1) == 2
    if I(3) == 4
        startVec = flipud(line2);
        endVec = [line3; flipud(line4); line1];
    elseif I(3) == 3
        startVec = [line3; flipud(line2)];
        endVec = [flipud(line4); line1];
    end
end

cnt = 1;
for j=round(ReconPts(I(4),2)):round(ReconPts(I(1),2)),
    x = round(IC(1)-startVec(cnt,1));
    y = round(IC(2)-j);
    coord = H*[startVec(cnt,1) j focal]';
    coord = focal*(coord/coord(3));
    coord(1) = round(IC(1)-coord(1));
    coord(2) = round(IC(2)-coord(2));
    img(offsetY+y, offsetX+x, 1) = Image(coord(2), coord(1), 1);
    img(offsetY+y, offsetX+x, 2) = Image(coord(2), coord(1), 2); 
    img(offsetY+y, offsetX+x, 3) = Image(coord(2), coord(1), 3);
    for i=round(startVec(cnt,1))-1:-1:round(endVec(cnt,1)),
        x = round(IC(1)-i);
        y = round(IC(2)-j);
        coord = H*[i j focal]';
        coord = focal*(coord/coord(3));
        coord(1) = round(IC(1)-coord(1));
        coord(2) = round(IC(2)-coord(2));
    img(offsetY+y, offsetX+x, 1) = Image(coord(2), coord(1), 1);
    img(offsetY+y, offsetX+x, 2) = Image(coord(2), coord(1), 2); 
    img(offsetY+y, offsetX+x, 3) = Image(coord(2), coord(1), 3);
    end
    cnt = cnt + 1;
end

newImg = img;