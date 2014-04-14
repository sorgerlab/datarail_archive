function d = tabledata(t)
    d = arraymap(@(i) t.(i), 1:width(t));
end
