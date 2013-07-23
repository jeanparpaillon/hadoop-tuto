#!/usr/bin/env python
import sys

if __name__ == '__main__':
    contrib = None
    count = 0

    for line in sys.stdin:
        elems = line.split()
        if len(elems) == 2:
            if elems[0] != contrib:
                if contrib is not None:
                    print "%s\t%s" % (contrib,count)
                contrib = elems[0]
                count = 0
            i = int(elems[1])
            count += i
