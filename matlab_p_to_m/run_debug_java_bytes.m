function run_debug_java_bytes()
buf = java.lang.reflect.Array.newInstance(java.lang.Byte.TYPE, 4);
buf(1) = 1;
buf(2) = 2;
buf(3) = 255;
buf(4) = 128;

try
    a = int8(buf);
    disp('int8:');
    disp(a');
catch ME
    disp(['int8 fail: ' ME.message]);
end

try
    b = uint8(buf);
    disp('uint8:');
    disp(b');
catch ME
    disp(['uint8 fail: ' ME.message]);
end

try
    c = typecast(int8(buf), 'uint8');
    disp('typecast int8->uint8:');
    disp(c');
catch ME
    disp(['typecast fail: ' ME.message]);
end
end
