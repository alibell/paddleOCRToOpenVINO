#!/bin/sh

# We loop over model names
failures=''
while IFS= read -r model_name; do
    echo "Converting $model_name ..."
    ./converted_model.sh $model_name > /dev/null

    if [ $? -ne 0 ]; then
        echo "/!\ Failure while converting $model_name /!\ "
    fi
done < ./models
