echo "copying cw_scripts"
ruby -e "require('FileUtils'); FileUtils.cp(Dir.glob('./cw_scripts/*.rb'), '_includes');"
echo "updating urls.yml"
cd _site;
mv urls.txt ../_data/urls.yml;
cd ../;
echo "serving jekyll"
jekyll serve
