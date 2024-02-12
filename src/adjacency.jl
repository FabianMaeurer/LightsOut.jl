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

function moebius_adjacent_squares(i::Int, j::Int, n::Int)
    i ∈ [1,n] && return [(i,mod(j-2,n)+1), (i,mod(j,n)+1), (i == 1 ? 2 : n-1, j)]

    [(i,mod(j,n)+1),
     (i,mod(j-2,n)+1),
     (mod(i,n)+1, j),
     (mod(i-2,n)+1, j)]
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