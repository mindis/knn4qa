#!/bin/bash
collect=$1
if [ "$collect" = "" ] ; then
  echo "Specify sub-collection (1st arg): manner, compr, stackoverflow, compr2M"
  exit 1
fi

IN_DIR="output/$collect/"
OUT_DIR="lucene_index/$collect"

if [ ! -d "$OUT_DIR" ] ; then
  echo "Directory (or a link to a directory) $OUT_DIR doesn't exist"
  exit 1
fi
echo "=========================================================================="
echo "Output directory: $OUT_DIR"
echo "Removing previous index (if exists)"
rm -f "$OUT_DIR"/*
echo "=========================================================================="

if [ "$collect" = "manner" ] ; then
  scripts/index/run_lucene_index.sh -root_dir $IN_DIR  -index_dir $OUT_DIR -sub_dirs train,dev1,dev2,test -solr_file SolrAnswerFile.txt
  if [ "$?" != "0" ] ; then
    echo "FAILURE!!!"
    exit 1
  fi
elif [ "$collect" = "compr" ] ; then
  scripts/index/run_lucene_index.sh -root_dir $IN_DIR  -index_dir $OUT_DIR  -sub_dirs train,dev1,dev2,test,tran  -solr_file SolrAnswerFile.txt
  if [ "$?" != "0" ] ; then
    echo "FAILURE!!!"
    exit 1
  fi
elif [ "$collect" = "stackoverflow" ] ; then
  scripts/index/run_lucene_index.sh -root_dir $IN_DIR  -index_dir $OUT_DIR  -sub_dirs train,dev1,dev2,test,tran  -solr_file SolrAnswerFile.txt
  if [ "$?" != "0" ] ; then
    echo "FAILURE!!!"
    exit 1
  fi
elif [ "$collect" = "compr2M" ] ; then
  # For compr2M the order of parts MUST be the same as in create_inmemfwd_index.sh !!!
  IN_DIR="output/compr/"
  scripts/index/run_lucene_index.sh -root_dir $IN_DIR  -index_dir $OUT_DIR  -sub_dirs train,dev1,dev2,test,tran -solr_file SolrAnswerFile.txt -n 2000000
  if [ "$?" != "0" ] ; then
    echo "FAILURE!!!"
    exit 1
  fi
else
  echo "Wrong collection name '$collect'"
  exit 1
fi
