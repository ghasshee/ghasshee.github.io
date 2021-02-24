#!/bin/sh

git clone https://github.com/reelsense/markdeep

cat ./markdeep/0.23/markdeep.min.js | sed -e 's/https\:\/\/cdn\.mathjax\.org\/mathjax\/latest\/MathJax\.js/\/dependencies\/mathjax\/MathJax\.js/' > ./local_markdeep.js
