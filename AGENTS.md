# Repository Guidelines

## Project Structure & Module Organization
- `matlab_p_to_m/` holds the MATLAB-only converter: `p_to_m.m` (single file), `p_to_m_batch.m` (batch), `p_to_m_format.m` (formatting), and parsing helpers.
- `full_test_case_matlab/` is the synthetic MATLAB test suite; `funMatlabLink/` is the business dataset.
- `pcode_out_*` and `p_to_m_matlab_out*` are generated outputs; treat them as disposable artifacts.

## Build, Test, and Development Commands
- M -> P (pcode, flat output):
  `powershell -ExecutionPolicy Bypass -File .\\batch_convert_m_to_p.ps1 -SrcDir .\\full_test_case_matlab -OutDir .\\pcode_out_flat -Threads 4`
- P -> M (MATLAB batch):
  `matlab.exe -nosplash -nodesktop -r "addpath('E:\\work\\prog\\github\\ptom_c-main\\matlab_p_to_m'); p_to_m_batch('pcode_out_flat','p_to_m_matlab_out','Format',true,'IndentWidth',4,'BaseNameOnly',true); exit"`
- Single file: `[ok, info] = p_to_m('in.p','out.m','Format',true,'IndentWidth',4);`

## Coding Style & Naming Conventions
- MATLAB only; keep 4-space indentation and the existing `p_to_m_*` naming pattern.
- Prefer small, single-purpose helpers and return `ok/info` rather than relying on globals.
- Keep formatting logic centralized in `p_to_m_format.m`.

## Testing Guidelines
- Use `full_test_case_matlab/` and `funMatlabLink/` as inputs; regenerate outputs into clean folders.
- Check success counts in MATLAB logs and spot-check formatting/spacing around operators.
- For batch runs, keep `_stage/` directories out of inputs to avoid duplicate processing.

## Commit & Pull Request Guidelines
- Git metadata may be missing; use concise, imperative commit messages.
- Include MATLAB version, commands used, and output paths in PR descriptions.
- Do not add C/Python/MEX implementations; keep the repo MATLAB-only.
