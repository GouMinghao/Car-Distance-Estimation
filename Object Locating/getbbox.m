function bbox = getbbox(b)
    [h,w] = size(b);
    xmin = w;
    ymin = h;
    xmax = 1;
    ymax = 1;
    for y = 1 : h
        for x = 1 : w
            if (b(y,x) == 1)
                xmin = min(xmin,x);
                ymin = min(ymin,y);
                xmax = max(xmax,x);
                ymax = max(ymax,y);
            end
        end
    end
    bbox = [xmin,ymin,xmax - xmin,ymax - ymin];
end
