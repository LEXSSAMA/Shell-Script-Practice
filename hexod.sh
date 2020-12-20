#!/bin/bash
cd $HOME/Documents/lexssama.github.io
git checkout blog
cp -r $HOME/Blog/source $HOME/Documents/lexssama.github.io/Blog/
date=`date`
git add .
git commit -m "$date"
git push
cd $HOME/Blog
hexo d -g
