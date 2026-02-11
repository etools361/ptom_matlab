# P->M 转换方法与实现流程（MATLAB 版）

## 目标与边界
- 解析 P-code 文件结构还原 `.m` 文本，不做字节码反编译。
- 仅支持头部版本 `v01.00` / `v00.00`，版本不匹配会拒绝解析。
- 解压依赖 MATLAB 内置 Java（`InflaterInputStream`）。
- 输出会进行格式化（缩进 + 空行压缩），因此空白可能与原始 `.m` 不一致。

## 关键文件与职责
- `matlab_p_to_m/p_to_m.m`: 单文件入口，组织流程与写文件。
- `matlab_p_to_m/p_to_m_batch.m`: 批量入口，支持并行 worker。
- `p_to_m_read_pfile.m`: 读取头部与压缩区，校验版本与大小。
- `p_to_m_unscramble.m`: 32-bit XOR 去扰码。
- `p_to_m_inflate_zlib.m`: Java zlib 解压。
- `p_to_m_uncompress.m`: 校验解压大小，拆出 token 计数与数据区。
- `p_to_m_parse_names.m`: 解析符号表字符串。
- `p_to_m_parse_mfile.m`: 解码 token 流，拼接文本。
- `p_to_m_unwrap_script.m`: 去除脚本的合成包装函数。
- `p_to_m_format.m`: 缩进与空行压缩。

## P 文件头结构（32 字节）
| 偏移 | 大小 | 字段 | 说明 |
| --- | --- | --- | --- |
| 0x00 | 6 | major | 期望 "v01.00" |
| 0x06 | 6 | minor | 期望 "v00.00" |
| 0x0C | 4 | scramble | 去扰码参数（大端） |
| 0x10 | 4 | crc | 当前实现未使用 |
| 0x14 | 4 | uk2 | 当前实现未使用 |
| 0x18 | 4 | size_after_compass | 压缩数据长度（大端） |
| 0x1C | 4 | size_befor_compass | 解压目标长度（大端） |

## 端序与校验
- `p_to_m_read_pfile` 使用 `swapbytes(typecast(...))` 把头部字段从大端转为主机端序。
- `p_to_m_uncompress` 在解压后再做一次 `swapbytes`，得到 `token_count[7]`。

## 去扰码（XOR）
- 计算：`scramble_number = (scramble >> 12) & 0xFF`
- 对前 `floor(nBytes/4)` 个 32-bit 字执行：
  `u32[i] ^= s_scramble_tbl[(i + scramble_number) & 0xFF]`
- 对应实现：`p_to_m_unscramble.m`。

## 解压与内存布局
- `p_to_m_inflate_zlib` 使用 `InflaterInputStream` 解压。
- 解压后长度必须等于 `size_befor_compass`。
- 解压缓冲区布局：
  1) `token_count[7]`（7 * u32）
  2) 符号表字符串区（NUL 结尾字符串）
  3) token 流（剩余字节）

## Token 解码规则（核心逻辑）
- 双字节 token：若 `b & 0x80 != 0`，则
  `res_id = 128 + 256 * ((b & 0x7F) - 1) + next_b`。
  由 `res_id+1` 映射到符号表字符串并输出。
- 单字节 token：若 `b < 134`，映射 `p_to_m_token_table`。
- 其余值视为解析失败，记录 `ErrorOffset`。
- 空格策略：
  - 默认在符号表 token 后追加空格。
  - 若下一个 token 是 `'`、`.''`、`.`、`.*`、`./`、`.\`、`.^`、`(`、`{`，则不加空格。
  - `+/-` 根据 `last_was_operand` 判定一元/二元，二元时两侧加空格。

## 输出与后处理
- `p_to_m_unwrap_script` 识别并移除脚本的合成包装函数（形如 `f_*`）。
- `p_to_m_format` 负责缩进与空行压缩（连续空行合并为 1 行）。
- `p_to_m` 写出文件，`ParseOk` 决定 `ok` 与错误信息。

## 运行与批量
- 单文件：
  ```matlab
  addpath('E:\work\prog\github\ptom_c-main\matlab_p_to_m');
  [ok, info] = p_to_m('input.p', 'output.m', 'Format', true, 'IndentWidth', 4);
  ```
- 批量：
  ```matlab
  report = p_to_m_batch('pcode_out_flat', 'p_to_m_matlab_out', 'Format', true, 'IndentWidth', 4, 'BaseNameOnly', true);
  ```

## 详细流程图
```
[p_to_m] 入口
  |
  +-> p_to_m_read_pfile
  |     - 读 32B 头部
  |     - 校验版本与大小
  |     - 读取压缩区
  |
  +-> p_to_m_uncompress
  |     - p_to_m_unscramble (XOR 去扰码)
  |     - p_to_m_inflate_zlib (Java 解压)
  |     - 拆出 token_count[7] + data
  |
  +-> p_to_m_parse_mfile
  |     - p_to_m_parse_names (符号表)
  |     - token 流解码 -> 文本
  |
  +-> p_to_m_unwrap_script (可选)
  |
  +-> p_to_m_format (缩进 + 空行压缩)
  |
  +-> 写文件 -> 返回 ok/info
```

## 关键变量说明
- `pfile`: 头部字段与压缩区（`Major/Minor/Scramble/SizeAfter/SizeBefore/Data`）。
- `mfile`: 解压结果（`Tokens[7]`、`Data`、`Size`）。
- `names`: 符号表字符串数组，按 `token_count` 顺序解析。
- `code_data`: token 流数据区。
- `last_was_operand`: 判定 `+/-` 一元/二元的状态。
- `info`: `{NameCount, ParseOk, ErrorOffset}` 解析结果。

## 缺点与可改进点
- 版本支持有限：仅接受 `v01.00` / `v00.00`。
- 未知 token 直接终止解析；可增加容错策略或逐步扩展 token 表。
- 格式化规则是启发式，空白与注释位置可能与原文件不同。
- 依赖 Java 解压；如需纯 MATLAB，可考虑替换为内置解压接口。
