function dr2_out = minus(dr2, A)

if isnumeric(A)    
    dr2_out = broadcastArithmetic(dr2, A, 'minus');
else
    ME = Mexception('DR2:badArthmeticInput', ...
        'Arithmetic functions are implemented only for numerical values');
    throw(ME)
end
