function x = isOctave()
    x = exist('OCTAVE_VERSION', 'builtin') ~= 0;
end