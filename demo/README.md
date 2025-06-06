# Demo: Metric Resampling Using Deformation Spheres

This demo illustrates how to **resample cortical surface metrics** from one rhesus macaque surface template to another using **precomputed deformation spheres**.

---

## Dependencies

To run this demo, you need access to the following folders:

- [`../surfaces/`](../surfaces/) – contains surface meshes and spheres for both source and target templates.
- [`../deformation_spheres/`](../deformation_spheres/) – contains registration spheres for transforming between templates.

Two alternative registration sets are available in `../deformation_spheres/`:

| Folder | Registration Method |
|--------|---------------------|
| [`standard_alignment/`](../deformation_spheres/standard_alignment/) | based on mean curvature matching |
| [`approx_volume_alignment/`](../deformation_spheres/approx_volume_alignment/) | based on RheMAP-projected random feature matching |

---

## Key Command Used: `wb_command -metric-resample`

This [Connectome Workbench](https://www.humanconnectome.org/software/connectome-workbench) command resamples a metric (e.g., `.shape.gii`) from one surface mesh to another via two registered spherical surfaces.

### Basic syntax:

```bash
wb_command -metric-resample \
  <metric-in> \
  <current-sphere> \
  <new-sphere> \
  ADAP_BARY_AREA \
  <metric-out> \
  -area-surfs <current-surf> <new-surf>
```
- `metric-in`: original metric file (e.g., curvature, parcellation).
- `current-sphere`: sphere representing the source mesh.
- `new-sphere`: sphere representing the target mesh (in register with `current-sphere`).
- `-area-surfs`: anatomical surfaces used for vertex area correction.
- `ADAP_BARY_AREA`: recommended method for continuous data.

---

## What `demo.sh` Does

The [`demo.sh`](./demo.sh) script performs the following steps:

1. **Metric resampling via forward deformation sphere**  
   Resample the metric from the source space (e.g., YRK) to the target space (e.g., MEBRAINS) using the deformation sphere generated from YRK → MEBRAINS.

2. **Metric resampling via reverse deformation sphere**  
   Achieve the same goal but use the reverse deformation sphere (MEBRAINS → YRK) to warp the data in an alternative way.  
   🔍 This highlights how different resampling paths can yield subtle differences.

3. **Round-trip consistency test**  
   Demonstrate a round-trip resampling from source → target → source using **the same** deformation sphere.  
   📌 Only if the same deformation sphere is used in both directions can reversibility be expected (minor differences may still occur due to numerical precision).

4. **Visualization of results**  
   Each metric is visualized using [`pytools/plot_surf.py`](./pytools/plot_surf.py). Output images are saved to [`outputs/`](./outputs/):

| Output Image | Description |
|--------------|-------------|
| [`lh.YRK.original.png`](./outputs/lh.YRK.original.png) | Original metric in moving space |
| [`lh.YRK-to-MEBRAINS.via_fwd.png`](./outputs/lh.YRK-to-MEBRAINS.via_fwd.png) | Resampled via forward deformation sphere |
| [`lh.YRK-to-MEBRAINS.via_rev.png`](./outputs/lh.YRK-to-MEBRAINS.via_rev.png) | Resampled via reverse deformation sphere |
| [`lh.YRK.roundtrip.png`](./outputs/lh.YRK.roundtrip.png) | Metric resampled back to original space (round-trip test) |

---

## How to Run

```bash
bash demo.sh
```

Make sure all paths (to surface, sphere, metric, and deformation files) are correctly set relative to your working directory.

---

For more details, open and explore [`demo.sh`](./demo.sh).
