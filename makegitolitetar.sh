mkdir temp && cd temp
label="v3.5.2"
git clone git://github.com/sitaramc/gitolite
cd gitolite
git checkout ${label}
cd ..
tar czf ../files/default/gitolite-3.5.2.tar.gz ./gitolite
cd ..
rm -Rf ./temp
