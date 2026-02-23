# Pi 5 Dual IMX219 NDVI Case (V1)

Parametric OpenSCAD prototype case for:
- Raspberry Pi 5 + official active cooler
- 2x Raspberry Pi Camera v2 (IMX219 + NoIR IMX219)
- NDVI/multispectral fixed stereo rig
- 1/4"-20 tripod mount

## Design Targets
- Camera orientation: horizontal pair (left-right)
- Working distance: ~0.8–1.0m
- Camera baseline: 40mm center-to-center (default)
- Material: PETG/ASA/ABS
- Printer: Voron Trident, 0.4mm nozzle
- Assembly: heat-set inserts + screws

## Files
- `openscad/pi5_dual_imx219_ndvi_case_v1.scad` - parametric CAD source
- `docs/BOM.md` - bill of materials
- `docs/PRINT.md` - print settings and assembly notes

## Quick Start
1. Open the SCAD file in OpenSCAD
2. Adjust top parameters if needed (`camera_baseline`, wall thickness, etc.)
3. Export STLs:
   - `base_plate`
   - `camera_bar`
   - `camera_clamp_left`
   - `camera_clamp_right`
4. Print and assemble

## Notes
- V1 is intentionally simple and rigid for calibration stability.
- Camera clamp **V2 mount update**: front alignment pocket + explicit M2 clearance holes + rear M2 heat-set insert pockets.
- For NDVI, lower parallax is preferred over large baseline; 40mm is a practical starting point.
- If alignment is difficult, try 35mm baseline by changing one parameter.
