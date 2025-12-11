#!/bin/sh

# We loop over model names
failures=''
ls -l .venv
while IFS= read -r model_name; do
    model_name="${model_name%$'\r'}"   # remove trailing \r
    echo "Converting $model_name ..."

    ./convert_model.sh $model_name > /dev/null

    if [ $? -ne 0 ]; then
        failures += $model_name
        echo "/!\ Failure while converting $model_name /!\ "
    fi
done < ./models

# Raise error
if [ "$failure" != "" ]; then
    exit 1
fi