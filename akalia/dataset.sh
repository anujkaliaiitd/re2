rm dataset.txt
touch dataset.txt
rm temp*.txt

# Download the first four pages. The next two pages are spam.
wget -O temp1.txt 'http://regexlib.com/Search.aspx?k=&c=-1&m=5&ps=100'
wget -O temp2.txt 'http://regexlib.com/Search.aspx?k=&c=-1&m=5&ps=100&p=2'
wget -O temp3.txt 'http://regexlib.com/Search.aspx?k=&c=-1&m=5&ps=100&p=3'
wget -O temp4.txt 'http://regexlib.com/Search.aspx?k=&c=-1&m=5&ps=100&p=4'

cat temp1.txt >> dataset.txt
cat temp2.txt >> dataset.txt
cat temp3.txt >> dataset.txt
cat temp4.txt >> dataset.txt

rm temp*.txt

# Extract only lines with the regexex
cat dataset.txt | grep "expressionDiv" > temp.txt
mv temp.txt dataset.txt

# Trim leading whitespace
sed "s/^[ \t ]*//" -i dataset.txt



