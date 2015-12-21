#!/usr/bin/perl
$pdflatex   = "lualatex -interaction=nonstopmode %O %S";
$latex      = "platex -kanji=utf8 -interaction=nonstopmode %O %S";
$dvipdf     = "dvipdfmx %O -o %D %S";
$bibtex     = 'pbibtex %O %B';
$biber      = 'biber %O --bblencoding=utf8 -u -U --output_safechars %B';
$pdf_mode   = 1;
