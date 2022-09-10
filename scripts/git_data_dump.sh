# git_data_dump.sh

echo "commit id,author,date,comment,changed files,lines added,lines deleted" > res.csv 
git log --since='Jul 3 2022'  --date=local --all --pretty="%x40%h%x2C%an%x2C%ad%x2C%x22%s%x22%x2C" --shortstat | tr "\n" " " | tr "@" "\n" >> res.csv
sed -i .bk0 's/ files changed//g' res.csv
sed -i .bk1 's/ file changed//g' res.csv
sed -i .bk2 's/ insertions(+)//g' res.csv
sed -i .bk3 's/ insertion(+)//g' res.csv
sed -i .bk4 's/ deletions(-)//g' res.csv
sed -i .bk5 's/ deletion(-)//g' res.csv
sed -i .bk6 's/ deletion(-)//g' res.csv
sed -i .bk7 's/Nikolaus Heger/NIK/g' res.csv


