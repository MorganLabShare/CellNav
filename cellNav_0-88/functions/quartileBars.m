function[resY] = quartileBars(randHR)
%%randHR is in the form of dim 1 = data points, dip 2 = groups



w = .15;
for i = 1:size(randHR,2)
    hold on
    b1 = bounds95(randHR(:,i),0.999);
    b2 = bounds95(randHR(:,i),0.5);
    y = [b1(1) b2(1) b1(2) b2(3) b1(3)];
    x = i;
    xb = [x-w *.6 x+w *.6;x-w x+w; x-w x+w; x-w *.6 x+w *.6;x-w x-w;x+w x+w;x x;x x; x-w x+w]
    yb = [y(1) y(1); y(2) y(2);y(4) y(4); y(5) y(5); y(2) y(4); y(2) y(4); y(4) y(5); y(1) y(2); y(3) y(3)];
    plot(xb',yb','k','linewidth',1)
    resY(i,:) = y;
end


