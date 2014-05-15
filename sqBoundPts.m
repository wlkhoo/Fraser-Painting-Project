function [line1, line2, line3, line4] = sqBoundPts(pt)

line1 = zeros(abs(pt(2,2)-pt(1,2)), 2);
m1 = (pt(2,2)-pt(1,2))/(pt(2,1)-pt(1,1));
b1 = pt(2,2) - m1*pt(2,1);
cnt = 1;
for i=min([pt(1,2) pt(2,2)]):max([pt(1,2) pt(2,2)]),
    x = (i-b1)/m1;
    line1(cnt,:) = [round(x) i];
    cnt = cnt + 1;
end

line2 = zeros(abs(pt(2,2)-pt(3,2)), 2);
cnt = 1;
if abs(pt(2,1)-pt(3,1)) <= 1
    for j=max([pt(2,2) pt(3,2)]):-1:min([pt(2,2) pt(3,2)]),
        line2(cnt,:) = [round(pt(2,1)) j];
        cnt = cnt + 1;
    end
else
    m2 = (pt(3,2)-pt(2,2))/(pt(3,1)-pt(2,1));
    b2 = pt(3,2) - m2*pt(3,1);
    for j=max([pt(2,2) pt(3,2)]):-1:min([pt(2,2) pt(3,2)]),
        x = (j-b2)/m2;
        line2(cnt,:) = [round(x) j];
        cnt = cnt + 1;
    end
end

line3 = zeros(abs(pt(4,2)-pt(3,2)), 2);
m3 = (pt(4,2)-pt(3,2))/(pt(4,1)-pt(3,1));
b3 = pt(4,2) - m3*pt(4,1);
cnt = 1;
for k=min([pt(3,2) pt(4,2)]):max([pt(3,2) pt(4,2)]),
    x = (k-b3)/m3;
    line3(cnt,:) = [round(x) k];
    cnt = cnt + 1;
end

line4 = zeros(abs(pt(1,2)-pt(4,2)), 2);
cnt = 1;
if abs(pt(1,1)-pt(4,1)) <= 1
    for l=max([pt(1,2) pt(4,2)]):-1:min([pt(1,2) pt(4,2)]),
        line4(cnt,:) = [round(pt(1,2)) l];
        cnt = cnt + 1;
    end
else
    m4 = (pt(4,2)-pt(1,2))/(pt(4,1)-pt(1,1));
    b4 = pt(4,2) - m4*pt(4,1);
    for l=max([pt(1,2) pt(4,2)]):-1:min([pt(1,2) pt(4,2)]),
        x = (l-b4)/m4;
        line4(cnt,:) = [round(x) l];
        cnt = cnt + 1;
    end
end