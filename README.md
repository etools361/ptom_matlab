# README
注意：仅用于学习用途！！！
MATLAB-only `.p` -> `.m` converter.

中文说明：这是一个纯 MATLAB 实现的 P-code 还原工具，面向 R2016a。
核心代码位于 `matlab_p_to_m/`，支持单文件与批量转换，并包含基础格式化。

## 快速开始

### P -> M（MATLAB 批量）
```powershell
p_to_m_batch('pcode_out_flat','p_to_m_matlab_out','Format',true,'IndentWidth',4,'BaseNameOnly',true);
```

### 单文件
```matlab
[ok, info] = p_to_m('input.p', 'output.m', 'Format', true, 'IndentWidth', 4);
```

## 工作原理（MATLAB）
1. `p_to_m_read_pfile` 读取 32 字节头部、校验版本与大小，加载压缩数据。
2. `p_to_m_unscramble` 根据 `scramble` 进行 32-bit XOR 去扰码。
3. `p_to_m_inflate_zlib` 用 Java `InflaterInputStream` 解压数据。
4. `p_to_m_parse_mfile` 解析 7 组符号表计数、还原名字表与 token 流。
5. `p_to_m_unwrap_script` 可移除脚本的合成包装函数。
6. `p_to_m_format` 进行缩进与空行压缩。

## 目录结构
- `matlab_p_to_m/`：MATLAB 解析实现与批量入口。
- `full_test_case_matlab/`：综合语法测试集。
- `funMatlabLink/`：业务样例集。
- `pcode_out_*`：`m -> p` 结果目录（可删除再生成）。
- `p_to_m_matlab_out*`：`p -> m` 输出目录（可删除再生成）。

## 说明
- 仅支持 `v01.00` / `v00.00` 的 P-code 头部版本。
- 解压依赖 MATLAB 内置 Java；禁用 Java 可能导致解压失败。
