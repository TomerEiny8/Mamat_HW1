#1/bin/bash

site="https://ynetnews.com/category/3082"

article_urls=$(wget -qO - "$site" | grep -Eo "https://www.ynetnews.com/article/[0-9a-zA-Z]+")

names=("Netanyahu" "Gantz" "Bennett" "Peretz")

for article_url in $article_urls; do
	article=$(wget -qO - "$article_url")
	output="$article_url"
	found_any=0

	for name in "${names[@]}"; do
		count=$(echo "$article" | grep -o "$name" | wc -l)
		if [ "$count" -gt 0 ]; then
			output="$output, $name, $count"
			found_any=1
		else
			output="$output, $name, 0"
		fi
	done

	if [ "$found_any" -eq 0 ]; then
		output="$article_url, -"
	fi
	echo "$output"
done

total=$(echo "$article_urls" | wc -l)
echo "Total: $total articles"

