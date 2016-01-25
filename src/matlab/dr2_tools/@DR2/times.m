function dr2_out = times(dr2, A)

if isnumeric(A)    
    dr2_out = broadcastArithmetic(dr2, A, 'rdivide');
else
    ME = Mexception('DR2:badArthmeticInput', ...
        'Arithmetic functions are implemented only for numerical values');
    throw(ME)
end
