function dr2_out = plus(dr2, A)

if isnumeric(A)    
    dr2_out = broadcastArithmetic(dr2, A, 'plus');
else
    ME = Mexception('DR2:badArthmeticInput', ...
        'Arithmetic functions are implemented only for numerical values');
    throw(ME)
end
