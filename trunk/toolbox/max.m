function max(A,B)
%% max(A,B)
%% Returns the maximum of two numbers,
%% Currently only non complex scalar arguments are supported.
    if parrot_typeof(A) != 'Complex'
        if isscalar(A)
            if parrot_typeof(B) != 'Complex'
                if isscalar(B)
                    if A > B
                        return A
                    else
                        return B
                    end
                end
            end
        end
    end
    disp("unsupported type sorry :(")
endfunction
