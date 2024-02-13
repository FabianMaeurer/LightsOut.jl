

#=----------------------------------------------------------
    adjacency 
----------------------------------------------------------=#

function adjacent_squares(i::Int, j::Int, n::Int, surface)
    surface == :square && return plain_adjacent_squares(i,j,n)
    surface == :cylinder && return cylinder_adjacent_squares(i,j,n)
    surface == :torus && return torus_adjacent_squares(i,j,n)
    surface == :moebius_strip && return moebius_adjacent_squares(i,j,n)
    surface == :kleinian_bottle && return kleinian_bottle_adjacent_squares(i,j,n)
    surface == :projective_plane && return projective_plane_adjacent_squares(i,j,n)
end

function torus_adjacent_squares(i::Int, j::Int, n::Int)
    [(i,mod(j,n)+1),
     (i,mod(j-2,n)+1),
     (mod(i,n)+1, j),
     (mod(i-2,n)+1, j)]
end

function plain_adjacent_squares(i::Int, j::Int, n::Int)
    # Edge cases
    i ∈ [1,n] && j ∈ [1,n] && return [(i,j == 1 ? 2 : n-1), (i == 1 ? 2 : n-1, j)]
    i ∈ [1,n] && return [(i,j-1), (i,j+1), (i == 1 ? 2 : n-1, j)]
    j ∈ [1,n] && return [(i, j == 1 ? 2 : n-1), (i+1,j), (i-1, j)]

    [(i,j+1),
     (i,j-1),
     (i+1,j),
     (i-1,j)]
end

function cylinder_adjacent_squares(i::Int, j::Int, n::Int)
    if j == 1
        return [(mod(i,n)+1,j), (mod(j-2,n)+1,i), (i, 2)]
    elseif j == n
        return [(mod(i,n)+1,j), (mod(i-2,n)+1,j), (i, n-1)]
    else
        return [(mod(i,n)+1,j),
        (mod(i-2,n)+1,j),
        (i, j+1),
        (i, j-1)]
    end
end

function moebius_adjacent_squares(i::Int, j::Int, n::Int)
    if j == 1
        if i == 1
            return [(n,n), (1,2), (2,1)]
        elseif i == n
            return [(1,n), (n-1,1), (n,2)]
        else
            return [(i-1,1), (i+1,1), (i,2)]
        end
    elseif j == n
        if i == 1
            return [(n,1), (2,n), (1,n-1)]
        elseif i == n
            return [(1,1), (n-1,n), (n,n-1)]
        else
            return [(i-1,n), (i+1,n), (i,n-1)]
        end
    end

    if i == 1 
        return [(1,j+1), (1,j-1), (2,j), (n,n-j+1)]
    elseif i == n
        return [(n,j+1), (n,j-1), (n-1,j), (1,n-j+1)]
    end

    [(i,j+1),
    (i,j-1),
    (i+1,j),
    (i-1,j)]
end

function projective_plane_adjacent_squares(i::Int, j::Int, n::Int)
    # Edge cases
    if i == 1
        if j == 1
            return [(n,n), (1,2), (2,1)]
        elseif j == n
            return [(n,1), (1,n-1), (2,n)]
        else
            return [(1,j-1), (1,j+1), (2,j), (n, n-j+1)]
        end
    elseif i == n
        if j == n 
            return [(1,1), (n-1,n), (n,n-1)]
        elseif j == 1
            return [(1,n), (n-1,1), (n,2)]
        else
            return [(n,j-1), (n,j+1), (1, n-j+1), (n-1, j)]
        end
    end

    if j == 1
        return [(i+1,1), (i-1,1), (n-i+1,n), (i,2)]
    elseif j == n
        return [(i+1,n), (i-1,n), (i,n-1), (n-i+1,1)]
    end

    [(i,j+1),
    (i,j-1),
    (i+1,j),
    (i-1,j)]
end

function kleinian_bottle_adjacent_squares(i::Int, j::Int, n::Int)
    if i == 1
        [(i,mod(j,n)+1),
        (i,mod(j-2,n)+1),
        (i+1,j),
        (n, n - j + 1)]
    elseif i == n
        [(i,mod(j,n)+1),
        (i,mod(j-2,n)+1),
        (1, n - j + 1),
        (n-1, j)]
    else
        [(i,mod(j,n)+1),
        (i,mod(j-2,n)+1),
        (mod(i,n)+1, j),
        (mod(i-2,n)+1, j)]
    end
end

#=----------------------------------------------------------
    adjacency matrices 
----------------------------------------------------------=#    

tuple_index(i,j,n) = (j-1)*n + i

function lights_out_matrix(n::Int, surface::Symbol = :square)
    K = GF(2)
    M = sparse_matrix(K, n^2,n^2)

    indices = [(i,j) for i ∈ 1:n, j ∈ 1:n][:]
    
    for (k,(i,j)) ∈ pairs(indices)
        ind = [tuple_index(i,j,n); [tuple_index(x,y,n) for (x,y) ∈ adjacent_squares(i,j,n, surface)]]
        
        if n <= 3
            ind = unique(ind)
        end

        M[k] = sparse_row(K, ind, [K(1) for _ ∈ ind])
    end

    return M
end

