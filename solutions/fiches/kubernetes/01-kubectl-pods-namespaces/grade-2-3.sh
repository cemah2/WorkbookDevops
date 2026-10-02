#!/usr/bin/env bash
# solutions/fiches/kubernetes/01-kubectl-pods-namespaces/grade-2-3.sh — note l'exercice autonome de la section 2.
# Usage : ./grade-2-3.sh      (variables : NS défaut shop, OUT défaut /opt/ckad)
# Sortie : une ligne par critère, OK ou KO, puis le total. Ne modifie rien.
set -uo pipefail
NS="${NS:-shop}"
OUT="${OUT:-/opt/ckad}"
score=0; total=0

check() { # check <libellé> <commande…>
  local label="$1"; shift
  total=$((total+1))
  if "$@" >/dev/null 2>&1; then echo "OK  $label"; score=$((score+1)); else echo "KO  $label"; fi
}

jp() { kubectl -n "$NS" get pod "$1" -o jsonpath="$2" 2>/dev/null; }

check "api.yaml existe et décrit un Pod api"        sh -c "grep -q 'kind: Pod' '$OUT/api.yaml' && grep -q 'name: api' '$OUT/api.yaml'"
check "api : image nginx:1.29"                      test "$(jp api '{.spec.containers[0].image}')" = "nginx:1.29"
check "api : port 80"                               test "$(jp api '{.spec.containers[0].ports[0].containerPort}')" = "80"
check "api : labels app=api,tier=backend"           test "$(jp api '{.metadata.labels.app}/{.metadata.labels.tier}')" = "api/backend"
check "api : env MODE=dev"                          test "$(jp api '{.spec.containers[0].env[?(@.name=="MODE")].value}')" = "dev"
check "worker : busybox:1.37, sleep 3600"           sh -c "test \"$(jp worker '{.spec.containers[0].image}')\" = busybox:1.37 && kubectl -n $NS get pod worker -o json | grep -q 3600"
check "worker : label tier=batch (après le point 4)" test "$(jp worker '{.metadata.labels.tier}')" = "batch"
check "cache : redis:8, label tier=data"            test "$(jp cache '{.spec.containers[0].image}/{.metadata.labels.tier}')" = "redis:8/data"
check "pods.txt : en-tête NAME NS IMAGE"            sh -c "head -1 '$OUT/pods.txt' | tr -s ' ' | grep -q '^NAME NS IMAGE'"
check "pods.txt : 3 lignes de données triées"       sh -c "tail -n +2 '$OUT/pods.txt' | awk '{print \$1}' | sort -c && test \"\$(tail -n +2 '$OUT/pods.txt' | wc -l)\" -eq 3"
check "pods.txt : images présentes"                 sh -c "grep -q nginx:1.29 '$OUT/pods.txt' && grep -q redis:8 '$OUT/pods.txt' && grep -q busybox:1.37 '$OUT/pods.txt'"

echo "score : $score / $total"
[ "$score" -eq "$total" ]
