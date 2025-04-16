#!/bin/bash

# the main site that we get the information from
site="https://www.ynetnews.com/category/3082"

# the names that we search in the articlesהןצ
names=("Netanyahu" "Gantz" "Bennett" "Peretz")

# putting all the article urls in an array, and then sorting them to see that then is no duplication
readarray -t article_urls < <(wget -qO - "$site" | grep -Eo "https://www.ynetnews.com/article/[0-9a-zA-Z]+" | sort -u)

# printing the total number of articles
# echo "${#article_urls[@]}"

# going over each article and printing each one with the numbers of names
for article_url in "${article_urls[@]}"; do
	article=$(wget -qO - "$article_url")
	output="$article_url"
	found_any=0
	
	# in each article going over every name, to see how many times appears
	for name in "${names[@]}"; do
		count=$(echo "$article" | grep -o -i "$name" | wc -l)
		output+=", $name, $count"
		# if we found any name, we need to print them all
		if [ "$count" -gt 0 ]; then
			found_any=1
		fi
	done
	if [ "$found_any" -eq 0 ]; then
		echo "$article_url, -"
	# if we didn't found any name we print -
	else 
		echo "$output"
	fi
done


