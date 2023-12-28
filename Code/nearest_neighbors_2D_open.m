function [val, pos] = nearest_neighbors_2D_open(G, i, j)
% Takes a matrix 'G' and position indices 'i', 'j'. Returns a values-vector
% 'val' and a positions-matrix 'pos' (a column per element: [row; column])
% of nearest neighboring elements to G(i,j).

%%% NOTE: Considers "open" boundaries: G(L+1,L+1) := G(1,1).

L = size(G, 1);

if i ~= 1
    if i ~= L
        if j ~= 1 
            if j ~= L % Inner element
                val = [G(i-1,j), G(i+1,j), G(i,j-1), G(i,j+1)];
                pos = [i-1, i+1, i, i; j, j, j-1, j+1];
            else % Inner right side
                val = [G(i-1,j), G(i+1,j), G(i,j-1), G(i,1)];
                pos = [i-1, i+1, i, i; j, j, j-1, 1];
            end
        else % Inner left side
            val = [G(i-1,j), G(i+1,j), G(i,L), G(i,j+1)];
            pos = [i-1, i+1, i, i; j, j, L, j+1];
        end
    elseif j ~= 1 
        if j ~= L % Inner bottom
            val = [G(i-1,j), G(1,j), G(i,j-1), G(i,j+1)];
            pos = [i-1, 1, i, i; j, j, j-1, j+1];
        else % Bottom-right corner
            val = [G(i-1,j), G(1,j), G(i,j-1), G(i,1)];
            pos = [i-1, 1, i, i; j, j, j-1, 1];
        end
    else % Bottom-left corner
        val = [G(i-1,j), G(1,j), G(i,L), G(i,j+1)];
        pos = [i-1, 1, i, i; j, j, L, j+1];
    end
elseif j ~= 1
    if j ~= L % Inner top
        val = [G(L,j), G(i+1,j), G(i,j-1), G(i,j+1)];
        pos = [L, i+1, i, i; j, j, j-1, j+1];
    else % Top-right corner
        val = [G(L,j), G(i+1,j), G(i,j-1), G(i,1)];
        pos = [L, i+1, i, i; j, j, j-1, 1];
    end
else % Top-left corner
    val = [G(L,j), G(i+1,j), G(i,L), G(i,j+1)];
    pos = [L, i+1, i, i; j, j, L, j+1];
end
