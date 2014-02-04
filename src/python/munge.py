import csv

r = csv.reader(open('small_molecule.csv'))
data = tuple(r)
hdr = data[0]
data = data[1:]

def cleanup(s):
    return nl.sub('', s)

def cleanup_record(r):
    return [cleanup(s) for s in r]

data0 = [cleanup_record(r) for r in data]

fh = open('small_molecule_1.tsv', 'w')
wr = csv.writer(fh, delimiter='\t')
wr.writerows([hdr] + data)
