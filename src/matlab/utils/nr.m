function [] = nr_(seq)
    if istable(seq)
        n = height(seq);
        seq.Properties.RowNames = arraymap(@num2str, 1:n);
        todisp = seq;
    else
        n = length_(seq);
        fmt = sprintf('%%%dd\t%%s', floor(log10(n)) + 1);
        seq = tostr_(seq, n);
        lines = arraymap(@(i) sprintf(fmt, i, seq{i}), 1:n);
        todisp = strjoin(lines, '\n');
    end
    disp(todisp);
end

function out = tostr_(seq, n)
    seq = reshape(seq, n, []);
    if iscell(seq)
        out = arraymap(@(i) num2str(seq{i, :}), 1:n);
    else
        out = arraymap(@(i) num2str(seq(i, :)), 1:n);
    end
end
