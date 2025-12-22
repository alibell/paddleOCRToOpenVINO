import openvino as ov
from nncf import compress_weights, CompressWeightsMode
import argparse
import os
from typing import Literal
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument(
    "--input_dir",
    type=Path,
)
parser.add_argument(
    "--output_dir",
    type=Path,
)

# Compression mode
# More info:
#   https://github.com/openvinotoolkit/nncf/blob/develop/docs/usage/post_training_compression/weights_compression/Usage.md#mixed-precision-modes
parser.add_argument(
    "--compression_mode",
    type=str,
    choices=[
        'FP4',
        'FP8_E4M3',
        'INT4_ASYM',
        'INT4_SYM',
        'INT8',
        'INT8_ASYM',
        'INT8_SYM',
        'MXFP4',
        'MXFP8_E4M3',
        'NF4',
    ],
    default="INT8_SYM"
)

# Load CLI args
args = parser.parse_args()
compression_mode = getattr(
    CompressWeightsMode,
    args.compression_mode
)

# Load OpenVino inference engine
core = ov.Core()

# Load model
model = core.read_model(
    model=str(
        args.input_dir /
        "model.xml"
    ),
    weights=str(
        args.input_dir /
        "model.bin"
    ),
)

# Compress model
compressed_model = compress_weights(
    model=model,
    mode=compression_mode,
)

# Save model
os.makedirs(args.output_dir, exist_ok=True)
ov.save_model(
    compressed_model,
    str(args.output_dir)
)
