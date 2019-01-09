# dataset.txt contains the full dataset
rm dataset.txt
touch dataset.txt

rm temp
touch temp
for page in `seq 1 8`; do
  wget -O temp "http://regexlib.com/Search.aspx?k=&c=-1&m=3&ps=100&p=$page"
  cat temp >> dataset.txt
done
rm temp

echo "Post-processing"

# Extract only lines with the regexes
cat dataset.txt | grep "expressionDiv" > temp.txt
mv temp.txt dataset.txt

# Trim leading whitespace
sed "s/^[ \t ]*//" -i dataset.txt

# Remove the leading HTML tags
sed -i 's/<td><div class="expressionDiv">//' dataset.txt

# Remove the trailing HTML tags
sed -i 's/<\/div><\/td>//' dataset.txt

# Recode the dataset from HTML to ASCII. Some HTML sequences require multiple
# calls to recode (e.g., "&amp;lt" becomes &lt becomes "<"), so we just run it
# a bunch of times.

rm -f dataset_decoded
touch dataset_decoded

while read line; do
  # `recode` fails for the entire file if there's an ill-formatted line.
  # (This failure typically happens due to encoded UTF8 characters.)
  # To work around this limitation of recode, we recode the dataset line-by-line
  # by using tmpfile as an intermediate, single-line file.
  rm -f tmpfile
  echo $line > tmpfile

  recode -q html..ascii tmpfile
  recode -q html..ascii tmpfile
  recode -q html..ascii tmpfile
  if recode -q html..ascii tmpfile; then
    cat tmpfile >> dataset_decoded
  else
    echo "recode: Failed to decode $line"
  fi
done < dataset.txt

mv dataset_decoded dataset.txt
rm tmpfile

# Delete scams
sed -ie '/Amazon/Id' dataset.txt
sed -ie '/Apple/Id' dataset.txt
sed -ie '/Facebook/Id' dataset.txt
sed -ie '/Quick/Id' dataset.txt
sed -ie '/Bangalore/Id' dataset.txt
sed -ie '/Gmail/Id' dataset.txt
sed -ie '/Outlook/Id' dataset.txt
sed -ie '/Norton/Id' dataset.txt
sed -ie '/Tech/Id' dataset.txt
sed -ie '/Service/Id' dataset.txt
