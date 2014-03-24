function out = take(seq, n)
    [l, d] = length_(seq);
    if n > l
      out = seq;
    else
      sz = size(seq);
      sz(d) = n;
      out = reshape(seq, l, []);
      out = reshape(out(1:n, :), sz);
    end
end