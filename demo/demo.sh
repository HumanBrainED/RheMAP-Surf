#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------------
# Demo: Metric Resampling Using Deformation Spheres
# -------------------------------------------------------
# This script demonstrates how to resample cortical metrics
# from a moving surface to a fixed (target) surface using
# precomputed deformation spheres.
#
# Two deformation sphere sets are available in ../deformation_spheres:
#   - standard_alignment/: based on mean curvature matching
#   - approx_volume_alignment/: based on RheMAP-driven feature matching
# -------------------------------------------------------

# Set hemisphere to process (lh or rh)
hemi="lh"

# Set moving and fixed (target) template names
# Choices include: "NMTv2.0-sym", "NMTv2.0-asym", "D99", "MEBRAINS", "YRK"
mov="YRK"
fix="MEBRAINS"

# -------------------------------------------------------
# Input files
# -------------------------------------------------------

MOV_SURF="../surfaces/${hemi}.${mov}.wm.surf.gii"
FIX_SURF="../surfaces/${hemi}.${fix}.wm.surf.gii"
MOV_SPHERE="../surfaces/${hemi}.${mov}.sphere.surf.gii"
FIX_SPHERE="../surfaces/${hemi}.${fix}.sphere.surf.gii"

# Choose one deformation sphere set to test:
# - For curvature-based registration:
#   ../deformation_spheres/standard_alignment/
# - For RheMAP-driven random feature-based registration:
#   ../deformation_spheres/approx_volume_alignment/

REG_SPHERE_FWD="../deformation_spheres/approx_volume_alignment/${hemi}.${mov}-to-${fix}.sphere.reg.surf.gii"
REG_SPHERE_REV="../deformation_spheres/approx_volume_alignment/${hemi}.${fix}-to-${mov}.sphere.reg.surf.gii"

# Metric to be resampled
MOV_METRIC="data/${hemi}.${mov}.Markov.annot.shape.gii"

# -------------------------------------------------------
# Output files (stored in ./outputs/)
# -------------------------------------------------------

mkdir -p outputs

METRIC_MOV_TO_FIX_1="outputs/${hemi}.${mov}-to-${fix}.resampled.via_fwd_sphere.shape.gii"
METRIC_MOV_TO_FIX_2="outputs/${hemi}.${mov}-to-${fix}.resampled.via_rev_sphere.shape.gii"
METRIC_ROUNDTRIP="outputs/${hemi}.${mov}-to-${fix}-to-${mov}.roundtrip.shape.gii"

# -------------------------------------------------------
# Step 1: Resample metric using mov-to-fix deformation sphere
# -------------------------------------------------------
# This resamples the metric from the moving surface (mov)
# to the target surface (fix) using the deformation sphere
# generated from mov to fix (e.g., YRK-to-MEBRAINS).

echo "Resampling via forward deformation sphere (mov-to-fix)..."
wb_command -metric-resample "$MOV_METRIC" "$REG_SPHERE_FWD" "$FIX_SPHERE" ADAP_BARY_AREA "$METRIC_MOV_TO_FIX_1" -area-surfs "$MOV_SURF" "$FIX_SURF"

# -------------------------------------------------------
# Step 2: Resample metric using fix-to-mov deformation sphere
# -------------------------------------------------------
# This also achieves mov→fix resampling, but uses the reverse
# deformation sphere (fix→mov) as the intermediate warp.
#
# These two methods achieve the same resampling, but the paths
# differ. Results may vary due to the independent MSM runs
# used to generate each deformation sphere.

echo "Resampling via reverse deformation sphere (fix-to-mov)..."
wb_command -metric-resample "$MOV_METRIC" "$MOV_SPHERE" "$REG_SPHERE_REV" ADAP_BARY_AREA "$METRIC_MOV_TO_FIX_2" -area-surfs "$MOV_SURF" "$FIX_SURF"

# -------------------------------------------------------
# Step 3: Demonstrate resample-back (round-trip) consistency
# -------------------------------------------------------
# This step performs a round-trip resampling: mov → fix → mov.
# For consistent resampling (i.e., same result after going
# back and forth), the same deformation sphere must be used
# in both directions.

echo "Resampling back to original space (round-trip test)..."
wb_command -metric-resample "$METRIC_MOV_TO_FIX_1" "$FIX_SPHERE" "$REG_SPHERE_FWD" ADAP_BARY_AREA "$METRIC_ROUNDTRIP" -area-surfs "$FIX_SURF" "$MOV_SURF"

# -------------------------------------------------------
# Step 4: Visualize results
# -------------------------------------------------------

echo "Plotting original metric..."
python3 pytools/plot_surf.py \
    --surf "$MOV_SURF" --metric "$MOV_METRIC" --hemi "$hemi" \
    --out "outputs/${hemi}.${mov}.original.png" \
    --subplot_shape 3 2 --window_size 2000 1800 --show_colorbar

echo "Plotting resampled metric via forward deformation sphere..."
python3 pytools/plot_surf.py \
    --surf "$FIX_SURF" --metric "$METRIC_MOV_TO_FIX_1" --hemi "$hemi" \
    --out "outputs/${hemi}.${mov}-to-${fix}.via_fwd.png" \
    --subplot_shape 3 2 --window_size 2000 1800 --show_colorbar

echo "Plotting resampled metric via reverse deformation sphere..."
python3 pytools/plot_surf.py \
    --surf "$FIX_SURF" --metric "$METRIC_MOV_TO_FIX_2" --hemi "$hemi" \
    --out "outputs/${hemi}.${mov}-to-${fix}.via_rev.png" \
    --subplot_shape 3 2 --window_size 2000 1800 --show_colorbar

echo "Plotting round-trip resampled metric via forward deformation sphere..."
python3 pytools/plot_surf.py \
    --surf "$MOV_SURF" --metric "$METRIC_ROUNDTRIP" --hemi "$hemi" \
    --out "outputs/${hemi}.${mov}.roundtrip.png" \
    --subplot_shape 3 2 --window_size 2000 1800 --show_colorbar

echo "✅ Done. All results saved in ./outputs/"
