#!/bin/sh
set -e

model_name=$1
filename=$(basename "$model_name")
model_path=./original_models/$model_name
model_onnx_path=./onnx_models/$filename/$filename.onnx
model_openvino_path=./openvino_models/$filename/

mkdir -p onnx_models/$filename/
mkdir -p openvino_models/$filename/

# Download model
echo "uvx hf download $model_name --local-dir $model_path"
uvx hf download $model_name --local-dir $model_path

# Convert to ONNX
.venv/bin/paddle2onnx \
--model_dir $model_path \
--model_filename inference.json \
--params_filename inference.pdiparams \
--save_file $model_onnx_path

# Convert to OpenVino
uvx --from openvino ovc $model_onnx_path --output_model $model_openvino_path

# Build artifact
tar -czf ./artifacts/$filename.onnx.tar -C $(dirname "$model_onnx_path") $(basename "$model_onnx_path")
tar -czf ./artifacts/$filename.onnx.tar -C $(dirname "$model_openvino_path") $(basename "$model_openvino_path")
