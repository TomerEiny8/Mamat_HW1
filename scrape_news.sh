#1/bin/bash

site="https://ynetnews.com/category/3082"

names=("Netanyahu" "Gantz" "Bennett" "Peretz")

readarray -t article_urls < <(wget -qO - "$site" | grep -Eo "https://www.ynetnews.com/article/[0-9a-zA-Z]+" | sort -u)

total=$(echo "${article_urls[@]}" | wc -w)
echo "${#article_urls[@]}"

for article_url in "${article_urls[@]}"; do
	article=$(wget -qO - "$article_url")
	output="$article_url"
	found_any=0

	for name in "${names[@]}"; do
		count=$(echo "$article" | grep -o -i "$name" | wc -l)
		output+=", $name, $count"
		if [ "$count" -gt 0 ]; then
			found_any=1
		fi
	done
	if [ "$found_any" -eq 0 ]; then
		echo "$article_url, -"
	else 
		echo "$output"
	fi
done

