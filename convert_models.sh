#!/bin/sh

# We loop over model names
failures=''
while IFS= read -r model_name; do
    model_name="${model_name%$'\r'}"   # remove trailing \r
    echo "Converting $model_name ..."

    ./convert_model.sh $model_name > /dev/null

    if [ $? -ne 0 ]; then
        echo "/!\ Failure while converting $model_name /!\ "
    fi
done < ./models
