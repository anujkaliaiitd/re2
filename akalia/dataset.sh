filenames="emails.txt uris.txt numbers.txt strings.txt dates.txt misc.txt address.txt"
rm $filenames

# dataset.txt contains the full dataset
rm dataset.txt
touch dataset.txt

# Emails
echo "Downloading email regexes"
wget -O emails.txt "http://regexlib.com/Search.aspx?k=&c=1&m=-1&ps=100"

# URIs
echo "Downloading URI regexes"
wget -O uris.txt "http://regexlib.com/Search.aspx?k=&c=2&m=-1&ps=100"

# Numbers
echo "Downloading number regexes"
wget -O numbers.txt "http://regexlib.com/Search.aspx?k=&c=3&m=-1&ps=100"
wget -O numbers2.txt "http://regexlib.com/Search.aspx?k=&c=3&m=-1&ps=100&p=2"
cat numbers2.txt >> numbers.txt
rm numbers2.txt

# Strings
echo "Downloading string regexes"
wget -O strings.txt "http://regexlib.com/Search.aspx?k=&c=4&m=-1&ps=100"

# Dates and times
echo "Downloading date regexes"
wget -O dates.txt "http://regexlib.com/Search.aspx?k=&c=5&m=-1&ps=100"
wget -O dates2.txt "http://regexlib.com/Search.aspx?k=&c=5&m=-1&ps=100&p=2"
cat dates2.txt >> dates.txt
rm dates2.txt

# Misc
echo "Downloading misc regexes"
wget -O misc.txt "http://regexlib.com/Search.aspx?k=&c=6&m=-1&ps=100"
wget -O misc2.txt "http://regexlib.com/Search.aspx?k=&c=6&m=-1&ps=100&p=2"
cat misc2.txt >> misc.txt
rm misc2.txt

# Address
echo "Downloading address regexes"
wget -O address.txt "http://regexlib.com/Search.aspx?k=&c=7&m=-1&ps=100"
wget -O address2.txt "http://regexlib.com/Search.aspx?k=&c=7&m=-1&ps=100&p=2"
cat address2.txt >> address.txt
rm address2.txt

for file in $filenames; do
  echo "Post-processing $file"
	# Extract only lines with the regexes
	cat $file | grep "expressionDiv" > temp.txt
	mv temp.txt $file

	# Trim leading whitespace
	sed "s/^[ \t ]*//" -i $file

	# Remove the leading HTML tags
	sed -i 's/<td><div class="expressionDiv">//' $file

	# Remove the trailing HTML tags
	sed -i 's/<\/div><\/td>//' $file

  # Some HTML sequences require multiple calls to recode.
  # Example: &amp;lt -> &lt -> <
  # Just run it a bunch of times
  #recode html..ascii $file
  #recode html..ascii $file
  #recode html..ascii $file
  #recode html..ascii $file
  #recode html..ascii $file

  cat $file >> dataset.txt
done


