new_DR2m

%%

A = 4;
DR2m_1 = DR2m - A;
DR2m_2 = DR2m_1 + A;

DR2m_1 == DR2m_2

DR2m_1 = DR2m .*A;
DR2m_2 = DR2m_1 ./A;

DR2m_1 == DR2m_2

%%
A = 3.5*ones(1,1,size(DR2m.data,3));
DR2m_1 = DR2m - A;
DR2m_2 = DR2m_1 + A;

DR2m_1 == DR2m_2

DR2m_1 = DR2m .*A;
DR2m_2 = DR2m_1 ./A;

DR2m_1 == DR2m_2

%%
s2DR2m = DR2m('column<6 & ismember(row_low, {''a'' ''b'' ''c''}) & plate==''P3''')

A = 2*ones(size(s2DR2m.data,2),1);
DR2m_1 = s2DR2m *A
