from fixedpoint import FixedPoint
import numpy as np

from config import INT_BITS, FRAC_BITS
import utils

TESTBENCH_ROM_PATH = "./roms/tb/perceptron"
WEIGHTS_ROM_PATH = f"{TESTBENCH_ROM_PATH}/weights.mem"
BIAS_ROM_PATH = f"{TESTBENCH_ROM_PATH}/bias.mem"
INPUT_ROM_PATH = f"{TESTBENCH_ROM_PATH}/data_in.mem"
RESULT_ROM_PATH = f"{TESTBENCH_ROM_PATH}/data_out.mem"

N_FEATURES = 11

rng = np.random.default_rng()

def n2f(n): return FixedPoint(n, True, INT_BITS, FRAC_BITS)
def fparr(count): return np.array([n2f(x) for x in rng.random(count)])

def gen_roms():
    weights = fparr(N_FEATURES)
    data_in = fparr(N_FEATURES)
    bias = fparr(1)
    result = FixedPoint(0, True, INT_BITS * 2, FRAC_BITS * 2)
    for w,d in zip(weights, data_in):
        print(f"{w:04x} * {d:04x} = {w*d:08x}")
        print(f"{float(w):.4} * {float(d):.4} = {float(w*d):.4}")
        print()
        result += w * d
    result += bias

    print(hex(result), float(result))
    print(result.qformat)

    result.resize(INT_BITS, FRAC_BITS)
    print(hex(result), float(result))
    print(result.qformat)

    utils.write_romfile(weights, WEIGHTS_ROM_PATH)
    utils.write_romfile(data_in, INPUT_ROM_PATH)
    utils.write_romfile(bias, BIAS_ROM_PATH)
    utils.write_romfile([result], RESULT_ROM_PATH)

if __name__ == "__main__":
    gen_roms()
