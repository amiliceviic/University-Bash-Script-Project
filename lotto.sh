#!/bin/bash

#Provera broja unetih argumenata
if [[ $# -ne 7 ]]; then
    echo "Greška: Morate uneti tačno 7 brojeva."
    echo "Primer: $0 5 12 18 23 30 33 37"
    exit 1
fi

#Provera da li su svi uneti brojevi u opsegu (1-37)
for num in "$@"; do
    if ! [[ "$num" =~ ^[0-9]+$ ]] || [[ "$num" -lt 1 ]] || [[ "$num" -gt 37 ]]; then
        echo "Greška: Svi uneti brojevi moraju biti celi brojevi u opsegu od 1 do 37."
        exit 1
    fi
done

#Provera da li su svi uneti brojevi jedinstveni
unique_numbers=($(echo "$@" | tr ' ' '\n' | sort -n | uniq))
if [[ ${#unique_numbers[@]} -ne 7 ]]; then
    echo "Greška: Svi uneti brojevi moraju biti jedinstveni."
    exit 1
fi

#Funkcija koja generise 7 jedinstvenih slučajnih brojeva u opsegu od 1 do 37
generate_random_numbers() {
    local numbers=()
    while [[ ${#numbers[@]} -lt 7 ]]; do
        rand=$((RANDOM % 37 + 1))
        if [[ ! " ${numbers[@]} " =~ " $rand " ]]; then
            numbers+=("$rand")
        fi
    done
    echo "${numbers[@]}"
}

#Generisanje slučajnih brojeva
generated_numbers=($(generate_random_numbers))

#Računanje pogodaka
matches=0
for num in "${unique_numbers[@]}"; do
    if [[ " ${generated_numbers[@]} " =~ " $num " ]]; then
        ((matches++))
    fi
done

#Prikaz rezultata
echo "Uneti brojevi: ${unique_numbers[@]}"
echo "Generisani brojevi: ${generated_numbers[@]}"
echo "Broj pogodaka: $matches"

#Upisivanje dobijenih rezultata u fajl
result="User: ${unique_numbers[@]} | Generated: ${generated_numbers[@]} | Matches: $matches"
echo "$result" >>lottery_results.txt
echo "Rezultat je sačuvan u fajl lottery_results.txt"
