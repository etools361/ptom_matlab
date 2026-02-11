function generate_matlab_p_to_m_overview(root_dir)
%GENERATE_MATLAB_P_TO_M_OVERVIEW Generate markdown docs for matlab_p_to_m.
%   Run this in MATLAB to update the overview doc in the project root.

    if nargin < 1 || isempty(root_dir)
        root_dir = fileparts(mfilename('fullpath'));
    end

    src_dir = fullfile(root_dir, 'matlab_p_to_m');
    out_path = fullfile(root_dir, 'matlab_p_to_m_overview.md');

    files = dir(fullfile(src_dir, '*.m'));
    if isempty(files)
        error('No .m files found under %s', src_dir);
    end

    file_names = sort({files.name});
    n_files = numel(file_names);

    file_text = cell(n_files, 1);
    file_lines = cell(n_files, 1);
    file_funcs = cell(n_files, 1);
    file_primary = cell(n_files, 1);
    file_is_script = false(n_files, 1);
    file_func_defs = cell(n_files, 1);

    for i = 1:n_files
        text = fileread(fullfile(src_dir, file_names{i}));
        lines = split_lines(text);
        file_text{i} = text;
        file_lines{i} = lines;
        [funcs, defs] = parse_functions(lines);
        file_funcs{i} = funcs;
        file_func_defs{i} = defs;
        if isempty(funcs)
            file_is_script(i) = true;
            file_primary{i} = file_names{i}(1:end-2);
        else
            file_primary{i} = funcs{1};
        end
    end

    func_to_nodes = containers.Map();
    for i = 1:n_files
        funcs = file_funcs{i};
        for j = 1:numel(funcs)
            fn = funcs{j};
            node = [file_names{i} ':' fn];
            if isKey(func_to_nodes, fn)
                lst = func_to_nodes(fn);
                lst{end+1} = node; %#ok<AGROW>
                func_to_nodes(fn) = lst;
            else
                func_to_nodes(fn) = {node};
            end
        end
    end
    all_func_names = keys(func_to_nodes);

    summaries = cell(n_files, 1);
    for i = 1:n_files
        summaries{i} = extract_summary(file_lines{i});
    end

    file_calls = init_call_map(file_names);
    func_calls = containers.Map();

    for i = 1:n_files
        name = file_names{i};
        lines = file_lines{i};

        % File-level calls (ignore same-file funcs)
        cleaned = strip_comments_and_strings(lines);
        local_funcs = file_funcs{i};
        for k = 1:numel(all_func_names)
            callee = all_func_names{k};
            if contains_name_call(cleaned, callee)
                if any(strcmp(local_funcs, callee))
                    continue;
                end
                nodes = func_to_nodes(callee);
                target_files = unique(cellfun(@(s) s(1:find(s==':',1)-1), nodes, 'UniformOutput', false));
                target_files = target_files(~strcmp(target_files, name));
                if numel(target_files) == 1
                    file_calls(name) = add_unique(file_calls(name), target_files{1});
                end
            end
        end

        % Function-level calls
        blocks = build_function_blocks(lines, file_func_defs{i});
        for b = 1:numel(blocks)
            block = blocks(b);
            if strcmp(block.name, '__script__')
                node = [name ':__script__'];
            else
                node = [name ':' block.name];
            end
            seg = lines(block.start:block.end_line);
            cleaned_seg = strip_comments_and_strings(seg);
            cleaned_seg = remove_function_def_lines(cleaned_seg);
            for k = 1:numel(all_func_names)
                callee = all_func_names{k};
                if contains_name_call(cleaned_seg, callee)
                    if any(strcmp(file_funcs{i}, callee))
                        target = [name ':' callee];
                        func_calls = add_edge(func_calls, node, target);
                    else
                        nodes = func_to_nodes(callee);
                        if numel(nodes) == 1
                            func_calls = add_edge(func_calls, node, nodes{1});
                        end
                    end
                end
            end
        end
    end

    file_roots = {};
    for i = 1:n_files
        if starts_with(file_names{i}, 'run_')
            file_roots{end+1} = file_names{i}; %#ok<AGROW>
        end
    end
    file_roots = add_if_missing(file_roots, 'p_to_m.m');
    file_roots = add_if_missing(file_roots, 'p_to_m_batch.m');

    func_roots = {};
    for i = 1:n_files
        if starts_with(file_names{i}, 'run_')
            func_roots{end+1} = [file_names{i} ':' file_primary{i}]; %#ok<AGROW>
        end
    end
    func_roots = add_if_missing(func_roots, ['p_to_m.m:' file_primary{strcmp(file_names, 'p_to_m.m')}]);
    func_roots = add_if_missing(func_roots, ['p_to_m_batch.m:' file_primary{strcmp(file_names, 'p_to_m_batch.m')}]);

    % Description maps (Chinese)
    file_desc = file_desc_map();
    func_desc = func_desc_map();

    fid = fopen_utf8(out_path);
    if fid < 0
        error('Failed to open output file: %s', out_path);
    end
    cleanup_obj = onCleanup(@() fclose(fid)); %#ok<NASGU>

    fprintf(fid, '# matlab_p_to_m 源码概览\n\n');
    fprintf(fid, '范围：`matlab_p_to_m` 目录下 21 个 .m 文件。\n\n');

    fprintf(fid, '## 文件简介\n\n');
    for i = 1:n_files
        name = file_names{i};
        intro = summaries{i};
        if isempty(intro)
            intro = '无头注释。';
        end
        fprintf(fid, '- `%s`: %s\n', name, intro);
        funcs = file_funcs{i};
        if ~isempty(funcs)
            fprintf(fid, '  - 主函数: `%s`\n', file_primary{i});
            if numel(funcs) > 1
                fprintf(fid, '  - 本文件函数: %s\n', join_code(funcs));
            end
        else
            fprintf(fid, '  - 脚本入口: `%s`\n', file_primary{i});
        end
    end
    fprintf(fid, '\n');

    fprintf(fid, '## 调用关系树（按文件）\n\n');
    fprintf(fid, '说明：基于函数名匹配的静态分析（忽略注释/字符串），仅展示本目录内 .m 文件间调用。\n\n');
    for i = 1:numel(file_roots)
        root = file_roots{i};
        fprintf(fid, '### %s\n\n', root);
        tree_lines = build_tree(root, file_calls, 6);
        fprintf(fid, '```text\n%s\n```\n\n', strjoin(tree_lines, '\n'));
    end

    fprintf(fid, '## 调用关系树（按函数）\n\n');
    fprintf(fid, '说明：基于函数名匹配的静态分析（忽略注释/字符串），仅展示本目录内函数间调用。\n\n');
    for i = 1:numel(func_roots)
        root = func_roots{i};
        fprintf(fid, '### %s\n\n', func_display(root));
        tree_lines = build_tree(root, func_calls, 6);
        disp_lines = cell(size(tree_lines));
        for j = 1:numel(tree_lines)
            disp_lines{j} = replace_node_display(tree_lines{j});
        end
        fprintf(fid, '```text\n%s\n```\n\n', strjoin(disp_lines, '\n'));
    end

    fprintf(fid, '## 文件与函数作用一览（中文一句话）\n\n');
    fprintf(fid, '### 文件\n\n');
    fprintf(fid, '| 文件 | 一句话作用 |\n');
    fprintf(fid, '|---|---|\n');
    for i = 1:n_files
        name = file_names{i};
        desc = '';
        if isKey(file_desc, name)
            desc = file_desc(name);
        elseif starts_with(name, 'run_')
            desc = '运行/调试脚本入口。';
        else
            desc = '无头注释，具体作用需结合实现。';
        end
        fprintf(fid, '| `%s` | %s |\n', name, desc);
    end
    fprintf(fid, '\n');

    fprintf(fid, '### 函数\n\n');
    fprintf(fid, '| 函数 | 所在文件 | 一句话作用 |\n');
    fprintf(fid, '|---|---|---|\n');
    for i = 1:n_files
        name = file_names{i};
        funcs = file_funcs{i};
        for j = 1:numel(funcs)
            fn = funcs{j};
            desc = '';
            if isKey(func_desc, fn)
                desc = func_desc(fn);
            else
                desc = guess_func_desc(fn);
            end
            fprintf(fid, '| `%s` | `%s` | %s |\n', fn, name, desc);
        end
    end
end

function [funcs, defs] = parse_functions(lines)
    funcs = {};
    defs = struct('idx', {}, 'name', {}, 'indent', {});
    for i = 1:numel(lines)
        fn = parse_func_name(lines{i});
        if ~isempty(fn)
            funcs{end+1} = fn; %#ok<AGROW>
            defs(end+1).idx = i; %#ok<AGROW>
            defs(end).name = fn;
            defs(end).indent = leading_indent(lines{i});
        end
    end
    funcs = unique_preserve(funcs);
end

function blocks = build_function_blocks(lines, defs)
    if isempty(defs)
        blocks = struct('name', '__script__', 'start', 1, 'end_line', numel(lines));
        return;
    end
    blocks = struct('name', {}, 'start', {}, 'end_line', {});
    for i = 1:numel(defs)
        start_line = defs(i).idx;
        end_line = numel(lines);
        for j = i+1:numel(defs)
            if defs(j).indent <= defs(i).indent
                end_line = defs(j).idx - 1;
                break;
            end
        end
        blocks(end+1).name = defs(i).name; %#ok<AGROW>
        blocks(end).start = start_line;
        blocks(end).end_line = end_line;
    end
end

function out = strip_comments_and_strings(lines)
    out_lines = cell(size(lines));
    for i = 1:numel(lines)
        line = lines{i};
        buf = repmat(' ', 1, numel(line));
        in_str = false;
        j = 1;
        while j <= numel(line)
            ch = line(j);
            if ch == ''''
                if in_str
                    if j < numel(line) && line(j+1) == ''''
                        j = j + 2;
                        continue;
                    else
                        in_str = false;
                        j = j + 1;
                        continue;
                    end
                else
                    in_str = true;
                    j = j + 1;
                    continue;
                end
            end
            if ~in_str && ch == '%'
                break;
            end
            if ~in_str
                buf(j) = ch;
            end
            j = j + 1;
        end
        out_lines{i} = buf;
    end
    out = out_lines;
end

function out = remove_function_def_lines(lines)
    out = lines;
    for i = 1:numel(lines)
        if ~isempty(parse_func_name(lines{i}))
            out{i} = '';
        end
    end
end

function tf = contains_name_call(lines, name)
    pattern = ['\<', name, '\>\s*\('];
    tf = false;
    for i = 1:numel(lines)
        if ~isempty(regexp(lines{i}, pattern, 'once')) %#ok<RGXP1>
            tf = true;
            return;
        end
    end
end

function name = parse_func_name(line)
    tok = regexp(line, '^\s*function\s+(?:\[[^\]]*\]\s*=|\w+\s*=)\s*([A-Za-z]\w*)', 'tokens', 'once');
    if ~isempty(tok)
        name = tok{1};
        return;
    end
    tok = regexp(line, '^\s*function\s+([A-Za-z]\w*)', 'tokens', 'once');
    if ~isempty(tok)
        name = tok{1};
    else
        name = '';
    end
end

function n = leading_indent(line)
    n = 0;
    for i = 1:numel(line)
        if line(i) == ' '
            n = n + 1;
        elseif line(i) == char(9)
            n = n + 4;
        else
            break;
        end
    end
end

function lines = split_lines(text)
    lines = regexp(text, '\r\n|\n|\r', 'split');
end

function s = join_code(list)
    parts = cell(size(list));
    for i = 1:numel(list)
        parts{i} = ['`' list{i} '`'];
    end
    s = strjoin(parts, ', ');
end

function out = unique_preserve(list)
    out = {};
    for i = 1:numel(list)
        if ~any(strcmp(out, list{i}))
            out{end+1} = list{i}; %#ok<AGROW>
        end
    end
end

function map = init_call_map(keys)
    map = containers.Map();
    for i = 1:numel(keys)
        map(keys{i}) = {};
    end
end

function map = add_edge(map, from_node, to_node)
    if ~isKey(map, from_node)
        map(from_node) = {to_node};
    else
        map(from_node) = add_unique(map(from_node), to_node);
    end
end

function lst = add_unique(lst, item)
    if ~any(strcmp(lst, item))
        lst{end+1} = item; %#ok<AGROW>
    end
end

function list = add_if_missing(list, item)
    if isempty(item)
        return;
    end
    if ~any(strcmp(list, item))
        list{end+1} = item; %#ok<AGROW>
    end
end

function lines = build_tree(root, edges, max_depth)
    lines = {root};
    lines = dfs_tree(root, edges, '', 0, max_depth, {root}, lines);
end

function lines = dfs_tree(node, edges, prefix, depth, max_depth, stack, lines)
    if depth >= max_depth
        return;
    end
    children = {};
    if isKey(edges, node)
        children = edges(node);
    end
    children = sort(children);
    for i = 1:numel(children)
        child = children{i};
        last = (i == numel(children));
        if last
            branch = '└─ ';
            next_prefix = [prefix '   '];
        else
            branch = '├─ ';
            next_prefix = [prefix '│  '];
        end
        lines{end+1} = [prefix branch child]; %#ok<AGROW>
        if any(strcmp(stack, child))
            lines{end+1} = [next_prefix '(cycle)']; %#ok<AGROW>
        else
            lines = dfs_tree(child, edges, next_prefix, depth + 1, max_depth, [stack {child}], lines);
        end
    end
end

function out = func_display(node)
    if ends_with(node, ':__script__')
        file_name = node(1:find(node==':',1)-1);
        out = [file_name ' (script)'];
        return;
    end
    idx = find(node == ':', 1);
    if isempty(idx)
        out = node;
        return;
    end
    file_name = node(1:idx-1);
    fn = node(idx+1:end);
    out = [fn ' (' file_name ')'];
end

function line = replace_node_display(line)
    tok = regexp(line, '^(\\s*[│ ]*[├└]─ |\\s*)(.+)$', 'tokens', 'once');
    if isempty(tok)
        line = func_display(line);
        return;
    end
    prefix = tok{1};
    node = tok{2};
    if strcmp(strtrim(node), '(cycle)')
        line = [prefix node];
    else
        line = [prefix func_display(node)];
    end
end

function tf = starts_with(str, prefix)
    tf = numel(str) >= numel(prefix) && strcmp(str(1:numel(prefix)), prefix);
end

function tf = ends_with(str, suffix)
    if numel(str) < numel(suffix)
        tf = false;
    else
        tf = strcmp(str(end-numel(suffix)+1:end), suffix);
    end
end

function fid = fopen_utf8(path)
    fid = fopen(path, 'w', 'n', 'UTF-8');
    if fid < 0
        fid = fopen(path, 'w');
    end
end

function map = file_desc_map()
    map = containers.Map();
    map('p_to_m.m') = '主入口：将 MATLAB .p 反编译为 .m。';
    map('p_to_m_batch.m') = '批量转换入口：遍历目录把 .p 转为 .m，支持并行与输出控制。';
    map('p_to_m_format.m') = '格式化器：对重建的 MATLAB 代码做缩进整理。';
    map('p_to_m_inflate_zlib.m') = 'zlib 解压实现：用于解码压缩的 pcode 数据。';
    map('p_to_m_parse_mfile.m') = '解析器：解析 MATLAB 代码文本/片段并构建结构。';
    map('p_to_m_parse_names.m') = '名称表解析：从 pcode 中提取符号/名称。';
    map('p_to_m_read_pfile.m') = '二进制读取：解析 .p 文件结构与段。';
    map('p_to_m_scramble_table.m') = '混淆表：提供 pcode 字节混淆/反混淆映射。';
    map('p_to_m_token_table.m') = 'Token 表：提供语法 token/关键字映射。';
    map('p_to_m_uncompress.m') = '解压/反混淆：还原压缩与混淆的数据块。';
    map('p_to_m_unscramble.m') = '反混淆：恢复混淆字节序列。';
    map('p_to_m_unwrap_script.m') = '脚本还原：移除包裹函数并恢复脚本形式。';
    map('run_batch_matlab_p_to_m.m') = '批量运行脚本：调用 p_to_m_batch 处理目录。';
    map('run_single_matlab_p_to_m.m') = '单文件运行脚本：调用 p_to_m 处理单个 .p。';
    map('run_debug_bytes.m') = '调试脚本：查看/验证字节级读取与反混淆。';
    map('run_debug_header.m') = '调试脚本：查看/验证 .p 头部解析。';
    map('run_debug_inflate.m') = '调试脚本：查看/验证 zlib 解压过程。';
    map('run_debug_java_array.m') = '调试脚本：测试 Java 数组互操作。';
    map('run_debug_java_bytes.m') = '调试脚本：测试 Java 字节数组互操作。';
    map('run_debug_parse.m') = '调试脚本：查看/验证解析流程。';
    map('run_debug_parse_addr.m') = '调试脚本：查看/验证地址相关解析。';
end

function map = func_desc_map()
    map = containers.Map();
    map('p_to_m') = '主入口：将单个 .p 转换为 .m。';
    map('p_to_m_batch') = '批量入口：遍历目录并调用 p_to_m 转换。';
    map('collect_p_files') = '递归收集目录下的 .p 文件列表。';
    map('flat_base') = '将路径打平成安全的文件基名。';
    map('load_source_map') = '读取源文件映射表。';
    map('default_job_storage') = '返回默认并行作业存储目录。';
    map('write_report') = '将批量转换统计写入报告文件。';
    map('common_root') = '计算路径列表的公共根目录。';
    map('normalize_root') = '规范化根路径分隔符与末尾。';
    map('rel_path') = '计算相对路径。';
    map('path_starts_with') = '判断路径是否以指定前缀开头。';
    map('p_to_m_format') = '对重建的 MATLAB 代码进行缩进格式化。';
    map('detect_line_break') = '检测文本的行结束符样式。';
    map('first_word') = '提取一行的首个关键字/单词。';
    map('is_block_start') = '判断是否为代码块开始关键字。';
    map('is_block_mid') = '判断是否为代码块中间关键字。';
    map('is_block_end') = '判断是否为代码块结束关键字。';
    map('p_to_m_inflate_zlib') = '使用 zlib 解压缩数据块。';
    map('p_to_m_parse_mfile') = '解析 MATLAB 代码文本为结构化片段。';
    map('append_part') = '向解析结果追加片段。';
    map('is_space_char') = '判断字符是否为空白。';
    map('p_to_m_parse_names') = '解析名称/符号表。';
    map('p_to_m_read_pfile') = '读取 .p 文件并解析其二进制结构。';
    map('p_to_m_read_u32_be') = '读取 32 位大端整数。';
    map('p_to_m_scramble_table') = '生成或返回混淆表。';
    map('p_to_m_token_table') = '生成或返回 token 表。';
    map('p_to_m_uncompress') = '解压与反混淆 pcode 数据。';
    map('p_to_m_unscramble') = '执行反混淆操作。';
    map('p_to_m_unwrap_script') = '移除脚本包装函数，恢复脚本形式。';
    map('starts_with_comment') = '判断行是否以注释开头。';
    map('get_basename_no_ext') = '获取不含扩展名的文件名。';
    map('parse_function_decl') = '解析函数声明行。';
    map('starts_with_token') = '判断是否以指定 token 开头。';
    map('is_wrapper_name') = '判断是否为包装函数名。';
    map('has_function_after') = '判断后续是否存在函数定义。';
    map('find_wrapper_end') = '查找包装函数结束位置。';
    map('strip_strings_and_comments') = '移除字符串与注释内容。';
    map('run_batch_matlab_p_to_m') = '运行入口：批量调用 p_to_m_batch。';
    map('run_single_matlab_p_to_m') = '运行入口：调用 p_to_m 处理单文件。';
    map('run_debug_bytes') = '调试入口：读取/验证字节级数据。';
    map('run_debug_header') = '调试入口：解析并检查 .p 头部。';
    map('run_debug_inflate') = '调试入口：测试解压流程。';
    map('read_stream') = '从文件/流读取字节数据。';
    map('run_debug_java_array') = '调试入口：测试 Java 数组互操作。';
    map('run_debug_java_bytes') = '调试入口：测试 Java 字节数组互操作。';
    map('run_debug_parse') = '调试入口：测试解析流程。';
    map('run_debug_parse_addr') = '调试入口：测试地址相关解析。';
end

function desc = guess_func_desc(fn)
    if starts_with(fn, 'is_')
        desc = '判断条件是否成立的辅助函数。';
    elseif starts_with(fn, 'detect_')
        desc = '检测特定特征的辅助函数。';
    elseif starts_with(fn, 'parse_')
        desc = '解析相关内容的辅助函数。';
    elseif starts_with(fn, 'read_')
        desc = '读取相关数据的辅助函数。';
    elseif starts_with(fn, 'write_')
        desc = '写入相关数据的辅助函数。';
    elseif starts_with(fn, 'run_')
        desc = '运行/调试入口函数。';
    else
        desc = '内部辅助函数，具体作用需结合实现。';
    end
end
