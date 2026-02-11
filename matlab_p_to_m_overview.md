# matlab_p_to_m 源码概览

范围：`matlab_p_to_m` 目录下 21 个 .m 文件。

## 文件简介

- `p_to_m.m`: P_TO_M Convert MATLAB .p to .m using MATLAB-only logic.
  - 主函数: `p_to_m`
- `p_to_m_batch.m`: P_TO_M_BATCH Batch convert .p files to .m files.
  - 主函数: `p_to_m_batch`
  - 本文件函数: `p_to_m_batch`, `collect_p_files`, `flat_base`, `load_source_map`, `default_job_storage`, `write_report`, `common_root`, `normalize_root`, `rel_path`, `path_starts_with`
- `p_to_m_format.m`: P_TO_M_FORMAT Apply a simple indentation pass to reconstructed M code.
  - 主函数: `p_to_m_format`
  - 本文件函数: `p_to_m_format`, `detect_line_break`, `first_word`, `is_block_start`, `is_block_mid`, `is_block_end`
- `p_to_m_inflate_zlib.m`: 无头注释。
  - 主函数: `p_to_m_inflate_zlib`
- `p_to_m_parse_mfile.m`: 无头注释。
  - 主函数: `p_to_m_parse_mfile`
  - 本文件函数: `p_to_m_parse_mfile`, `append_part`, `is_space_char`
- `p_to_m_parse_names.m`: 无头注释。
  - 主函数: `p_to_m_parse_names`
- `p_to_m_read_pfile.m`: 无头注释。
  - 主函数: `p_to_m_read_pfile`
  - 本文件函数: `p_to_m_read_pfile`, `p_to_m_read_u32_be`
- `p_to_m_scramble_table.m`: 无头注释。
  - 主函数: `p_to_m_scramble_table`
- `p_to_m_token_table.m`: 无头注释。
  - 主函数: `p_to_m_token_table`
- `p_to_m_uncompress.m`: 无头注释。
  - 主函数: `p_to_m_uncompress`
- `p_to_m_unscramble.m`: 无头注释。
  - 主函数: `p_to_m_unscramble`
- `p_to_m_unwrap_script.m`: P_TO_M_UNWRAP_SCRIPT Remove synthetic wrapper function for script files.
  - 主函数: `p_to_m_unwrap_script`
  - 本文件函数: `p_to_m_unwrap_script`, `starts_with_comment`, `get_basename_no_ext`, `detect_line_break`, `parse_function_decl`, `starts_with_token`, `is_wrapper_name`, `has_function_after`, `find_wrapper_end`, `is_block_start`, `is_block_end`, `strip_strings_and_comments`
- `run_batch_matlab_p_to_m.m`: 无头注释。
  - 主函数: `run_batch_matlab_p_to_m`
- `run_debug_bytes.m`: 无头注释。
  - 主函数: `run_debug_bytes`
- `run_debug_header.m`: 无头注释。
  - 主函数: `run_debug_header`
- `run_debug_inflate.m`: 无头注释。
  - 主函数: `run_debug_inflate`
  - 本文件函数: `run_debug_inflate`, `read_stream`
- `run_debug_java_array.m`: 无头注释。
  - 主函数: `run_debug_java_array`
- `run_debug_java_bytes.m`: 无头注释。
  - 主函数: `run_debug_java_bytes`
- `run_debug_parse.m`: 无头注释。
  - 主函数: `run_debug_parse`
- `run_debug_parse_addr.m`: 无头注释。
  - 主函数: `run_debug_parse_addr`
- `run_single_matlab_p_to_m.m`: 无头注释。
  - 主函数: `run_single_matlab_p_to_m`

## 调用关系树（按文件）

说明：基于函数名匹配的静态分析（忽略注释/字符串），仅展示本目录内 .m 文件间调用。

### run_batch_matlab_p_to_m.m

```text
run_batch_matlab_p_to_m.m
└─ p_to_m_batch.m
   └─ p_to_m.m
      ├─ p_to_m_format.m
      ├─ p_to_m_parse_mfile.m
      │  ├─ p_to_m_parse_names.m
      │  └─ p_to_m_token_table.m
      ├─ p_to_m_read_pfile.m
      ├─ p_to_m_uncompress.m
      │  ├─ p_to_m_inflate_zlib.m
      │  └─ p_to_m_unscramble.m
      │     └─ p_to_m_scramble_table.m
      └─ p_to_m_unwrap_script.m
```

### run_debug_bytes.m

```text
run_debug_bytes.m
├─ p_to_m_read_pfile.m
└─ p_to_m_unscramble.m
   └─ p_to_m_scramble_table.m
```

### run_debug_header.m

```text
run_debug_header.m
├─ p_to_m_read_pfile.m
└─ p_to_m_unscramble.m
   └─ p_to_m_scramble_table.m
```

### run_debug_inflate.m

```text
run_debug_inflate.m
├─ p_to_m_read_pfile.m
└─ p_to_m_unscramble.m
   └─ p_to_m_scramble_table.m
```

### run_debug_java_array.m

```text
run_debug_java_array.m
```

### run_debug_java_bytes.m

```text
run_debug_java_bytes.m
```

### run_debug_parse.m

```text
run_debug_parse.m
├─ p_to_m_inflate_zlib.m
├─ p_to_m_parse_mfile.m
│  ├─ p_to_m_parse_names.m
│  └─ p_to_m_token_table.m
├─ p_to_m_parse_names.m
├─ p_to_m_read_pfile.m
└─ p_to_m_unscramble.m
   └─ p_to_m_scramble_table.m
```

### run_debug_parse_addr.m

```text
run_debug_parse_addr.m
├─ p_to_m_inflate_zlib.m
├─ p_to_m_parse_mfile.m
│  ├─ p_to_m_parse_names.m
│  └─ p_to_m_token_table.m
├─ p_to_m_parse_names.m
├─ p_to_m_read_pfile.m
└─ p_to_m_unscramble.m
   └─ p_to_m_scramble_table.m
```

### run_single_matlab_p_to_m.m

```text
run_single_matlab_p_to_m.m
└─ p_to_m.m
   ├─ p_to_m_format.m
   ├─ p_to_m_parse_mfile.m
   │  ├─ p_to_m_parse_names.m
   │  └─ p_to_m_token_table.m
   ├─ p_to_m_read_pfile.m
   ├─ p_to_m_uncompress.m
   │  ├─ p_to_m_inflate_zlib.m
   │  └─ p_to_m_unscramble.m
   │     └─ p_to_m_scramble_table.m
   └─ p_to_m_unwrap_script.m
```

### p_to_m.m

```text
p_to_m.m
├─ p_to_m_format.m
├─ p_to_m_parse_mfile.m
│  ├─ p_to_m_parse_names.m
│  └─ p_to_m_token_table.m
├─ p_to_m_read_pfile.m
├─ p_to_m_uncompress.m
│  ├─ p_to_m_inflate_zlib.m
│  └─ p_to_m_unscramble.m
│     └─ p_to_m_scramble_table.m
└─ p_to_m_unwrap_script.m
```

### p_to_m_batch.m

```text
p_to_m_batch.m
└─ p_to_m.m
   ├─ p_to_m_format.m
   ├─ p_to_m_parse_mfile.m
   │  ├─ p_to_m_parse_names.m
   │  └─ p_to_m_token_table.m
   ├─ p_to_m_read_pfile.m
   ├─ p_to_m_uncompress.m
   │  ├─ p_to_m_inflate_zlib.m
   │  └─ p_to_m_unscramble.m
   │     └─ p_to_m_scramble_table.m
   └─ p_to_m_unwrap_script.m
```

## 调用关系树（按函数）

说明：基于函数名匹配的静态分析（忽略注释/字符串），仅展示本目录内函数间调用。

### run_batch_matlab_p_to_m (run_batch_matlab_p_to_m.m)

```text
run_batch_matlab_p_to_m (run_batch_matlab_p_to_m.m)
└─ p_to_m_batch (p_to_m_batch.m)
   ├─ p_to_m (p_to_m.m)
   │  ├─ p_to_m_format (p_to_m_format.m)
   │  │  ├─ detect_line_break (p_to_m_format.m)
   │  │  ├─ first_word (p_to_m_format.m)
   │  │  ├─ is_block_end (p_to_m_format.m)
   │  │  ├─ is_block_mid (p_to_m_format.m)
   │  │  └─ is_block_start (p_to_m_format.m)
   │  ├─ p_to_m_parse_mfile (p_to_m_parse_mfile.m)
   │  │  ├─ append_part (p_to_m_parse_mfile.m)
   │  │  ├─ is_space_char (p_to_m_parse_mfile.m)
   │  │  │  ├─ append_part (p_to_m_parse_mfile.m)
   │  │  │  └─ is_space_char (p_to_m_parse_mfile.m)
   │  │  │     (cycle)
   │  │  ├─ p_to_m_parse_names (p_to_m_parse_names.m)
   │  │  └─ p_to_m_token_table (p_to_m_token_table.m)
   │  ├─ p_to_m_read_pfile (p_to_m_read_pfile.m)
   │  │  └─ p_to_m_read_u32_be (p_to_m_read_pfile.m)
   │  ├─ p_to_m_uncompress (p_to_m_uncompress.m)
   │  │  ├─ p_to_m_inflate_zlib (p_to_m_inflate_zlib.m)
   │  │  └─ p_to_m_unscramble (p_to_m_unscramble.m)
   │  │     └─ p_to_m_scramble_table (p_to_m_scramble_table.m)
   │  └─ p_to_m_unwrap_script (p_to_m_unwrap_script.m)
   │     ├─ detect_line_break (p_to_m_unwrap_script.m)
   │     ├─ find_wrapper_end (p_to_m_unwrap_script.m)
   │     │  ├─ is_block_end (p_to_m_unwrap_script.m)
   │     │  │  └─ starts_with_token (p_to_m_unwrap_script.m)
   │     │  ├─ is_block_start (p_to_m_unwrap_script.m)
   │     │  │  └─ starts_with_token (p_to_m_unwrap_script.m)
   │     │  └─ strip_strings_and_comments (p_to_m_unwrap_script.m)
   │     ├─ get_basename_no_ext (p_to_m_unwrap_script.m)
   │     ├─ has_function_after (p_to_m_unwrap_script.m)
   │     │  ├─ starts_with_comment (p_to_m_unwrap_script.m)
   │     │  └─ starts_with_token (p_to_m_unwrap_script.m)
   │     ├─ is_wrapper_name (p_to_m_unwrap_script.m)
   │     ├─ parse_function_decl (p_to_m_unwrap_script.m)
   │     │  └─ starts_with_token (p_to_m_unwrap_script.m)
   │     └─ starts_with_comment (p_to_m_unwrap_script.m)
   ├─ collect_p_files (p_to_m_batch.m)
   │  └─ collect_p_files (p_to_m_batch.m)
   │     (cycle)
   ├─ common_root (p_to_m_batch.m)
   │  └─ normalize_root (p_to_m_batch.m)
   ├─ default_job_storage (p_to_m_batch.m)
   ├─ flat_base (p_to_m_batch.m)
   │  ├─ normalize_root (p_to_m_batch.m)
   │  └─ path_starts_with (p_to_m_batch.m)
   ├─ load_source_map (p_to_m_batch.m)
   ├─ normalize_root (p_to_m_batch.m)
   ├─ rel_path (p_to_m_batch.m)
   │  ├─ normalize_root (p_to_m_batch.m)
   │  └─ path_starts_with (p_to_m_batch.m)
   └─ write_report (p_to_m_batch.m)
```

### run_debug_bytes (run_debug_bytes.m)

```text
run_debug_bytes (run_debug_bytes.m)
├─ p_to_m_read_pfile (p_to_m_read_pfile.m)
│  └─ p_to_m_read_u32_be (p_to_m_read_pfile.m)
└─ p_to_m_unscramble (p_to_m_unscramble.m)
   └─ p_to_m_scramble_table (p_to_m_scramble_table.m)
```

### run_debug_header (run_debug_header.m)

```text
run_debug_header (run_debug_header.m)
├─ p_to_m_read_pfile (p_to_m_read_pfile.m)
│  └─ p_to_m_read_u32_be (p_to_m_read_pfile.m)
└─ p_to_m_unscramble (p_to_m_unscramble.m)
   └─ p_to_m_scramble_table (p_to_m_scramble_table.m)
```

### run_debug_inflate (run_debug_inflate.m)

```text
run_debug_inflate (run_debug_inflate.m)
├─ p_to_m_read_pfile (p_to_m_read_pfile.m)
│  └─ p_to_m_read_u32_be (p_to_m_read_pfile.m)
├─ p_to_m_unscramble (p_to_m_unscramble.m)
│  └─ p_to_m_scramble_table (p_to_m_scramble_table.m)
└─ read_stream (run_debug_inflate.m)
```

### run_debug_java_array (run_debug_java_array.m)

```text
run_debug_java_array (run_debug_java_array.m)
```

### run_debug_java_bytes (run_debug_java_bytes.m)

```text
run_debug_java_bytes (run_debug_java_bytes.m)
```

### run_debug_parse (run_debug_parse.m)

```text
run_debug_parse (run_debug_parse.m)
├─ p_to_m_inflate_zlib (p_to_m_inflate_zlib.m)
├─ p_to_m_parse_mfile (p_to_m_parse_mfile.m)
│  ├─ append_part (p_to_m_parse_mfile.m)
│  ├─ is_space_char (p_to_m_parse_mfile.m)
│  │  ├─ append_part (p_to_m_parse_mfile.m)
│  │  └─ is_space_char (p_to_m_parse_mfile.m)
│  │     (cycle)
│  ├─ p_to_m_parse_names (p_to_m_parse_names.m)
│  └─ p_to_m_token_table (p_to_m_token_table.m)
├─ p_to_m_parse_names (p_to_m_parse_names.m)
├─ p_to_m_read_pfile (p_to_m_read_pfile.m)
│  └─ p_to_m_read_u32_be (p_to_m_read_pfile.m)
└─ p_to_m_unscramble (p_to_m_unscramble.m)
   └─ p_to_m_scramble_table (p_to_m_scramble_table.m)
```

### run_debug_parse_addr (run_debug_parse_addr.m)

```text
run_debug_parse_addr (run_debug_parse_addr.m)
├─ p_to_m_inflate_zlib (p_to_m_inflate_zlib.m)
├─ p_to_m_parse_mfile (p_to_m_parse_mfile.m)
│  ├─ append_part (p_to_m_parse_mfile.m)
│  ├─ is_space_char (p_to_m_parse_mfile.m)
│  │  ├─ append_part (p_to_m_parse_mfile.m)
│  │  └─ is_space_char (p_to_m_parse_mfile.m)
│  │     (cycle)
│  ├─ p_to_m_parse_names (p_to_m_parse_names.m)
│  └─ p_to_m_token_table (p_to_m_token_table.m)
├─ p_to_m_parse_names (p_to_m_parse_names.m)
├─ p_to_m_read_pfile (p_to_m_read_pfile.m)
│  └─ p_to_m_read_u32_be (p_to_m_read_pfile.m)
└─ p_to_m_unscramble (p_to_m_unscramble.m)
   └─ p_to_m_scramble_table (p_to_m_scramble_table.m)
```

### run_single_matlab_p_to_m (run_single_matlab_p_to_m.m)

```text
run_single_matlab_p_to_m (run_single_matlab_p_to_m.m)
└─ p_to_m (p_to_m.m)
   ├─ p_to_m_format (p_to_m_format.m)
   │  ├─ detect_line_break (p_to_m_format.m)
   │  ├─ first_word (p_to_m_format.m)
   │  ├─ is_block_end (p_to_m_format.m)
   │  ├─ is_block_mid (p_to_m_format.m)
   │  └─ is_block_start (p_to_m_format.m)
   ├─ p_to_m_parse_mfile (p_to_m_parse_mfile.m)
   │  ├─ append_part (p_to_m_parse_mfile.m)
   │  ├─ is_space_char (p_to_m_parse_mfile.m)
   │  │  ├─ append_part (p_to_m_parse_mfile.m)
   │  │  └─ is_space_char (p_to_m_parse_mfile.m)
   │  │     (cycle)
   │  ├─ p_to_m_parse_names (p_to_m_parse_names.m)
   │  └─ p_to_m_token_table (p_to_m_token_table.m)
   ├─ p_to_m_read_pfile (p_to_m_read_pfile.m)
   │  └─ p_to_m_read_u32_be (p_to_m_read_pfile.m)
   ├─ p_to_m_uncompress (p_to_m_uncompress.m)
   │  ├─ p_to_m_inflate_zlib (p_to_m_inflate_zlib.m)
   │  └─ p_to_m_unscramble (p_to_m_unscramble.m)
   │     └─ p_to_m_scramble_table (p_to_m_scramble_table.m)
   └─ p_to_m_unwrap_script (p_to_m_unwrap_script.m)
      ├─ detect_line_break (p_to_m_unwrap_script.m)
      ├─ find_wrapper_end (p_to_m_unwrap_script.m)
      │  ├─ is_block_end (p_to_m_unwrap_script.m)
      │  │  └─ starts_with_token (p_to_m_unwrap_script.m)
      │  ├─ is_block_start (p_to_m_unwrap_script.m)
      │  │  └─ starts_with_token (p_to_m_unwrap_script.m)
      │  └─ strip_strings_and_comments (p_to_m_unwrap_script.m)
      ├─ get_basename_no_ext (p_to_m_unwrap_script.m)
      ├─ has_function_after (p_to_m_unwrap_script.m)
      │  ├─ starts_with_comment (p_to_m_unwrap_script.m)
      │  └─ starts_with_token (p_to_m_unwrap_script.m)
      ├─ is_wrapper_name (p_to_m_unwrap_script.m)
      ├─ parse_function_decl (p_to_m_unwrap_script.m)
      │  └─ starts_with_token (p_to_m_unwrap_script.m)
      └─ starts_with_comment (p_to_m_unwrap_script.m)
```

### p_to_m (p_to_m.m)

```text
p_to_m (p_to_m.m)
├─ p_to_m_format (p_to_m_format.m)
│  ├─ detect_line_break (p_to_m_format.m)
│  ├─ first_word (p_to_m_format.m)
│  ├─ is_block_end (p_to_m_format.m)
│  ├─ is_block_mid (p_to_m_format.m)
│  └─ is_block_start (p_to_m_format.m)
├─ p_to_m_parse_mfile (p_to_m_parse_mfile.m)
│  ├─ append_part (p_to_m_parse_mfile.m)
│  ├─ is_space_char (p_to_m_parse_mfile.m)
│  │  ├─ append_part (p_to_m_parse_mfile.m)
│  │  └─ is_space_char (p_to_m_parse_mfile.m)
│  │     (cycle)
│  ├─ p_to_m_parse_names (p_to_m_parse_names.m)
│  └─ p_to_m_token_table (p_to_m_token_table.m)
├─ p_to_m_read_pfile (p_to_m_read_pfile.m)
│  └─ p_to_m_read_u32_be (p_to_m_read_pfile.m)
├─ p_to_m_uncompress (p_to_m_uncompress.m)
│  ├─ p_to_m_inflate_zlib (p_to_m_inflate_zlib.m)
│  └─ p_to_m_unscramble (p_to_m_unscramble.m)
│     └─ p_to_m_scramble_table (p_to_m_scramble_table.m)
└─ p_to_m_unwrap_script (p_to_m_unwrap_script.m)
   ├─ detect_line_break (p_to_m_unwrap_script.m)
   ├─ find_wrapper_end (p_to_m_unwrap_script.m)
   │  ├─ is_block_end (p_to_m_unwrap_script.m)
   │  │  └─ starts_with_token (p_to_m_unwrap_script.m)
   │  ├─ is_block_start (p_to_m_unwrap_script.m)
   │  │  └─ starts_with_token (p_to_m_unwrap_script.m)
   │  └─ strip_strings_and_comments (p_to_m_unwrap_script.m)
   ├─ get_basename_no_ext (p_to_m_unwrap_script.m)
   ├─ has_function_after (p_to_m_unwrap_script.m)
   │  ├─ starts_with_comment (p_to_m_unwrap_script.m)
   │  └─ starts_with_token (p_to_m_unwrap_script.m)
   ├─ is_wrapper_name (p_to_m_unwrap_script.m)
   ├─ parse_function_decl (p_to_m_unwrap_script.m)
   │  └─ starts_with_token (p_to_m_unwrap_script.m)
   └─ starts_with_comment (p_to_m_unwrap_script.m)
```

### p_to_m_batch (p_to_m_batch.m)

```text
p_to_m_batch (p_to_m_batch.m)
├─ p_to_m (p_to_m.m)
│  ├─ p_to_m_format (p_to_m_format.m)
│  │  ├─ detect_line_break (p_to_m_format.m)
│  │  ├─ first_word (p_to_m_format.m)
│  │  ├─ is_block_end (p_to_m_format.m)
│  │  ├─ is_block_mid (p_to_m_format.m)
│  │  └─ is_block_start (p_to_m_format.m)
│  ├─ p_to_m_parse_mfile (p_to_m_parse_mfile.m)
│  │  ├─ append_part (p_to_m_parse_mfile.m)
│  │  ├─ is_space_char (p_to_m_parse_mfile.m)
│  │  │  ├─ append_part (p_to_m_parse_mfile.m)
│  │  │  └─ is_space_char (p_to_m_parse_mfile.m)
│  │  │     (cycle)
│  │  ├─ p_to_m_parse_names (p_to_m_parse_names.m)
│  │  └─ p_to_m_token_table (p_to_m_token_table.m)
│  ├─ p_to_m_read_pfile (p_to_m_read_pfile.m)
│  │  └─ p_to_m_read_u32_be (p_to_m_read_pfile.m)
│  ├─ p_to_m_uncompress (p_to_m_uncompress.m)
│  │  ├─ p_to_m_inflate_zlib (p_to_m_inflate_zlib.m)
│  │  └─ p_to_m_unscramble (p_to_m_unscramble.m)
│  │     └─ p_to_m_scramble_table (p_to_m_scramble_table.m)
│  └─ p_to_m_unwrap_script (p_to_m_unwrap_script.m)
│     ├─ detect_line_break (p_to_m_unwrap_script.m)
│     ├─ find_wrapper_end (p_to_m_unwrap_script.m)
│     │  ├─ is_block_end (p_to_m_unwrap_script.m)
│     │  │  └─ starts_with_token (p_to_m_unwrap_script.m)
│     │  ├─ is_block_start (p_to_m_unwrap_script.m)
│     │  │  └─ starts_with_token (p_to_m_unwrap_script.m)
│     │  └─ strip_strings_and_comments (p_to_m_unwrap_script.m)
│     ├─ get_basename_no_ext (p_to_m_unwrap_script.m)
│     ├─ has_function_after (p_to_m_unwrap_script.m)
│     │  ├─ starts_with_comment (p_to_m_unwrap_script.m)
│     │  └─ starts_with_token (p_to_m_unwrap_script.m)
│     ├─ is_wrapper_name (p_to_m_unwrap_script.m)
│     ├─ parse_function_decl (p_to_m_unwrap_script.m)
│     │  └─ starts_with_token (p_to_m_unwrap_script.m)
│     └─ starts_with_comment (p_to_m_unwrap_script.m)
├─ collect_p_files (p_to_m_batch.m)
│  └─ collect_p_files (p_to_m_batch.m)
│     (cycle)
├─ common_root (p_to_m_batch.m)
│  └─ normalize_root (p_to_m_batch.m)
├─ default_job_storage (p_to_m_batch.m)
├─ flat_base (p_to_m_batch.m)
│  ├─ normalize_root (p_to_m_batch.m)
│  └─ path_starts_with (p_to_m_batch.m)
├─ load_source_map (p_to_m_batch.m)
├─ normalize_root (p_to_m_batch.m)
├─ rel_path (p_to_m_batch.m)
│  ├─ normalize_root (p_to_m_batch.m)
│  └─ path_starts_with (p_to_m_batch.m)
└─ write_report (p_to_m_batch.m)
```

## 文件与函数作用一览（中文一句话）

### 文件

| 文件 | 一句话作用 |
|---|---|
| `p_to_m.m` | 主入口：将 MATLAB .p 反编译为 .m。 |
| `p_to_m_batch.m` | 批量转换入口：遍历目录把 .p 转为 .m，支持并行与输出控制。 |
| `p_to_m_format.m` | 格式化器：对重建的 MATLAB 代码做缩进整理。 |
| `p_to_m_inflate_zlib.m` | zlib 解压实现：用于解码压缩的 pcode 数据。 |
| `p_to_m_parse_mfile.m` | 解析器：解析 MATLAB 代码文本/片段并构建结构。 |
| `p_to_m_parse_names.m` | 名称表解析：从 pcode 中提取符号/名称。 |
| `p_to_m_read_pfile.m` | 二进制读取：解析 .p 文件结构与段。 |
| `p_to_m_scramble_table.m` | 混淆表：提供 pcode 字节混淆/反混淆映射。 |
| `p_to_m_token_table.m` | Token 表：提供语法 token/关键字映射。 |
| `p_to_m_uncompress.m` | 解压/反混淆：还原压缩与混淆的数据块。 |
| `p_to_m_unscramble.m` | 反混淆：恢复混淆字节序列。 |
| `p_to_m_unwrap_script.m` | 脚本还原：移除包裹函数并恢复脚本形式。 |
| `run_batch_matlab_p_to_m.m` | 批量运行脚本：调用 p_to_m_batch 处理目录。 |
| `run_debug_bytes.m` | 调试脚本：查看/验证字节级读取与反混淆。 |
| `run_debug_header.m` | 调试脚本：查看/验证 .p 头部解析。 |
| `run_debug_inflate.m` | 调试脚本：查看/验证 zlib 解压过程。 |
| `run_debug_java_array.m` | 调试脚本：测试 Java 数组互操作。 |
| `run_debug_java_bytes.m` | 调试脚本：测试 Java 字节数组互操作。 |
| `run_debug_parse.m` | 调试脚本：查看/验证解析流程。 |
| `run_debug_parse_addr.m` | 调试脚本：查看/验证地址相关解析。 |
| `run_single_matlab_p_to_m.m` | 单文件运行脚本：调用 p_to_m 处理单个 .p。 |

### 函数

| 函数 | 所在文件 | 一句话作用 |
|---|---|---|
| `p_to_m` | `p_to_m.m` | 主入口：将单个 .p 转换为 .m。 |
| `p_to_m_batch` | `p_to_m_batch.m` | 批量入口：遍历目录并调用 p_to_m 转换。 |
| `collect_p_files` | `p_to_m_batch.m` | 递归收集目录下的 .p 文件列表。 |
| `flat_base` | `p_to_m_batch.m` | 将路径打平成安全的文件基名。 |
| `load_source_map` | `p_to_m_batch.m` | 读取源文件映射表。 |
| `default_job_storage` | `p_to_m_batch.m` | 返回默认并行作业存储目录。 |
| `write_report` | `p_to_m_batch.m` | 将批量转换统计写入报告文件。 |
| `common_root` | `p_to_m_batch.m` | 计算路径列表的公共根目录。 |
| `normalize_root` | `p_to_m_batch.m` | 规范化根路径分隔符与末尾。 |
| `rel_path` | `p_to_m_batch.m` | 计算相对路径。 |
| `path_starts_with` | `p_to_m_batch.m` | 判断路径是否以指定前缀开头。 |
| `p_to_m_format` | `p_to_m_format.m` | 对重建的 MATLAB 代码进行缩进格式化。 |
| `detect_line_break` | `p_to_m_format.m` | 检测文本的行结束符样式。 |
| `first_word` | `p_to_m_format.m` | 提取一行的首个关键字/单词。 |
| `is_block_start` | `p_to_m_format.m` | 判断是否为代码块开始关键字。 |
| `is_block_mid` | `p_to_m_format.m` | 判断是否为代码块中间关键字。 |
| `is_block_end` | `p_to_m_format.m` | 判断是否为代码块结束关键字。 |
| `p_to_m_inflate_zlib` | `p_to_m_inflate_zlib.m` | 使用 zlib 解压缩数据块。 |
| `p_to_m_parse_mfile` | `p_to_m_parse_mfile.m` | 解析 MATLAB 代码文本为结构化片段。 |
| `append_part` | `p_to_m_parse_mfile.m` | 向解析结果追加片段。 |
| `is_space_char` | `p_to_m_parse_mfile.m` | 判断字符是否为空白。 |
| `p_to_m_parse_names` | `p_to_m_parse_names.m` | 解析名称/符号表。 |
| `p_to_m_read_pfile` | `p_to_m_read_pfile.m` | 读取 .p 文件并解析其二进制结构。 |
| `p_to_m_read_u32_be` | `p_to_m_read_pfile.m` | 读取 32 位大端整数。 |
| `p_to_m_scramble_table` | `p_to_m_scramble_table.m` | 生成或返回混淆表。 |
| `p_to_m_token_table` | `p_to_m_token_table.m` | 生成或返回 token 表。 |
| `p_to_m_uncompress` | `p_to_m_uncompress.m` | 解压与反混淆 pcode 数据。 |
| `p_to_m_unscramble` | `p_to_m_unscramble.m` | 执行反混淆操作。 |
| `p_to_m_unwrap_script` | `p_to_m_unwrap_script.m` | 移除脚本包装函数，恢复脚本形式。 |
| `starts_with_comment` | `p_to_m_unwrap_script.m` | 判断行是否以注释开头。 |
| `get_basename_no_ext` | `p_to_m_unwrap_script.m` | 获取不含扩展名的文件名。 |
| `detect_line_break` | `p_to_m_unwrap_script.m` | 检测文本的行结束符样式。 |
| `parse_function_decl` | `p_to_m_unwrap_script.m` | 解析函数声明行。 |
| `starts_with_token` | `p_to_m_unwrap_script.m` | 判断是否以指定 token 开头。 |
| `is_wrapper_name` | `p_to_m_unwrap_script.m` | 判断是否为包装函数名。 |
| `has_function_after` | `p_to_m_unwrap_script.m` | 判断后续是否存在函数定义。 |
| `find_wrapper_end` | `p_to_m_unwrap_script.m` | 查找包装函数结束位置。 |
| `is_block_start` | `p_to_m_unwrap_script.m` | 判断是否为代码块开始关键字。 |
| `is_block_end` | `p_to_m_unwrap_script.m` | 判断是否为代码块结束关键字。 |
| `strip_strings_and_comments` | `p_to_m_unwrap_script.m` | 移除字符串与注释内容。 |
| `run_batch_matlab_p_to_m` | `run_batch_matlab_p_to_m.m` | 运行入口：批量调用 p_to_m_batch。 |
| `run_debug_bytes` | `run_debug_bytes.m` | 调试入口：读取/验证字节级数据。 |
| `run_debug_header` | `run_debug_header.m` | 调试入口：解析并检查 .p 头部。 |
| `run_debug_inflate` | `run_debug_inflate.m` | 调试入口：测试解压流程。 |
| `read_stream` | `run_debug_inflate.m` | 从文件/流读取字节数据。 |
| `run_debug_java_array` | `run_debug_java_array.m` | 调试入口：测试 Java 数组互操作。 |
| `run_debug_java_bytes` | `run_debug_java_bytes.m` | 调试入口：测试 Java 字节数组互操作。 |
| `run_debug_parse` | `run_debug_parse.m` | 调试入口：测试解析流程。 |
| `run_debug_parse_addr` | `run_debug_parse_addr.m` | 调试入口：测试地址相关解析。 |
| `run_single_matlab_p_to_m` | `run_single_matlab_p_to_m.m` | 运行入口：调用 p_to_m 处理单文件。 |
