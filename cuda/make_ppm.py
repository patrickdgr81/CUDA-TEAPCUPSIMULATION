#!/usr/bin/python

print('P3') # format, P3 is ascii numbers separated by white space, P6 is binary
print('16 16') # x, y resolution
print('255') # max value
for i in xrange(16):
	for j in xrange(16):
		print('%d %d %d'%(i*15, j*15, 0))

