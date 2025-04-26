#!/bin/bash

#Provera da li je uneta lozinka kao argument
if [[ $# -ne 1 ]]; then
    echo "Greška: Morate uneti lozinku kao argument."
    echo "Primer: $0 'lozinka123!'"
    exit 1
fi

password="$1"

#Provera minimalne dužine lozinke
if [[ ${#password} -lt 8 ]]; then
    echo "Greška: Lozinka mora biti dugačka najmanje 8 karaktera."
    exit 1
fi

#Provera prisustva numeričkog karaktera
if ! [[ "$password" =~ [0-9] ]]; then
    echo "Greška: Lozinka mora sadržati barem jedan numerički karakter (0-9)."
    exit 1
fi

#Provera prisustva specijalnog karaktera
if ! echo "$password" | grep -q -E '[@#\$%\&\*\+\-\=]'; then
    echo "Greška: Lozinka mora sadržati barem jedan specijalni karakter (@, #, $, %, &, *, +, -, =)."
    exit 1
fi

#Ako je lozinka validna, kriptuje se SHA-256 algoritmom
echo -n "$password" | shasum | awk '{print "Enkriptovana vrednost lozinke: " $1}'
exit 0
