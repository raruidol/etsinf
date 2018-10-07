#!/usr/bin/octave -qf

load "data";
mt = minv';
save -text "data_trans" mt;
