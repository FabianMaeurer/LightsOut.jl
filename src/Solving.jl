#=----------------------------------------------------------
    Solve the Lights Out Game 
----------------------------------------------------------=#

function config_to_vector(config::Array{Bool,2})
    K = GF(2)
    n,_ = size(config)
    sparse_row(K, [(i, K(b)) for (i,b) ∈ pairs(config[:])])
end


function is_solvable(config::Array{Bool,2}, surface::Symbol = :square)
    b = config_to_vector(config)
    n,_ = size(config)
    try
        return true, solve(lights_out_matrix(n, surface), b)
    catch 
        return false, nothing
    end
end

function vector_to_grid(vec::SRow, n::Int)
    A = [false for _ ∈ 1:n^2]
    for (i,_) ∈ vec
        A[i] = true
    end
    reshape(A,n,n)
end


#=----------------------------------------------------------
    Solvability Stats   
----------------------------------------------------------=#

function uniquely_solvable_up_to(n::Int, surface::Symbol = :square)
    uniquely_solvable_up_to(1,n,surface)
end

function uniquely_solvable_up_to(m::Int, n::Int, surface::Symbol = :square)
    ret = Int[]
    for k ∈ m:n
        d,_ = nullspace(lights_out_matrix(k, surface))
        if d == 0 
            ret = [ret; k]
        end
    end

    return ret
end