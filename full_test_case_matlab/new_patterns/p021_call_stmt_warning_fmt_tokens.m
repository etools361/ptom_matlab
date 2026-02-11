% p021: call statement with nested list + fmt_tokens args.

function out = p021_call_stmt_warning_fmt_tokens()
    warning('aelcmd', 16, fmt_tokens({'Invalid character found', 'only alphanumeric characters [0-9A-Z] are supported.'}));
    out = [];
    return;
end
