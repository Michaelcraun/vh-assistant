#!/bin/bash

VH_DIR=~/"Documents/curseforge/minecraft/Instances/Vault\ Hunters\ -\ Official\ Modpack\ \(1\)/config/the_vault"
PROJECT_DIR="$( cd "$( dirname "$0" )" && pwd )"
FILE_LIST=("abilities.json" "researches_groups.json" "researches.json" "skill_descriptions.json" "skill_gates.json" "talents.json")

copy_file()
{
    SOURCE="$VH_DIR/$1"
    DESTINATION="$PROJECT_DIR/Data"

    echo "File found; copying $1 to $DESTINATION..."
    eval cp "$SOURCE" "$DESTINATION"
}

echo "Copying project files to $PROJECT_DIR..."
eval cd "$VH_DIR"

for FILE in *; do 
    if [[ $FILE == "abilities.json" ]]; then
        copy_file $FILE
    elif [[ $FILE == "researches_groups.json" ]]; then
        copy_file $FILE
    elif [[ $FILE == "researches.json" ]]; then
        copy_file $FILE
    elif [[ $FILE == "skill_descriptions.json" ]]; then
        copy_file $FILE
    elif [[ $FILE == "skill_gates.json" ]]; then
        copy_file $FILE
    elif [[ $FILE == "talents.json" ]]; then
        copy_file $FILE
    fi
done

exit 0