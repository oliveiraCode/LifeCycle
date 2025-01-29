#!/usr/bin/env bash

# Define datas fixas para 2024
start_date="2024-01-01"
end_date="2024-12-31"
current_date="$start_date"

# Array de tipos de commit
commit_types=("feat" "fix" "docs" "style" "refactor" "test" "chore")
areas=("auth" "ui" "core" "api" "tests" "config" "docs")
features=("login" "dashboard" "settings" "profile" "notifications" "search" "analytics")

# Função para adicionar dias a uma data no MacOS
add_days() {
   date -j -v+"$2"d -f "%Y-%m-%d" "$1" "+%Y-%m-%d"
}

# Função para converter data em timestamp para comparação no MacOS
date_to_timestamp() {
   date -j -f "%Y-%m-%d" "$1" "+%s"
}

while [ $(date_to_timestamp "$current_date") -le $(date_to_timestamp "$end_date") ]; do
   # 80% de chance de pular o dia (mais realista)
   if [ $((RANDOM % 10)) -lt 8 ]; then
       current_date=$(add_days "$current_date" 1)
       continue
   fi
   
   # Se for fim de semana, 95% de chance de pular
   day_of_week=$(date -j -f "%Y-%m-%d" "$current_date" "+%u")
   if [ "$day_of_week" -gt 5 ] && [ $((RANDOM % 100)) -lt 95 ]; then
       current_date=$(add_days "$current_date" 1)
       continue
   fi

   # Quando há commits, maior chance de ter múltiplos (2-5 commits)
   num_commits=$((2 + RANDOM % 4))
   
   # Seleciona uma feature para o dia
   feature_index=$((RANDOM % ${#features[@]}))
   current_feature="${features[$feature_index]}"
   
   for ((i=1; i<=num_commits; i++)); do
       # Gera hora aleatória realista
       if [ "$day_of_week" -le 5 ]; then
           # Dias de semana: 9h-18h
           hour=$((9 + RANDOM % 9))
       else
           # Fins de semana: 11h-15h (mais restrito)
           hour=$((11 + RANDOM % 4))
       fi
       minute=$((RANDOM % 60))
       
       # Formata a data ISO 8601
       iso_date=$(date -j -f "%Y-%m-%d %H:%M:%S" "$current_date $hour:$minute:00" "+%Y-%m-%dT%H:%M:%S%z")
       
       # Mensagens mais realistas em sequência
       case $i in
           1) commit_msg="feat(${current_feature}): initial implementation" ;;
           2) commit_msg="style(${current_feature}): improve code formatting and structure" ;;
           3) commit_msg="fix(${current_feature}): resolve review feedback" ;;
           4) commit_msg="test(${current_feature}): add unit tests" ;;
           *) commit_msg="docs(${current_feature}): update documentation" ;;
       esac
       
       echo "$iso_date $commit_msg" >> README.md
       git commit -a -m "$commit_msg" --date="$iso_date"
       
       # Pequeno delay entre commits do mesmo dia
       sleep 0.5
   done
   
   # 40% de chance de pular 2-3 dias após uma série de commits
   if [ $((RANDOM % 10)) -lt 4 ]; then
       skip_days=$((2 + RANDOM % 2))
       current_date=$(add_days "$current_date" $skip_days)
   else
       current_date=$(add_days "$current_date" 1)
   fi
done

echo "Commits completed. Use 'git push' to update GitHub."