function z = h2(x,y)
   z = ((x - 0.5).^2 + (y - 0.5).^2 < 0.2^2).*x.^2 + ((x - 0.5).^2 + (y - 0.5).^2 >= 0.2^2).*(y.^2 -1/2);
end