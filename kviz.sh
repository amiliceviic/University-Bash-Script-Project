#!/bin/bash

#Funkcija za mesanje(menjanje redosleda) elemenata niza
shuffle_array() {
    local array=("$@")
    local n=${#array[@]}
    local i tmp j

    for ((i = n - 1; i > 0; i--)); do
        j=$((RANDOM % (i + 1))) #Generisanje random indeksa
        tmp=${array[i]}         #Zamena elemanata
        array[i]=${array[j]}
        array[j]=$tmp
    done

    echo "${array[@]}"
}

#Cuvanje URL API-ja za preuzimanje pitanja
API_URL="https://the-trivia-api.com/v2/questions/?limit=1"

#Preuzimanje pitanja i odgovora koristeći curl(za slanje zahteva) i jq(za JSON) alata
echo "Preuzimam pitanje sa API-ja..."
response=$(curl -s "$API_URL")

#Proveravanje da li je odgovor uspesno preuzet
if [[ -z "$response" ]]; then
    echo "Greška pri preuzimanju podataka. Pokušajte ponovo kasnije."
    exit 1
fi

#Parsiranje pitanja i odgovora
question=$(echo "$response" | jq -r '.[0].question.text')
correct_answer=$(echo "$response" | jq -r '.[0].correctAnswer')
incorrect_answers=($(echo "$response" | jq -r '.[0].incorrectAnswers[]'))

#Kombinovanje tačnih i netačnih odgovora u listu
all_answers=("$correct_answer" $incorrect_answers)

#Mešanje odgovora nasumično koristeći shuffle_array
shuffled_answers=($(shuffle_array "${all_answers[@]}"))

#Prikaz pitanja i odgovora
echo
echo "Pitanje: $question"
echo

for i in "${!shuffled_answers[@]}"; do
    echo "$((i + 1)). ${shuffled_answers[$i]}"
done

#Prikupljanje korisničkog odgovora
while true; do
    read -p "Unesite broj odgovora (1-4): " user_input

    # Provera da li je unos validan
    if [[ "$user_input" =~ ^[1-4]$ ]]; then
        break
    else
        echo "Nevalidan unos. Molimo unesite broj između 1 i 4."
    fi
done

#Proveravanje da li je korisnicki odgovor tacan
selected_answer=${shuffled_answers[$((user_input - 1))]}

if [[ "$selected_answer" == "$correct_answer" ]]; then
    echo "Tačno! Odgovor je: $correct_answer"
else
    echo "Netačno. Tačan odgovor je: $correct_answer"
fi
