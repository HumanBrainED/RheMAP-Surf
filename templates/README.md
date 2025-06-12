# `templates/`: External Template Resources for RheMAP-Surf

This folder contains all externally sourced template data used in the **RheMAP-Surf** project. Each subfolder contains files that retain their original filenames from the corresponding download source, ensuring traceability and reproducibility.

---

## Contents Overview

The five subfolders — `NMTv2.0-sym`, `NMTv2.0-asym`, `D99`, `MEBRAINS`, and `YRK` — each contain surface and volume data from previously published macaque brain templates.  
**Detailed descriptions for them and for other subfolders are as follows.**

| Folder Name       | Description       |
|-------------------|-------------------|
| `NMTv2.0-sym`     | Contains symmetric macaque brain templates from [AFNI’s NMT v2.0 release](https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/nonhuman/macaque_tempatl/template_nmtv2.html). |
| `NMTv2.0-asym`    | Contains asymmetric macaque brain templates from [AFNI’s NMT v2.0 release](https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/nonhuman/macaque_tempatl/template_nmtv2.html). |
| `D99`             | Contains surface and volume templates from [AFNI’s macaque D99 atlas](https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/nonhuman/macaque_tempatl/atlas_d99v2.html). |
| `MEBRAINS`        | Contains surface and volume templates from [EBRAINS MEBRAINS v2.0](https://search.kg.ebrains.eu/instances/de58ab47-b980-437c-8906-87f1123e14fb). |
| `YRK`             | Contains Yerkes19 macaque brain templates from [Washington University’s NHPPipelines repository](https://github.com/Washington-University/NHPPipelines) and [BALSA](https://balsa.wustl.edu/reference/show/976nz). Includes 32k_fs_LR surfaces and F99-to-Yerkes19 deformation spheres. |
| `Markov`          | Includes Markov architectonic parcellation file from [BALSA](https://balsa.wustl.edu/study/W336), used to initialize MSM alignment. |
| `CompositeWarps`  | Includes inter-template volume warp fields from the [RheMAP project (ANTs-derived warps)](https://gin.g-node.org/ChrisKlink/RheMAP/src/master/warps/final). Due to large file size, this folder is **not included** in the GitHub repository. |

---

## Template Sources and File Listings

### `NMTv2.0-sym`
**Source:** [AFNI’s NMT v2.0 symmetric](https://afni.nimh.nih.gov/pub/dist/atlases/macaque/nmt/NMT_v2.0_sym.tgz)  
**Included Files:**
- Surfaces:  
  `NMT_v2.0_sym/NMT_v2.0_sym_surfaces/`  
  → `lh.white_surface.rsl.gii`, `lh.mid_surface.rsl.gii`, etc. (6 files for white, midthickness, and pial surfaces of the left and right hemispheres)
- Volume:  
  `NMT_v2.0_sym/NMT_v2.0_sym/NMT_v2.0_sym_SS.nii.gz`

---

### `NMTv2.0-asym`
**Source:** [AFNI’s NMT v2.0 asymmetric](https://afni.nimh.nih.gov/pub/dist/atlases/macaque/nmt/NMT_v2.0_asym.tgz)  
**Included Files:**
- Surfaces:  
  `NMT_v2.0_asym/NMT_v2.0_asym_surfaces/`  
  → `lh.white_surface.rsl.gii`, `lh.mid_surface.rsl.gii`, etc. (6 files for white, midthickness, and pial surfaces of the left and right hemispheres)
- Volume:  
  `NMT_v2.0_asym/NMT_v2.0_asym/NMT_v2.0_asym_SS.nii.gz`

---

### `D99`
**Source:** [AFNI’s macaque D99 atlas](https://afni.nimh.nih.gov/pub/dist/atlases/macaque/macaqueatlas_1.2b.tgz)  
**Included Files:**
- Surfaces:  
  `macaqueatlas_1.2b/wholebrain_surfaces/`  
  → Includes 6 files for white, pial, and spherical surfaces of the left and right hemispheres
  → Includes 4 midthickness files with and without medial wall smoothing (`MWS`)
- Volume:  
  `macaqueatlas_1.2b/D99_template.nii.gz`

---

### `MEBRAINS`
**Source:** [EBRAINS MEBRAINS v2.0](https://search.kg.ebrains.eu/instances/de58ab47-b980-437c-8906-87f1123e14fb)  
**Included Files:**
- Surfaces:  
  `v2.0/MEBRAINS_surface_templates/`  
  → `lh.MEBRAINS.smoothwm.gii`, `lh.MEBRAINS.pial.gii`, etc. (4 files for white and pial surfaces of the left and right hemispheres)
- Volume:  
  `v2.0/MEBRAINS_volume_templates/MEBRAINS_T1_masked.nii.gz`

---

### `YRK`
**Source 1 (T1 volume):** [GitHub NHPPipelines](https://github.com/Washington-University/NHPPipelines/blob/master/global/templates/MacaqueYerkes19_T1w_0.5mm_brain.nii.gz)  
**Included File:**
- `MacaqueYerkes19_T1w_0.5mm_brain.nii.gz`

**Source 2 (surfaces):** [BALSA](https://balsa.wustl.edu/reference/show/976nz)  
**Included Files:**
- Surfaces:  
  `MacaqueYerkes19_v1.2_Vj_976nz/MNINonLinear/fsaverage_LR32k/`  
  → Includes 8 files for white, midthickness, pial, and spherical surfaces of the left and right hemispheres
  → Includes 1 `.dscalar.nii` file with NaN-labeled medial wall
- Legacy transformation:  
  `MacaqueYerkes19_v1.2_Vj_976nz/F99_74k_RegisteredToMY19/`  
  → 4 files: F99-to-Yerkes19 deformation spheres and F99 midthickness surfaces

---

### `Markov`
**Source:** [BALSA download link](https://balsa.wustl.edu/download/downloadFile/w8Vm)  
**Included File:**
- `MarkovCC12_M132_91-area.32k_fs_LR.dlabel.nii`  
  → Used to initialize MSM alignment

---

### `CompositeWarps` (Not Included)
**Source:** [RheMAP G-NODE repository](https://gin.g-node.org/ChrisKlink/RheMAP/src/master/warps/final)  
**Contents:**  
Contains ANTs-derived **volume-to-volume warp fields** from the original RheMAP project.  
→ Includes all **20 pairwise mappings** between the 5 templates (`NMTv2.0-sym`, `NMTv2.0-asym`, `D99`, `MEBRAINS`, and `YRK`).

📌 **Note:** These warp files are too large to upload to GitHub.

---

All data in this folder are publicly available resources sourced from the original links.  
Please cite the respective papers and data sources when using these templates in your work.
