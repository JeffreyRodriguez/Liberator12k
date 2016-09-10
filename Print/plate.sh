#!/bin/bash
OPENSCAD="openscad"

# Upper Receiver

echo "Plating Upper Receiver Front.stl"
openscad -DPLATE_TEE_HOUSING_BACK=false \
         -DPLATE_TEE_HOUSING_FRONT=true \
         -o "Upper Receiver Front.stl" \
         "Upper Receiver Plater.scad"

echo "Plating Upper Receiver Back.stl"
openscad -DPLATE_TEE_HOUSING_BACK=true \
         -DPLATE_TEE_HOUSING_FRONT=false \
         -o "Upper Receiver Back.stl" \
         "Upper Receiver Plater.scad"



