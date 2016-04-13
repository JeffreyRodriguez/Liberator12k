#!/bin/bash
OPENSCAD="openscad"

# Tee Housing

echo "Plating Tee Housing Front.stl"
openscad -DPLATE_TEE_HOUSING_BACK=false \
         -DPLATE_TEE_HOUSING_FRONT=true \
         -o "Tee Housing Front.stl" \
         "Tee Housing Plater.scad"

echo "Plating Tee Housing Back.stl"
openscad -DPLATE_TEE_HOUSING_BACK=true \
         -DPLATE_TEE_HOUSING_FRONT=false \
         -o "Tee Housing Back.stl" \
         "Tee Housing Plater.scad"



