new_DR2m

%%
idx = [3:6 1:2 7:10]';
t_2 = table(idx, strcat('c', num2cellstr(idx)), 'variablenames', {'column' 'tag'});

d2 = leftjoin(DR2m, t_2);

[b,f] = eq(d2,DR2m);
(~b & f==1011)

%%

idx = [3:6 0:2 7:10]';
t_3 = table(idx, strcat('c', num2cellstr(idx)), 'variablenames', {'N' 'tag'});

d3 = leftjoin(DR2m, t_3, 'leftkeys', 'column', 'rightkeys', 'N');

t_4 = table(idx, strcat('c', num2cellstr(idx)), 'variablenames', {'col' 'tag'});
d4 = leftjoin(DR2m, t_4, 'leftkeys', 'column', 'rightkeys', 'col');


d3==d4

[b,f] = eq(d3,DR2m);
(~b & f==1011)

%%

idx = [3:6 1:2 7:10]';
t_2 = table(idx, strcat('c', num2cellstr(idx)), 'variablenames', {'column' 'tag'});
d2 = innerjoin(DR2m, t_2);

idx = idx(randperm(length(idx)));
t_3 = table(idx, strcat('c', num2cellstr(idx)), 'variablenames', {'N' 'tag'});
d3 = innerjoin(DR2m, t_3, 'leftkeys', 'column', 'rightkeys', 'N');

[b,f] = eq(d2,DR2m);
f==1
d2==d3

%%
d2('tag==''c4''')==d3('column==4')
