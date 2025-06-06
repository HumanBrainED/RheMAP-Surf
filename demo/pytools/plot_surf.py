#!/usr/bin/env python3
import pyvista as pv
import nibabel as nib
import numpy as np
import argparse

def get_clim(data, mode, value=None):
    if mode == "auto":
        return [np.nanmin(data), np.nanmax(data)]
    elif mode == "fixed" and value:
        return value # expects [min, max]
    elif mode == "percentile" and value:
        pmin, pmax = np.percentile(data[~np.isnan(data)], value)
        return [pmin, pmax]
    else:
        return [0, 1]

def plot_surf(
    surf_file, metric_file, hemi, output_path,
    metric_name="Metric", clim_mode="auto", clim_value=None,
    surf2_file=None, surf1_opacity=1.0, surf2_opacity=0.3, views_to_plot=None,
    subplot_shape=None, window_size=None,
    cmap="coolwarm", show_colorbar=True, bg_color="white"
):
    # Load surface
    surf = nib.load(surf_file)
    coords = surf.darrays[0].data
    faces = np.insert(surf.darrays[1].data, 0, 3, axis=1) # PyVista expects [N, i0, i1, i2]
    mesh = pv.PolyData(coords, faces)

    # Load metric if given
    if metric_file:
        metric = nib.load(metric_file).darrays[0].data
        mesh[metric_name] = metric
        clim = get_clim(metric, clim_mode, clim_value)
    else:
        metric = None
        clim = None

    # Optional second surface
    mesh2 = None
    if surf2_file:
        surf2 = nib.load(surf2_file)
        coords2 = surf2.darrays[0].data
        faces2 = np.insert(surf2.darrays[1].data, 0, 3, axis=1)
        mesh2 = pv.PolyData(coords2, faces2)

    # Define views
    default_views = {
        "lateral": ([-1, 0, 0], [0, 0, 1]) if hemi == "lh" else ([1, 0, 0], [0, 0, 1]),
        "medial": ([1, 0, 0], [0, 0, 1]) if hemi == "lh" else ([-1, 0, 0], [0, 0, 1]),
        "anterior": ([0, 1, 0], [0, 0, 1]),
        "posterior": ([0, -1, 0], [0, 0, 1]),
        "dorsal": ([0, 0, 1], [1, 0, 0]),
        "ventral": ([0, 0, -1], [1, 0, 0]),
    }

    views_to_plot = views_to_plot or list(default_views.keys())

    shape = tuple(subplot_shape) if subplot_shape else (len(views_to_plot), 1)
    win_size = tuple(window_size) if window_size else (1000, 600 * shape[0])

    plotter = pv.Plotter(shape=shape, window_size=win_size, off_screen=True)
    plotter.set_background(bg_color)

    for idx, view in enumerate(views_to_plot):
        view_vector, viewup = default_views[view]
        row, col = divmod(idx, shape[1])
        plotter.subplot(row, col)
        plotter.add_text(view.capitalize(), font_size=12)

        if metric is not None:
            plotter.add_mesh(
                mesh,
                scalars=metric_name,
                cmap=cmap,
                clim=clim,
                nan_color="gray",
                show_scalar_bar=(show_colorbar and idx == len(views_to_plot)-1),
                scalar_bar_args={"title": metric_name, "vertical": True},
                opacity=surf1_opacity
            )
        else:
            plotter.add_mesh(mesh, color="white", opacity=surf1_opacity)

        if mesh2:
            plotter.add_mesh(mesh2, color="green", opacity=surf2_opacity)

        plotter.view_vector(view_vector, viewup=viewup)
        plotter.camera.zoom(1.75)

    plotter.screenshot(output_path)
    plotter.close()
    print(f"✅ Saved: {output_path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Flexible surface viewer")

    parser.add_argument("--surf", required=True)
    parser.add_argument("--metric", default=None)
    parser.add_argument("--hemi", required=True, choices=["lh", "rh"])
    parser.add_argument("--out", required=True)

    parser.add_argument("--metric_name", default="Metric")
    parser.add_argument("--clim_mode", choices=["auto", "fixed", "percentile"], default="auto")
    parser.add_argument("--clim_value", type=float, nargs=2, help="Used for 'fixed' or 'percentile' modes")

    parser.add_argument("--surf2", default=None, help="Second surface for overlay")
    parser.add_argument("--surf1_opacity", type=float, default=1.0)
    parser.add_argument("--surf2_opacity", type=float, default=0.3)

    parser.add_argument("--views", nargs="+", choices=[
        "lateral", "medial", "anterior", "posterior", "dorsal", "ventral"
    ])

    parser.add_argument("--subplot_shape", type=int, nargs=2)
    parser.add_argument("--window_size", type=int, nargs=2)

    parser.add_argument("--cmap", default="coolwarm")
    parser.add_argument("--show_colorbar", action="store_true")
    parser.add_argument("--bg_color", default="white")

    args = parser.parse_args()

    plot_surf(
        surf_file=args.surf,
        metric_file=args.metric,
        hemi=args.hemi,
        output_path=args.out,
        metric_name=args.metric_name,
        clim_mode=args.clim_mode,
        clim_value=args.clim_value,
        surf2_file=args.surf2,
        surf1_opacity=args.surf1_opacity,
        surf2_opacity=args.surf2_opacity,
        views_to_plot=args.views,
        subplot_shape=args.subplot_shape,
        window_size=args.window_size,
        cmap=args.cmap,
        show_colorbar=args.show_colorbar,
        bg_color=args.bg_color,
    )
