function run_debug_java_array()
try
    a = javaArray('byte', 4); %#ok<NASGU>
    disp('byte ok');
catch ME
    disp(['byte fail: ' ME.message]);
end
try
    b = javaArray('int8', 4); %#ok<NASGU>
    disp('int8 ok');
catch ME
    disp(['int8 fail: ' ME.message]);
end
try
    c = javaArray('java.lang.Byte', 4); %#ok<NASGU>
    disp('Byte ok');
catch ME
    disp(['Byte fail: ' ME.message]);
end
try
    d = javaArray('java.lang.Integer', 4); %#ok<NASGU>
    disp('Integer ok');
catch ME
    disp(['Integer fail: ' ME.message]);
end

try
    e = java.lang.reflect.Array.newInstance(java.lang.Byte.TYPE, 4); %#ok<NASGU>
    disp('reflect byte ok');
catch ME
    disp(['reflect byte fail: ' ME.message]);
end
end
