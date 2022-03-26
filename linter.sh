#!/bin/bash

for i in $(find . -name '*.sls'|grep -v 'formula');do 
  salt-lint $i
done
