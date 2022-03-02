from fixedpoint import FixedPoint
import numpy as np

from config import INT_BITS, FRAC_BITS

def write_romfile(data, path):
    DATA_WIDTH = (INT_BITS + FRAC_BITS + 3) // 4
    with open(path, "w") as fd:
        for c in data:
            c.resize(INT_BITS, FRAC_BITS)

        fd.write("\n".join(f"{c:0{DATA_WIDTH}x}" for c in data))
        fd.write("\n")