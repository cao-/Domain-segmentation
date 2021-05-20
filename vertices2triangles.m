function VT = vertices2triangles(T, N)

VT = cell(N, 1);

for i = 1:size(T, 1)
    for j =1:3
        VT(T(i, j)) = {[VT{T(i, j)}, i]};
    end
end

end

