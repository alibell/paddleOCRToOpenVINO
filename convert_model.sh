#!/bin/sh
set -e

model_name=$1
filename=$(basename "$model_name")
model_path=./original_models/$model_name
model_onnx_path=./onnx_models/$filename/
model_openvino_path=./openvino_models/$filename/

mkdir -p $model_onnx_path && \
mkdir -p $model_openvino_path

# Download model
echo "uvx hf download $model_name --local-dir $model_path"
uvx hf download $model_name --local-dir $model_path

# Copy config file
cp $model_path/config.json $model_onnx_path/config.json
cp $model_path/config.json $model_openvino_path/config.json

# Convert to ONNX
.venv/bin/paddle2onnx \
--model_dir $model_path \
--model_filename inference.json \
--params_filename inference.pdiparams \
--save_file $model_onnx_path/model.onnx

# Convert to OpenVino
uvx --from openvino ovc $model_onnx_path --output_model $model_openvino_path || true

# Build artifact
tar -czf ./artifacts/$filename.onnx.tar.gz -C $(dirname "$model_onnx_path") $(basename "$model_onnx_path")
tar -czf ./artifacts/$filename.openvino.tar.gz -C $(dirname "$model_openvino_path") $(basename "$model_openvino_path")
