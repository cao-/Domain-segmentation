function z = h1(x, y)
    z = franke(x,y).*(y >= 1/2-1/5*sin(5*x))...
            +(franke(x,y) - 1/2).*(y < 1/2-1/5*sin(5*x));
    
end